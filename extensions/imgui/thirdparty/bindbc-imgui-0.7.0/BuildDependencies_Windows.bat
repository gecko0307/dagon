cmake -G "Visual Studio 17 2022" -Ax64 -DSTATIC_CIMGUI= -DWINDOWS_STATIC_CRT= -S deps -B deps/build_windows_x64_cimguiStatic_StaticCRT
cmake --build deps/build_windows_x64_cimguiStatic_StaticCRT --config Release

cmake -G "Visual Studio 17 2022" -Ax64 -DSTATIC_CIMGUI= -S deps -B deps/build_windows_x64_cimguiStatic_DynamicCRT
cmake --build deps/build_windows_x64_cimguiStatic_DynamicCRT --config Release

cmake -G "Visual Studio 17 2022" -Ax64 -DWINDOWS_STATIC_CRT= -S deps -B deps/build_windows_x64_cimguiDynamic_StaticCRT
cmake --build deps/build_windows_x64_cimguiDynamic_StaticCRT --config Release

cmake -G "Visual Studio 17 2022" -Ax64 -S deps -B deps/build_windows_x64_cimguiDynamic_DynamicCRT
cmake --build deps/build_windows_x64_cimguiDynamic_DynamicCRT --config Release

cmake -G "Visual Studio 17 2022" -AWin32 -DSTATIC_CIMGUI= -DWINDOWS_STATIC_CRT -S deps -B deps/build_windows_x86_cimguiStatic_StaticCRT
cmake --build deps/build_windows_x86_cimguiStatic_StaticCRT --config Release

cmake -G "Visual Studio 17 2022" -AWin32 -DSTATIC_CIMGUI= -S deps -B deps/build_windows_x86_cimguiStatic_DynamicCRT
cmake --build deps/build_windows_x86_cimguiStatic_DynamicCRT --config Release

cmake -G "Visual Studio 17 2022" -AWin32 -DWINDOWS_STATIC_CRT= -S deps -B deps/build_windows_x86_cimguiDynamic_StaticCRT
cmake --build deps/build_windows_x86_cimguiDynamic_StaticCRT --config Release

cmake -G "Visual Studio 17 2022" -AWin32 -S deps -B deps/build_windows_x86_cimguiDynamic_DynamicCRT
cmake --build deps/build_windows_x86_cimguiDynamic_DynamicCRT --config Release

cmake -G "Visual Studio 17 2022" -AARM64 -DSTATIC_CIMGUI= -DWINDOWS_STATIC_CRT -S deps -B deps/build_windows_arm64_cimguiStatic_StaticCRT
cmake --build deps/build_windows_arm64_cimguiStatic_StaticCRT --config Release

cmake -G "Visual Studio 17 2022" -AARM64 -DSTATIC_CIMGUI= -S deps -B deps/build_windows_arm64_cimguiStatic_DynamicCRT
cmake --build deps/build_windows_arm64_cimguiStatic_DynamicCRT --config Release

cmake -G "Visual Studio 17 2022" -AARM64 -DWINDOWS_STATIC_CRT= -S deps -B deps/build_windows_arm64_cimguiDynamic_StaticCRT
cmake --build deps/build_windows_arm64_cimguiDynamic_StaticCRT --config Release