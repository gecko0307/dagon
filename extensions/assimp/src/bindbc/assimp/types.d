module bindbc.assimp.types;

import std: tuple;

enum AssimpSupport
{
    noLibrary,
    badLibrary,
    assimp500 = 500,
}

version(ASSIMP_DOUBLE_PRECISION)
{
    alias ai_real = double;
    alias ai_int = long;
    alias ai_uint = ulong;
    enum ASSIMP_AI_REAL_TEXT_PRECISION = 16;
}
else
{
    alias ai_real = float;
    alias ai_int = int;
    alias ai_uint = uint;
    enum ASSIMP_AI_REAL_TEXT_PRECISION = 8;
}

enum AI_MATH_PI          = 3.141592653589793238462643383279;
enum AI_MATH_TWO_PI      = AI_MATH_PI * 2.0;
enum AI_MATH_HALF_PI     = AI_MATH_PI * 0.5;

enum AI_MATH_PI_F        = 3.1415926538f;
enum AI_MATH_TWO_PI_F    = AI_MATH_PI_F * 2.0f;
enum AI_MATH_HALF_PI_F   = AI_MATH_PI_F * 0.5f;

// Tiny macro to convert from radians to degrees and back
alias AI_DEG_TO_RAD = x => x * cast(ai_real)0.0174532925;
alias AI_RAD_TO_DEG = x => x * cast(ai_real)57.2957795;

enum ai_epsilon = cast(ai_real)0.00001;

enum AI_MAX_ALLOC(type) = (256U * 1024 * 1024) / type.sizeof;

struct aiVector3D
{
    ai_real x, y, z;
}

struct aiVector2D
{
    ai_real x, y;
}

struct aiColor4D
{
    ai_real r, g, b, a;
}

struct aiMatrix3x3
{
    ai_real a1, a2, a3;
    ai_real b1, b2, b3;
    ai_real c1, c2, c3;
}

struct aiMatrix4x4
{
    ai_real a1, a2, a3, a4;
    ai_real b1, b2, b3, b4;
    ai_real c1, c2, c3, c4;
    ai_real d1, d2, d3, d4;
}

struct aiQuaternion
{
    ai_real w, x, y, z;
}

alias ai_int32 = int;
alias ai_uint32 = uint;

enum MAXLEN = 1024;

struct aiPlane
{
    ai_real a, b, c, d;
}

struct aiRay
{
    aiVector3D pos, dir;
}

struct aiColor3D
{
    ai_real r, g, b;
}

struct aiString
{
    ai_uint32 length;
    char[MAXLEN] data;
}

enum aiReturn
{
    SUCCESS = 0x0,
    FAILURE = -0x1,
    OUTOFMEMORY = -0x3,
}

enum AI_SUCCESS = aiReturn.SUCCESS;
enum AI_FAILURE = aiReturn.FAILURE;
enum AI_OUTOFMEMORY = aiReturn.OUTOFMEMORY;

enum aiOrigin
{
    SET = 0x0,
    CUR = 0x1,
    END = 0x2,
}

enum aiDefaultLogStream
{
    FILE = 0x1,
    STDOUT = 0x2,
    STDERR = 0x4,
    DEBUGGER = 0x8,
}

enum DLS_FILE     = aiDefaultLogStream.FILE;
enum DLS_STDOUT   = aiDefaultLogStream.STDOUT;
enum DLS_STDERR   = aiDefaultLogStream.STDERR;
enum DLS_DEBUGGER = aiDefaultLogStream.DEBUGGER;

struct aiMemoryInfo
{
    uint textures;
    uint materials;
    uint meshes;
    uint nodes;
    uint animations;
    uint cameras;
    uint lights;
    uint total;
}

struct aiVectorKey
{
    double mTime;
    aiVector3D mValue;
}

struct aiQuatKey
{
    double mTime;
    aiQuaternion mValue;
}

struct aiMeshKey
{
    double mTime;
    uint mValue;
}

struct aiMeshMorphKey
{
    double mTime;
    uint *mValues;
    double *mWeights;
    uint mNumValuesAndWeights;
}

enum aiAnimBehaviour
{
    DEFAULT  = 0x0,
    CONSTANT = 0x1,
    LINEAR   = 0x2,
    REPEAT   = 0x3,
}

struct aiNodeAnim
{
    aiString mNodeName;
    uint mNumPositionKeys;
    aiVectorKey* mPositionKeys;
    uint mNumRotationKeys;
    aiQuatKey* mRotationKeys;
    uint mNumScalingKeys;
    aiVectorKey* mScalingKeys;
    aiAnimBehaviour mPreState;
    aiAnimBehaviour mPostState;
}

struct aiMeshAnim
{
    aiString mName;
    uint mNumKeys;
    aiMeshKey* mKeys;
}

struct aiMeshMorphAnim
{
    aiString mName;
    uint mNumKeys;
    aiMeshMorphKey* mKeys;
}

struct aiAnimation
{
    aiString mName;
    double mDuration;
    double mTicksPerSecond;
    uint mNumChannels;
    aiNodeAnim** mChannels;
    uint mNumMeshChannels;
    aiMeshAnim** mMeshChannels;
    uint mNumMorphMeshChannels;
    aiMeshMorphAnim **mMorphMeshChannels;
}

struct aiCamera
{
    aiString mName;
    aiVector3D mPosition;
    aiVector3D mUp;
    aiVector3D mLookAt;
    float mHorizontalFOV;
    float mClipPlaneNear;
    float mClipPlaneFar;
    float mAspect;
}

struct aiExportFormatDesc
{
    const char* id;
    const char* description;
    const char* fileExtension;
}

struct aiExportDataBlob
{
    size_t size;
    void* data;
    aiString name;
    aiExportDataBlob* next;
}

alias aiFileWriteProc = size_t function(aiFile*, const char*, size_t, size_t);
alias aiFileReadProc = size_t function(aiFile*, char*, size_t,size_t);
alias aiFileTellProc = size_t function(aiFile*);
alias aiFileFlushProc = void function(aiFile*);
alias aiFileSeek = aiReturn function(aiFile*, size_t, aiOrigin);

alias aiFileOpenProc = aiFile* function(aiFileIO*, const char*, const char*);
alias aiFileCloseProc = void function(aiFileIO*, aiFile*);

alias aiUserData = char*;

struct aiFileIO
{
    aiFileOpenProc OpenProc;
    aiFileCloseProc CloseProc;
    aiUserData UserData;
}

struct aiFile
{
    aiFileReadProc ReadProc;
    aiFileWriteProc WriteProc;
    aiFileTellProc TellProc;
    aiFileTellProc FileSizeProc;
    aiFileSeek SeekProc;
    aiFileFlushProc FlushProc;
    aiUserData UserData;
}

alias aiLogStreamCallback = void function(const char*, char*);

struct aiLogStream
{
    aiLogStreamCallback callback;
    char* user;
}

struct aiPropertyStore
{
   char sentinel;
}

alias aiBool = int;

enum AI_FALSE = 0;
enum AI_TRUE = 1;

enum aiImporterFlags
{
    SupportTextFlavour = 0x1,
    SupportBinaryFlavour = 0x2,
    SupportCompressedFlavour = 0x4,
    LimitedSupport = 0x8,
    Experimental = 0x10
}

struct aiImporterDesc
{
    const char* mName;
    const char* mAuthor;
    const char* mMaintainer;
    const char* mComments;
    uint mFlags;
    uint mMinMajor;
    uint mMinMinor;
    uint mMaxMajor;
    uint mMaxMinor;
    const char* mFileExtensions;
}

enum aiLightSourceType
{
    UNDEFINED     = 0x0,
    DIRECTIONAL   = 0x1,
    POINT         = 0x2,
    SPOT          = 0x3,
    AMBIENT       = 0x4,
    AREA          = 0x5,
}

struct aiLight
{
    aiString mName;
    aiLightSourceType mType;
    aiVector3D mPosition;
    aiVector3D mDirection;
    aiVector3D mUp;
    float mAttenuationConstant;
    float mAttenuationLinear;
    float mAttenuationQuadratic;
    aiColor3D mColorDiffuse;
    aiColor3D mColorSpecular;
    aiColor3D mColorAmbient;
    float mAngleInnerCone;
    float mAngleOuterCone;
    aiVector2D mSize;
}

enum AI_DEFAULT_MATERIAL_NAME = "DefaultMaterial";

enum aiTextureOp
{
    Multiply = 0x0,
    Add = 0x1,
    Subtract = 0x2,
    Divide = 0x3,
    SmoothAdd = 0x4,
    SignedAdd = 0x5,
}

enum aiTextureMapMode
{
    Wrap = 0x0,
    Clamp = 0x1,
    Decal = 0x3,
    Mirror = 0x2,
}

enum aiTextureMapping
{
    UV = 0x0,
    SPHERE = 0x1,
    CYLINDER = 0x2,
    BOX = 0x3,
    PLANE = 0x4,
    OTHER = 0x5,
}
enum aiTextureType
{
    NONE = 0,
    DIFFUSE = 1,
    SPECULAR = 2,
    AMBIENT = 3,
    EMISSIVE = 4,
    HEIGHT = 5,
    NORMALS = 6,
    SHININESS = 7,
    OPACITY = 8,
    DISPLACEMENT = 9,
    LIGHTMAP = 10,
    REFLECTION = 11,
    BASE_COLOR = 12,
    NORMAL_CAMERA = 13,
    EMISSION_COLOR = 14,
    METALNESS = 15,
    DIFFUSE_ROUGHNESS = 16,
    AMBIENT_OCCLUSION = 17,
    UNKNOWN = 18,
}

enum AI_TEXTURE_TYPE_MAX = aiTextureType.UNKNOWN;

enum aiShadingMode
{
    Flat = 0x1,
    Gouraud = 0x2,
    Phong = 0x3,
    Blinn = 0x4,
    Toon = 0x5,
    OrenNayar = 0x6,
    Minnaert = 0x7,
    CookTorrance = 0x8,
    NoShading = 0x9,
    Fresnel = 0xa,
}

enum aiTextureFlags
{
    Invert = 0x1,
    UseAlpha = 0x2,
    IgnoreAlpha = 0x4,
}

enum aiBlendMode
{
    Default = 0x0,
    Additive = 0x1,
}

align(1) struct aiUVTransform
{
    aiVector2D mTranslation;
    aiVector2D mScaling;
    ai_real mRotation;
}

enum aiPropertyTypeInfo
{
    Float   = 0x1,
    Double   = 0x2,
    String  = 0x3,
    Integer = 0x4,
    Buffer  = 0x5,
}

struct aiMaterialProperty
{
    aiString mKey;
    uint mSemantic;
    uint mIndex;
    uint mDataLength;
    aiPropertyTypeInfo mType;
    char* mData;
}

struct aiMaterial
{
    aiMaterialProperty** mProperties;
    uint mNumProperties;
    uint mNumAllocated;
}

enum AI_MATKEY_NAME = tuple("?mat.name",0,0);
enum AI_MATKEY_TWOSIDED = tuple("$mat.twosided",0,0);
enum AI_MATKEY_SHADING_MODEL = tuple("$mat.shadingm",0,0);
enum AI_MATKEY_ENABLE_WIREFRAME = tuple("$mat.wireframe",0,0);
enum AI_MATKEY_BLEND_FUNC = tuple("$mat.blend",0,0);
enum AI_MATKEY_OPACITY = tuple("$mat.opacity",0,0);
enum AI_MATKEY_TRANSPARENCYFACTOR = tuple("$mat.transparencyfactor",0,0);
enum AI_MATKEY_BUMPSCALING = tuple("$mat.bumpscaling",0,0);
enum AI_MATKEY_SHININESS = tuple("$mat.shininess",0,0);
enum AI_MATKEY_REFLECTIVITY = tuple("$mat.reflectivity",0,0);
enum AI_MATKEY_SHININESS_STRENGTH = tuple("$mat.shinpercent",0,0);
enum AI_MATKEY_REFRACTI = tuple("$mat.refracti",0,0);
enum AI_MATKEY_COLOR_DIFFUSE = tuple("$clr.diffuse",0,0);
enum AI_MATKEY_COLOR_AMBIENT = tuple("$clr.ambient",0,0);
enum AI_MATKEY_COLOR_SPECULAR = tuple("$clr.specular",0,0);
enum AI_MATKEY_COLOR_EMISSIVE = tuple("$clr.emissive",0,0);
enum AI_MATKEY_COLOR_TRANSPARENT = tuple("$clr.transparent",0,0);
enum AI_MATKEY_COLOR_REFLECTIVE = tuple("$clr.reflective",0,0);
enum AI_MATKEY_GLOBAL_BACKGROUND_IMAGE = tuple("?bg.global",0,0);
enum AI_MATKEY_GLOBAL_SHADERLANG = tuple("?sh.lang",0,0);
enum AI_MATKEY_SHADER_VERTEX = tuple("?sh.vs",0,0);
enum AI_MATKEY_SHADER_FRAGMENT = tuple("?sh.fs",0,0);
enum AI_MATKEY_SHADER_GEO = tuple("?sh.gs",0,0);
enum AI_MATKEY_SHADER_TESSELATION = tuple("?sh.ts",0,0);
enum AI_MATKEY_SHADER_PRIMITIVE = tuple("?sh.ps",0,0);
enum AI_MATKEY_SHADER_COMPUTE = tuple("?sh.cs",0,0);

enum _AI_MATKEY_TEXTURE_BASE         = "$tex.file";
enum _AI_MATKEY_UVWSRC_BASE          = "$tex.uvwsrc";
enum _AI_MATKEY_TEXOP_BASE           = "$tex.op";
enum _AI_MATKEY_MAPPING_BASE         = "$tex.mapping";
enum _AI_MATKEY_TEXBLEND_BASE        = "$tex.blend";
enum _AI_MATKEY_MAPPINGMODE_U_BASE   = "$tex.mapmodeu";
enum _AI_MATKEY_MAPPINGMODE_V_BASE   = "$tex.mapmodev";
enum _AI_MATKEY_TEXMAP_AXIS_BASE     = "$tex.mapaxis";
enum _AI_MATKEY_UVTRANSFORM_BASE     = "$tex.uvtrafo";
enum _AI_MATKEY_TEXFLAGS_BASE        = "$tex.flags";

enum AI_MATKEY_TEXTURE(aiTextureType type, uint N) = tuple(_AI_MATKEY_TEXTURE_BASE,type,N);

enum AI_MATKEY_TEXTURE_DIFFUSE(uint N) = 
    AI_MATKEY_TEXTURE!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_TEXTURE_SPECULAR(uint N) =
    AI_MATKEY_TEXTURE!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_TEXTURE_AMBIENT(uint N) =
    AI_MATKEY_TEXTURE!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_TEXTURE_EMISSIVE(uint N) =
    AI_MATKEY_TEXTURE!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_TEXTURE_NORMALS(uint N) =
    AI_MATKEY_TEXTURE!(aiTextureType.NORMALS,N);

enum AI_MATKEY_TEXTURE_HEIGHT(uint N) =
    AI_MATKEY_TEXTURE!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_TEXTURE_SHININESS(uint N) =
    AI_MATKEY_TEXTURE!(aiTextureType.SHININESS,N);

enum AI_MATKEY_TEXTURE_OPACITY(uint N) =
    AI_MATKEY_TEXTURE!(aiTextureType.OPACITY,N);

enum AI_MATKEY_TEXTURE_DISPLACEMENT(uint N) =
    AI_MATKEY_TEXTURE!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_TEXTURE_LIGHTMAP(uint N) =
    AI_MATKEY_TEXTURE(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_TEXTURE_REFLECTION(uint N) =
    AI_MATKEY_TEXTURE(aiTextureType.REFLECTION,N);

enum AI_MATKEY_UVWSRC(aiTextureType type, uint N) = tuple(_AI_MATKEY_UVWSRC_BASE,type,N);

enum AI_MATKEY_UVWSRC_DIFFUSE(uint N) = 
    AI_MATKEY_UVWSRC!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_UVWSRC_SPECULAR(uint N)    =
    AI_MATKEY_UVWSRC!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_UVWSRC_AMBIENT(uint N) =
    AI_MATKEY_UVWSRC!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_UVWSRC_EMISSIVE(uint N)    =
    AI_MATKEY_UVWSRC!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_UVWSRC_NORMALS(uint N) =
    AI_MATKEY_UVWSRC!(aiTextureType.NORMALS,N);

enum AI_MATKEY_UVWSRC_HEIGHT(uint N)  =
    AI_MATKEY_UVWSRC!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_UVWSRC_SHININESS(uint N)   =
    AI_MATKEY_UVWSRC!(aiTextureType.SHININESS,N);

enum AI_MATKEY_UVWSRC_OPACITY(uint N) =
    AI_MATKEY_UVWSRC!(aiTextureType.OPACITY,N);

enum AI_MATKEY_UVWSRC_DISPLACEMENT(uint N)    =
    AI_MATKEY_UVWSRC!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_UVWSRC_LIGHTMAP(uint N)    =
    AI_MATKEY_UVWSRC!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_UVWSRC_REFLECTION(uint N)  =
    AI_MATKEY_UVWSRC!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_TEXOP(aiTextureType type, uint N) = tuple(_AI_MATKEY_TEXOP_BASE,type,N);

enum AI_MATKEY_TEXOP_DIFFUSE(uint N)  =
    AI_MATKEY_TEXOP!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_TEXOP_SPECULAR(uint N) =
    AI_MATKEY_TEXOP!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_TEXOP_AMBIENT(uint N)  =
    AI_MATKEY_TEXOP!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_TEXOP_EMISSIVE(uint N) =
    AI_MATKEY_TEXOP!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_TEXOP_NORMALS(uint N)  =
    AI_MATKEY_TEXOP!(aiTextureType.NORMALS,N);

enum AI_MATKEY_TEXOP_HEIGHT(uint N)   =
    AI_MATKEY_TEXOP!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_TEXOP_SHININESS(uint N)    =
    AI_MATKEY_TEXOP!(aiTextureType.SHININESS,N);

enum AI_MATKEY_TEXOP_OPACITY(uint N)  =
    AI_MATKEY_TEXOP!(aiTextureType.OPACITY,N);

enum AI_MATKEY_TEXOP_DISPLACEMENT(uint N) =
    AI_MATKEY_TEXOP!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_TEXOP_LIGHTMAP(uint N) =
    AI_MATKEY_TEXOP!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_TEXOP_REFLECTION(uint N)   =
    AI_MATKEY_TEXOP!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_MAPPING(aiTextureType type, N) = tuple(_AI_MATKEY_MAPPING_BASE,type,N);

enum AI_MATKEY_MAPPING_DIFFUSE(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_MAPPING_SPECULAR(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_MAPPING_AMBIENT(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_MAPPING_EMISSIVE(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_MAPPING_NORMALS(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.NORMALS,N);

enum AI_MATKEY_MAPPING_HEIGHT(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_MAPPING_SHININESS(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.SHININESS,N);

enum AI_MATKEY_MAPPING_OPACITY(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.OPACITY,N);

enum AI_MATKEY_MAPPING_DISPLACEMENT(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_MAPPING_LIGHTMAP(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_MAPPING_REFLECTION(uint N) =
    AI_MATKEY_MAPPING!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_TEXBLEND(aiTextureType type, uint N) = tuple(_AI_MATKEY_TEXBLEND_BASE,type,N);

enum AI_MATKEY_TEXBLEND_DIFFUSE(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_TEXBLEND_SPECULAR(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_TEXBLEND_AMBIENT(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_TEXBLEND_EMISSIVE(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_TEXBLEND_NORMALS(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.NORMALS,N);

enum AI_MATKEY_TEXBLEND_HEIGHT(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_TEXBLEND_SHININESS(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.SHININESS,N);

enum AI_MATKEY_TEXBLEND_OPACITY(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.OPACITY,N);

enum AI_MATKEY_TEXBLEND_DISPLACEMENT(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_TEXBLEND_LIGHTMAP(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_TEXBLEND_REFLECTION(uint N) =
    AI_MATKEY_TEXBLEND!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_MAPPINGMODE_U(aiTextureType type, uint N) =
    tuple(_AI_MATKEY_MAPPINGMODE_U_BASE,type,N);

enum AI_MATKEY_MAPPINGMODE_U_DIFFUSE(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_MAPPINGMODE_U_SPECULAR(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_MAPPINGMODE_U_AMBIENT(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_MAPPINGMODE_U_EMISSIVE(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_MAPPINGMODE_U_NORMALS(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.NORMALS,N);

enum AI_MATKEY_MAPPINGMODE_U_HEIGHT(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_MAPPINGMODE_U_SHININESS(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.SHININESS,N);

enum AI_MATKEY_MAPPINGMODE_U_OPACITY(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.OPACITY,N);

enum AI_MATKEY_MAPPINGMODE_U_DISPLACEMENT(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_MAPPINGMODE_U_LIGHTMAP(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_MAPPINGMODE_U_REFLECTION(uint N) =
    AI_MATKEY_MAPPINGMODE_U!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_MAPPINGMODE_V(aiTextureType type, uint N) =
    tuple(_AI_MATKEY_MAPPINGMODE_V_BASE,type,N);

enum AI_MATKEY_MAPPINGMODE_V_DIFFUSE(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_MAPPINGMODE_V_SPECULAR(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_MAPPINGMODE_V_AMBIENT(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_MAPPINGMODE_V_EMISSIVE(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_MAPPINGMODE_V_NORMALS(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.NORMALS,N);

enum AI_MATKEY_MAPPINGMODE_V_HEIGHT(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_MAPPINGMODE_V_SHININESS(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.SHININESS,N);

enum AI_MATKEY_MAPPINGMODE_V_OPACITY(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.OPACITY,N);

enum AI_MATKEY_MAPPINGMODE_V_DISPLACEMENT(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_MAPPINGMODE_V_LIGHTMAP(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_MAPPINGMODE_V_REFLECTION(uint N) =
    AI_MATKEY_MAPPINGMODE_V!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_TEXMAP_AXIS(aiTextureType type, uint N) =
    tuple(_AI_MATKEY_TEXMAP_AXIS_BASE,type,N);

enum AI_MATKEY_TEXMAP_AXIS_DIFFUSE(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_TEXMAP_AXIS_SPECULAR(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_TEXMAP_AXIS_AMBIENT(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_TEXMAP_AXIS_EMISSIVE(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_TEXMAP_AXIS_NORMALS(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.NORMALS,N);

enum AI_MATKEY_TEXMAP_AXIS_HEIGHT(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_TEXMAP_AXIS_SHININESS(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.SHININESS,N);

enum AI_MATKEY_TEXMAP_AXIS_OPACITY(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.OPACITY,N);

enum AI_MATKEY_TEXMAP_AXIS_DISPLACEMENT(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_TEXMAP_AXIS_LIGHTMAP(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_TEXMAP_AXIS_REFLECTION(uint N) =
    AI_MATKEY_TEXMAP_AXIS!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_UVTRANSFORM(aiTextureType type, uint N) =
    tuple(_AI_MATKEY_UVTRANSFORM_BASE,type,N);

enum AI_MATKEY_UVTRANSFORM_DIFFUSE(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_UVTRANSFORM_SPECULAR(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_UVTRANSFORM_AMBIENT(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_UVTRANSFORM_EMISSIVE(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_UVTRANSFORM_NORMALS(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.NORMALS,N);

enum AI_MATKEY_UVTRANSFORM_HEIGHT(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_UVTRANSFORM_SHININESS(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.SHININESS,N);

enum AI_MATKEY_UVTRANSFORM_OPACITY(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.OPACITY,N);

enum AI_MATKEY_UVTRANSFORM_DISPLACEMENT(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_UVTRANSFORM_LIGHTMAP(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_UVTRANSFORM_REFLECTION(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_UVTRANSFORM_UNKNOWN(uint N) =
    AI_MATKEY_UVTRANSFORM!(aiTextureType.UNKNOWN,N);

enum AI_MATKEY_TEXFLAGS(aiTextureType type, uint N) =
    tuple(_AI_MATKEY_TEXFLAGS_BASE,type,N);

enum AI_MATKEY_TEXFLAGS_DIFFUSE(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.DIFFUSE,N);

enum AI_MATKEY_TEXFLAGS_SPECULAR(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.SPECULAR,N);

enum AI_MATKEY_TEXFLAGS_AMBIENT(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.AMBIENT,N);

enum AI_MATKEY_TEXFLAGS_EMISSIVE(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.EMISSIVE,N);

enum AI_MATKEY_TEXFLAGS_NORMALS(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.NORMALS,N);

enum AI_MATKEY_TEXFLAGS_HEIGHT(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.HEIGHT,N);

enum AI_MATKEY_TEXFLAGS_SHININESS(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.SHININESS,N);

enum AI_MATKEY_TEXFLAGS_OPACITY(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.OPACITY,N);

enum AI_MATKEY_TEXFLAGS_DISPLACEMENT(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.DISPLACEMENT,N);

enum AI_MATKEY_TEXFLAGS_LIGHTMAP(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.LIGHTMAP,N);

enum AI_MATKEY_TEXFLAGS_REFLECTION(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.REFLECTION,N);

enum AI_MATKEY_TEXFLAGS_UNKNOWN(uint N) =
    AI_MATKEY_TEXFLAGS!(aiTextureType.UNKNOWN,N);

struct aiAABB
{
    aiVector3D mMin;
    aiVector3D mMax;
}

enum AI_MAX_FACE_INDICES = 0x7fff;
enum AI_MAX_BONE_WEIGHTS = 0x7fffffff;
enum AI_MAX_VERTICES = 0x7fffffff;
enum AI_MAX_FACES = 0x7fffffff;
enum AI_MAX_NUMBER_OF_COLOR_SETS = 0x8;
enum AI_MAX_NUMBER_OF_TEXTURECOORDS = 0x8;

struct aiFace
{
    uint mNumIndices;
    uint* mIndices;
}

struct aiVertexWeight
{
    uint mVertexId;
    float mWeight;
}

struct aiBone
{
    aiString mName;
    uint mNumWeights;
    aiVertexWeight* mWeights;
    aiMatrix4x4 mOffsetMatrix;
}

enum aiPrimitiveType
{
    POINT       = 0x1,
    LINE        = 0x2,
    TRIANGLE    = 0x4,
    POLYGON     = 0x8,
}

enum AI_PRIMITIVE_TYPE_FOR_N_INDICES(n) =
    ((n) > 3 ? aiPrimitiveType.POLYGON : cast(aiPrimitiveType)(1u << ((n)-1)));


struct aiAnimMesh
{
    aiString mName;
    aiVector3D* mVertices;
    aiVector3D* mNormals;
    aiVector3D* mTangents;
    aiVector3D* mBitangents;
    aiColor4D*[AI_MAX_NUMBER_OF_COLOR_SETS] mColors;
    aiVector3D*[AI_MAX_NUMBER_OF_TEXTURECOORDS] mTextureCoords;
    uint mNumVertices;
    float mWeight;
}

enum aiMorphingMethod
{
    VERTEX_BLEND       = 0x1,
    MORPH_NORMALIZED   = 0x2,
    MORPH_RELATIVE     = 0x3,
}

struct aiMesh
{
    uint mPrimitiveTypes;
    uint mNumVertices;
    uint mNumFaces;
    aiVector3D* mVertices;
    aiVector3D* mNormals;
    aiVector3D* mTangents;
    aiVector3D* mBitangents;
    aiColor4D*[AI_MAX_NUMBER_OF_COLOR_SETS] mColors;
    aiVector3D*[AI_MAX_NUMBER_OF_TEXTURECOORDS] mTextureCoords;
    uint[AI_MAX_NUMBER_OF_TEXTURECOORDS] mNumUVComponents;
    aiFace* mFaces;
    uint mNumBones;
    aiBone** mBones;
    uint mMaterialIndex;
    aiString mName;
    uint mNumAnimMeshes;
    aiAnimMesh** mAnimMeshes;
    uint mMethod;
    aiAABB mAABB;
}

enum aiMetadataType
{
    BOOL       = 0,
    INT32      = 1,
    UINT64     = 2,
    FLOAT      = 3,
    DOUBLE     = 4,
    STRING   = 5,
    VECTOR3D = 6,
    META_MAX   = 7,
}

struct aiMetadataEntry
{
    aiMetadataType mType;
    void* mData;
}

struct aiMetadata
{
    uint mNumProperties;
    aiString* mKeys;
    aiMetadataEntry* mValues;
}

struct aiNode
{
    aiString mName;
    aiMatrix4x4 mTransformation;
    aiNode* mParent;
    uint mNumChildren;
    aiNode** mChildren;
    uint mNumMeshes;
    uint* mMeshes;
    aiMetadata* mMetaData;
}

enum AI_SCENE_FLAGS_INCOMPLETE = 0x1;
enum AI_SCENE_FLAGS_VALIDATED = 0x2;
enum AI_SCENE_FLAGS_VALIDATION_WARNING = 0x4;
enum AI_SCENE_FLAGS_NON_VERBOSE_FORMAT = 0x8;
enum AI_SCENE_FLAGS_TERRAIN = 0x10;
enum AI_SCENE_FLAGS_ALLOW_SHARED = 0x20;

struct aiScene
{
    uint mFlags;
    aiNode* mRootNode;
    uint mNumMeshes;
    aiMesh** mMeshes;
    uint mNumMaterials;
    aiMaterial** mMaterials;
    uint mNumAnimations;
    aiAnimation** mAnimations;
    uint mNumTextures;
    aiTexture** mTextures;
    uint mNumLights;
    aiLight** mLights;
    uint mNumCameras;
    aiCamera** mCameras;
    aiMetadata* mMetaData;
    char* mPrivate;
}

enum AI_EMBEDDED_TEXNAME_PREFIX = "*";

align(1) struct aiTexel
{
    ubyte b,g,r,a;
}

enum HINTMAXTEXTURELEN = 9;

struct aiTexture
{
    uint mWidth;
    uint mHeight;
    char[HINTMAXTEXTURELEN] achFormatHint; // 8 for string + 1 for terminator.
    aiTexel* pcData;
    aiString mFilename;
}

enum aiPostProcessSteps
{
    CalcTangentSpace = 0x1,
    JoinIdenticalVertices = 0x2,
    MakeLeftHanded = 0x4,
    Triangulate = 0x8,
    RemoveComponent = 0x10,
    GenNormals = 0x20,
    GenSmoothNormals = 0x40,
    SplitLargeMeshes = 0x80,
    PreTransformVertices = 0x100,
    LimitBoneWeights = 0x200,
    ValidateDataStructure = 0x400,
    ImproveCacheLocality = 0x800,
    RemoveRedundantMaterials = 0x1000,
    FixInfacingNormals = 0x2000,
    SortByPType = 0x8000,
    FindDegenerates = 0x10000,
    FindInvalidData = 0x20000,
    GenUVCoords = 0x40000,
    TransformUVCoords = 0x80000,
    FindInstances = 0x100000,
    OptimizeMeshes  = 0x200000,
    OptimizeGraph  = 0x400000,
    FlipUVs = 0x800000,
    FlipWindingOrder  = 0x1000000,
    SplitByBoneCount  = 0x2000000,
    Debone  = 0x4000000,
    GlobalScale = 0x8000000,
    EmbedTextures  = 0x10000000,
    ForceGenNormals = 0x20000000,
    DropNormals = 0x40000000,
    GenBoundingBoxes = 0x80000000,
    ConvertToLeftHanded =
        aiPostProcessSteps.MakeLeftHanded     | 
        aiPostProcessSteps.FlipUVs            | 
        aiPostProcessSteps.FlipWindingOrder   | 
        0,
}

enum aiPostProcessStepsPreset {
    TargetRealtime_Fast =
        aiPostProcessSteps.CalcTangentSpace      |
        aiPostProcessSteps.GenNormals            |
        aiPostProcessSteps.JoinIdenticalVertices |
        aiPostProcessSteps.Triangulate           |
        aiPostProcessSteps.GenUVCoords           |
        aiPostProcessSteps.SortByPType           |
        0,
    TargetRealtime_Quality =
        aiPostProcessSteps.CalcTangentSpace              |
        aiPostProcessSteps.GenSmoothNormals              |
        aiPostProcessSteps.JoinIdenticalVertices         |
        aiPostProcessSteps.ImproveCacheLocality          |
        aiPostProcessSteps.LimitBoneWeights              |
        aiPostProcessSteps.RemoveRedundantMaterials      |
        aiPostProcessSteps.SplitLargeMeshes              |
        aiPostProcessSteps.Triangulate                   |
        aiPostProcessSteps.GenUVCoords                   |
        aiPostProcessSteps.SortByPType                   |
        aiPostProcessSteps.FindDegenerates               |
        aiPostProcessSteps.FindInvalidData               |
        0,
    TargetRealtime_MaxQuality = 
        aiPostProcessStepsPreset.TargetRealtime_Quality  |
        aiPostProcessSteps.FindInstances                 |
        aiPostProcessSteps.ValidateDataStructure         |
        aiPostProcessSteps.OptimizeMeshes                |
        0
}

enum AssimpCFlags {
    SHARED = 0x1,
    STLPORT = 0x2,
    DEBUG = 0x4,
    NOBOOST = 0x8,
    SINGLETHREADED = 0x10
}
