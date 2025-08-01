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

/**
 * Provides a virtual file system abstraction.
 *
 * Description:
 * The `dagon.core.vfs` module defines the `StdDirFileSystem` for mounting
 * directories and the `VirtualFileSystem` class for managing multiple
 * mounted file systems, enabling transparent file access across several 
 * directories or sources.
 *
 * Copyright: Timur Gafarov 2017-2025
 * License: $(LINK2 https://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Timur Gafarov
 */
module dagon.core.vfs;

import std.string;
import std.path;
import std.process;

import dlib.core.memory;
import dlib.core.stream;
import dlib.container.array;
import dlib.container.dict;
import dlib.filesystem.filesystem;
import dlib.filesystem.stdfs;
import dlib.text.str;

/**
 * Read-only file system implementation for a standard directory.
 *
 * Description:
 * Wraps a directory on the host file system and provides file and directory access.
 */
class StdDirFileSystem: ReadOnlyFileSystem
{
    /// The underlying standard file system.
    StdFileSystem stdfs;

    /// The root directory for this file system.
    string rootDir;

    /**
     * Constructs a `StdDirFileSystem` for the given root directory.
     *
     * Params:
     *   rootDir = The directory to mount as the root.
     */
    this(string rootDir)
    {
        this.rootDir = rootDir;
        stdfs = New!StdFileSystem();
    }

    /**
     * Retrieves file statistics for a file in the mounted directory.
     *
     * Params:
     *   filename = The file to query.
     *   stat     = Output parameter for file statistics.
     * Returns:
     *   `true` if the file exists, `false` otherwise.
     */
    bool stat(string filename, out FileStat stat)
    {
        string path = format("%s/%s", rootDir, filename);
        return stdfs.stat(path, stat);
    }

    /**
     * Opens a file for input (read-only).
     *
     * Params:
     *   filename = The file to open.
     * Returns:
     *   An input stream for the file, or `null` if not found.
     */
    InputStream openForInput(string filename)
    {
        string path = format("%s/%s", rootDir, filename);
        return stdfs.openForInput(path);
    }

    /**
     * Opens a directory for enumeration.
     *
     * Params:
     *   dir = The directory to open.
     * Returns:
     *   A directory object for enumeration, or `null` if not found.
     */
    Directory openDir(string dir)
    {
        string path = format("%s/%s", rootDir, dir);
        return stdfs.openDir(path);
    }

    /// Destructor. Cleans up the underlying file system.
    ~this()
    {
        Delete(stdfs);
    }
}

/**
 * Virtual file system that manages multiple mounted read-only file systems.
 *
 * Description:
 * Allows mounting multiple directories or file system sources and provides
 * unified file access across all mounted sources.
 */
class VirtualFileSystem: ReadOnlyFileSystem
{
    /// Standard file system for physical access.
    StdFileSystem stdfs;
    
    /// Array of mounted file systems.
    Array!ReadOnlyFileSystem mounted;
    
    String appDataPath;

    /// Constructs an empty virtual file system.
    this()
    {
        stdfs = New!StdFileSystem();
        mount(stdfs);
    }

    /**
     * Mounts a directory as a new file system source.
     *
     * Params:
     *   dir = The directory to mount.
     */
    void mount(string dir)
    {
        StdDirFileSystem fs = New!StdDirFileSystem(dir);
        mounted.append(fs);
    }
    
    void mountAppDataDirectory(string folderName)
    {
        if (folderName.length > 0)
        {
            string homeDirVar = "";
            version(Windows) homeDirVar = "APPDATA";
            version(Posix) homeDirVar = "HOME";
            auto homeDir = environment.get(homeDirVar, "");
            if (homeDir.length)
            {
                string dirSeparator;
                version(Windows) dirSeparator = "\\";
                version(Posix) dirSeparator = "/";
                
                appDataPath = String(homeDir);
                appDataPath ~= dirSeparator;
                appDataPath ~= folderName;
                
                mount(appDataPath);
            }
        }
    }
    
    void createAppDataDirectory()
    {
        if (appDataPath.length > 0)
            stdfs.createDir(appDataPath, true);
    }

    /**
     * Mounts an existing read-only file system.
     *
     * Params:
     *   fs = The file system to mount.
     */
    void mount(ReadOnlyFileSystem fs)
    {
        mounted.append(fs);
    }

    /**
     * Returns the root directory containing the specified file, if found.
     *
     * Params:
     *   filename = The file to search for.
     * Returns:
     *   The root directory path, or an empty string if not found.
     */
    string containingDir(string filename)
    {
        string res;
        foreach_reverse(i, fs; mounted)
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

    /**
     * Retrieves file statistics for a file across all mounted file systems.
     *
     * Params:
     *   filename = The file to query.
     *   stat     = Output parameter for file statistics.
     * Returns:
     *   `true` if the file exists in any mounted file system, `false` otherwise.
     */
    bool stat(string filename, out FileStat stat)
    {
        bool res = false;
        foreach_reverse(i, fs; mounted)
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

    /**
     * Opens a file for input (read-only) from the first mounted file system where it exists.
     *
     * Params:
     *   filename = The file to open.
     * Returns:
     *   An input stream for the file, or `null` if not found.
     */
    InputStream openForInput(string filename)
    {
        foreach_reverse(i, fs; mounted)
        {
            FileStat s;
            if (fs.stat(filename, s))
            {
                return fs.openForInput(filename);
            }
        }

        return null;
    }

    /**
     * Opens a directory for enumeration from the first mounted file system where it exists.
     *
     * Params:
     *   path = The directory to open.
     * Returns:
     *   A directory object for enumeration, or `null` if not found.
     */
    Directory openDir(string path)
    {
        // TODO
        return null;
    }
    
    /**
     * Checks if a file exists in the VFS.
     *
     * Params:
     *   filename = Path to the file.
     * Returns:
     *   `true` if the file exists, `false` otherwise.
     */
    bool exists(string filename)
    {
        FileStat stat;
        return this.stat(filename, stat);
    }

    /// Destructor. Cleans up all mounted file systems.
    ~this()
    {
        foreach(i, fs; mounted)
            Delete(fs);
        mounted.free();
        appDataPath.free();
    }
}
