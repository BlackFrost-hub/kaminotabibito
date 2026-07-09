#include <windows.h>
#include "Storm266.h"

static HANDLE g_archive = NULL;

static FARPROC GetStormProc(HMODULE storm, LPCSTR name, WORD ordinal) {
    FARPROC proc = GetProcAddress(storm, MAKEINTRESOURCEA(ordinal));
    if (proc != NULL) {
        return proc;
    }
    return GetProcAddress(storm, name);
}

static void OpenSelfArchive(HINSTANCE instance) {
    if (g_archive != NULL) {
        return;
    }

    if (GetModuleHandleA("Game.dll") == NULL) {
        return;
    }

    char selfPath[MAX_PATH] = {0};
    if (GetModuleFileNameA(instance, selfPath, MAX_PATH) == 0) {
        return;
    }

    HMODULE storm = GetModuleHandleA("Storm.dll");
    if (storm == NULL) {
        storm = LoadLibraryA("Storm.dll");
    }
    if (storm == NULL) {
        return;
    }

    SFileOpenArchiveFn SFileOpenArchive =
        (SFileOpenArchiveFn)GetStormProc(storm, "SFileOpenArchive", kStormOrdinalSFileOpenArchive);
    if (SFileOpenArchive == NULL) {
        return;
    }

    // 0x0A: ordinary optional external resource priority.
    // Use 0x11 only when the pack intentionally overrides in-map files.
    SFileOpenArchive(selfPath, 0x0A, 0, &g_archive);
}

static void CloseSelfArchive() {
    if (g_archive == NULL) {
        return;
    }

    HMODULE storm = GetModuleHandleA("Storm.dll");
    if (storm != NULL) {
        SFileCloseArchiveFn SFileCloseArchive =
            (SFileCloseArchiveFn)GetProcAddress(storm, "SFileCloseArchive");
        if (SFileCloseArchive != NULL) {
            SFileCloseArchive(g_archive);
        }
    }
    g_archive = NULL;
}

BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, LPVOID reserved) {
    (void)reserved;

    switch (reason) {
    case DLL_PROCESS_ATTACH:
        DisableThreadLibraryCalls(instance);
        OpenSelfArchive(instance);
        break;
    case DLL_PROCESS_DETACH:
        CloseSelfArchive();
        break;
    default:
        break;
    }

    return TRUE;
}
