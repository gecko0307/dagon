import std.stdio;
import std.file;
import std.json;
import std.conv;
import std.array;
import std.format;
import std.string;
import std.algorithm;
import std.algorithm.searching;
import std.algorithm.iteration;

struct BackendData
{
    string ImplName; // ImplSDL2
    string Name; // SDL2
    string ImportCode; // import bindbc.sdl;
    string VersionDefine; // USE_SDL
}

struct backend_function
{
    string functionName;
    JSONValue cimguiFunction;
}

struct enum_values
{
    string[string] values;
}

shared immutable string[string] cArgMap;
shared immutable string[string] cTypeMap;
shared immutable string[string] cDefaultArgumentsNeedingConversion;
shared immutable BackendData[string] cBackendMap;
shared enum_values[string] gEnumType; // this should actually just be a set...
shared string[string] gConvertedEnumValue;


shared static this()
{
    cArgMap = [
        "align": "alignment",
        "ref" : "reference",
        "in" : "inItem",
        "out" : "outItem"
    ];
    
    cTypeMap = [
        "unsigned char": "char",
        "unsigned_char": "char",
        "unsigned short": "ushort",
        "unsigned int": "uint",
        "unsigned long long": "ulong",
        "unsigned char*": "char*",
        "unsigned short*": "ushort*",
        "unsigned int*": "uint*",
        "signed char": "byte",
        "signed short": "short",
        "signed int": "int",
        "signed long long": "long",
        "signed char*": "byte*",
        "signed short*": "short*",
        "signed int*": "int*",
        "int64_t" : "long",
        "signed __int64" : "long",
        "unsigned __int64" : "ulong",
        "uint64_t" : "ulong",
        "union { int BackupInt[2]; float BackupFloat[2];}": "union { int[2] BackupInt; float[2] BackupFloat;}",
        "const char*" : "const(char)*",
        "const char* const[]" : "const(char)**",
        "unsigned char[256]" : "char[256]",
        "unsigned char**" : "char**",
        "const unsigned char[256]" : "const char[256]",
        "ImGuiWindowPtr" : "ImGuiWindow*",
        "ImFontPtr" : "ImFont*",
        "ImDrawListPtr" : "ImDrawList*",
        "ImGuiViewportPPtr" : "ImGuiViewportP*",
        "ImGuiViewportPtr" : "ImGuiViewport*",
        "const_charPtr" : "const(char)*",
        "const ImWchar*" : "const(ImWchar)*",
        "const ImVec4*" : "const(ImVec4)*",
        "const ImFontGlyph*" : "const(ImFontGlyph)*",
        "const ImGuiPayload*" : "const(ImGuiPayload)*",
        "const ImGuiPlatformMonitor*" : "const(ImGuiPlatformMonitor)*",
        "const ImGuiDataTypeInfo*" : "const(ImGuiDataTypeInfo)*",
        "int(__cdecl*)(void const*,void const*)" : "int function(const(void*), const(void*))",
        "ImBitArray<ImGuiKey_NamedKey_COUNT,-ImGuiKey_NamedKey_BEGIN>" : "ImBitArray!(ImGuiKey.NamedKey_COUNT,-ImGuiKey.NamedKey_BEGIN)"
    ];

    //alias ImBitArrayForNamedKeys = ImBitArray(ImGuiKey.NamedKey_COUNT,-ImGuiKey.NamedKey_BEGIN); ImBitArray<ImGuiKey_NamedKey_COUNT,-ImGuiKey_NamedKey_BEGIN>;

    cDefaultArgumentsNeedingConversion = [
        "sizeof(float)" : "float.sizeof",
        "((void*)0)" : "null",
        "NULL" : "null",
        "FLT_MIN" : "float.min_normal",
        "FLT_MAX" : "float.max",
        "ImVec2(-FLT_MIN,0)" : "ImVec2(-float.min_normal,0)"
    ];

    cBackendMap = [
        "ImGui_ImplSDL2": BackendData(
            "ImGui_ImplSDL2", 
            "SDL2", 
            "import bindbc.sdl;",
            "USE_SDL2"
        ),
        "ImGui_ImplGlfw" :BackendData(
            "ImGui_ImplGlfw", 
            "Glfw", 
            "import bindbc.glfw;",
            "USE_GLFW"
        ),
        "ImGui_ImplOpenGL2" :BackendData(
            "ImGui_ImplOpenGL2", 
            "OpenGL2", 
            "",
            "USE_OpenGL2"
        ),
        "ImGui_ImplOpenGL3" :BackendData(
            "ImplOpenGL3", 
            "OpenGL3", 
            "",
            "USE_OpenGL3"
        ),
    ];
}

string imgui_argname_to_dlang(string imguiName)
{
    if (auto type = imguiName in cArgMap)
    {
        return *type;
    }

    return imguiName;
}

import std.algorithm;

string handle_dang_template(string templateName, string imguiType)
{
    imguiType = imguiType.replace(templateName ~ "_", "");
    bool addPointerBack = false;

    if (endsWith(imguiType, "*"))
    {
        imguiType = imguiType[0 .. (imguiType.length - 1)];
        addPointerBack = true;
    }

    if (auto type = imguiType in cTypeMap)
        imguiType = templateName ~ "!(" ~ *type ~ ")";
    else
        imguiType = templateName ~ "!(" ~ imguiType ~ ")";

    if (addPointerBack)
        imguiType = imguiType ~ "*";

    return imguiType;
}

string imgui_type_to_dlang(string imguiType)
{
    if (auto type = imguiType in cTypeMap)
    {
        return *type;
    }

    imguiType = imguiType.replace("struct ", "");

    // Replace C template stubs with D template type.
    if (startsWith(imguiType, "ImVector_"))
        imguiType = handle_dang_template("ImVector", imguiType);
    else if (startsWith(imguiType, "ImSpan_"))
        imguiType = handle_dang_template("ImSpan", imguiType);
    else if (startsWith(imguiType, "ImBitArray_"))
        imguiType = handle_dang_template("ImBitArray", imguiType);
    
    if (canFind(imguiType, "(*)"))
    {
        imguiType = imguiType.replace("(*)", " function");

        foreach (key, value; cTypeMap)
        {
            imguiType = imguiType.replace(key, value);
        }
    }

    return imguiType;
}

struct code_writer
{
    void put_lines(string aLines)
    {
        foreach (line; std.string.splitLines(aLines))
        {
            write_indent();
            mBuilder.put(line);
            mBuilder.put('\n');
        }
    }

    /// Can be called put once I remove all other uses of the appender other than this class.
    void put_string(string content)
    {
        mBuilder.put(content);
    }
    
    /// Can be called put once I remove all other uses of the appender other than this class.
    void put_string(char content)
    {
        mBuilder.put(content);
    }

    void line_break()
    {
        mBuilder.put('\n');
    }

    void add_extern_c()
    {
        write_indent();
        mBuilder.put("extern (C) @nogc nothrow ");
        add_scope();
    }

    void add_normal_extern_c()
    {
        write_indent();
        mBuilder.put("extern (C) ");
        add_scope();
    }

    void add_enum(string enumName, string enumBaseType = "")
    {
        write_indent();
        mBuilder.put("enum ");
        mBuilder.put(enumName);
        mBuilder.put(" ");

        if (enumBaseType.length != 0)
        {
            mBuilder.put(": ");
            mBuilder.put(enumBaseType);
            mBuilder.put(" ");
        }

        add_scope();
    }
    
    /// Implies add_scope, so must be closed with a RemoveScope;
    void add_gshared()
    {
        write_indent();
        mBuilder.put("__gshared ");
        add_scope();
    }

    /// Implies add_scope, so must be closed with a RemoveScope;
    void add_struct(string structName)
    {
        write_indent();
        mBuilder.put("struct ");
        mBuilder.put(structName);
        mBuilder.put(" ");
        add_scope();
    }
    
    /// Implies add_scope, so must be closed with a RemoveScope;
    void add_if(string condition)
    {
        write_indent();
        mBuilder.put("if (");
        mBuilder.put(condition);
        mBuilder.put(") ");
        add_scope();
    }
    
    /// Implies add_scope, so must be closed with a RemoveScope;
    void add_else_f(string condition)
    {
        write_indent();
        mBuilder.put("else if (");
        mBuilder.put(condition);
        mBuilder.put(") ");
        add_scope();
    }
    
    /// Implies add_scope, so must be closed with a RemoveScope;
    void add_else()
    {
        write_indent();
        mBuilder.put("else ");
        add_scope();
    }

    /// Implies add_scope, so must be closed with a RemoveScope;
    void add_version(string versionVar)
    {
        write_indent();
        mBuilder.put("version (");
        mBuilder.put(versionVar);
        mBuilder.put(") ");
        add_scope();
    }

    void add_scope()
    {
        mBuilder.put('{');
        mBuilder.put('\n');
        add_indent();
    }

    void remove_scope()
    {
        remove_indent();
        write_indent();
        mBuilder.put('}');
        mBuilder.put('\n');
    }

    void add_indent()
    {
        ++indent;
    }

    void remove_indent()
    {
        --indent;
    }

    void write_indent()
    {
        string indentStr;
        for (int i = 0; i < indent; ++i)
            mBuilder.put("    ");
    }

    Appender!string mBuilder;
    int indent = 0;
}





string loaderPrelude = `
module bindbc.imgui.dynload;

version(BindImGui_Static) {}
else:

import bindbc.loader;
import bindbc.imgui.config,
       bindbc.imgui.bind,
       bindbc.imgui.bind.imgui;

private {
    SharedLib lib;
    ImGuiSupport loadedVersion;
}

void unloadImGui()
{
    if(lib != invalidHandle) {
        lib.unload();
    }
}

ImGuiSupport loadedImGuiVersion() { return loadedVersion; }

bool isImGuiLoaded()
{
    return  lib != invalidHandle;
}

ImGuiSupport loadImGui()
{
    // #1778 prevents me from using static arrays here :(
    version(Windows) {
        const(char)[][2] libNames = [
            "cimgui.dll",
            "cimguid.dll",
        ];
    }
    else version(OSX) {
        const(char)[][1] libNames = [
            "cimgui.dylib"
        ];
    }
    else version(Posix) {
        const(char)[][1] libNames = [
            "cimgui.so"
        ];
    }
    else static assert(0, "bindbc-ImGui is not yet supported on this platform.");

    ImGuiSupport ret;
    foreach(name; libNames) {
        ret = loadImGui(name.ptr);
        if(ret != ImGuiSupport.noLibrary) break;
    }

    return ret;
}

ImGuiSupport loadImGui(const(char)* libName)
{
    lib = load(libName);
    if(lib == invalidHandle) {
        return ImGuiSupport.noLibrary;
    }
`;

string loaderEnd = `

    if (errorCount() != 0) return ImGuiSupport.badLibrary;

    return ImGuiSupport.ImGui_1_79;
}
`;

const string imPool = q{
struct TypeToReplace {
    TemplatedTypeToReplace Buf;
    ImGuiStorage Map;
    ImPoolIdx FreeIdx;
}
};


const string imSpan = q{
struct ImSpan(tType) {
    tType* Data;
    tType* DataEnd;

    // Constructors, destructor
    //this() 
    //{
    //    Data = DataEnd = NULL; 
    //}

    this(tType* data, int size)
    {
        Data = data;
        DataEnd = data + size; 
    }

    this(tType* data, tType* data_end)
    {
        Data = data;
        DataEnd = data_end; 
    }

    void set(tType* data, int size)
    {
            Data = data;
            DataEnd = data + size; 
    }

    void set(tType* data, tType* data_end)
    {
        Data = data;
        DataEnd = data_end; 
    }

    int size() const 
    {
        return cast(int)cast(ptrdiff_t)(DataEnd - Data); 
    }

    int size_in_bytes() const 
    {
        return cast(int)cast(ptrdiff_t)(DataEnd - Data) * cast(int)tType.sizeof;
    }

    tType* opIndex(size_t i)
    {
        tType* p = Data + i;
        assert(p >= Data && p < DataEnd);
        return p; 
    }

    tType* begin() 
    {
        return Data; 
    }

    tType* end() 
    {
        return DataEnd; 
    }

    // Utilities
    int  index_from_ptr(const tType* it)
    { 
        assert(it >= Data && it < DataEnd); 
        const ptrdiff_t off = it - Data;
        return cast(int)off; 
    }
}
};


//template<int BITCOUNT, int OFFSET = 0>
//struct ImBitArray
//{
//    ImU32           Storage[(BITCOUNT + 31) >> 5];
//    ImBitArray()                                { ClearAllBits(); }
//    void            ClearAllBits()              { memset(Storage, 0, sizeof(Storage)); }
//    void            SetAllBits()                { memset(Storage, 255, sizeof(Storage)); }
//    bool            TestBit(int n) const        { n += OFFSET; IM_ASSERT(n >= 0 && n < BITCOUNT); return ImBitArrayTestBit(Storage, n); }
//    void            SetBit(int n)               { n += OFFSET; IM_ASSERT(n >= 0 && n < BITCOUNT); ImBitArraySetBit(Storage, n); }
//    void            ClearBit(int n)             { n += OFFSET; IM_ASSERT(n >= 0 && n < BITCOUNT); ImBitArrayClearBit(Storage, n); }
//    void            SetBitRange(int n, int n2)  { n += OFFSET; n2 += OFFSET; IM_ASSERT(n >= 0 && n < BITCOUNT && n2 > n && n2 <= BITCOUNT); ImBitArraySetBitRange(Storage, n, n2); } // Works on range [n..n2)
//    bool            operator[](int n) const     { n += OFFSET; IM_ASSERT(n >= 0 && n < BITCOUNT); return ImBitArrayTestBit(Storage, n); }
//};

const string imBitArray = q{
struct ImBitArray(int BITCOUNT, int OFFSET = 0)
{
    ImU32[(BITCOUNT + 31) >> 5] Storage;
    //ImBitArray()
    //{ 
    //    ClearAllBits(); 
    //}

    void ClearAllBits()
    { 
        core.stdc.string.memset(Storage.ptr, 0, Storage.sizeof);
    }

    void SetAllBits()
    { 
        core.stdc.string.memset(Storage.ptr, 255, Storage.sizeof);
    }

    bool TestBit(int n) const
    { 
        n += OFFSET; 
        assert(n >= 0 && n < BITCOUNT); 
        return igImBitArrayTestBit(Storage.ptr, n); 
    }

    void SetBit(int n)
    { 
        n += OFFSET;
        assert(n >= 0 && n < BITCOUNT); 
        igImBitArraySetBit(Storage.ptr, n); 
    }

    void ClearBit(int n)
    { 
        n += OFFSET;
        assert(n >= 0 && n < BITCOUNT); 
        igImBitArrayClearBit(Storage.ptr, n); 
    }
    
    // Works on range [n..n2)
    void SetBitRange(int n, int n2)
    { 
        n += OFFSET; 
        n2 += OFFSET; 
        assert(n >= 0 && n < BITCOUNT && n2 > n && n2 <= BITCOUNT); 
        igImBitArraySetBitRange(Storage.ptr, n, n2); 
    }

    bool opIndex(int n) const
    { 
        n += OFFSET; 
        assert(n >= 0 && n < BITCOUNT); 
        return igImBitArrayTestBit(Storage.ptr, n); 
    }
}
};

const string imVector = q{
struct ImVector(tType) {
    int Size;
    int Capacity;
    tType* Data;

    import core.stdc.string;


    bool empty() const                       
    {
        return Size == 0; 
    }

    int size() const                        
    {
        return Size; 
    }

    int size_in_bytes() const               
    {
        return Size * cast(int)tType.sizeof; 
    }

    int max_size() const                    
    {
        return 0x7FFFFFFF / cast(int)tType.sizeof; 
    }

    int capacity() const                    
    {
        return Capacity; 
    }

    void clear()                             
    {
        if (Data) 
        {
            Size = Capacity = 0;
            igMemFree(Data);
            Data = null; 
        } 
    }

    void swap(ImVector* rhs)
    {
        int rhs_size = rhs.Size;
        rhs.Size = Size;
        Size = rhs_size;
        int rhs_cap = rhs.Capacity;
        rhs.Capacity = Capacity;
        Capacity = rhs_cap;
        tType* rhs_data = rhs.Data;
        rhs.Data = Data;
        Data = rhs_data;
    }

    int _grow_capacity(int sz) const        
    {
        int new_capacity = Capacity ? (Capacity + Capacity / 2) : 8;
        return new_capacity > sz ? new_capacity : sz; 
    }

    void resize(int new_size)                
    {
        if (new_size > Capacity) 
            reserve(_grow_capacity(new_size)); Size = new_size; 
    }

    void resize(int new_size, const tType* v)    
    {
        if (new_size > Capacity)
            reserve(_grow_capacity(new_size));
        if (new_size > Size)
            for (int n = Size; n < new_size; n++) 
                memcpy(&Data[n], v, tType.sizeof); 
        
        Size = new_size; 
    }

    // Resize a vector to a smaller size, guaranteed not to cause a reallocation
    void shrink(int new_size)                
    {
        assert(new_size <= Size);
        Size = new_size; 
    } 

    void reserve(int new_capacity)           
    {
        if (new_capacity <= Capacity) 
            return; 

        tType* new_data = cast(tType*)igMemAlloc(cast(size_t)new_capacity * tType.sizeof); 
        
        if (Data) 
        {
            memcpy(new_data, Data, cast(size_t)Size * tType.sizeof); 
            igMemFree(Data);
        } 

        Data = new_data; 
        Capacity = new_capacity; 
    }


    // NB: It is illegal to call push_back/push_front/insert with a reference pointing inside the 
    // ImVector data itself! e.g. v.push_back(v[10]) is forbidden.
    void push_back(const tType* v)               
    {
        if (Size == Capacity)
            reserve(_grow_capacity(Size + 1)); 
        
        memcpy(&Data[Size], v, tType.sizeof);
        Size++; 
    }

    void pop_back()                          
    {
         assert(Size > 0);
         Size--; 
    }

    void push_front(const tType* v)              
    {
        if (Size == 0)
            push_back(v); 
        else 
            insert(Data, v); 
    }

    tType* erase(const tType* it)
    {
         assert(it >= Data && it < Data + Size);
         const ptrdiff_t off = it - Data;
         memmove(Data + off, Data + off + 1, (cast(size_t)Size - cast(size_t)off - 1) * tType.sizeof);
         Size--;
         return Data + off; 
    }

    tType* erase(const tType* it, const tType* it_last)
    {
         assert(it >= Data && it < Data + Size && it_last > it && it_last <= Data + Size);
         const ptrdiff_t count = it_last - it;
         const ptrdiff_t off = it - Data;
         memmove(Data + off, Data + off + count, (cast(size_t)Size - cast(size_t)off - count) * tType.sizeof);
         Size -= cast(int)count;
         return Data + off; 
    }

    tType* erase_unsorted(const tType* it)
    {
        assert(it >= Data && it < Data + Size);
        const ptrdiff_t off = it - Data;
         
        if (it < Data + Size - 1)
            memcpy(Data + off, Data + Size - 1, tType.sizeof);
        
        Size--;
        return Data + off; 
    }

    tType* insert(const tType* it, const tType* v)
    {
         assert(it >= Data && it <= Data + Size); 
         const ptrdiff_t off = it - Data;
         
        if (Size == Capacity) 
            reserve(_grow_capacity(Size + 1));
        
        if (off < cast(int)Size) 
            memmove(Data + off + 1, Data + off, (cast(size_t)Size - cast(size_t)off) * tType.sizeof);

        memcpy(&Data[off], v, tType.sizeof);
        Size++;
        return Data + off; 
    }
}
};

const string imChunkStream = q{
struct TypeToReplace {
    TemplatedTypeToReplace Buf;
}
};


const string cCFunctionWrapper = q{
auto igGenFuncC(T)(T func) {
  import std.traits;
  extern(C) ReturnType!T f(Parameters!T args)
  {
    static if (is(ReturnType!T == void)) 
    {
      func(args);
    } else 
    {
      return func(args);
    }
  }

  return &f;
}
};



string[string] write_template_structs(code_writer codeWriter, JSONValue definitions)
{
    string[string] imTemplateTypes;
    auto structs = definitions["structs"];

    imTemplateTypes["ImVector_const_charPtr"] =  "const char*";

    foreach (string structName, JSONValue structMembers; structs) 
    {
        foreach (JSONValue value; structMembers.array)
        {
            //string typeName = imgui_type_to_dlang(value["type"].str);
            //string objectName = value["name"].str;
            //if (startsWith(typeName, "ImVector_"))
            //{
            //    ++imTemplateTypes.length;
            //    imTemplateTypes[imTemplateTypes.length - 1] = imgui_type_to_dlang(typeName["ImVector_".length .. typeName.length]);
            //}

            if ("template_type" in value)
                imTemplateTypes[value["type"].str] =  value["template_type"].str;
        }
    }

    codeWriter.put_lines(imVector);
    codeWriter.put_lines(imSpan);
    codeWriter.put_lines(imBitArray);

    foreach (string templateName, string templatedOnType; imTemplateTypes)
    {
        string structTemplate;
        if (startsWith(templateName, "ImVector_") 
            || startsWith(templateName, "ImSpan_")
            || startsWith(templateName, "ImBitArray_"))
            continue; // We utlize a D template for these. (ImPool and ImChunkStream to follow).
        else if (startsWith(templateName, "ImPool_"))
            structTemplate = imPool;
        else if (startsWith(templateName, "ImChunkStream_"))
            structTemplate = imChunkStream;

        codeWriter.put_lines(structTemplate.replace("TemplatedTypeToReplace", imgui_type_to_dlang(templatedOnType)).replace("TypeToReplace", templateName));
    }

    return imTemplateTypes;
}

void write_typedefs(code_writer codeWriter, JSONValue typedefs, JSONValue structs_and_enums)
{
    foreach (string typedefName, JSONValue typeDefValue; typedefs) 
    {
        const string originalTypeName = imgui_type_to_dlang(typeDefValue.str);

        if (typedefName in structs_and_enums["enums"] ||
            (typedefName ~ "_") in structs_and_enums["enums"])
            continue;

        if (originalTypeName == "T") continue;
        if (typedefName == "iterator") continue;
        if (typedefName == "const_iterator") continue;

        if (originalTypeName != typedefName)
        {
            string aliasStr = format("alias %s = %s", typedefName,originalTypeName);
            codeWriter.put_string(aliasStr);

            // Sometimes we get a function with a semicolon. so we only sometimes need to write a semicolon.
            if (';'!= aliasStr[aliasStr.length - 1]) codeWriter.put_string(';');
            codeWriter.line_break();
        }

        if ((originalTypeName == typedefName) && !(typedefName in structs_and_enums["structs"]))
            codeWriter.put_lines(format("struct %s;", typedefName));
    }
}

void write_enums(code_writer codeWriter, JSONValue definitions)
{
    auto enums = definitions["enums"];

    foreach (string enumName, JSONValue enumValues; enums) 
    {
        string enumBaseType = "";
        string adjustedEnumTypeName = enumName;

        if ('_' == adjustedEnumTypeName[adjustedEnumTypeName.length - 1])
            adjustedEnumTypeName = adjustedEnumTypeName[0 .. adjustedEnumTypeName.length - 1];

        if (adjustedEnumTypeName.endsWith("Private"))
        {
            adjustedEnumTypeName = adjustedEnumTypeName[0 .. adjustedEnumTypeName.length - "Private".length] ~ "I"; 
            enumBaseType = adjustedEnumTypeName[0 .. adjustedEnumTypeName.length - 1];
        }

        codeWriter.add_enum(adjustedEnumTypeName, enumBaseType);
        gEnumType[adjustedEnumTypeName] = enum_values();

        foreach (JSONValue value; enumValues.array)
        {
            auto valueName = value["name"].str;
            if (valueName.startsWith(enumName))
                valueName = valueName[enumName.length .. valueName.length];
            else if (valueName.startsWith(enumBaseType))
                valueName = valueName[enumBaseType.length .. valueName.length];

            if (valueName.startsWith("_"))
                valueName = valueName[1 .. valueName.length];

            if (std.string.isNumeric(valueName))
                valueName = "n" ~ valueName;

            gConvertedEnumValue[value["name"].str] = adjustedEnumTypeName ~ "." ~ valueName;

            if (enumBaseType.length == 0)
                codeWriter.put_lines(format("%s = %d,\n", valueName, value["calc_value"].integer));
            else
                codeWriter.put_lines(format("%s = cast(%s)%d,\n", valueName, enumBaseType, value["calc_value"].integer));
            gEnumType[adjustedEnumTypeName].values[to!string(value["calc_value"].integer)] = valueName; // should cache the first gEnumType[adjustedEnumTypeName] call, but don't know how to take it by ref.
        }

        codeWriter.remove_scope();
        codeWriter.line_break();
    }
}

void write_structs(code_writer codeWriter, JSONValue definitions)
{
    auto structs = definitions["structs"];
    foreach (string structName, JSONValue structMembers; structs) 
    {
        codeWriter.add_struct(structName);

        foreach (JSONValue value; structMembers.array)
        {
            string typeName = imgui_type_to_dlang(value["type"].str);
            string objectName = value["name"].str;

            if ((0 != objectName.length) && (']' == objectName[objectName.length - 1]))
            {
                ptrdiff_t position = std.string.lastIndexOf(objectName, '[');

                string sizeExpression = objectName[position + 1 .. objectName.length - 1]; 
                if (sizeExpression in gConvertedEnumValue)
                    sizeExpression = gConvertedEnumValue[sizeExpression];

                typeName = typeName ~ "[" ~ sizeExpression ~ "]";
                objectName = objectName[0 .. position];
            }
            else
            {

            }

            codeWriter.put_lines(format("%s %s;", typeName, objectName));
        }

        codeWriter.remove_scope();
        codeWriter.line_break();
    }
}


void write_function_loading(code_writer codeWriter, JSONValue definitions)
{
    foreach (string functionName, JSONValue functionDecl; definitions) 
    {
        foreach (JSONValue cimguiFunction; functionDecl.array)
        {
            if ("templated" in cimguiFunction && cimguiFunction["templated"].boolean)
                continue;
                
            codeWriter.put_lines(
                format(
                    "lib.bindSymbol(cast(void**)&%s, \"%s\");", 
                    cimguiFunction["ov_cimguiname"].str, 
                    cimguiFunction["ov_cimguiname"].str));
        }
    }
}


backend_function[][string] get_backend_functions(JSONValue definitions)
{
    backend_function[][string] backendFunctionsMap;

    foreach (string functionName, JSONValue functionDecl; definitions)
    {
        if (functionName == "ImVector_ImVector")
            continue;

        foreach (JSONValue cimguiFunction; functionDecl.array)
        {
            string implKey = functionName[0 .. std.string.indexOf(functionName, '_', 6)];

            // Init the array if it's not already
            if (!(implKey in backendFunctionsMap)) backendFunctionsMap[implKey] = [];

            ++backendFunctionsMap[implKey].length;
            backendFunctionsMap[implKey][backendFunctionsMap[implKey].length - 1] = backend_function(functionName, cimguiFunction);
        }
    }

    return backendFunctionsMap;
}


void write_backend_function_loading(code_writer codeWriter, JSONValue definitions)
{
    // impl to a Backend
    backend_function[][string] backendFunctionsMap = get_backend_functions(definitions);

    foreach (implKey, backendFunctions; backendFunctionsMap)
    {
        if (!(implKey in cBackendMap))
        {
            writeln("WARNING UNKNOWN BACKEND IMPLEMENTATION " ~ implKey ~ ":");

            foreach (backendFunction; backendFunctions)
                writeln("  " ~ backendFunction.functionName);

            continue;
        }

        const auto backendData = cBackendMap[implKey];
        codeWriter.add_version(backendData.VersionDefine);

        
        foreach (backendFunction; backendFunctions)
        {
            if ("templated" in backendFunction.cimguiFunction && backendFunction.cimguiFunction["templated"].boolean)
                continue;
                
            codeWriter.put_lines(
                format(
                    "lib.bindSymbol(cast(void**)&%s, \"%s\");", 
                    backendFunction.cimguiFunction["ov_cimguiname"].str, 
                    backendFunction.cimguiFunction["ov_cimguiname"].str));
        }

        codeWriter.remove_scope();  // version
        codeWriter.line_break();
    }
}


struct function_overload_info
{
    void put_name(string name, string overloadName)
    {
        overload_name = overloadName;
        is_overload = name != overloadName;
        overload_decl = overload_decl ~ " " ~ overloadName ~ "(";
        decl = decl ~ " " ~ name ~ "(";
        call = call ~ " " ~ name ~ "(";
    }

    void put_return(string returnType)
    {
        overload_decl = returnType ~ " ";
        decl = returnType ~ " ";
        if (returnType != "void")
            call = "return ";
    }

    void end_function()
    {
        overload_decl = overload_decl ~ ")";
        decl = decl ~ ");";
        call = call ~ ");";
    }

    void put_parameter_type(string parameterType)
    {
        if (parameter_already_placed)
        {
            overload_decl = overload_decl ~ ", ";
            decl = decl ~ ", ";
        }

        if (parameterType.indexOf("function") != -1)
        {
            was_function_type = true;
            last_function_type = parameterType;
        }
        else // function paramters need the name of the parameter to have their type name written out.
        {
            overload_decl = overload_decl ~ parameterType;
            decl = decl ~ parameterType;
        }

        parameter_already_placed = true;
    }

    void put_parameter_name(string parameterName)
    {
        if (parameter_already_placed_call)
        {
            call = call ~ ", ";
        }
        
        if (was_function_type)
        {
            string functionParameterTypeName = overload_name ~ "_" ~ parameterName;
            string functionParameterType = "extern(C) alias " ~ functionParameterTypeName  ~ " = " ~ last_function_type ~ ";";
            function_parameters ~= functionParameterType;

            // Parameter Type part.
            overload_decl = overload_decl ~ functionParameterTypeName;
            decl = decl ~ functionParameterTypeName;

            // Parameter name part.
            call = call ~ parameterName;
            was_function_type = false;
        }
        else
        {
            call = call ~ parameterName;
        }

        overload_decl = overload_decl ~ " " ~ parameterName;
        decl = decl ~ " " ~ parameterName;

        parameter_already_placed_call = true;
    }

    void put_default_argument(string defaultArgument)
    {
        overload_decl = overload_decl ~ " = " ~ defaultArgument;
        decl = decl ~ " = " ~ defaultArgument;
        // the call doesn't require a default argument. 
    }

    string overload_decl;
    string decl;
    string call;
    string overload_name;
    string last_function_type;
    string return_type = "";
    string function_ptr_type = "";
    string[] function_parameters;
    bool parameter_already_placed = false;
    bool parameter_already_placed_call = false;
    bool was_function_type = false;
    bool is_overload = false;
};

/// Return value is the type of the Function pointer, so that it can later be used if we're writing the global symbols to load into.
function_overload_info write_function(code_writer codeWriter, string functionName, JSONValue cimguiFunction, bool writeFunctionGlobals)
{
    function_overload_info info;

    if ("templated" in cimguiFunction && cimguiFunction["templated"].boolean)
        return info;

    codeWriter.write_indent();

    if ("constructor" in cimguiFunction && cimguiFunction["constructor"].boolean)
        info.return_type = format("%s*", functionName[0 .. std.string.lastIndexOf(functionName, '_')]);
    else
        info.return_type = cimguiFunction["ret"].str;

    info.function_ptr_type = "p" ~ cimguiFunction["ov_cimguiname"].str;
    if (writeFunctionGlobals)
        codeWriter.put_string("alias " ~ info.function_ptr_type ~ " = ");

    info.put_return(imgui_type_to_dlang(info.return_type));
    codeWriter.put_string(imgui_type_to_dlang(info.return_type));
    codeWriter.put_string(' ');
    
    if (writeFunctionGlobals)
        codeWriter.put_string("function");
    else
        codeWriter.put_string(cimguiFunction["ov_cimguiname"].str);

    info.put_name(cimguiFunction["ov_cimguiname"].str, cimguiFunction["cimguiname"].str);
    
    codeWriter.put_string("(");

    int i = 0;
    auto defaultArguments = cimguiFunction["defaults"];
    foreach (JSONValue parameter; cimguiFunction["argsT"].array)
    {
        string argType = imgui_type_to_dlang(parameter["type"].str);
        string argName = parameter["name"].str;
        string origArgName = parameter["name"].str;
        string defaultArgument = "";

        // Deal with arraySubScriptToken in Arg name
        if ((0 != argName.length) && (']' == argName[argName.length - 1]))
        {
            ptrdiff_t position = std.string.lastIndexOf(argName, '[');

            argType = argType ~ argName[position .. argName.length];
            argName = argName[0 .. position];
        }
        
        // Deal with arraySubScriptToken in Arg Type
        if ((0 != argType.length) && (']' == argType[argType.length - 1]))
        {
            ptrdiff_t position = std.string.lastIndexOf(argType, '[');

            const string arraySubScriptToken = argType[position .. argType.length];
            argType = argType ~ "*";

            if (arraySubScriptToken != "[]")
            {
                argType = argType ~ "/*" ~ arraySubScriptToken ~ "*/";
            }
        }

        argName = imgui_argname_to_dlang(argName);
        argType = imgui_type_to_dlang(argType);

        info.put_parameter_type(argType);
        codeWriter.put_string(argType);
        
        if (!startsWith(argType, "..."))
            codeWriter.put_string(' ');

        // Don't write the name out if this function is variadic
        if (argName != "...") 
        {

            info.put_parameter_name(argName);
            codeWriter.put_string(argName);
        }

        // Parse default argument information
        if (origArgName in defaultArguments)
        {
            defaultArgument = defaultArguments[origArgName].str;

            if (defaultArgument in gConvertedEnumValue) 
                defaultArgument = gConvertedEnumValue[defaultArgument];
            
            if (defaultArgument in cDefaultArgumentsNeedingConversion)
                defaultArgument = cDefaultArgumentsNeedingConversion[defaultArgument];

            if (isNumeric(defaultArgument) && argType in gEnumType)
                defaultArgument = argType ~ "." ~ to!string(gEnumType[argType].values[defaultArgument]);
            
            info.put_default_argument(defaultArgument);
            codeWriter.put_string(" = " ~ defaultArgument);
        }

        // Write out a comma and space if this isn't the last parameter.
        if (++i != cimguiFunction["argsT"].array.length) codeWriter.put_string(", ");
    }
    
    info.end_function();
    codeWriter.put_string(");");
    codeWriter.line_break();

    return info;
}


function_overload_info[] write_functions(code_writer codeWriter, JSONValue definitions, bool writeFunctionGlobals)
{
    string[] imFunctionPtrTypes;
    function_overload_info[] infos;

    codeWriter.add_extern_c();
    foreach (string functionName, JSONValue functionDecl; definitions)
    {
        if (functionName == "ImVector_ImVector")
            continue;

        foreach (JSONValue cimguiFunction; functionDecl.array)
        {
            auto functionInfo = write_function(codeWriter, functionName, cimguiFunction, writeFunctionGlobals);
            const string functionPointerTypeName = functionInfo.function_ptr_type;

            //if (functionDecl.array.length > 1)
            //    writeln(functionName ~ " : " ~ cimguiFunction["ov_cimguiname"].str);    

            if (writeFunctionGlobals && (functionPointerTypeName.length != 0))
            {
                ++imFunctionPtrTypes.length;
                imFunctionPtrTypes[imFunctionPtrTypes.length - 1] = functionPointerTypeName;
            }

            if (functionInfo.is_overload)
            {
                infos ~= functionInfo;
            }
        }
    }
    
    if (writeFunctionGlobals)
    {
        codeWriter.add_gshared();
        
        foreach (string item; imFunctionPtrTypes)
            codeWriter.put_lines(item ~ " " ~ item[1 .. item.length] ~ ";");

        codeWriter.remove_scope();
    }
    
    codeWriter.remove_scope();
    return infos;
}

function_overload_info[] write_backend_functions(code_writer codeWriter, JSONValue definitions, bool writeFunctionGlobals)
{
    // impl to a Backend
    backend_function[][string] backendFunctionsMap = get_backend_functions(definitions);
    function_overload_info[] infos;
    
    codeWriter.add_extern_c();

    foreach (implKey, backendFunctions; backendFunctionsMap)
    {
        if (!(implKey in cBackendMap))
        {
            writeln("WARNING UNKNOWN BACKEND IMPLEMENTATION " ~ implKey ~ ":");

            foreach (backendFunction; backendFunctions)
                writeln("  " ~ backendFunction.functionName);

            continue;
        }

        const auto backendData = cBackendMap[implKey];
        string[] imFunctionPtrTypes;

        codeWriter.add_version(backendData.VersionDefine);
        codeWriter.put_lines(backendData.ImportCode);
        codeWriter.line_break();

        foreach (backendFunction; backendFunctions)
        {
            auto info = write_function(
                codeWriter, 
                backendFunction.functionName, 
                backendFunction.cimguiFunction, 
                writeFunctionGlobals);
            const string functionPointerTypeName = info.function_ptr_type;
            
            if (writeFunctionGlobals && (functionPointerTypeName.length != 0))
            {
                ++imFunctionPtrTypes.length;
                imFunctionPtrTypes[imFunctionPtrTypes.length - 1] = functionPointerTypeName;
            }

            if (info.is_overload)
            {
                infos ~= info;
            }
        }
        
        if (writeFunctionGlobals)
        {
            codeWriter.line_break();
            codeWriter.add_gshared();

            foreach (string item; imFunctionPtrTypes)
                codeWriter.put_lines(item ~ " " ~ item[1 .. item.length] ~ ";");

            codeWriter.remove_scope();
        }

        codeWriter.remove_scope();  // version
    }
    
    codeWriter.remove_scope(); // extern
    return infos;
}


void write_imgui_file(
    JSONValue typedefs_dict,
    JSONValue structs_and_enums,
    JSONValue definitions,
    JSONValue impl_definitions)
{
    auto codeWriter = code_writer();

    codeWriter.put_lines("module bindbc.imgui.bind.imgui;");
    codeWriter.line_break();
    codeWriter.put_lines("import std.algorithm;");
    codeWriter.line_break();
    codeWriter.put_lines("import core.stdc.stdio;");
    codeWriter.line_break();
    codeWriter.put_lines("import core.stdc.stdarg;");
    codeWriter.line_break();
    codeWriter.put_lines("import core.stdc.string;");
    codeWriter.line_break();

    codeWriter.add_normal_extern_c();

    write_typedefs(codeWriter, typedefs_dict, structs_and_enums);
    auto tempalteStructInfo = write_template_structs(codeWriter, structs_and_enums);
    codeWriter.line_break();
    write_enums(codeWriter, structs_and_enums);
    codeWriter.line_break();
    write_structs(codeWriter, structs_and_enums);
    codeWriter.line_break();

    codeWriter.remove_scope();

    // Writing out the static version of the symbols
    codeWriter.add_version("BindImGui_Static");

    auto infos = write_functions(codeWriter, definitions, false);
    infos ~= write_backend_functions(codeWriter, impl_definitions, false);

    // NOTE: For some reason we merge this scope and following else into one line, hence why we're not using remove_scope here.    
    codeWriter.remove_indent();
    codeWriter.put_string("} ");

    // Writing out the Dynamic version of the symbols
    codeWriter.add_else();

    write_functions(codeWriter, definitions, true);
    write_backend_functions(codeWriter, impl_definitions, true);
    codeWriter.remove_scope();

    codeWriter.put_lines(cCFunctionWrapper);

    // writing out the dlang overloaded functions:
    foreach(function_overload_info overload; infos) 
    {
        foreach(functionParameter; overload.function_parameters) 
        {
            codeWriter.put_lines(functionParameter);
            codeWriter.put_string("\n");
        }

        codeWriter.put_lines("pragma(inline):");
        codeWriter.put_lines(overload.overload_decl);
        codeWriter.add_scope();
        codeWriter.put_lines(overload.call);
        codeWriter.remove_scope();
        codeWriter.put_string("\n");
    }

    std.file.write("source/bindbc/imgui/bind/imgui.d", codeWriter.mBuilder.data);
}

void write_loader(
    JSONValue definitions,
    JSONValue impl_definitions)
{
    auto codeWriter = code_writer();
    codeWriter.put_lines(loaderPrelude);
    codeWriter.line_break();
    codeWriter.add_indent();

    write_function_loading(codeWriter, definitions);

    codeWriter.line_break();
    codeWriter.put_lines("// Backends");

    write_backend_function_loading(codeWriter, impl_definitions);

    codeWriter.remove_indent();
    codeWriter.put_lines(loaderEnd);
    
    std.file.write("source/bindbc/imgui/dynload.d", codeWriter.mBuilder.data);
}

void main()
{
    JSONValue typedefs_dict = parseJSON(std.file.readText("./deps/cimgui/generator/output/typedefs_dict.json"));
    JSONValue structs_and_enums = parseJSON(std.file.readText("./deps/cimgui/generator/output/structs_and_enums.json"));
    JSONValue definitions = parseJSON(std.file.readText("./deps/cimgui/generator/output/definitions.json"));
    JSONValue impl_definitions = parseJSON(std.file.readText("./deps/cimgui/generator/output/impl_definitions.json"));

    write_loader(definitions, impl_definitions);
    write_imgui_file(typedefs_dict, structs_and_enums, definitions, impl_definitions);

    //JSONValue definitions = parseJSON(std.file.readText("./cimgui/generator/output/definitions.json"));
    //JSONValue impl_definitions = parseJSON(std.file.readText("./cimgui/generator/output/impl_definitions.json"));
    //JSONValue typedefs_dict = parseJSON(std.file.readText("./cimgui/generator/output/typedefs_dict.json"));

    //WriteFunctionBindings(definitions);
    //write_function_loading(impl_definitions);
}
