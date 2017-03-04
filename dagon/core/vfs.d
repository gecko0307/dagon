module dagon.core.vfs;

import std.string;
import std.path;
import dlib.core.memory;
import dlib.core.stream;
import dlib.container.array;
import dlib.container.dict;
import dlib.filesystem.filesystem;
import dlib.filesystem.stdfs;

class StdDirFileSystem: ReadOnlyFileSystem
{
    StdFileSystem stdfs;
    string rootDir;

    this(string rootDir)
    {
        this.rootDir = rootDir;
        stdfs = New!StdFileSystem();
    }

    bool stat(string filename, out FileStat stat)
    {
        string path = format("%s/%s", rootDir, filename);
        return stdfs.stat(path, stat);
    }

    InputStream openForInput(string filename)
    {
        string path = format("%s/%s", rootDir, filename);
        return stdfs.openForInput(path);
    }

    Directory openDir(string dir)
    {
        string path = format("%s/%s", rootDir, dir);
        return stdfs.openDir(path);
    }

    ~this()
    {
        Delete(stdfs);
    }
}

class VirtualFileSystem: ReadOnlyFileSystem
{
    DynamicArray!ReadOnlyFileSystem mounted;

    this()
    {
    }

    void mount(string dir)
    {
        StdDirFileSystem fs = New!StdDirFileSystem(dir);
        mounted.append(fs);
    }

    void mount(ReadOnlyFileSystem fs)
    {
        mounted.append(fs);
    }

    string containingDir(string filename)
    {
        string res;
        foreach(i, fs; mounted)
        {
            if (cast(StdDirFileSystem)fs)
            {
                FileStat s;
                if (fs.stat(filename, s))
                {
                    res = (cast(StdDirFileSystem)fs).rootDir;
                    break;
                }
            }
        }
        return res;
    }

    bool stat(string filename, out FileStat stat)
    {
        bool res = false;
        foreach(i, fs; mounted)
        {
            FileStat s;
            if (fs.stat(filename, s))
            {
                stat = s;
                res = true;
                break;
            }
        }

        return res;
    }

    InputStream openForInput(string filename)
    {
        foreach(i, fs; mounted)
        {
            FileStat s;
            if (fs.stat(filename, s))
            {
                return fs.openForInput(filename);
            }
        }

        return null;
    }

    Directory openDir(string path)
    {
        // TODO
        return null;
    }

    ~this()
    {
        foreach(i, fs; mounted)
            Delete(fs);
        mounted.free();
    }
}
