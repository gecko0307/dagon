module dagon.resource.fontasset;

import dlib.core.memory;
import dlib.core.stream;
import dlib.filesystem.filesystem;
import dlib.filesystem.stdfs;

import dagon.core.ownership;
import dagon.resource.asset;
import dagon.ui.ftfont;

class FontAsset: Asset
{
    FreeTypeFont font;
    ubyte[] buffer;

    this(uint height, Owner o)
    {
        super(o);
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
        buffer = New!(ubyte[])(cast(size_t)s.sizeInBytes);
        istrm.fillArray(buffer);
        font.createFromMemory(buffer);
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
        if (buffer.length)
            Delete(buffer);
    }
}

