/*
Copyright (c) 2017-2025 Timur Gafarov

Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module dagon.resource.asset;

import core.stdc.string;
import std.stdio;
import std.algorithm;
import std.path;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.core.compound;
import dlib.core.stream;
import dlib.core.thread;
import dlib.container.dict;
import dlib.filesystem.filesystem;
import dlib.filesystem.stdfs;
import dlib.image.image;
import dlib.image.unmanaged;
import dlib.image.hdri;
import dlib.image.io;

import dagon.core.application;
import dagon.core.event;
import dagon.core.vfs;
import dagon.core.logger;
import dagon.graphics.texture;
import dagon.resource.boxfs;
import dagon.resource.texture;
import dagon.resource.dds;
import dagon.resource.sdlimage;

struct MonitorInfo
{
    FileStat lastStat;
    bool fileExists = false;
}

abstract class Asset: Owner
{
    this(Owner o)
    {
        super(o);
    }

    MonitorInfo monitorInfo;
    bool threadSafePartLoaded = false;
    bool threadUnsafePartLoaded = false;
    bool loadThreadSafePart(string filename, InputStream istrm, ReadOnlyFileSystem fs, AssetManager mngr);
    bool loadThreadUnsafePart();
    void release();
}

abstract class TextureLoader: Owner
{
    AssetManager assetManager;
    
    this(AssetManager assetManager)
    {
        super(assetManager);
        this.assetManager = assetManager;
    }
    
    // Override this
    Compound!(bool, string) load(
        string filename,
        string extension,
        InputStream istrm,
        TextureAsset asset,
        uint option = 0);
}

// Basic loader that prefers SDL2_Image if present and falls back to dlib.image otherwise
class DefaultTextureLoader: TextureLoader
{
    UnmanagedImageFactory ldrImageFactory;
    UnmanagedHDRImageFactory hdrImageFactory;
    
    this(AssetManager assetManager)
    {
        super(assetManager);
        ldrImageFactory = New!UnmanagedImageFactory();
        hdrImageFactory = New!UnmanagedHDRImageFactory();
    }
    
    ~this()
    {
        Delete(ldrImageFactory);
        Delete(hdrImageFactory);
    }
    
    override Compound!(bool, string) load(
        string filename,
        string extension,
        InputStream istrm,
        TextureAsset asset,
        uint option = 0)
    {
        
        bool useSDLImage = false;
        if (assetManager.application)
        {
            useSDLImage = assetManager.application.sdlImagePresent;
        }
        
        // Use built-in DDS loader
        if (extension == ".dds")
        {
            bool loaded = loadDDS(istrm, &asset.buffer);
            if (loaded)
            {
                asset.bufferDataIsImageData = false;
                asset.generateMipmaps = true;
                return compound(true, "");
            }
            else
                return compound(false, "");
        }
        
        if (!isSDLImageSupportedFormat(extension))
            useSDLImage = false;
        
        // Use SDL2_Image
        if (useSDLImage)
        {
            bool loaded = loadImageViaSDLImage(istrm, extension, asset);
            if (loaded)
            {
                asset.bufferDataIsImageData = false;
                asset.generateMipmaps = true;
                return compound(true, "");
            }
            else
                return compound(false, "");
        }
        
        // Use dlib.image
        ubyte[] data = New!(ubyte[])(istrm.size);
        istrm.fillArray(data);
        ArrayStream arrStrm = New!ArrayStream(data);
        Compound!(SuperImage, string) res;
        if (extension == ".bmp")
            res = loadBMP(arrStrm, ldrImageFactory);
        else if (extension == ".png")
            res = loadPNG(arrStrm, ldrImageFactory);
        else if (extension == ".jpg" || extension == ".jpeg")
            res = loadJPEG(arrStrm, ldrImageFactory);
        else if (extension == ".tga")
            res = loadTGA(arrStrm, ldrImageFactory);
        else if (extension == ".hdr")
            res = loadHDR(arrStrm, hdrImageFactory);
        else
            res = compound(null, "Unsupported image file format");
        Delete(arrStrm);
        Delete(data);
        
        asset.image = res[0];
        if (asset.image is null)
        {
            return compound(false, res[1]);
        }
        else
        {
            Compound!(bool, string) result;
            
            TextureFormat textureFormat;
            if (detectTextureFormat(asset.image, textureFormat))
            {
                asset.buffer.format = textureFormat;
                asset.buffer.size = TextureSize(asset.image.width, asset.image.height, 0);
                asset.buffer.mipLevels = 1;
                size_t bufferSize = asset.image.data.length;
                asset.buffer.data = asset.image.data;
                asset.bufferDataIsImageData = true;
                asset.generateMipmaps = true;
                result = compound(true, "");
            }
            else
            {
                result = compound(false, "Unsupported pixel format");
            }
            
            return result;
        }
    }
}

struct ImageFormatInfo
{
    string format;
    string dummyFilename;
    string prefix;
}

class AssetManager: Owner
{
    Application application; // set by the scene
    Dict!(TextureLoader, string) textureLoaders;
    DefaultTextureLoader defaultTextureLoader;
    
    Dict!(Asset, string) assetsByFilename;
    VirtualFileSystem fs;
    StdFileSystem stdfs;
    UnmanagedImageFactory imageFactory;
    UnmanagedHDRImageFactory hdrImageFactory;
    Thread loadingThread;

    bool liveUpdate = false;
    double liveUpdatePeriod = 5.0;

    protected double monitorTimer = 0.0;

    float nextLoadingPercentage = 0.0f;

    EventManager eventManager;
    
    Dict!(string, string) base64ImagePrefixes;

    this(EventManager emngr, Owner o = null)
    {
        super(o);
        
        defaultTextureLoader = New!DefaultTextureLoader(this);
        
        textureLoaders = New!(Dict!(TextureLoader, string));
        registerTextureLoader(".bmp", defaultTextureLoader);
        registerTextureLoader([".jpg", ".jpeg"], defaultTextureLoader);
        registerTextureLoader(".png", defaultTextureLoader);
        registerTextureLoader(".tga", defaultTextureLoader);
        registerTextureLoader(".hdr", defaultTextureLoader);
        registerTextureLoader(".webp", defaultTextureLoader);
        registerTextureLoader(".avif", defaultTextureLoader);
        registerTextureLoader([".tif", ".tiff"], defaultTextureLoader);
        registerTextureLoader(".dds", defaultTextureLoader);
        registerTextureLoader(".jxl", defaultTextureLoader);
        registerTextureLoader(".gif", defaultTextureLoader);
        registerTextureLoader(".pcx", defaultTextureLoader);
        registerTextureLoader([".pnm", ".ppm", ".pgm", ".pbm"], defaultTextureLoader);
        registerTextureLoader(".qoi", defaultTextureLoader);
        registerTextureLoader(".xpm", defaultTextureLoader);
        registerTextureLoader(".svg", defaultTextureLoader);
        
        assetsByFilename = New!(Dict!(Asset, string));
        fs = New!VirtualFileSystem();
        stdfs = New!StdFileSystem();
        fs.mount(stdfs);
        fs.mount(".");
        imageFactory = New!UnmanagedImageFactory();
        hdrImageFactory = New!UnmanagedHDRImageFactory();

        loadingThread = New!Thread(&threadFunc);

        eventManager = emngr;
        
        base64ImagePrefixes = New!(Dict!(string, string))();
        
        // Reference: https://www.digipres.org/formats/mime-types/
        base64ImagePrefixes["data:image/png;base64,"] = "image.png";
        base64ImagePrefixes["data:image/apng;base64,"] = "image.png";
        base64ImagePrefixes["data:image/jpeg;base64,"] = "image.jpg";
        base64ImagePrefixes["data:image/gif;base64,"] = "image.gif";
        base64ImagePrefixes["data:image/webp;base64,"] = "image.webp";
        base64ImagePrefixes["data:image/ktx;base64,"] = "image.ktx";
        base64ImagePrefixes["data:image/svg+xml;base64,"] = "image.svg";
        base64ImagePrefixes["data:image/vnd-ms.dds;base64,"] = "image.dds";
        base64ImagePrefixes["data:image/image/vnd.radiance;base64,"] = "image.hdr";
        base64ImagePrefixes["data:image/x-targa;base64,"] = "image.tga";
        base64ImagePrefixes["data:image/x-tga;base64,"] = "image.tga";
        base64ImagePrefixes["data:image/x-ms-bmp;base64,"] = "image.bmp";
        base64ImagePrefixes["data:image/x-psd;base64,"] = "image.psd";
        base64ImagePrefixes["data:image/avif;base64,"] = "image.avif";
        base64ImagePrefixes["data:image/bmp;base64,"] = "image.bmp";
        base64ImagePrefixes["data:image/x-tiff;base64,"] = "image.tiff";
        base64ImagePrefixes["data:image/x-tif;base64,"] = "image.tif";
        base64ImagePrefixes["data:image/x-xcf;base64,"] = "image.xcf";
        base64ImagePrefixes["data:image/jxl;base64,"] = "image.jxl";
    }
    
    ImageFormatInfo detectBase64Image(string uri)
    {
        ImageFormatInfo result;
        result.format = "";
        result.dummyFilename = "";
        result.prefix = "";
        
        foreach(string prefix, string dummyFilename; base64ImagePrefixes)
        {
            if (uri.startsWith(prefix))
            {
                result.format = extension(dummyFilename);
                result.dummyFilename = dummyFilename;
                result.prefix = prefix;
                break;
            }
        }
        
        return result;
    }

    ~this()
    {
        Delete(textureLoaders);
        Delete(assetsByFilename);
        Delete(fs);
        Delete(imageFactory);
        Delete(hdrImageFactory);
        Delete(loadingThread);
        Delete(base64ImagePrefixes);
    }

    void mountDirectory(string dir)
    {
        fs.mount(dir);
    }

    void mountBoxFile(string filename)
    {
        BoxFileSystem boxfs = New!BoxFileSystem(fs.openForInput(filename), true);
        fs.mount(boxfs);
    }

    void mountBoxFileDirectory(string filename, string dir)
    {
        BoxFileSystem boxfs = New!BoxFileSystem(fs.openForInput(filename), true, dir);
        fs.mount(boxfs);
    }
    
    void registerTextureLoader(string extension, TextureLoader loader)
    {
        textureLoaders[extension] = loader;
    }
    
    void registerTextureLoader(string[] extensions, TextureLoader loader)
    {
        foreach(extension; extensions)
        {
            registerTextureLoader(extension, loader);
        }
    }
    
    TextureLoader textureLoader(string extension)
    {
        if (extension in textureLoaders)
            return textureLoaders[extension];
        else
            return null;
    }

    bool assetExists(string name)
    {
        if (name in assetsByFilename)
            return true;
        else
            return false;
    }

    Asset addAsset(Asset asset, string name)
    {
        if (!(name in assetsByFilename))
        {
            assetsByFilename[name] = asset;
            if (fs.stat(name, asset.monitorInfo.lastStat))
                asset.monitorInfo.fileExists = true;
        }
        return asset;
    }

    Asset preloadAsset(Asset asset, string name)
    {
        if (!(name in assetsByFilename))
        {
            assetsByFilename[name] = asset;
            if (fs.stat(name, asset.monitorInfo.lastStat))
                asset.monitorInfo.fileExists = true;
        }

        asset.release();
        asset.threadSafePartLoaded = false;
        asset.threadUnsafePartLoaded = false;

        asset.threadSafePartLoaded = loadAssetThreadSafePart(asset, name);
        if (asset.threadSafePartLoaded)
            asset.threadUnsafePartLoaded = asset.loadThreadUnsafePart();

        return asset;
    }

    void reloadAsset(Asset asset, string filename)
    {
        asset.release();
        asset.threadSafePartLoaded = false;
        asset.threadUnsafePartLoaded = false;

        asset.threadSafePartLoaded = loadAssetThreadSafePart(asset, filename);
        if (asset.threadSafePartLoaded)
            asset.threadUnsafePartLoaded = asset.loadThreadUnsafePart();
    }

    void reloadAsset(string name)
    {
        auto asset = assetsByFilename[name];

        asset.release();
        asset.threadSafePartLoaded = false;
        asset.threadUnsafePartLoaded = false;

        asset.threadSafePartLoaded = loadAssetThreadSafePart(asset, name);
        if (asset.threadSafePartLoaded)
            asset.threadUnsafePartLoaded = asset.loadThreadUnsafePart();
    }

    Asset getAsset(string name)
    {
        if (name in assetsByFilename)
            return assetsByFilename[name];
        else
            return null;
    }

    void removeAsset(string name)
    {
        Delete(assetsByFilename[name]);
        assetsByFilename.remove(name);
    }

    void releaseAssets()
    {
        clearOwnedObjects();
        Delete(assetsByFilename);
        assetsByFilename = New!(Dict!(Asset, string));

        Delete(loadingThread);
        loadingThread = New!Thread(&threadFunc);
    }
    
    bool loadAssetThreadSafePart(Asset asset, ubyte[] buffer, string filename)
    {
        ArrayStream arrStrm = New!ArrayStream(buffer);
        bool res = loadAssetThreadSafePart(asset, arrStrm, filename);
        Delete(arrStrm);
        return res;
    }
    
    bool loadAssetThreadSafePart(Asset asset, InputStream istrm, string filename)
    {
        bool res = asset.loadThreadSafePart(filename, istrm, fs, this);
        if (!res)
        {
            logError("Failed to load asset \"", filename, "\"");
        }
        return res;
    }

    bool loadAssetThreadSafePart(Asset asset, string filename)
    {
        if (!fileExists(filename))
        {
            logError("Cannot find file \"", filename, "\"");
            return false;
        }

        auto fstrm = fs.openForInput(filename);
        bool res = loadAssetThreadSafePart(asset, fstrm, filename);
        Delete(fstrm);
        return res;
    }

    void threadFunc()
    {
        foreach(filename, asset; assetsByFilename)
        {
            nextLoadingPercentage += 1.0f / cast(float)(assetsByFilename.length);
            
            if (!asset.threadSafePartLoaded)
            {
                asset.threadSafePartLoaded = loadAssetThreadSafePart(asset, filename);
                asset.threadUnsafePartLoaded = false;
            }
        }
    }

    void loadThreadSafePart()
    {
        nextLoadingPercentage = 0.0f;
        monitorTimer = 0.0;
        loadingThread.start();
    }

    bool isLoading()
    {
        return loadingThread.isRunning;
    }

    void loadThreadUnsafePart()
    {
        bool res = true;
        foreach(filename, asset; assetsByFilename)
        {
            if (asset.threadSafePartLoaded)
            {
                res = asset.loadThreadUnsafePart();
                asset.threadUnsafePartLoaded = res;
                if (!res)
                {
                    logError("Failed to load asset \"", filename, "\"");
                }
            }
        }
    }

    bool fileExists(string filename)
    {
        FileStat stat;
        return fs.stat(filename, stat);
    }

    void updateMonitor(double dt)
    {
        if (liveUpdate)
        {
            monitorTimer += dt;
            if (monitorTimer >= liveUpdatePeriod)
            {
                monitorTimer = 0.0;
                foreach(filename, asset; assetsByFilename)
                    monitorCheck(filename, asset);
            }
        }
    }

    protected void monitorCheck(string filename, Asset asset)
    {
        FileStat currentStat;
        if (fs.stat(filename, currentStat))
        {
            if (!asset.monitorInfo.fileExists)
            {
                asset.monitorInfo.fileExists = true;
            }
            else if (currentStat.modificationTimestamp >
                     asset.monitorInfo.lastStat.modificationTimestamp ||
                     currentStat.sizeInBytes !=
                     asset.monitorInfo.lastStat.sizeInBytes)
            {
                reloadAsset(filename);
                asset.monitorInfo.lastStat = currentStat;
                eventManager.generateFileChangeEvent(filename);
            }
        }
        else
        {
            if (asset.monitorInfo.fileExists)
            {
                asset.monitorInfo.fileExists = false;
            }
        }
    }
}
