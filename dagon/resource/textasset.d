module dagon.resource.textasset;

import dlib.core.memory;
import dlib.core.stream;
import dlib.filesystem.filesystem;
import dlib.filesystem.stdfs;

import dagon.resource.asset;

class TextAsset: Asset
{
    string text;

    this()
    {
        
    }

    ~this()
    {
        release();
    }

    bool loadThreadSafePart(string filename, InputStream istrm, ReadOnlyFileSystem fs, AssetManager mngr)
    {
        text = readText(istrm);
        return true;
    }

    bool loadThreadUnsafePart()
    {
        return true;
    }

    void release()
    {
        if (text.length)
            Delete(text);
    }
}

