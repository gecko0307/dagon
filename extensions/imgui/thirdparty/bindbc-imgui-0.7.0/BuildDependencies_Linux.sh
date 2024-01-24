cd deps
mkdir build_linux_x64_cimguiStatic
cd build_linux_x64_cimguiStatic
cmake -DSTATIC_CIMGUI=  ..
cmake --build . --config Release
cd ..
mkdir build_linux_x64_cimguiDynamic
cd build_linux_x64_cimguiDynamic
cmake  ..
cmake --build . --config Release
cd ..
cd ../../