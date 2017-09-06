module dagon.resource.textasset;

import dlib.core.memory;
import dlib.core.stream;
import dlib.filesystem.filesystem;
import dlib.filesystem.stdfs;

import dagon.core.ownership;
import dagon.resource.asset;

class TextAsset: Asset
{
    string text;

    this(Owner o)
    {
        super(o);
    }

    ~this()
    {
        release();
    }

    override bool loadThreadSafePart(string filename, InputStream istrm, ReadOnlyFileSystem fs, AssetManager mngr)
    {
        text = readText(istrm);
        return true;
    }

    override bool loadThreadUnsafePart()
    {
        return true;
    }

    override void release()
    {
        if (text.length)
            Delete(text);
    }
}

