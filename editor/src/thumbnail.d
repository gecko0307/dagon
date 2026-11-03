/*
Copyright (c) 2023-2026 Timur Gafarov

Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation (the "Software"), to deal in
the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
*/
module thumbnail;

import std.algorithm: max, min;
import std.math: floor;
import std.path: extension;
import std.string: toLower;
import dagon.core.bindings: GL_RGB, GL_RGBA, GL_TEXTURE_2D, GL_UNSIGNED_BYTE;
import dagon.resource.asset: AssetManager;
import dagon.resource.texture: TextureAsset;
import dagon.graphics.texture: Texture, TextureBuffer, TextureSize;
import dlib.container.array: Array;
import dlib.core.memory: Delete, New;
import dlib.core.ownership: Owner;

struct ThumbnailEntry
{
    string filename;
    Texture texture;
}

class ThumbnailGenerator: Owner
{
    enum uint maxDimension = 128;

    private AssetManager assetManager;
    private Array!ThumbnailEntry thumbnails;

    this(AssetManager assetManager)
    {
        super(assetManager);
        this.assetManager = assetManager;
    }

    ~this()
    {
        foreach (entry; thumbnails)
        {
            auto filename = cast(char[])entry.filename;
            Delete(filename);
        }
        thumbnails.free();
    }

    Texture getThumbnail(string filename)
    {
        string format = extension(filename).toLower;
        if (assetManager.textureLoader(format) is null)
            return null;

        foreach (entry; thumbnails)
        {
            if (entry.filename == filename)
                return entry.texture;
        }

        auto source = New!TextureAsset(this);
        source.persistent = true;
        assetManager.preloadExternalAsset(source, filename);
        bool retainSource;
        scope(exit)
        {
            if (!retainSource)
                source.release();
        }

        Texture result;
        if (source.threadUnsafePartLoaded &&
            source.buffer.format.target == GL_TEXTURE_2D &&
            source.buffer.format.pixelType == GL_UNSIGNED_BYTE &&
            (source.buffer.format.format == GL_RGB ||
             source.buffer.format.format == GL_RGBA))
        {
            uint sourceWidth = source.buffer.size.width;
            uint sourceHeight = source.buffer.size.height;
            uint channels = source.buffer.format.format == GL_RGBA ? 4 : 3;
            size_t sourceDataSize = cast(size_t)sourceWidth * sourceHeight * channels;

            if (sourceWidth > 0 && sourceHeight > 0 &&
                source.buffer.data.length >= sourceDataSize)
            {
                float scale = min(1.0f, cast(float)maxDimension /
                    cast(float)(sourceWidth > sourceHeight ? sourceWidth : sourceHeight));
                uint width = max(1, cast(uint)(sourceWidth * scale));
                uint height = max(1, cast(uint)(sourceHeight * scale));

                TextureBuffer thumbnailBuffer;
                thumbnailBuffer.format = source.buffer.format;
                thumbnailBuffer.size = TextureSize(width, height, 1);
                thumbnailBuffer.mipLevels = 1;
                thumbnailBuffer.data = New!(ubyte[])(cast(size_t)width * height * channels);

                foreach (y; 0 .. height)
                {
                    float sourceY = (cast(float)y + 0.5f) * sourceHeight / height - 0.5f;
                    sourceY = sourceY < 0.0f ? 0.0f : sourceY;
                    uint y0 = cast(uint)floor(sourceY);
                    uint y1 = min(y0 + 1, sourceHeight - 1);
                    float fy = sourceY - y0;

                    foreach (x; 0 .. width)
                    {
                        float sourceX = (cast(float)x + 0.5f) * sourceWidth / width - 0.5f;
                        sourceX = sourceX < 0.0f ? 0.0f : sourceX;
                        uint x0 = cast(uint)floor(sourceX);
                        uint x1 = min(x0 + 1, sourceWidth - 1);
                        float fx = sourceX - x0;

                        foreach (channel; 0 .. channels)
                        {
                            size_t topLeft = (cast(size_t)y0 * sourceWidth + x0) * channels + channel;
                            size_t topRight = (cast(size_t)y0 * sourceWidth + x1) * channels + channel;
                            size_t bottomLeft = (cast(size_t)y1 * sourceWidth + x0) * channels + channel;
                            size_t bottomRight = (cast(size_t)y1 * sourceWidth + x1) * channels + channel;
                            float top = source.buffer.data[topLeft] * (1.0f - fx) +
                                source.buffer.data[topRight] * fx;
                            float bottom = source.buffer.data[bottomLeft] * (1.0f - fx) +
                                source.buffer.data[bottomRight] * fx;
                            float value = top * (1.0f - fy) + bottom * fy;
                            size_t target = (cast(size_t)y * width + x) * channels + channel;
                            thumbnailBuffer.data[target] = cast(ubyte)(value + 0.5f);
                        }
                    }
                }

                result = New!Texture(this);
                result.createFromBuffer(thumbnailBuffer, false);
                if (!result.valid)
                    result = null;
                else
                {
                    result.bind();
                    result.unbind();
                }
                Delete(thumbnailBuffer.data);
            }
        }

        if (result is null && source.threadUnsafePartLoaded && source.texture.valid)
        {
            result = source.texture;
            result.bind();
            result.unbind();
            retainSource = true;
        }

        // Array storage is GC-free, so cached filenames need explicit ownership.
        auto cachedFilename = New!(char[])(filename.length);
        cachedFilename[] = filename[];
        thumbnails.append(ThumbnailEntry(cast(string)cachedFilename, result));
        return result;
    }
}
