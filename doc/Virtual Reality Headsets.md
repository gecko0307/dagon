# Virtual Reality Headsets

A virtual reality headset is a head-mounted device that provides a VR environment for the user. It uses a stereoscopic display with two separate images for each eye and an accelerometer/gyroscope for tracking the pose of the user's head to sync the virtual camera.

## VR APIs: OpenVR vs OpenXR

Dagon supports two major APIs: [OpenVR](https://github.com/valvesoftware/openvr) and [OpenXR](https://www.khronos.org/openxr/), implemented as `dagon:openvr` and `dagon:openxr` extensions, respectively.

- OpenVR is a legacy API by Valve Corporation that allows applications to interoperate with [SteamVR](https://store.steampowered.com/app/250820/SteamVR/) platform, accessing various VR hardware such as Valve Index, HTC Vive, Oculus Rift, Windows Mixed Reality. The downside of this API is vendor lock-in. While you are not required to add your game to Steam, it will not run on user machines without Steam.
- OpenXR is a newer API by Khronos Group that aims to standardize access to VR headsets. It works with any VR platform that provides an OpenXR runtime: Meta Quest, HTC Vive, Magic Leap 2, Varjo and others. Moreover, SteamVR also can work as an OpenXR runtime.

OpenVR has strong compatibility, while OpenXR generally offers higher performance. It is not recommended to use both APIs at once; choose only one that fits your application best. Because of architectural differences between the two, `dagon:openvr` and `dagon:openxr` are not directly interchangeable.

## OpenVR Usage

TODO

## OpenXR Usage

TODO
