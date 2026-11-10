# Platforms and Toolchain

Dagon is written in [D2](https://dlang.org/) and requires an up-to-date D toolchain. Supported compilers are [DMD](https://dlang.org/download.html#dmd) and [LDC](https://github.com/ldc-developers/ldc#installation). [DUB](https://dub.pm/) is used as a build system and a dependency manager; it is usually bundled with the binary release of a compiler.

To use Dagon with DUB, either add it as a dependency to your application (`dub add dagon`), or generate a project template (`dub init --type=dagon`).

The engine targets x86_64 desktop platforms.

## Linux Tips

Distributing Linux applications has historically been a difficult task. Dagon is specificially designed to develop disto-agnostic, portable applications that do not require installation, so users can simply download a bundle, unpack it to their home folder, and run the executable. The engine is self-contained: Dagon's DUB recipe automatically copies all the necessary shared libraries to the project.

With this in mind, on Linux it is **strongly recommended** to build with `-rpath=$ORIGIN` flag that tells the dynamic linker to look for shared libraries (.so files) relative to the location of the executable. Otherwise the linker will search the libraries in the system, and the user will be required to install them first (or use `LD_LIBRARY_PATH`), which is not convenient.

Add the following to your `dub.json`:

```json
"lflags-linux": ["-rpath=$$ORIGIN"]
```

Note the two dollar signs (`$$`) instead of just one, because DUB interprets a single dollar sign as the start of an environment variable substitution. Doubling the symbol escapes it so it is processed as a literal `$`.

## Windows Tips

Dagon supports 64-bit Windows versions starting from Windows 7.

Same as on Linux, all the DLLs necessary to run the application are provided automatically when you build with DUB. Some dependencies require Visual C++ v14 Redistributable. You can download an official installer [here](https://aka.ms/vc14/vc_redist.x64.exe). It is recommended to bundle `vc_redist.x64.exe` with your application's installer for end users.

To add an application icon, version information and a manifest, a resource file (`*.res`) can be used:

```json
"sourceFiles-windows" : ["app.res"]
```

However, this requires installing a resource file compiler. Much easier way is to use [Electron's rcedit](https://github.com/electron/rcedit). Assuming you have rcedit executable (`rcedit-x64.exe`) in your project's directory, you can call it after each build using `postBuildCommands`:

```json
"postBuildCommands-windows-x86_64": [
    "$PACKAGE_DIR\\rcedit-x64 \"app.exe\" --set-file-version \"1.0.0.0\"
--set-product-version \"1.0.0\" --set-icon \"$PACKAGE_DIR\\icon.ico\"
--application-manifest \"$PACKAGE_DIR\\app.manifest\""
]
```

An example manifest file:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
 <!-- Version compatibility -->
 <compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1">
  <application>
    <supportedOS Id="{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}"/> <!-- Windows 10, 11 -->
    <supportedOS Id="{1f676c76-80e1-4239-95bb-83d0f6d0da78}"/> <!-- Windows 8.1 -->
    <supportedOS Id="{4a2f28e3-53b9-4441-ba9c-d69d4a4a6e38}"/> <!-- Windows 8 -->
    <supportedOS Id="{35138b9a-5d96-4fbd-8e2d-a2440225f93a}"/> <!-- Windows 7 -->
   </application>
 </compatibility>
 
 <!-- DPI-awareness -->
 <asmv3:application>
  <asmv3:windowsSettings>
   <!-- For Windows 10 и 11: -->
   <dpiAwareness xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">
    PerMonitorV2
   </dpiAwareness>
   <!-- For older versions: -->
   <dpiAware xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">
    true/pm
   </dpiAware>
  </asmv3:windowsSettings>
 </asmv3:application>
</assembly>
```
