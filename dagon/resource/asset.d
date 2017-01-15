module dagon.resource.asset;

import std.stdio;

import dlib.core.memory;
import dlib.core.stream;
import dlib.container.dict;
import dlib.filesystem.filesystem;
import dlib.filesystem.stdfs;
import dlib.image.unmanaged;

import dagon.core.ownership;
import dagon.core.vfs;

struct MonitorInfo
{
    FileStat lastStat;
    bool fileExists = false;
}

/*
enum FileEvent
{
    Created,
    Deleted,
    Modified
}
*/

abstract class Asset
{
    MonitorInfo monitorInfo;
    bool loadThreadSafePart(string filename, InputStream istrm, ReadOnlyFileSystem fs, AssetManager mngr);
    bool loadThreadUnsafePart();
    void release();
}

class AssetManager
{
    Dict!(Asset, string) assetsByFilename;
    VirtualFileSystem fs;
    UnmanagedImageFactory imageFactory;

    bool liveUpdate = false;
    double liveUpdatePeriod = 5.0;

    protected double monitorTimer = 0.0;

    this()
    {
        assetsByFilename = New!(Dict!(Asset, string));
        fs = New!VirtualFileSystem();
        fs.mount(".");
        imageFactory = New!UnmanagedImageFactory();
    }

    ~this()
    {
        foreach(filename, asset; assetsByFilename)
        {
            Delete(asset);
        }
        Delete(assetsByFilename);
        Delete(fs);
        Delete(imageFactory);
    }

    void mountDirectory(string dir)
    {
        fs.mount(dir);
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

    void removeAsset(string name)
    {
        Delete(assetsByFilename[name]);
        assetsByFilename.remove(name);
    }

    void releaseAssets()
    {
        foreach(filename, asset; assetsByFilename)
        {
            Delete(asset);
        }
        Delete(assetsByFilename);
        assetsByFilename = New!(Dict!(Asset, string));
    }

    bool loadAssetThreadSafePart(Asset asset, string filename)
    {
        if (!fileExists(filename))
        {
            writefln("Error: cannot find file \"%s\"", filename);
            return false;
        }
            
        auto fstrm = fs.openForInput(filename);
        
        bool res = asset.loadThreadSafePart(filename, fstrm, fs, this);
        if (!res)
        {
            writefln("Error: failed to load asset \"%s\"", filename);
        }
            
        Delete(fstrm);
        return res;
    }

    bool loadThreadSafePart()
    {
        bool res = true;
        foreach(filename, asset; assetsByFilename)
        {
            res = loadAssetThreadSafePart(asset, filename);
            if (!res)
                break;
        }
        return res;
    }

    bool loadThreadUnsafePart()
    {
        bool res = true;
        foreach(filename, asset; assetsByFilename)
        {
            res = asset.loadThreadUnsafePart();
            if (!res)
            {
                writefln("Error: failed to load asset \"%s\"", filename);
                break;
            }
        }
        return res;
    }

    void reloadAsset(string name)
    {
        auto asset = assetsByFilename[name];
        asset.release();
        bool res = loadAssetThreadSafePart(asset, name);
        if (res)
            asset.loadThreadUnsafePart();
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
                //if (callbackFunc)
                //    callbackFunc(FileEvent.Created);
            }
            else if (currentStat.modificationTimestamp > 
                     asset.monitorInfo.lastStat.modificationTimestamp ||
                     currentStat.sizeInBytes != 
                     asset.monitorInfo.lastStat.sizeInBytes)
            {
                //if (callbackFunc)
                //    callbackFunc(FileEvent.Modified);
                reloadAsset(filename);
                asset.monitorInfo.lastStat = currentStat;
            }
        }
        else
        {
            if (asset.monitorInfo.fileExists)
            {
                asset.monitorInfo.fileExists = false;
                //if (callbackFunc)
                //    callbackFunc(FileEvent.Deleted);
            }
        }
    }
}

