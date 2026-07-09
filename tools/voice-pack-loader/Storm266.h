#pragma once

#include <windows.h>

typedef BOOL(WINAPI* SFileOpenArchiveFn)(
    LPCSTR lpFileName,
    DWORD dwPriority,
    DWORD dwFlags,
    HANDLE* lphArchive
);

typedef BOOL(WINAPI* SFileCloseArchiveFn)(HANDLE hArchive);

static const DWORD kStormOrdinalSFileOpenArchive = 266;
