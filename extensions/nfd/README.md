# dagon:nfd

A simple way to show native file open/save dialogs. Based on [Native File Dialog](https://github.com/mlabbe/nativefiledialog) library.

Currently Windows-only.

## Usage

```d
import dagon.ext.nfd;

char* outPath = null;
auto result = NFD_OpenDialog("png,jpg,bmp,tga", null, &outPath);
if (result == NFD_OKAY)
{
    // do something with outPath
}
```
