module dagon.resource.iqm;

import std.stdio;
import std.math;
import std.string;
import std.path;

import dlib.core.memory;
import dlib.core.stream;
import dlib.container.array;
import dlib.container.dict;
import dlib.filesystem.filesystem;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.quaternion;
import dlib.math.interpolation;

import dagon.core.ownership;
import dagon.graphics.animmodel;
import dagon.graphics.texture;
import dagon.resource.asset;
import dagon.resource.serialization;
import dagon.resource.textureasset;

enum IQM_VERSION = 2;

struct IQMHeader
{
    ubyte[16] magic;
    uint ver;
    uint filesize;
    uint flags;
    uint numText, ofsText;
    uint numMeshes, ofsMeshes;
    uint numVertexArrays, numVertices, ofsVertexArrays;
    uint numTriangles, ofsTriangles, ofsAdjacency;
    uint numJoints, ofsJoints;
    uint numPoses, ofsPoses;
    uint numAnims, ofsAnims;
    uint numFrames, numFrameChannels, ofsFrames, ofsBounds;
    uint numComment, ofsComment;
    uint numExtensions, ofsExtensions;
}

struct IQMVertexArray
{
    uint type;
    uint flags;
    uint format;
    uint size;
    uint offset;
}

alias uint[3] IQMTriangle;

struct IQMJoint
{
    uint name;
    int parent;
    Vector3f translation;
    Quaternionf rotation;
    Vector3f scaling;
}

struct IQMMesh
{
    uint name;
    uint material;
    uint firstVertex, numVertices;
    uint firstTriangle, numTriangles;
}

alias ubyte[4] IQMBlendIndex;
alias ubyte[4] IQMBlendWeight;

enum
{
    IQM_POSITION     = 0,
    IQM_TEXCOORD     = 1,
    IQM_NORMAL       = 2,
    IQM_TANGENT      = 3,
    IQM_BLENDINDEXES = 4,
    IQM_BLENDWEIGHTS = 5,
    IQM_COLOR        = 6,
    IQM_CUSTOM       = 0x10
}

struct IQMPose
{
    int parent;
    uint mask;
    float[10] channelOffset;
    float[10] channelScale;
}

struct IQMAnim
{
    uint name;
    uint firstFrame;
    uint numFrames;
    float framerate;
    uint flags;
}

//version = IQMDebug;

class IQMModel: AnimatedModel
{
    DynamicArray!Vector3f vertices;
    DynamicArray!Vector3f normals;
    DynamicArray!Vector2f texcoords;
    // TODO: tangents

    DynamicArray!IQMBlendIndex blendIndices;
    DynamicArray!IQMBlendWeight blendWeights;

    IQMTriangle[] tris;
    IQMVertexArray[] vas;
    IQMMesh[] meshes;
    AnimationFacegroup[] facegroups;

    DynamicArray!IQMJoint joints;

    Matrix4x4f[] baseFrame;
    Matrix4x4f[] invBaseFrame;
    
    Matrix4x4f[] frames;
    
    uint numFrames;

    ubyte[] textBuffer;

    //Material[uint] material;

    Dict!(IQMAnim, string) animations;
    
    this(InputStream istrm, ReadOnlyFileSystem rofs, AssetManager mngr)
    {
        load(istrm, rofs, mngr);
    }

    ~this()
    {
        release();
    }

    void release()
    {
        vertices.free();
        normals.free();
        texcoords.free();

        blendIndices.free();
        blendWeights.free();

        if (tris.length) Delete(tris);
        if (vas.length) Delete(vas);
        if (meshes.length) Delete(meshes);

        joints.free();

        if (baseFrame.length) Delete(baseFrame);
        if (invBaseFrame.length) Delete(invBaseFrame);
        if (frames.length) Delete(frames);

        if (textBuffer.length) Delete(textBuffer);

        if (animations) Delete(animations);

        if (facegroups) Delete(facegroups);
    }
    
    void load(InputStream istrm, ReadOnlyFileSystem rofs, AssetManager mngr)
    {
        // Header part
        IQMHeader hdr = istrm.read!(IQMHeader, true);

        version(IQMDebug)
        {
            writefln("hdr.magic: %s", cast(string)hdr.magic);
            writefln("hdr.ver: %s", hdr.ver);
        }
        assert(cast(string)hdr.magic == "INTERQUAKEMODEL\0");
        assert(hdr.ver == IQM_VERSION);

        version(IQMDebug)
        {
            writefln("hdr.numText: %s", hdr.numText);
            writefln("hdr.ofsText: %s", hdr.ofsText);
        }
       
        istrm.setPosition(hdr.ofsText);
        textBuffer = New!(ubyte[])(hdr.numText);
        istrm.fillArray(textBuffer);
        version(IQMDebug)
            writefln("text:\n%s", cast(string)textBuffer);

        // FIXME: 
        //Delete(buf);

        // Vertex data part
        version(IQMDebug)
        {
            writefln("hdr.numVertexArrays: %s", hdr.numVertexArrays);
            writefln("hdr.ofsVertexArrays: %s", hdr.ofsVertexArrays);
        }

        vas = New!(IQMVertexArray[])(hdr.numVertexArrays);
        istrm.setPosition(hdr.ofsVertexArrays);
        foreach(i; 0..hdr.numVertexArrays)
        {
            vas[i] = istrm.read!(IQMVertexArray, true);
        }

        // FIXME:
        //Delete(vas);

        foreach(i, va; vas)
        {
            version(IQMDebug)
            {
                writefln("Vertex array %s:", i);
                writefln("va.type: %s", va.type);
                writefln("va.flags: %s", va.flags);
                writefln("va.format: %s", va.format);
                writefln("va.size: %s", va.size);
                writefln("va.offset: %s", va.offset);
                writeln("---------------");
            }

            if (va.type == IQM_POSITION)
            {
                assert(va.size == 3);
                // TODO: format asserion
                auto verts = New!(Vector3f[])(hdr.numVertices);
                istrm.setPosition(va.offset);
                istrm.fillArray(verts);
                vertices.append(verts);
                Delete(verts);
            }
            else if (va.type == IQM_NORMAL)
            {
                assert(va.size == 3);
                // TODO: format asserion
                auto norms = New!(Vector3f[])(hdr.numVertices);
                istrm.setPosition(va.offset);
                istrm.fillArray(norms);
                normals.append(norms);
                Delete(norms);
            }
            else if (va.type == IQM_TEXCOORD)
            {
                assert(va.size == 2);
                // TODO: format asserion
                auto texs = New!(Vector2f[])(hdr.numVertices);
                istrm.setPosition(va.offset);
                istrm.fillArray(texs);
                texcoords.append(texs);
                Delete(texs);
            }
            /* TODO: IQM_TANGENT */ 
            else if (va.type == IQM_BLENDINDEXES)
            {
                assert(va.size == 4);
                // TODO: format asserion
                auto bi = New!(IQMBlendIndex[])(hdr.numVertices);
                istrm.setPosition(va.offset);
                istrm.fillArray(bi);
                blendIndices.append(bi);
                Delete(bi);
            }
            else if (va.type == IQM_BLENDWEIGHTS)
            {
                assert(va.size == 4);
                // TODO: format asserion
                auto bw = New!(IQMBlendWeight[])(hdr.numVertices);
                istrm.setPosition(va.offset);
                istrm.fillArray(bw);
                blendWeights.append(bw);
                Delete(bw);
            }
        }

        version(IQMDebug)
        {
            writefln("numVertices: %s", vertices.length);
            writefln("numNormals: %s", normals.length);
            writefln("numTexcoords: %s", texcoords.length);

            writefln("hdr.numTriangles: %s", hdr.numTriangles);
            writefln("hdr.ofsTriangles: %s", hdr.ofsTriangles);
        }

        tris = New!(IQMTriangle[])(hdr.numTriangles);
        istrm.setPosition(hdr.ofsTriangles);
        foreach(i; 0..hdr.numTriangles)
        {
            tris[i] = istrm.read!IQMTriangle;
            uint tmp = tris[i][0];
            tris[i][0] = tris[i][2];
            tris[i][2] = tmp;
        }

        version(IQMDebug)
            writefln("hdr.ofsAdjacency: %s", hdr.ofsAdjacency);

        // Skeleton part
        version(IQMDebug)
        {
            writefln("hdr.numJoints: %s", hdr.numJoints);
            writefln("hdr.ofsJoints: %s", hdr.ofsJoints);
        }

        baseFrame = New!(Matrix4x4f[])(hdr.numJoints);
        invBaseFrame = New!(Matrix4x4f[])(hdr.numJoints);
        istrm.setPosition(hdr.ofsJoints);
        foreach(i; 0..hdr.numJoints)
        {
            IQMJoint j = istrm.read!(IQMJoint, true);

            j.rotation.normalize();
            baseFrame[i] = transformationMatrix(j.rotation, j.translation, j.scaling);
            invBaseFrame[i] = baseFrame[i].inverse;

            if (j.parent >= 0)
            {
                baseFrame[i] = baseFrame[j.parent] * baseFrame[i];
                invBaseFrame[i] = invBaseFrame[i] * invBaseFrame[j.parent];
            }

            assert(validMatrix(baseFrame[i]));
            assert(validMatrix(invBaseFrame[i]));

            assert(baseFrame[i].isAffine);
            assert(invBaseFrame[i].isAffine);

            joints.append(j);
        }

        // Meshes part
        version(IQMDebug)
        {
            writefln("hdr.numMeshes: %s", hdr.numMeshes);
            writefln("hdr.ofsMeshes: %s", hdr.ofsMeshes);
        }
        meshes = New!(IQMMesh[])(hdr.numMeshes);

        facegroups = New!(AnimationFacegroup[])(meshes.length);

        istrm.setPosition(hdr.ofsMeshes);
        foreach(i; 0..hdr.numMeshes)
        {
            meshes[i] = istrm.read!(IQMMesh, true);

            // Load texture
            uint matIndex = meshes[i].material;
            version(IQMDebug)
                writefln("matIndex: %s", matIndex);
                
            if (matIndex > 0)
            {
                char* texFilenamePtr = cast(char*)&textBuffer[matIndex];
                string texFilename = cast(string)fromStringz(texFilenamePtr);
                version(IQMDebug)
                    writefln("material: %s", texFilename);

                facegroups[i].firstTriangle = meshes[i].firstTriangle;
                facegroups[i].numTriangles = meshes[i].numTriangles;
                facegroups[i].textureName = texFilename;

                if (!mngr.assetExists(texFilename))
                {
                    auto texAsset = New!TextureAsset(mngr.imageFactory, mngr);
                    mngr.addAsset(texAsset, texFilename);
                    texAsset.threadSafePartLoaded = mngr.loadAssetThreadSafePart(texAsset, texFilename);
                    facegroups[i].texture = texAsset.texture;
                }
                else
                    facegroups[i].texture = (cast(TextureAsset)mngr.getAsset(texFilename)).texture;
            }
        }
    
        // Animation part
    
        // Number of poses should be the same as bindpose joints
        version(IQMDebug)
            writefln("hdr.numPoses: %s", hdr.numPoses);
        assert(hdr.numPoses == hdr.numJoints);

        version(IQMDebug)
        {
            writefln("hdr.numFrames: %s", hdr.numFrames);
            writefln("hdr.numFrameChannels: %s", hdr.numFrameChannels);
        }
        
        // Read poses
        istrm.setPosition(hdr.ofsPoses);
        IQMPose[] poses = New!(IQMPose[])(hdr.numPoses);
        foreach(i; 0..hdr.numPoses)
        {
            poses[i] = istrm.read!(IQMPose, true);
        }

        // Read frames
        numFrames = hdr.numFrames;
        frames = New!(Matrix4x4f[])(hdr.numFrames * hdr.numPoses);
        istrm.setPosition(hdr.ofsFrames);
        uint fi = 0;
        foreach(i; 0..hdr.numFrames)
        foreach(j; 0..hdr.numPoses)
        {
            auto p = &poses[j];
            
            Vector3f trans, scale;
            Quaternionf rot;
            trans.x = p.channelOffset[0]; if (p.mask & 0x01) trans.x += istrm.read!(ushort, true) * p.channelScale[0];
            trans.y = p.channelOffset[1]; if (p.mask & 0x02) trans.y += istrm.read!(ushort, true) * p.channelScale[1];
            trans.z = p.channelOffset[2]; if (p.mask & 0x04) trans.z += istrm.read!(ushort, true) * p.channelScale[2];
            rot.x = p.channelOffset[3]; if(p.mask&0x08) rot.x += istrm.read!(ushort, true) * p.channelScale[3];
            rot.y = p.channelOffset[4]; if(p.mask&0x10) rot.y += istrm.read!(ushort, true) * p.channelScale[4];
            rot.z = p.channelOffset[5]; if(p.mask&0x20) rot.z += istrm.read!(ushort, true) * p.channelScale[5];
            rot.w = p.channelOffset[6]; if(p.mask&0x40) rot.w += istrm.read!(ushort, true) * p.channelScale[6];
            scale.x = p.channelOffset[7]; if(p.mask&0x80) scale.x += istrm.read!(ushort, true) * p.channelScale[7];
            scale.y = p.channelOffset[8]; if(p.mask&0x100) scale.y += istrm.read!(ushort, true) * p.channelScale[8];
            scale.z = p.channelOffset[9]; if(p.mask&0x200) scale.z += istrm.read!(ushort, true) * p.channelScale[9];
            
            rot.normalize();            
            Matrix4x4f m = transformationMatrix(rot, trans, scale);
            assert(validMatrix(m));
            
            // Concatenate each pose with the inverse base pose to avoid doing this at animation time.
            // If the joint has a parent, then it needs to be pre-concatenated with its parent's base pose.
            if (p.parent >= 0)
                frames[i * hdr.numPoses + j] = 
                    baseFrame[p.parent] * m * invBaseFrame[j];
            else 
                frames[i * hdr.numPoses + j] = m * invBaseFrame[j];
        }
    
        // Read animations
        animations = New!(Dict!(IQMAnim, string));
        istrm.setPosition(hdr.ofsAnims);
        foreach(i; 0..hdr.numAnims)
        {
            IQMAnim anim = istrm.read!(IQMAnim, true);
        
            char* namePtr = cast(char*)&textBuffer[anim.name];
            string name = cast(string)fromStringz(namePtr);
            version(IQMDebug)
            {
                writefln("anim.name: %s", name);
            }
        
            animations[name] = anim;
            
            version(IQMDebug)
            {
                writefln("anim.firstFrame: %s", anim.firstFrame);
                writefln("anim.numFrames: %s", anim.numFrames);
            }
        }

        if (poses.length) Delete(poses);
    }

    Vector3f[] getVertices()
    {
        return vertices.data;
    }

    Vector3f[] getNormals()
    {
        return normals.data;
    }

    Vector2f[] getTexcoords()
    {
        return texcoords.data;
    }

    uint[3][] getTriangles()
    {
        return tris;
    }

    size_t numBones()
    {
        return joints.length;
    }

    AnimationFacegroup[] getFacegroups()
    {
        return facegroups;
    }

    uint numAnimationFrames()
    {
        return numFrames;
    }

    void calcBindPose(AnimationFrameData* data)
    {
        foreach(i, ref j; joints)
        {
            data.frame[i] = baseFrame[i] * invBaseFrame[i];
        }

        foreach(i, v; vertices)
        {
            auto bi = blendIndices[i];
            auto bw = blendWeights[i];

            float w = (cast(float)bw[0])/255.0f;
            Matrix4x4f mat = multScalarAffine(data.frame[bi[0]], w);

            for (uint j = 1; j < 4 && bw[j] > 0.0; j++)
            {
                w = (cast(float)bw[j])/255.0f;
                auto tmp = multScalarAffine(data.frame[bi[j]], w);
                mat = addMatrixAffine(mat, tmp);
            }

            assert(validMatrix(mat));
            assert(mat.isAffine);

            data.vertices[i] = vertices[i] * mat;
            data.normals[i] = normals[i] * matrix4x4to3x3(mat);
            data.normals[i].normalize();
        }
    }

    void calcFrame(
        uint f1, 
        uint f2, 
        float t, 
        AnimationFrameData* data)
    {            
        Matrix4x4f* mat1 = &frames[f1 * joints.length];
        Matrix4x4f* mat2 = &frames[f2 * joints.length];
        
        // Interpolate between two frames
        foreach(i, ref j; joints)
        {
            Matrix4x4f mat = mat1[i] * (1.0f - t) + mat2[i] * t;
            if (j.parent >= 0)
                data.frame[i] = data.frame[j.parent] * mat;
            else
                data.frame[i] = mat;
        }
        
        // Update vertex data
        foreach(i, v; vertices)
        {
            auto bi = blendIndices[i];
            auto bw = blendWeights[i];

            float w = (cast(float)bw[0])/255.0f;
            Matrix4x4f mat = multScalarAffine(data.frame[bi[0]], w);
            
            for (uint j = 1; j < 4 && bw[j] > 0.0; j++)
            {
                w = (cast(float)bw[j])/255.0f;
                auto tmp = multScalarAffine(data.frame[bi[j]], w);
                mat = addMatrixAffine(mat, tmp);
            }

            assert(validMatrix(mat));
            assert(mat.isAffine);

            data.vertices[i] = vertices[i] * mat;
            data.normals[i] = normals[i] * matrix4x4to3x3(mat);
            data.normals[i].normalize();
        }
    }

    void blendFrame(
        uint f1, 
        uint f2, 
        float t, 
        AnimationFrameData* data,
        float blendFactor)
    {
        Matrix4x4f* mat1 = &frames[f1 * joints.length];
        Matrix4x4f* mat2 = &frames[f2 * joints.length];
        
        // Interpolate between two frames
        foreach(i, ref j; joints)
        {
            Matrix4x4f mat = mat1[i] * (1.0f - t) + mat2[i] * t;
            if (j.parent >= 0)
                data.frame[i] = data.frame[j.parent] * mat;
            else
                data.frame[i] = mat;
        }
        
        // Update vertex data
        foreach(i, v; vertices)
        {
            auto bi = blendIndices[i];
            auto bw = blendWeights[i];

            float w = (cast(float)bw[0])/255.0f;
            Matrix4x4f mat = multScalarAffine(data.frame[bi[0]], w);
            
            for (uint j = 1; j < 4 && bw[j] > 0.0; j++)
            {
                w = (cast(float)bw[j])/255.0f;
                auto tmp = multScalarAffine(data.frame[bi[j]], w);
                mat = addMatrixAffine(mat, tmp);
            }

            assert(validMatrix(mat));
            assert(mat.isAffine);

            data.vertices[i] = lerp(data.vertices[i], vertices[i] * mat, blendFactor);
            data.normals[i] = lerp(data.normals[i], normals[i] * matrix4x4to3x3(mat), blendFactor);
            //data.normals[i].normalize();
        }
    }

    bool getAnimation(string name, AnimationData* data)
    {
        if (!name.length)
        {
            data.firstFrame = 0;
            data.numFrames = numFrames;
            return true;
        }

        if (!(name in animations))
            return false;

        auto anim = animations[name];
        data.firstFrame = anim.firstFrame;
        data.numFrames = anim.numFrames;
        data.framerate = anim.framerate;
        return true;
    }
}

class IQMAsset: Asset
{
    IQMModel model;

    this(Owner o)
    {
        super(o);
    }

    ~this()
    {
        if (model)
            Delete(model);
    }

    override bool loadThreadSafePart(string filename, InputStream istrm, ReadOnlyFileSystem fs, AssetManager mngr)
    {
        model = New!IQMModel(istrm, fs, mngr);
        return true;
    }

    override bool loadThreadUnsafePart()
    {
        return true;
    }

    override void release()
    {
        if (model)
            model.release();
    }
}

bool fileExists(ReadOnlyFileSystem rofs, string filename)
{
    FileStat stat;
    return rofs.stat(filename, stat);
}

Matrix4x4f transformationMatrix(Quaternionf r, Vector3f t, Vector3f s)
{
    Matrix4x4f res = Matrix4x4f.identity;
    Matrix3x3f rm = r.toMatrix3x3;
    res.a11 = rm.a11 * s.x; res.a12 = rm.a12 * s.x; res.a13 = rm.a13 * s.x;
    res.a21 = rm.a21 * s.y; res.a22 = rm.a22 * s.y; res.a23 = rm.a23 * s.y;
    res.a31 = rm.a31 * s.z; res.a32 = rm.a32 * s.z; res.a33 = rm.a33 * s.z;
    res.a14 = t.x;
    res.a24 = t.y;
    res.a34 = t.z;
    return res;
}

Matrix4x4f multScalarAffine(Matrix4x4f m, float s)
{
    Matrix4x4f res = m;
    res.a11 *= s; res.a12 *= s; res.a13 *= s;
    res.a21 *= s; res.a22 *= s; res.a23 *= s;
    res.a31 *= s; res.a32 *= s; res.a33 *= s;
    res.a14 *= s;
    res.a24 *= s;
    res.a34 *= s;
    return res;
}

Matrix4x4f addMatrixAffine(Matrix4x4f m1, Matrix4x4f m2)
{
    Matrix4x4f res = m1;
    res.a11 += m2.a11; res.a12 += m2.a12; res.a13 += m2.a13;
    res.a21 += m2.a21; res.a22 += m2.a22; res.a23 += m2.a23;
    res.a31 += m2.a31; res.a32 += m2.a32; res.a33 += m2.a33;
    res.a14 += m2.a14;
    res.a24 += m2.a24;
    res.a34 += m2.a34;
    return res;
}

bool validMatrix(T, size_t N)(Matrix!(T, N) m)
{
    foreach (v; m.arrayof)
        if (isNaN(v))
            return false;
    return true;
}

bool validVector(T, size_t N)(Vector!(T, N) vec)
{
    foreach (v; vec.arrayof)
        if (isNaN(v))
            return false;
    return true;
}


