module dagon.resource.fontasset;

import dlib.core.memory;
import dlib.core.stream;
import dlib.filesystem.filesystem;
import dlib.filesystem.stdfs;

import dagon.resource.asset;
import dagon.ui.ftfont;

class FontAsset: Asset
{
    FreeTypeFont font;

    this(uint height)
    {
        font = New!FreeTypeFont(height);
    }

    ~this()
    {
        release();
    }

    override bool loadThreadSafePart(string filename, InputStream istrm, ReadOnlyFileSystem fs, AssetManager mngr)
    {
        FileStat s;
        fs.stat(filename, s);
        ubyte[] buffer = New!(ubyte[])(cast(size_t)s.sizeInBytes);
        istrm.fillArray(buffer);
        font.createFromMemory(buffer);
        Delete(buffer);
        return true;
    }

    override bool loadThreadUnsafePart()
    {
        font.preloadASCII();
        return true;
    }

    override void release()
    {
        if (font)
            Delete(font);
    }
}

