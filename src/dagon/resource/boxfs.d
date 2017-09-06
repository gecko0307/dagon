module dagon.resource.boxfs;

import std.stdio;
import std.datetime;
import std.algorithm;

import dlib.core.memory;
import dlib.core.stream;
import dlib.filesystem.filesystem;
import dlib.container.dict;
import dlib.container.array;
import dlib.text.utils;

struct BoxEntry
{
    ulong offset;
    ulong size;
}

class UnmanagedArrayStream: ArrayStream
{
    ubyte[] buffer;

    this(ubyte[] data)
    {
        super(data, data.length);
        buffer = data;
    }

    ~this()
    {
        Delete(buffer);
    }
}

class BoxFileSystem: ReadOnlyFileSystem
{
    InputStream boxStrm;
    string rootDir = "";
    Dict!(BoxEntry, string) files;
    DynamicArray!string filenames;
    bool deleteStream = false;

    this(InputStream istrm, bool deleteStream = false, string rootDir = "")
    {
        this.deleteStream = deleteStream;
        this.rootDir = rootDir;
        this.boxStrm = istrm;

        ubyte[4] magic;
        boxStrm.fillArray(magic);
        assert(magic == "BOXF");

        ulong numFiles;
        boxStrm.readLE(&numFiles);

        files = New!(Dict!(BoxEntry, string));

        string rootDirWithSeparator;
        if (rootDir.length)
            rootDirWithSeparator = catStr(rootDir, "/");

        foreach(i; 0..numFiles)
        {
            uint filenameSize;
            boxStrm.readLE(&filenameSize);
            ubyte[] filenameBytes = New!(ubyte[])(filenameSize);
            boxStrm.fillArray(filenameBytes);
            string filename = cast(string)filenameBytes;
            ulong offset, size;
            boxStrm.readLE(&offset);
            boxStrm.readLE(&size);

            if (rootDirWithSeparator.length)
            {
                if (filename.startsWith(rootDirWithSeparator))
                {
                    string newFilename = filename[rootDirWithSeparator.length..$];
                    filenames.append(filename);
                    files[newFilename] = BoxEntry(offset, size);
                }
                else
                    Delete(filenameBytes);
            }
            else
            {
                filenames.append(filename);
                files[filename] = BoxEntry(offset, size);
            }
        }

        if (rootDirWithSeparator.length)
            Delete(rootDirWithSeparator);
    }

    bool stat(string filename, out FileStat stat)
    {
        if (filename in files)
        {
            stat.isFile = true;
            stat.isDirectory = false;
            stat.sizeInBytes = files[filename].size;
            stat.creationTimestamp = SysTime.init;
            stat.modificationTimestamp = SysTime.init;

            return true;
        }
        else
            return false;
    }

    InputStream openForInput(string filename)
    {
        if (filename in files)
        {
            BoxEntry file = files[filename];
            ubyte[] buffer = New!(ubyte[])(cast(size_t)file.size);
            boxStrm.position = file.offset;
            boxStrm.fillArray(buffer);
            return New!UnmanagedArrayStream(buffer);
        }
        else
            return null;
    }

    Directory openDir(string dir)
    {
        // TODO
        return null;
    }

    ~this()
    {
        foreach(f; filenames)
            Delete(f);
        filenames.free();
        Delete(files);
        if (deleteStream)
            Delete(boxStrm);
    }
}

