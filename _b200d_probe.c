/* Batch 200d probe - what does comctl32 actually do in this environment?
 *
 * The PB witness prints 0 for the image-list handle.  Two candidate causes remain:
 *   (a) ILC_COLOR32 needs comctl32 v6 and this process gets v5 (no manifest) -> Create returns NULL
 *   (b) the PB path truncates/loses the 64-bit handle
 * A plain C process answers (a) directly: same loader, same comctl32, no PB involved.
 * It also reports the loaded comctl32 version, which is the fact neither guess had.
 */
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <commctrl.h>
#include <winver.h>

typedef struct { DWORD dwSize; DWORD dwICC; } ICCX;

static void show_version(const char* path)
{
    DWORD dummy = 0, sz = GetFileVersionInfoSizeA(path, &dummy);
    if (!sz) { printf("comctl32 version= (no version resource)\n"); return; }
    char* buf = (char*)malloc(sz);
    if (buf && GetFileVersionInfoA(path, 0, sz, buf)) {
        VS_FIXEDFILEINFO* fi = NULL; UINT len = 0;
        if (VerQueryValueA(buf, "\\", (void**)&fi, &len) && fi)
            printf("comctl32 version= %u.%u.%u.%u\n",
                   (unsigned)HIWORD(fi->dwFileVersionMS), (unsigned)LOWORD(fi->dwFileVersionMS),
                   (unsigned)HIWORD(fi->dwFileVersionLS), (unsigned)LOWORD(fi->dwFileVersionLS));
    }
    free(buf);
}

int main(void)
{
    char path[MAX_PATH]; path[0] = 0;
    HMODULE h = LoadLibraryA("comctl32.dll");
    if (h) GetModuleFileNameA(h, path, MAX_PATH);
    printf("LoadLibraryA(comctl32) = %p\n", (void*)h);
    printf("comctl32 path         = %s\n", path);
    if (path[0]) show_version(path);

    SetLastError(0);
    void* a = (void*)ImageList_Create(16, 16, 0x20 | 0x01, 4, 4);   /* ILC_COLOR32|ILC_MASK */
    printf("before init: COLOR32|MASK = %p  err=%lu\n", (void*)a, (unsigned long)GetLastError());

    INITCOMMONCONTROLSEX icc; icc.dwSize = sizeof(icc); icc.dwICC = 0xFFFF;
    SetLastError(0);
    int ini = InitCommonControlsEx(&icc);
    printf("InitCommonControlsEx -> %d  err=%lu\n", ini, (unsigned long)GetLastError());

    SetLastError(0);
    printf("after init : COLOR32|MASK = %p\n", (void*)ImageList_Create(16, 16, 0x20 | 0x01, 4, 4));
    printf("             COLOR24|MASK = %p\n", (void*)ImageList_Create(16, 16, 0x18 | 0x01, 4, 4));
    printf("             COLOR8|MASK  = %p\n", (void*)ImageList_Create(16, 16, 0x08 | 0x01, 4, 4));
    printf("             COLOR|MASK   = %p\n", (void*)ImageList_Create(16, 16, 0x00 | 0x01, 4, 4));
    printf("             flags=0      = %p\n", (void*)ImageList_Create(16, 16, 0, 4, 4));
    printf("last error = %lu\n", (unsigned long)GetLastError());
    return 0;
}
