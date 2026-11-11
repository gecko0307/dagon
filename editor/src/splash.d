module splash;

version (Windows):

import std.utf: toUTF16z;
import core.stdc.stdint: intptr_t, uintptr_t;

pragma(lib, "gdiplus");

alias HWND      = void*;
alias HINSTANCE = void*;
alias HDC       = void*;
alias HBRUSH    = void*;
alias HICON     = void*;
alias HCURSOR   = void*;
alias BOOL      = int;
alias UINT      = uint;
alias DWORD     = uint;
alias WPARAM    = uintptr_t;
alias LPARAM    = intptr_t;
alias LRESULT   = intptr_t;

alias WNDPROC = extern(Windows) LRESULT function(HWND, UINT, WPARAM, LPARAM);

struct RECT
{
    int left, top, right, bottom;
}

struct POINT
{
    int x, y;
}

struct WNDCLASSEXW
{
    UINT cbSize;
    UINT style;
    WNDPROC lpfnWndProc;
    int cbClsExtra;
    int cbWndExtra;
    HINSTANCE hInstance;
    HICON hIcon;
    HCURSOR hCursor;
    HBRUSH hbrBackground;
    const(wchar)* lpszMenuName;
    const(wchar)* lpszClassName;
    HICON hIconSm;
}

struct MSG
{
    HWND hwnd;
    UINT message;
    WPARAM wParam;
    LPARAM lParam;
    DWORD time;
    POINT pt;
}

struct PAINTSTRUCT
{
    HDC hdc;
    BOOL fErase;
    RECT rcPaint;
    BOOL fRestore;
    BOOL fIncUpdate;
    ubyte[32] rgbReserved;
}

// GDI+

struct GdiplusStartupInput
{
    uint GdiplusVersion;
    void* DebugEventCallback;
    BOOL SuppressBackgroundThread;
    BOOL SuppressExternalCodecs;
}

extern(Windows)
{
    // Win32

    HINSTANCE GetModuleHandleW(const(wchar)*);

    uint RegisterClassExW(const WNDCLASSEXW*);

    HWND CreateWindowExW(
        DWORD, const(wchar)*, const(wchar)*,
        DWORD, int, int, int, int,
        HWND, void*, HINSTANCE, void*
    );

    BOOL DestroyWindow(HWND);
    BOOL ShowWindow(HWND, int);
    BOOL UpdateWindow(HWND);

    BOOL PeekMessageW(MSG*, HWND, UINT, UINT, UINT);
    BOOL TranslateMessage(const MSG*);
    LRESULT DispatchMessageW(const MSG*);

    LRESULT DefWindowProcW(HWND, UINT, WPARAM, LPARAM);

    int GetSystemMetrics(int);
    HBRUSH CreateSolidBrush(uint);
    BOOL DeleteObject(void*);
    HDC BeginPaint(HWND, PAINTSTRUCT*);
    BOOL EndPaint(HWND, const PAINTSTRUCT*);
    int FillRect(HDC, const RECT*, HBRUSH);

    // GDI+

    int GdiplusStartup(
        uintptr_t*, const GdiplusStartupInput*, void*
    );

    void GdiplusShutdown(uintptr_t);

    int GdipLoadImageFromFile(
        const(wchar)*, void**
    );

    int GdipGetImageWidth(void*, uint*);
    int GdipGetImageHeight(void*, uint*);

    int GdipCreateFromHDC(HDC, void**);

    int GdipDrawImageRectI(
        void*, void*, int, int, int, int
    );

    int GdipDeleteGraphics(void*);
    int GdipDisposeImage(void*);
}

// Constants

enum : UINT
{
    WM_PAINT        = 0x000F,
    WM_ERASEBKGND   = 0x0014,
    PM_REMOVE       = 0x0001
}

enum : DWORD
{
    WS_POPUP         = 0x80000000,
    WS_EX_TOOLWINDOW = 0x00000080,
    WS_EX_TOPMOST    = 0x00000008,
    CS_HREDRAW       = 0x00000002,
    CS_VREDRAW       = 0x00000001
}

enum
{
    SW_SHOWNOACTIVATE = 4,
    SM_CXSCREEN = 0,
    SM_CYSCREEN = 1
}

// Splash implementation

struct Splash
{
    private static HWND hwnd;
    private static void* image;
    private static HBRUSH brush;

    private static uintptr_t gdipToken;
    private static bool gdipStarted;
    private static bool classRegistered;

    private static uint imageWidth;
    private static uint imageHeight;

    private static immutable(wchar)[] className =
        "DagonSplashWindow\0"w;

    private static extern(Windows)
    LRESULT wndProc(
        HWND window,
        UINT msg,
        WPARAM wParam,
        LPARAM lParam
    )
    {
        switch (msg)
        {
            case WM_ERASEBKGND:
                return 1;

            case WM_PAINT:
            {
                PAINTSTRUCT ps;
                auto hdc = BeginPaint(window, &ps);

                FillRect(hdc, &ps.rcPaint, brush);

                if (image !is null)
                {
                    void* graphics;

                    if (GdipCreateFromHDC(hdc, &graphics) == 0)
                    {
                        GdipDrawImageRectI(
                            graphics,
                            image,
                            0, 0,
                            cast(int)imageWidth,
                            cast(int)imageHeight
                        );

                        GdipDeleteGraphics(graphics);
                    }
                }

                EndPaint(window, &ps);
                return 0;
            }

            default:
                return DefWindowProcW(
                    window, msg, wParam, lParam
                );
        }
    }

    private static bool initGdiPlus()
    {
        if (gdipStarted)
            return true;

        GdiplusStartupInput input;
        input.GdiplusVersion = 1;

        if (GdiplusStartup(&gdipToken, &input, null) != 0)
            return false;

        gdipStarted = true;
        return true;
    }

    private static bool registerWindowClass()
    {
        if (classRegistered)
            return true;

        brush = CreateSolidBrush(0x00202020);

        WNDCLASSEXW wc;
        wc.cbSize = WNDCLASSEXW.sizeof;
        wc.style = CS_HREDRAW | CS_VREDRAW;
        wc.lpfnWndProc = &wndProc;
        wc.hInstance = GetModuleHandleW(null);
        wc.hbrBackground = brush;
        wc.lpszClassName = className.ptr;

        if (RegisterClassExW(&wc) == 0)
            return false;

        classRegistered = true;
        return true;
    }

    static bool show(string filename)
    {
        if (hwnd !is null)
            return false;

        if (!initGdiPlus())
            return false;

        if (!registerWindowClass())
            return false;

        auto path = toUTF16z(filename);

        if (GdipLoadImageFromFile(path, &image) != 0)
        {
            close();
            return false;
        }

        if (GdipGetImageWidth(image, &imageWidth) != 0 ||
            GdipGetImageHeight(image, &imageHeight) != 0)
        {
            close();
            return false;
        }

        int screenW = GetSystemMetrics(SM_CXSCREEN);
        int screenH = GetSystemMetrics(SM_CYSCREEN);

        int x = (screenW - cast(int)imageWidth) / 2;
        int y = (screenH - cast(int)imageHeight) / 2;

        hwnd = CreateWindowExW(
            WS_EX_TOOLWINDOW | WS_EX_TOPMOST,
            className.ptr,
            "Dagon Editor"w.ptr,
            WS_POPUP,
            x, y,
            cast(int)imageWidth,
            cast(int)imageHeight,
            null,
            null,
            GetModuleHandleW(null),
            null
        );

        if (hwnd is null)
        {
            close();
            return false;
        }

        ShowWindow(hwnd, SW_SHOWNOACTIVATE);
        UpdateWindow(hwnd);

        return true;
    }

    static void pump()
    {
        if (hwnd is null)
            return;

        MSG msg;

        while (PeekMessageW(&msg, hwnd, 0, 0, PM_REMOVE))
        {
            TranslateMessage(&msg);
            DispatchMessageW(&msg);
        }
    }

    static void close()
    {
        if (hwnd !is null)
        {
            DestroyWindow(hwnd);
            hwnd = null;
        }

        if (image !is null)
        {
            GdipDisposeImage(image);
            image = null;
        }

        if (gdipStarted)
        {
            GdiplusShutdown(gdipToken);
            gdipStarted = false;
            gdipToken = 0;
        }
    }
}
