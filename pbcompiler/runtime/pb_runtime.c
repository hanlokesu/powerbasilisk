/*
 * pb_runtime.c — PowerBASIC runtime support for pbcompiler
 *
 * Implements FORMAT$, PARSE$, REPLACE, and other PB-specific functions
 * that don't have direct C library equivalents.
 *
 * Build: clang -c pb_runtime.c -o pb_runtime.obj
 * Link:  clang program.ll pb_runtime.obj -o program.exe
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include <time.h>  /* clock for pb_tix fallback */
#include <io.h>  /* _locking / _fileno for LOCK/UNLOCK */
#include <conio.h>  /* _getch for WAITKEY$ */
#include <direct.h>  /* _chdrive for CHDRIVE */
#include <sys/locking.h>  /* _LK_LOCK / _LK_UNLCK */

#ifdef _WIN32
/* Declare only what we need from oleaut32 — avoids pulling in all of windows.h */
__declspec(dllimport) char* __stdcall SysAllocStringByteLen(const char* psz, unsigned int len);
__declspec(dllimport) void __stdcall SysFreeString(char* bstrString);
/* Win32 API for crash handling */
__declspec(dllimport) void* __stdcall AddVectoredExceptionHandler(unsigned long First, void* Handler);
__declspec(dllimport) void __stdcall ExitProcess(unsigned int uExitCode);
__declspec(dllimport) int __stdcall MessageBoxA(void* hWnd, const char* lpText, const char* lpCaption, unsigned int uType);
__declspec(dllimport) int __stdcall CopyFileA(const char* lpExistingFileName, const char* lpNewFileName, int bFailIfExists);
__declspec(dllimport) unsigned long __stdcall GetLastError(void);
__declspec(dllimport) int __stdcall SetFileAttributesA(const char* lpFileName, unsigned long dwFileAttributes);
__declspec(dllimport) void* __stdcall GetCurrentProcess(void);
__declspec(dllimport) unsigned long __stdcall GetPriorityClass(void* hProcess);
/* UTF-16 conversion for GET$$/PUT$$ (kernel32) */
__declspec(dllimport) int __stdcall MultiByteToWideChar(unsigned int CodePage, unsigned long dwFlags, const char* lpMultiByteStr, int cbMultiByte, short* lpWideCharStr, int cchWideChar);
__declspec(dllimport) int __stdcall WideCharToMultiByte(unsigned int CodePage, unsigned long dwFlags, const short* lpWideCharStr, int cchWideChar, char* lpMultiByteStr, int cbMultiByte, const char* lpDefaultChar, int* lpUsedDefaultChar);
#define PB_CP_ACP 0
__declspec(dllimport) int __stdcall SetPriorityClass(void* hProcess, unsigned long dwPriorityClass);
/* Win32 clipboard (user32) */
__declspec(dllimport) int __stdcall SystemParametersInfoA(unsigned int uiAction, unsigned int uiParam, void* pvParam, unsigned int fWinIni);
__declspec(dllimport) void* __stdcall GetDC(void* hWnd);
__declspec(dllimport) int __stdcall GetDeviceCaps(void* hdc, int nIndex);
__declspec(dllimport) int __stdcall ReleaseDC(void* hWnd, void* hDC);
__declspec(dllimport) void* __stdcall GlobalFree(void* hMem);
__declspec(dllimport) unsigned long long __stdcall GlobalSize(void* hMem);
__declspec(dllimport) void* __stdcall LoadCursorA(void* hInstance, const char* lpCursorName);
__declspec(dllimport) void* __stdcall SetCursor(void* hCursor);
__declspec(dllimport) int __stdcall ShowCursor(int bShow);
__declspec(dllimport) int __stdcall OpenClipboard(void* hWndNewOwner);
__declspec(dllimport) int __stdcall CloseClipboard(void);
__declspec(dllimport) int __stdcall EmptyClipboard(void);
__declspec(dllimport) void* __stdcall SetClipboardData(unsigned int uFormat, void* hMem);
__declspec(dllimport) void* __stdcall GetClipboardData(unsigned int uFormat);
__declspec(dllimport) void* __stdcall GlobalAlloc(unsigned int uFlags, unsigned long dwBytes);
__declspec(dllimport) void* __stdcall GlobalLock(void* hMem);
__declspec(dllimport) int __stdcall GlobalUnlock(void* hMem);
/* WinSock2 (HOST ADDR / HOST NAME) */
typedef struct _pb_hostent {
    char* h_name;
    char** h_aliases;
    int h_addrtype;
    int h_length;
    char** h_addr_list;
} pb_hostent;
typedef struct _pb_in_addr { unsigned long s_addr; } pb_in_addr;
__declspec(dllimport) pb_hostent* __stdcall gethostbyname(const char* name);
__declspec(dllimport) pb_hostent* __stdcall gethostbyaddr(const char* addr, int len, int type);
__declspec(dllimport) char* __stdcall inet_ntoa(pb_in_addr in);
__declspec(dllimport) int __stdcall gethostname(char* name, int namelen);
__declspec(dllimport) int __stdcall WSAStartup(unsigned short wVersionRequested, void* lpWSAData);
__declspec(dllimport) int __stdcall WSACleanup(void);
typedef unsigned long DWORD;
/* COMM serial + THREAD (batch 21) */
typedef void* HANDLE;
#define PB_INVALID_HANDLE ((void*)(long long)-1)
__declspec(dllimport) void* __stdcall CreateFileA(const char* lpFileName, unsigned long dwDesiredAccess, unsigned long dwShareMode, void* lpSecurityAttributes, unsigned long dwCreationDisposition, unsigned long dwFlagsAndAttributes, void* hTemplateFile);
__declspec(dllimport) int __stdcall GetCommState(void* hFile, void* lpDCB);
__declspec(dllimport) int __stdcall SetCommState(void* hFile, void* lpDCB);
__declspec(dllimport) int __stdcall SetCommTimeouts(void* hFile, void* lpCommTimeouts);
__declspec(dllimport) int __stdcall ReadFile(void* hFile, void* lpBuffer, unsigned long nNumberOfBytesToRead, unsigned long* lpNumberOfBytesRead, void* lpOverlapped);
__declspec(dllimport) int __stdcall WriteFile(void* hFile, const void* lpBuffer, unsigned long nNumberOfBytesToWrite, unsigned long* lpNumberOfBytesWritten, void* lpOverlapped);
__declspec(dllimport) int __stdcall CloseHandle(void* hObject);
__declspec(dllimport) int __stdcall FlushFileBuffers(void* hFile);
__declspec(dllimport) int __stdcall EscapeCommFunction(void* hFile, unsigned long dwFunc);
__declspec(dllimport) void* __stdcall CreateThread(void* lpThreadAttributes, unsigned long dwStackSize, void* lpStartAddress, void* lpParameter, unsigned long dwCreationFlags, unsigned long* lpThreadId);
__declspec(dllimport) unsigned long __stdcall SuspendThread(void* hThread);
__declspec(dllimport) unsigned long __stdcall ResumeThread(void* hThread);
__declspec(dllimport) int __stdcall TerminateThread(void* hThread, unsigned long dwExitCode);
__declspec(dllimport) int __stdcall GetExitCodeThread(void* hThread, unsigned long* lpExitCode);
__declspec(dllimport) int __stdcall GetThreadPriority(void* hThread);
__declspec(dllimport) int __stdcall SetThreadPriority(void* hThread, int nPriority);
#endif

/* ===== Debug/crash reporting ===== */
static const char* pb_debug_current_func = "unknown";
int pb_debug_line = 0; /* Current source line — updated by codegen */
static int pb_debug_enabled = 0;
static int pb_debug_verbose = 0; /* Set to 1 for verbose modal/function logging */
static FILE* pb_debug_log = NULL;

/* Circular buffer for recent call trace */
#define PB_TRACE_SIZE 50
static const char* pb_trace_buf[PB_TRACE_SIZE];
static int pb_trace_idx = 0;
static int pb_modal_count = 0;

/* Call this from codegen at the start of each function for debug mode */
void pb_debug_enter(const char* func_name) {
    pb_debug_current_func = func_name;
    pb_trace_buf[pb_trace_idx % PB_TRACE_SIZE] = func_name;
    pb_trace_idx++;
    if (pb_debug_log) {
        fprintf(pb_debug_log, "[ENTER] %s\n", func_name);
        fflush(pb_debug_log);
    }
}

void pb_debug_init(void) {
    pb_debug_enabled = 1;
    pb_debug_log = fopen("pb_debug.log", "w");
    if (pb_debug_log) {
        fprintf(pb_debug_log, "=== PowerBasilisk Debug Log ===\n");
        fflush(pb_debug_log);
    }
    /* Check environment variable for verbose debug mode */
    const char* verbose = getenv("PB_DEBUG_VERBOSE");
    if (verbose && (verbose[0] == '1' || verbose[0] == 'Y' || verbose[0] == 'y')) {
        pb_debug_verbose = 1;
        if (pb_debug_log) {
            fprintf(pb_debug_log, "[DEBUG] Verbose mode enabled via PB_DEBUG_VERBOSE\n");
            fflush(pb_debug_log);
        }
    }
}

/* ===== Modal/Dialog debug logging ===== */

/* Log modal dialog text for test debugging.
 * Called from PB code (ui_stubs or ui.inc) when debug mode is enabled.
 * Writes to pb_debug.log with modal type, title, and full text content.
 * When tests hang, this log shows the last modal that was displayed. */
void pb_debug_modal(const char* modal_type, const char* title, const char* text) {
    pb_modal_count++;
    if (pb_debug_log) {
        fprintf(pb_debug_log, "[MODAL #%d] type=%s title=\"%s\" text=\"%.500s\"\n",
                pb_modal_count,
                modal_type ? modal_type : "(null)",
                title ? title : "(no title)",
                text ? text : "(no text)");
        fflush(pb_debug_log);
    }
    /* Also write to stderr for immediate visibility in test output */
    fprintf(stderr, "[MODAL #%d] type=%s title=\"%s\"\n",
            pb_modal_count,
            modal_type ? modal_type : "(null)",
            title ? title : "(no title)");
}

/* Log a generic debug message from PB code */
void pb_debug_log_msg(const char* category, const char* message) {
    if (pb_debug_log) {
        fprintf(pb_debug_log, "[%s] in %s (line %d): %s\n",
                category ? category : "DEBUG",
                pb_debug_current_func, pb_debug_line,
                message ? message : "");
        fflush(pb_debug_log);
    }
}

#ifdef _WIN32
/* Vectored exception handler — catches crashes and reports the current function */
static long __stdcall pb_crash_handler(void* exception_pointers) {
    /* EXCEPTION_POINTERS* ep = (EXCEPTION_POINTERS*)exception_pointers; */
    /* Extract exception record */
    unsigned long* ep = (unsigned long*)exception_pointers;
    unsigned long* er = (unsigned long*)ep[0]; /* EXCEPTION_RECORD* */
    unsigned long code = er[0]; /* ExceptionCode */
    unsigned long addr = er[3]; /* ExceptionAddress — offset 12 bytes (3 DWORDs) */

    /* Only catch fatal exceptions — ignore informational/debug exceptions */
    /* High bit 0xC = fatal, 0x4 = informational */
    if ((code & 0xF0000000) != 0xC0000000) {
        return 0; /* EXCEPTION_CONTINUE_SEARCH — let system handle it */
    }

    char msg[1024];
    sprintf(msg,
        "CRASH in function: %s\n"
        "Source line: %d\n"
        "Exception code: 0x%08lX\n"
        "Exception address: 0x%08lX\n"
        "\nCheck pb_debug.log for call trace.",
        pb_debug_current_func, pb_debug_line, code, addr);

    /* Write call trace to debug log */
    {
        FILE* trace_f = fopen("pb_debug.log", "w");
        if (trace_f) {
            fprintf(trace_f, "=== Call Trace (last %d entries) ===\n", PB_TRACE_SIZE);
            int start = (pb_trace_idx > PB_TRACE_SIZE) ? pb_trace_idx - PB_TRACE_SIZE : 0;
            for (int i = start; i < pb_trace_idx; i++) {
                const char* fn = pb_trace_buf[i % PB_TRACE_SIZE];
                if (fn) fprintf(trace_f, "[%d] %s\n", i - start, fn);
            }
            fprintf(trace_f, "\n!!! CRASH !!!\n%s\n", msg);
            fclose(trace_f);
        }
    }

    /* Also write to stderr */
    fprintf(stderr, "\n!!! RUNTIME CRASH !!!\n%s\n", msg);
    /* Print last 10 call trace entries to stderr */
    {
        int start = (pb_trace_idx > 10) ? pb_trace_idx - 10 : 0;
        fprintf(stderr, "Call trace (last entries):\n");
        for (int i = start; i < pb_trace_idx; i++) {
            const char* fn = pb_trace_buf[i % PB_TRACE_SIZE];
            if (fn) fprintf(stderr, "  [%d] %s\n", i - start, fn);
        }
    }
    fflush(stderr);

    /* Write crash info to a file that Electron/Claude can read */
    FILE* f = fopen("pb_crash.log", "w");
    if (f) {
        fprintf(f, "%s\n", msg);
        fclose(f);
    }

    ExitProcess(99);
    return 0; /* EXCEPTION_CONTINUE_SEARCH */
}
#endif

/* Called from main() wrapper before PBMAIN */
void pb_install_crash_handler(void) {
#ifdef _WIN32
    AddVectoredExceptionHandler(1, pb_crash_handler);
    pb_debug_init();
#endif
}

/* Public BSTR allocation wrapper — called from LLVM IR codegen (cdecl) */
char* pb_bstr_alloc(const char* src, unsigned int len) {
#ifdef _WIN32
    return SysAllocStringByteLen(src, len);
#else
    char* buf = (char*)malloc(len + 1);
    if (src) memcpy(buf, src, len);
    buf[len] = '\0';
    return buf;
#endif
}


/* MKx family: numeric -> binary ANSI string (pb_mkbyt already exists) */
char* pb_mkint(int v) {
    short s = (short)v;
    return pb_bstr_alloc((const char*)&s, 2);      /* MKI$, MKWRD$ */
}
char* pb_mklong(int v) {
    long l = (long)v;
    return pb_bstr_alloc((const char*)&l, 4);      /* MKL$, MKDWD$ */
}
char* pb_mkquad(long long v) {
    return pb_bstr_alloc((const char*)&v, 8);      /* MKQ$, MKCUR$, MKCUX$ */
}
char* pb_mksingle(float v) {
    return pb_bstr_alloc((const char*)&v, 4);      /* MKS$ */
}
char* pb_mkdouble(double v) {
    return pb_bstr_alloc((const char*)&v, 8);      /* MKD$ */
}

/* DESKTOP GET CLIENT / LOC / PPI (work area = screen minus taskbar) */
typedef struct { long left, top, right, bottom; } PB_RECT;
#define PB_SPI_GETWORKAREA 0x0030
void pb_desktop_get_client(long* w, long* h) {
    PB_RECT rc = {0, 0, 0, 0};
    SystemParametersInfoA(PB_SPI_GETWORKAREA, 0, &rc, 0);
    *w = rc.right - rc.left;
    *h = rc.bottom - rc.top;
}
void pb_desktop_get_loc(long* x, long* y) {
    PB_RECT rc = {0, 0, 0, 0};
    SystemParametersInfoA(PB_SPI_GETWORKAREA, 0, &rc, 0);
    *x = rc.left;
    *y = rc.top;
}
void pb_desktop_get_ppi(long* x, long* y) {
    void* dc = GetDC(NULL);
    *x = GetDeviceCaps(dc, 88);   /* LOGPIXELSX */
    *y = GetDeviceCaps(dc, 90);   /* LOGPIXELSY */
    ReleaseDC(NULL, dc);
}

/* LEN() — BSTR byte length (unlike strlen, handles embedded NUL bytes) */
int pb_str_len(const char* s) {
    if (!s) return 0;
    const unsigned int* p = (const unsigned int*)s - 1;  /* BSTR length prefix */
    return (int)*p;
}

/* GLOBALMEM: allocate moveable global memory, return 1-based slot id so the
 * handle fits a PB LONG/DWORD on 64-bit. Slot table avoids truncation. */
#define GMEM_MOVEABLE 0x0002u
#define GMEM_ZEROINIT 0x0040u
static void* gm_table[256];
static int gm_alloc_slot(void) {
    for (int i = 1; i < 256; i++) {
        if (!gm_table[i]) return i;
    }
    return 0;
}
long pb_globalmem_alloc(long count) {
    void* h = GlobalAlloc(GMEM_MOVEABLE | GMEM_ZEROINIT, (unsigned long long)count);
    if (!h) return 0;
    int slot = gm_alloc_slot();
    if (!slot) { GlobalFree(h); return 0; }
    gm_table[slot] = h;
    return slot;
}
long pb_globalmem_free(long slot) {
    if (slot <= 0 || slot >= 256) return slot;
    void* h = gm_table[slot];
    if (!h) return slot;
    void* r = GlobalFree(h);
    gm_table[slot] = NULL;
    return r ? slot : 0; /* success -> 0, failure -> original handle value */
}
void* pb_globalmem_lock(long slot) {
    if (slot <= 0 || slot >= 256) return NULL;
    return GlobalLock(gm_table[slot]);
}
long pb_globalmem_size(long slot) {
    if (slot <= 0 || slot >= 256) return 0;
    return (long)GlobalSize(gm_table[slot]);
}
long pb_globalmem_unlock(long slot) {
    if (slot <= 0 || slot >= 256) return 0;
    return GlobalUnlock(gm_table[slot]) ? 1 : 0; /* non-zero = still locked */
}

/* MOUSEPTR: style 0 = hide, 1..13 = stock cursors, other = fail closed */
long pb_mouseptr(long style) {
    unsigned short idc = 0;
    switch (style) {
        case 0: ShowCursor(0); return 1;
        case 1: case 4: idc = 32512; break; /* IDC_ARROW */
        case 2: idc = 32515; break;         /* IDC_CROSS */
        case 3: idc = 32513; break;         /* IDC_IBEAM */
        case 5: idc = 32648; break;         /* IDC_SIZEALL */
        case 6: idc = 32645; break;         /* IDC_SIZENESW */
        case 7: idc = 32647; break;         /* IDC_SIZENS */
        case 8: idc = 32644; break;         /* IDC_SIZENWSE */
        case 9: idc = 32646; break;         /* IDC_SIZEWE */
        case 10: idc = 32516; break;        /* IDC_UPARROW */
        case 11: idc = 32514; break;        /* IDC_WAIT */
        case 12: ShowCursor(0); return 1; /* no pointer */
        case 13: idc = 32651; break;        /* IDC_APPSTARTING */
        default: return 0;                  /* opaque cursor handle: fail closed */
    }
    void* h = LoadCursorA(NULL, (const char*)(size_t)idc);
    if (!h) return 0;
    return SetCursor(h) ? 1 : 0;
}

/* UCODEPAGE: record codepage for future ANSI<->UNICODE conversions.
 * ANSI = CP_ACP(0), OEM = CP_OEMCP(1), numeric = explicit codepage. */
static long pb_ucodepage_cur = 0;
long pb_ucodepage(long cp) {
    long old = pb_ucodepage_cur;
    pb_ucodepage_cur = cp;
    return old;
}

/* Public BSTR free wrapper — called from LLVM IR codegen (cdecl) */
void pb_bstr_free(char* bstr) {
#ifdef _WIN32
    SysFreeString(bstr);
#else
    free(bstr);
#endif
}

/* Helper: allocate a BSTR from a C string buffer, then free the buffer */
static char* bstr_from_buf(char* buf) {
    int len = (int)strlen(buf);
    char* bstr = pb_bstr_alloc(buf, len);
    free(buf);
    return bstr;
}

/* ============================================================
 * FORMAT$ — Simplified PB number formatting
 *
 * PB FORMAT$ uses picture strings like "#,###.##", "0.00", etc.
 * This implementation covers the most common patterns:
 *   - "#" = digit or space
 *   - "0" = digit or zero
 *   - "." = decimal point
 *   - "," = thousands separator (if before ".")
 *   - "$" = dollar sign
 *   - "%" = percent (multiply by 100)
 *   - Any other characters are passed through literally
 * ============================================================ */
char* pb_format(double val, const char* fmt) {
    char buf[256];

    if (fmt == NULL || fmt[0] == '\0') {
        /* No format string — use default */
        snprintf(buf, sizeof(buf), "%g", val);
        char* result = (char*)malloc(strlen(buf) + 1);
        strcpy(result, buf);
        return bstr_from_buf(result);
    }

    /* Count decimal places from format string */
    int decimals = -1;
    int has_comma = 0;
    int has_dollar = 0;
    int has_percent = 0;
    const char* dot_pos = strchr(fmt, '.');

    if (dot_pos) {
        decimals = 0;
        for (const char* p = dot_pos + 1; *p == '#' || *p == '0'; p++) {
            decimals++;
        }
    }

    for (const char* p = fmt; *p; p++) {
        if (*p == ',') has_comma = 1;
        if (*p == '$') has_dollar = 1;
        if (*p == '%') has_percent = 1;
    }

    if (has_percent) val *= 100.0;

    /* Format the number */
    if (decimals >= 0) {
        snprintf(buf, sizeof(buf), "%.*f", decimals, val);
    } else {
        snprintf(buf, sizeof(buf), "%.0f", val);
    }

    if (has_comma) {
        /* Insert thousands separators */
        char formatted[256];
        char* src = buf;
        char* dst = formatted;
        int is_neg = 0;

        if (*src == '-') {
            *dst++ = *src++;
            is_neg = 1;
        }

        /* Find decimal point in formatted number */
        char* num_dot = strchr(src, '.');
        int int_len = num_dot ? (int)(num_dot - src) : (int)strlen(src);

        /* Copy integer part with commas */
        for (int i = 0; i < int_len; i++) {
            int remaining = int_len - i;
            if (i > 0 && remaining % 3 == 0) {
                *dst++ = ',';
            }
            *dst++ = src[i];
        }

        /* Copy decimal part */
        if (num_dot) {
            strcpy(dst, num_dot);
        } else {
            *dst = '\0';
        }

        strcpy(buf, formatted);
    }

    /* Build final result */
    int prefix_len = has_dollar ? 1 : 0;
    int suffix_len = has_percent ? 1 : 0;
    int buf_len = (int)strlen(buf);
    char* result = (char*)malloc(prefix_len + buf_len + suffix_len + 1);
    char* out = result;

    if (has_dollar) *out++ = '$';
    memcpy(out, buf, buf_len);
    out += buf_len;
    if (has_percent) *out++ = '%';
    *out = '\0';

    return bstr_from_buf(result);
}

/* ============================================================
 * PARSE$ — Split string by delimiter, extract Nth field (1-based)
 *
 * PARSE$(string, delimiter, index)  — returns the index'th field
 * PARSE$(string, delimiter)          — returns field count
 *
 * When index <= 0, returns the count of fields as a string-encoded integer.
 * When called with 3 args from PB: index is the field number (1-based).
 * ============================================================ */
char* pb_parse(const char* str, const char* delim, int index) {
    if (str == NULL || delim == NULL) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return bstr_from_buf(empty);
    }

    int delim_len = (int)strlen(delim);
    if (delim_len == 0) {
        char* result = (char*)malloc(strlen(str) + 1);
        strcpy(result, str);
        return bstr_from_buf(result);
    }

    /* Count fields and find the index'th one */
    int field_num = 0;
    const char* p = str;
    const char* field_start = str;

    while (1) {
        /* Check for delimiter match (single-char: match any char in delim) */
        int found_delim = 0;
        if (delim_len == 1) {
            if (*p == delim[0]) found_delim = 1;
        } else {
            /* Multi-char delimiter: match exact substring */
            if (strncmp(p, delim, delim_len) == 0) found_delim = 1;
        }

        if (found_delim || *p == '\0') {
            field_num++;
            if (field_num == index) {
                /* Found the field we want */
                int len = (int)(p - field_start);
                char* result = (char*)malloc(len + 1);
                memcpy(result, field_start, len);
                result[len] = '\0';
                return bstr_from_buf(result);
            }
            if (*p == '\0') break;
            p += (delim_len == 1) ? 1 : delim_len;
            field_start = p;
        } else {
            p++;
        }
    }

    if (index <= 0) {
        /* Return field count */
        char buf[16];
        snprintf(buf, sizeof(buf), "%d", field_num);
        char* result = (char*)malloc(strlen(buf) + 1);
        strcpy(result, buf);
        return bstr_from_buf(result);
    }

    /* Field index out of range — return empty */
    char* empty = (char*)malloc(1);
    empty[0] = '\0';
    return bstr_from_buf(empty);
}

/* ============================================================
 * PARSECOUNT — Return number of fields in a delimited string
 * ============================================================ */
int pb_parsecount(const char* str, const char* delim) {
    if (str == NULL || delim == NULL || str[0] == '\0') return 0;

    int delim_len = (int)strlen(delim);
    if (delim_len == 0) return 1;

    int count = 1;
    const char* p = str;
    while (*p) {
        if (delim_len == 1) {
            if (*p == delim[0]) count++;
            p++;
        } else {
            if (strncmp(p, delim, delim_len) == 0) {
                count++;
                p += delim_len;
            } else {
                p++;
            }
        }
    }
    return count;
}

/* ============================================================
 * REPLACE — Replace all occurrences of old_str with new_str in target
 *
 * Modifies the target string pointer in-place (PB semantics).
 * ============================================================ */
void pb_replace(char** target, const char* old_str, const char* new_str) {
    if (target == NULL || *target == NULL || old_str == NULL || new_str == NULL) return;

    int old_len = (int)strlen(old_str);
    int new_len = (int)strlen(new_str);
    if (old_len == 0) return;

    /* Count occurrences */
    int count = 0;
    const char* p = *target;
    while ((p = strstr(p, old_str)) != NULL) {
        count++;
        p += old_len;
    }
    if (count == 0) return;

    /* Build result */
    int orig_len = (int)strlen(*target);
    int result_len = orig_len + count * (new_len - old_len);
    char* result = (char*)malloc(result_len + 1);
    char* dst = result;
    const char* src = *target;

    while (*src) {
        if (strncmp(src, old_str, old_len) == 0) {
            memcpy(dst, new_str, new_len);
            dst += new_len;
            src += old_len;
        } else {
            *dst++ = *src++;
        }
    }
    *dst = '\0';

    *target = bstr_from_buf(result);
}

/* ============================================================
 * USING$ — Format number using a PRINT USING-style format string
 *
 * For now, delegates to pb_format (which handles the common cases).
 * ============================================================ */
char* pb_using(const char* fmt, double val) {
    return pb_format(val, fmt);
}

/* ============================================================
 * REMOVE$ — Remove all occurrences of characters in chars from str
 * ============================================================ */
char* pb_remove(const char* str, const char* chars) {
    if (str == NULL) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return bstr_from_buf(empty);
    }
    if (chars == NULL || chars[0] == '\0') {
        char* result = (char*)malloc(strlen(str) + 1);
        strcpy(result, str);
        return bstr_from_buf(result);
    }

    int len = (int)strlen(str);
    char* result = (char*)malloc(len + 1);
    char* dst = result;

    for (const char* p = str; *p; p++) {
        if (strchr(chars, *p) == NULL) {
            *dst++ = *p;
        }
    }
    *dst = '\0';
    return bstr_from_buf(result);
}

/* ============================================================
 * File I/O Runtime Functions
 * ============================================================ */

#define MAX_FILE_HANDLES 256
static FILE* file_handles[MAX_FILE_HANDLES] = {0};
static int file_modes[MAX_FILE_HANDLES] = {0}; /* 0=INPUT 1=OUTPUT 2=APPEND 3=BINARY */

int pb_freefile(void) {
    for (int i = 1; i < MAX_FILE_HANDLES; i++) {
        if (file_handles[i] == NULL) return i;
    }
    return 0;
}

int pb_open(const char* path, int mode, int filenum) {
    if (filenum < 1 || filenum >= MAX_FILE_HANDLES) return -1;
    const char* fmode;
    switch (mode) {
        case 0: fmode = "r"; break;   /* INPUT */
        case 1: fmode = "w"; break;   /* OUTPUT */
        case 2: fmode = "a"; break;   /* APPEND */
        case 3:
            /* BINARY: open existing file read/write without truncating;
               create it if it does not exist (PB semantics). */
            file_handles[filenum] = fopen(path, "r+b");
            if (!file_handles[filenum]) {
                file_handles[filenum] = fopen(path, "w+b");
            }
            file_modes[filenum] = mode;
            return (file_handles[filenum] != NULL) ? 0 : -1;
        default: fmode = "r"; break;
    }
    file_handles[filenum] = fopen(path, fmode);
    if (file_handles[filenum]) file_modes[filenum] = mode;
    return (file_handles[filenum] != NULL) ? 0 : -1;
}

void pb_close(int filenum) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        fclose(file_handles[filenum]);
        file_handles[filenum] = NULL;
        file_modes[filenum] = 0;
    }
}

/* FILESCAN [#] fnum&, RECORDS TO y& [, WIDTH TO x&]
   INPUT mode: count CRLF/EOF-terminated records; WIDTH = longest record.
   BINARY mode: PB packed strings (2-byte length prefix, 0xFFFF marker + 4-byte
   length for strings > 65535 bytes); WIDTH = longest string length. */
void pb_filescan(int filenum, long long* records, long long* width) {
    FILE* f = (filenum >= 1 && filenum < MAX_FILE_HANDLES) ? file_handles[filenum] : NULL;
    if (!f) { *records = 0; *width = 0; return; }
    long pos = ftell(f);
    rewind(f);
    long long rec = 0, w = 0;
    if (file_modes[filenum] == 3) {
        /* BINARY: PB packed strings */
        for (;;) {
            unsigned char h[2];
            size_t n = fread(h, 1, 2, f);
            if (n < 2) break;
            unsigned int len = h[0] | (h[1] << 8);
            if (len == 0xFFFF) {
                unsigned char l4[4];
                if (fread(l4, 1, 4, f) < 4) break;
                len = l4[0] | (l4[1] << 8) | (l4[2] << 16) | ((unsigned int)l4[3] << 24);
            }
            if (fseek(f, (long)len, SEEK_CUR) != 0) break;
            rec++;
            if ((long long)len > w) w = len;
        }
    } else {
        /* INPUT: CRLF-delimited records */
        int ch;
        long long cur = 0;
        int in_rec = 0;
        while ((ch = fgetc(f)) != EOF) {
            if (ch == '\r' || ch == '\n') {
                if (in_rec) { rec++; if (cur > w) w = cur; cur = 0; in_rec = 0; }
            } else {
                in_rec = 1;
                cur++;
            }
        }
        if (in_rec) { rec++; if (cur > w) w = cur; }
    }
    fseek(f, pos, SEEK_SET);
    *records = rec;
    *width = w;
}

void pb_print_file(int filenum, const char* text) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        fputs(text, file_handles[filenum]);
    }
}

void pb_print_file_newline(int filenum) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        fputc('\n', file_handles[filenum]);
    }
}

char* pb_line_input(int filenum) {
    if (filenum < 1 || filenum >= MAX_FILE_HANDLES || !file_handles[filenum]) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return bstr_from_buf(empty);
    }
    char buf[4096];
    if (fgets(buf, sizeof(buf), file_handles[filenum]) == NULL) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return bstr_from_buf(empty);
    }
    /* Strip trailing newline */
    int len = (int)strlen(buf);
    if (len > 0 && buf[len-1] == '\n') {
        buf[len-1] = '\0';
        len--;
    }
    if (len > 0 && buf[len-1] == '\r') {
        buf[len-1] = '\0';
        len--;
    }
    char* result = (char*)malloc(len + 1);
    memcpy(result, buf, len);
    result[len] = '\0';
    return bstr_from_buf(result);
}

int pb_eof(int filenum) {
    if (filenum < 1 || filenum >= MAX_FILE_HANDLES || !file_handles[filenum]) return -1;
    /* PB EOF() returns true when no more data to read — need to peek ahead */
    int ch = fgetc(file_handles[filenum]);
    if (ch == EOF) return -1;  /* PB: -1 = true (EOF) */
    ungetc(ch, file_handles[filenum]);
    return 0;  /* PB: 0 = false (not EOF) */
}

void pb_input_file_str(int filenum, char** dest) {
    if (filenum < 1 || filenum >= MAX_FILE_HANDLES || !file_handles[filenum]) return;
    char buf[4096];
    int i = 0;
    int ch;
    while ((ch = fgetc(file_handles[filenum])) != EOF) {
        if (ch == ',' || ch == '\n') break;
        if (ch == '\r') continue;
        if (i < (int)sizeof(buf) - 1) buf[i++] = (char)ch;
    }
    buf[i] = '\0';
    /* Strip surrounding double quotes written by WRITE# (CSV quoting) */
    if (i >= 2 && buf[0] == '"' && buf[i - 1] == '"') {
        char* unquoted = (char*)malloc(i - 1);
        memcpy(unquoted, buf + 1, i - 2);
        unquoted[i - 2] = '\0';
        *dest = bstr_from_buf(unquoted);
        return;
    }
    char* result = (char*)malloc(i + 1);
    memcpy(result, buf, i + 1);
    *dest = bstr_from_buf(result);
}

void pb_input_file_int(int filenum, int* dest) {
    if (filenum < 1 || filenum >= MAX_FILE_HANDLES || !file_handles[filenum]) return;
    char buf[64];
    int i = 0;
    int ch;
    while ((ch = fgetc(file_handles[filenum])) != EOF) {
        if (ch == ',' || ch == '\n') break;
        if (ch == '\r') continue;
        if (i < (int)sizeof(buf) - 1) buf[i++] = (char)ch;
    }
    buf[i] = '\0';
    *dest = atoi(buf);
}

void pb_input_file_dbl(int filenum, double* dest) {
    if (filenum < 1 || filenum >= MAX_FILE_HANDLES || !file_handles[filenum]) return;
    char buf[64];
    int i = 0;
    int ch;
    while ((ch = fgetc(file_handles[filenum])) != EOF) {
        if (ch == ',' || ch == '\n') break;
        if (ch == '\r') continue;
        if (i < (int)sizeof(buf) - 1) buf[i++] = (char)ch;
    }
    buf[i] = '\0';
    *dest = atof(buf);
}

void pb_kill(const char* path) {
    if (path) remove(path);
}

/* pb_err is defined later in this file (global ERR variable) */
extern int pb_err;

/* CLS: clear the console screen (PB/CC) */
void pb_cls(void) {
    system("cls");
}

/* ENVIRON "VAR=value" (statement form): set / remove an environment variable.
   With '=' → set. Without '=' → remove the variable. */
void pb_environ_set(const char* s) {
    if (!s) return;
    if (strchr(s, '=')) {
        _putenv(s);
    } else {
        size_t n = strlen(s);
        char* buf = (char*)malloc(n + 2);
        if (!buf) return;
        memcpy(buf, s, n);
        buf[n] = '=';
        buf[n + 1] = '\0';
        _putenv(buf);
        free(buf);
    }
}

/* FILECOPY src$, dst$ — copy a file. Sets ERR on failure (PB semantics). */
int pb_filecopy(const char* src, const char* dst) {
    if (!src || !dst) { pb_err = 76; return -1; }
    if (!CopyFileA(src, dst, 0)) {
        unsigned long e = GetLastError();
        if (e == 2)       pb_err = 53;  /* ERROR_FILE_NOT_FOUND */
        else if (e == 5)  pb_err = 70;  /* ERROR_ACCESS_DENIED */
        else              pb_err = 76;  /* path / other */
        return -1;
    }
    pb_err = 0;
    return 0;
}

/* SETATTR "path", attr& — set file attributes. Sets ERR on failure. */
void pb_setattr(const char* path, int attr) {
    if (!path) { pb_err = 76; return; }
    if (!SetFileAttributesA(path, (unsigned long)attr)) {
        unsigned long e = GetLastError();
        pb_err = (e == 2) ? 53 : 76;
    } else {
        pb_err = 0;
    }
}

/* ===== ERR system variable (PB-compatible error code) ===== */
int pb_err = 0;   /* readable from PB source as ERR; set by failing MKDIR/RMDIR/CHDIR/KILL */

/* ===== ON ERROR GOTO runtime state ===== */
int pb_err_stmt_id = 0;  /* id of the statement that triggered the error */
int pb_err_active = 0;   /* 1 while executing the ON ERROR handler (trapping suspended) */

/* ===== System builtins ===== */

#ifdef _WIN32
__declspec(dllimport) unsigned long __stdcall GetEnvironmentVariableA(const char* lpName, char* lpBuffer, unsigned long nSize);
__declspec(dllimport) unsigned long __stdcall GetModuleFileNameA(void* hModule, char* lpFilename, unsigned long nSize);
#endif

/* ENVIRON$("VARNAME") — returns environment variable value */
char* pb_environ(const char* var_name) {
    if (!var_name || !var_name[0]) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return bstr_from_buf(empty);
    }
#ifdef _WIN32
    char buf[4096];
    unsigned long len = GetEnvironmentVariableA(var_name, buf, sizeof(buf));
    if (len == 0 || len >= sizeof(buf)) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return bstr_from_buf(empty);
    }
    char* result = (char*)malloc(len + 1);
    memcpy(result, buf, len);
    result[len] = '\0';
    return bstr_from_buf(result);
#else
    const char* val = getenv(var_name);
    if (!val) val = "";
    int len = (int)strlen(val);
    char* result = (char*)malloc(len + 1);
    memcpy(result, val, len);
    result[len] = '\0';
    return bstr_from_buf(result);
#endif
}

/* EXE.PATH$ — returns directory of current executable */
char* pb_exe_path(void) {
#ifdef _WIN32
    char buf[4096];
    unsigned long len = GetModuleFileNameA(0, buf, sizeof(buf));
    if (len == 0) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return bstr_from_buf(empty);
    }
    /* Strip filename, keep directory with trailing backslash */
    int i = (int)len - 1;
    while (i >= 0 && buf[i] != '\\' && buf[i] != '/') i--;
    if (i >= 0) buf[i + 1] = '\0';
    int plen = (int)strlen(buf);
    char* result = (char*)malloc(plen + 1);
    memcpy(result, buf, plen);
    result[plen] = '\0';
    return bstr_from_buf(result);
#else
    char* empty = (char*)malloc(1);
    empty[0] = '\0';
    return bstr_from_buf(empty);
#endif
}

/* EXE.NAME$ — returns filename of current executable */
char* pb_exe_name(void) {
#ifdef _WIN32
    char buf[4096];
    unsigned long len = GetModuleFileNameA(0, buf, sizeof(buf));
    if (len == 0) {
        char* empty = (char*)malloc(1);
        empty[0] = '\0';
        return bstr_from_buf(empty);
    }
    /* Find last path separator */
    int i = (int)len - 1;
    while (i >= 0 && buf[i] != '\\' && buf[i] != '/') i--;
    const char* name = buf + i + 1;
    int nlen = (int)strlen(name);
    char* result = (char*)malloc(nlen + 1);
    memcpy(result, name, nlen);
    result[nlen] = '\0';
    return bstr_from_buf(result);
#else
    char* empty = (char*)malloc(1);
    empty[0] = '\0';
    return bstr_from_buf(empty);
#endif
}

/* ===== Null-safe string concatenation ===== */

/* pb_str_concat — concatenates two strings, treating null as empty */
char* pb_str_concat(const char* a, const char* b) {
    static const char empty[] = "";
    if (!a) a = empty;
    if (!b) b = empty;
    int len_a = (int)strlen(a);
    int len_b = (int)strlen(b);
    int total = len_a + len_b;
    char* tmp = (char*)malloc(total + 1);
    memcpy(tmp, a, len_a);
    memcpy(tmp + len_a, b, len_b);
    tmp[total] = '\0';
    char* result = pb_bstr_alloc(tmp, total);
    free(tmp);
    return result;
}

/* ===== DATE$ and TIME$ builtins ===== */

#ifdef _WIN32
typedef struct {
    unsigned short wYear;
    unsigned short wMonth;
    unsigned short wDay;
    unsigned short wDayOfWeek;
    unsigned short wHour;
    unsigned short wMinute;
    unsigned short wSecond;
    unsigned short wMilliseconds;
} PB_SYSTEMTIME;

__declspec(dllimport) void __stdcall GetLocalTime(PB_SYSTEMTIME* lpSystemTime);
#endif

/* DATE$ — returns "MM-DD-YYYY" */
char* pb_date(void) {
    char buf[12];
#ifdef _WIN32
    PB_SYSTEMTIME st;
    GetLocalTime(&st);
    sprintf(buf, "%02d-%02d-%04d", st.wMonth, st.wDay, st.wYear);
#else
    strcpy(buf, "01-01-2026");
#endif
    return pb_bstr_alloc(buf, (int)strlen(buf));
}

/* TIME$ — returns "HH:MM:SS" */
char* pb_time(void) {
    char buf[10];
#ifdef _WIN32
    PB_SYSTEMTIME st;
    GetLocalTime(&st);
    sprintf(buf, "%02d:%02d:%02d", st.wHour, st.wMinute, st.wSecond);
#else
    strcpy(buf, "00:00:00");
#endif
    return pb_bstr_alloc(buf, (int)strlen(buf));
}

/* WAITKEY$ — waits for one key press (console), returns the key as a 1-char string.
   Interactive console: _getch (immediate, no Enter needed).
   Redirected stdin (pipes / CI): getchar so automated tests can feed a key. */
char* pb_waitkey(void) {
    int c;
    if (_isatty(_fileno(stdin))) {
        c = _getch();
        if (c == 0 || c == 0xE0) {
            /* extended key: read the scan code and return an empty string */
            _getch();
            return pb_bstr_alloc("", 0);
        }
    } else {
        c = getchar();
        if (c == EOF) c = ' ';
    }
    char buf[2];
    buf[0] = (char)c;
    buf[1] = '\0';
    return pb_bstr_alloc(buf, 1);
}

/* ===== TIX / MKBYT$ / ISINFINITE / ISNORMAL / CHDRIVE / SETEOF / PLAY WAVE ===== */

#ifdef _WIN32
typedef union {
    long long QuadPart;
    struct { unsigned long LowPart; long HighPart; } u;
} PB_LARGE_INTEGER;

__declspec(dllimport) int __stdcall QueryPerformanceCounter(PB_LARGE_INTEGER* lp);
__declspec(dllimport) int __stdcall SetEndOfFile(void* hFile);
__declspec(dllimport) int __stdcall PlaySoundA(const char* pszSound, void* hmod, unsigned long fdwSound);
#endif

#define PB_SND_FILENAME 0x00020000

/* TIX — high-resolution performance counter (QUAD) */
long long pb_tix(void) {
#ifdef _WIN32
    PB_LARGE_INTEGER c;
    if (QueryPerformanceCounter(&c)) return c.QuadPart;
#endif
    return (long long)clock();
}

/* MKBYT$ (n) — one byte as a single-character string */
char* pb_mkbyt(int n) {
    char buf[2];
    buf[0] = (char)(n & 0xFF);
    buf[1] = '\0';
    return pb_bstr_alloc(buf, 1);
}

/* ISINFINITE (x) / ISNORMAL (x) — IEEE-754 classification, PB -1/0 */
int pb_isinfinite(double v) { return isinf(v) ? -1 : 0; }
int pb_isnormal(double v) { return isnormal(v) ? -1 : 0; }

/* CHDRIVE drv$ — change current drive (PB semantics: drive letter only) */
int pb_chdrive(const char* drv) {
#ifdef _WIN32
    if (drv && drv[0] != '\0') {
        return _chdrive(toupper((unsigned char)drv[0]) - 'A' + 1);
    }
#endif
    return -1;
}

/* SETEOF #f — truncate file at current position */
int pb_seteof(int f) {
    if (f < 1 || f >= MAX_FILE_HANDLES || file_handles[f] == NULL) return -1;
#ifdef _WIN32
    int fd = _fileno(file_handles[f]);
    void* h = (void*)_get_osfhandle(fd);
    if (h == (void*)-1) return -1;
    return SetEndOfFile(h) ? 0 : -1;
#else
    long cur = ftell(file_handles[f]);
    return ftruncate(fileno(file_handles[f]), cur) == 0 ? 0 : -1;
#endif
}

/* PLAY WAVE "file.wav" — play a .wav synchronously */
int pb_play_wave(const char* path) {
#ifdef _WIN32
    return PlaySoundA(path, NULL, PB_SND_FILENAME) ? 0 : -1;
#else
    return -1;
#endif
}

/* ===== Batch 2: ARRAY REVERSE / PUT$ / SHIFT / ROTATE ===== */

/* ARRAY REVERSE — reverse elements in place */
void pb_array_reverse(void* base, int elem_size, int total) {
    if (!base || total <= 1) return;
    char* p = (char*)base;
    for (int i = 0; i < total / 2; i++) {
        char* a = p + (size_t)i * elem_size;
        char* b = p + (size_t)(total - 1 - i) * elem_size;
        for (int j = 0; j < elem_size; j++) {
            char t = a[j];
            a[j] = b[j];
            b[j] = t;
        }
    }
}

/* PUT$ #f, str$ — write ANSI string at current file position */
int pb_put_string(int f, const char* s) {
    if (f < 1 || f >= MAX_FILE_HANDLES || file_handles[f] == NULL) return -1;
    if (!s) return -1;
    size_t n = strlen(s);
    if (n == 0) return 0;
    return fwrite(s, 1, n, file_handles[f]) == n ? 0 : -1;
}

/* GET$ #f, count, dest$: read count bytes from a binary file into a BSTR */
int pb_get_string(int f, long long count, char** dest) {
    if (f < 1 || f >= MAX_FILE_HANDLES || file_handles[f] == NULL) return -1;
    if (count < 0 || count > 0x7FFFFFFFLL) return -1;
    char* buf = (char*)malloc((size_t)count + 1);
    if (!buf) return -1;
    size_t got = fread(buf, 1, (size_t)count, file_handles[f]);
    *dest = pb_bstr_alloc(buf, (unsigned int)got);
    free(buf);
    /* NB: do NOT SysFreeString the previous *dest — the variable is often
       initialized to a codegen string constant (not a BSTR), and freeing it
       crashes. Old BSTRs leak instead; acceptable for a compiler runtime. */
    return (got == (size_t)count) ? 0 : -1;
}

/* PUT$$ #f, StrgExpr: write a WIDE (UTF-16LE) string at the file position */
int pb_put_wstring(int f, const char* s) {
    if (f < 1 || f >= MAX_FILE_HANDLES || file_handles[f] == NULL) return -1;
    if (!s) return -1;
    size_t n = strlen(s);
    if (n == 0) return 0;
    int wlen = MultiByteToWideChar(PB_CP_ACP, 0, s, (int)n, NULL, 0);
    if (wlen <= 0) return -1;
    short* wbuf = (short*)malloc((size_t)wlen * 2);
    if (!wbuf) return -1;
    MultiByteToWideChar(PB_CP_ACP, 0, s, (int)n, wbuf, wlen);
    size_t written = fwrite(wbuf, 2, (size_t)wlen, file_handles[f]);
    free(wbuf);
    return written == (size_t)wlen ? 0 : -1;
}

/* GET\$\$ #f, Count&, StrgVar: read Count WIDE chars (Count*2 bytes), convert to ANSI */
int pb_get_wstring(int f, long long count, char** dest) {
    if (f < 1 || f >= MAX_FILE_HANDLES || file_handles[f] == NULL) return -1;
    if (count < 0 || count > 0x3FFFFFFFLL) return -1;
    size_t bytes = (size_t)count * 2;
    char* buf = (char*)malloc(bytes + 2);
    if (!buf) return -1;
    size_t got = fread(buf, 1, bytes, file_handles[f]);
    size_t wchars = got / 2;
    int ansi_len = WideCharToMultiByte(PB_CP_ACP, 0, (const short*)buf, (int)wchars,
                                       NULL, 0, NULL, NULL);
    if (ansi_len < 0) ansi_len = 0;
    char* out = (char*)malloc((size_t)ansi_len + 1);
    if (!out) { free(buf); return -1; }
    if (ansi_len > 0) {
        WideCharToMultiByte(PB_CP_ACP, 0, (const short*)buf, (int)wchars,
                            out, ansi_len, NULL, NULL);
    }
    out[ansi_len] = '\\0';
    *dest = pb_bstr_alloc(out, (unsigned int)ansi_len);
    free(out);
    free(buf);
    /* same NB as pb_get_string: do not free the previous *dest */
    return (got == bytes) ? 0 : -1;
}

/* SHIFT LEFT — logical left shift on 64-bit */
long long pb_shift_left(long long v, int n) { return v << (n & 63); }

/* SHIFT RIGHT — keep_sign=1 is arithmetic (SIGNED), 0 is logical */
long long pb_shift_right(long long v, int n, int keep_sign) {
    int k = n & 63;
    if (keep_sign) return v >> k;
    return (long long)((unsigned long long)v >> k);
}

/* ROTATE LEFT/RIGHT — 64-bit circular shift */
long long pb_rotate_left(long long v, int n) {
    int k = n & 63;
    if (k == 0) return v;
    return (v << k) | ((unsigned long long)v >> (64 - k));
}
long long pb_rotate_right(long long v, int n) {
    int k = n & 63;
    if (k == 0) return v;
    return ((unsigned long long)v >> k) | (v << (64 - k));
}

/* ===== Batch 3: PLAY SOUND / SPLIT / ARRAY SHUFFLE ===== */

#ifdef _WIN32
__declspec(dllimport) int __stdcall Beep(unsigned long dwFreq, unsigned long dwDuration);
#endif

/* PLAY SOUND freq&, duration& — speaker beep via Beep() */
int pb_play_sound(long freq, long dur) {
#ifdef _WIN32
    return Beep((unsigned long)freq, (unsigned long)dur) ? 0 : -1;
#else
    return -1;
#endif
}

/* SPLIT MainStr, Part1Len TO Part1Var, Part2Var */
void pb_split(const char* src, int n, char** out1, char** out2) {
    if (!src) src = "";
    size_t len = strlen(src);
    if (n < 0) n = 0;
    if ((size_t)n > len) n = (int)len;
    *out1 = pb_bstr_alloc(src, n);
    *out2 = pb_bstr_alloc(src + n, (int)(len - n));
}

/* ARRAY SHUFFLE — Fisher-Yates shuffle in place */
void pb_array_shuffle(void* base, int elem_size, int total) {
    if (!base || total <= 1) return;
    char* p = (char*)base;
    for (int i = total - 1; i > 0; i--) {
        int j = rand() % (i + 1);
        if (j == i) continue;
        char* a = p + (size_t)i * elem_size;
        char* b = p + (size_t)j * elem_size;
        for (int k = 0; k < elem_size; k++) {
            char t = a[k];
            a[k] = b[k];
            b[k] = t;
        }
    }
}

/* ===== Batch 4: DATA / READ / RESTORE ===== */

#define MAX_DATA_ITEMS 16384
static const char* data_pool[MAX_DATA_ITEMS] = {0};
static int data_count = 0;
static int data_cursor = 0;

void pb_data_append(const char* s) {
    if (!s || data_count >= MAX_DATA_ITEMS) return;
    data_pool[data_count++] = s;
}

char* pb_read_data_str(void) {
    if (data_cursor >= data_count) return pb_bstr_alloc("", 0);
    const char* item = data_pool[data_cursor];
    data_cursor++;
    return pb_bstr_alloc(item, (int)strlen(item));
}

double pb_read_data_num(void) {
    if (data_cursor >= data_count) return 0.0;
    return atof(data_pool[data_cursor++]);
}

void pb_data_reset(void) {
    data_cursor = 0;
}

// PROCESS GET/SET PRIORITY - current process priority class
unsigned long pb_process_get_priority(void) {
    return GetPriorityClass(GetCurrentProcess());
}

int pb_process_set_priority(unsigned long pri) {
    return SetPriorityClass(GetCurrentProcess(), pri) ? 0 : -1;
}

/* ARRAY SCAN arr([idx]) [FOR count], OP expr, TO var& — first matching relative index, 0 = none.
   op: 0='=', 1='<>', 2='<', 3='>', 4='<=', 5='>=' */
long long pb_array_scan_num(char* base, int elem_size, long long total, long long index,
                            long long count, long long value, int op) {
    if (index < 1) index = 1;
    if (index > total) return 0;
    if (count <= 0) count = total - index + 1;
    if (index + count - 1 > total) count = total - index + 1;
    for (long long i = 0; i < count; i++) {
        long long v;
        if (elem_size == 1) {
            signed char t;
            memcpy(&t, base + (index - 1 + i) * 1, 1);
            v = t;
        } else if (elem_size == 2) {
            short t;
            memcpy(&t, base + (index - 1 + i) * 2, 2);
            v = t;
        } else if (elem_size == 4) {
            int t;
            memcpy(&t, base + (index - 1 + i) * 4, 4);
            v = t;
        } else {
            memcpy(&v, base + (index - 1 + i) * 8, 8);
        }
        int hit = 0;
        switch (op) {
            case 0: hit = (v == value); break;
            case 1: hit = (v != value); break;
            case 2: hit = (v < value); break;
            case 3: hit = (v > value); break;
            case 4: hit = (v <= value); break;
            default: hit = (v >= value); break;
        }
        if (hit) return index + i;
    }
    return 0;
}

long long pb_array_scan_str(char* base, long long total, long long index, long long count,
                            char* strval) {
    if (index < 1) index = 1;
    if (index > total) return 0;
    if (count <= 0) count = total - index + 1;
    if (index + count - 1 > total) count = total - index + 1;
    for (long long i = 0; i < count; i++) {
        char** sp = (char**)(base + (index - 1 + i) * 8);
        if (*sp && strval && strcmp(*sp, strval) == 0) return index + i;
        if (!*sp && !strval) return index + i;
    }
    return 0;
}

/* ARRAY INSERT arr(index), value — insert element, shift down (fixed array: last element lost) */
void pb_array_insert_num(char* base, int elem_size, long long total, long long index,
                         long long value) {
    if (index < 1) index = 1;
    if (index > total) return;
    memmove(base + index * elem_size, base + (index - 1) * elem_size,
            (size_t)((total - index) * elem_size));
    memcpy(base + (index - 1) * elem_size, &value, (size_t)elem_size);
}

void pb_array_insert_str(char* base, long long total, long long index, char* bstr) {
    if (index < 1) index = 1;
    if (index > total) return;
    memmove(base + index * 8, base + (index - 1) * 8, (size_t)((total - index) * 8));
    memcpy(base + (index - 1) * 8, &bstr, 8);
}

/* ARRAY DELETE arr(index) [FOR count] — remove element(s), shift up */
void pb_array_delete(char* base, int elem_size, long long total, long long index,
                     long long count, int is_string) {
    if (index < 1) index = 1;
    if (count <= 0) count = 1;
    if (index > total) return;
    if (index + count > total) count = total - index + 1;
    long long from = index - 1;
    memmove(base + from * elem_size, base + (from + count) * elem_size,
            (size_t)((total - from - count) * elem_size));
    if (is_string) {
        for (long long i = total - count; i < total; i++) {
            char** sp = (char**)(base + i * elem_size);
            if (*sp) {
                SysFreeString(*sp);
                *sp = NULL;
            }
        }
    } else {
        memset(base + (total - count) * elem_size, 0,
               (size_t)(count * elem_size));
    }
}

/* ARRAY ARRAYIX arr() — set each element to its element index (1-based).
   Numeric arrays: value = index (widened to element size).
   String arrays: element = decimal text of index (BSTR). */
void pb_array_arrayix(char* base, int elem_size, long long total, int type) {
    for (long long i = 1; i <= total; i++) {
        char* p = base + (i - 1) * elem_size;
        if (type == 0) {
            if (elem_size == 1) {
                signed char t = (signed char)i;
                memcpy(p, &t, 1);
            } else if (elem_size == 2) {
                short t = (short)i;
                memcpy(p, &t, 2);
            } else if (elem_size == 4) {
                int t = (int)i;
                memcpy(p, &t, 4);
            } else {
                long long t = i;
                memcpy(p, &t, 8);
            }
        } else {
            char buf[24];
            _i64toa_s(i, buf, 24, 10);
            char** sp = (char**)p;
            if (*sp) SysFreeString(*sp);
            *sp = (char*)SysAllocStringByteLen(buf, (unsigned int)strlen(buf));
        }
    }
}

/* CLIPBOARD SET TEXT / GET TEXT / RESET (Win32) */
#define CF_TEXT 1
#define GMEM_MOVEABLE 0x0042
int pb_clipboard_set_text(const char* text) {
    if (!OpenClipboard(0)) return -1;
    EmptyClipboard();
    unsigned long len = (unsigned long)strlen(text);
    void* h = GlobalAlloc(GMEM_MOVEABLE, len + 1);
    int ok = -1;
    if (h) {
        char* p = (char*)GlobalLock(h);
        if (p) {
            memcpy(p, text, len + 1);
            GlobalUnlock(h);
        }
        if (SetClipboardData(CF_TEXT, h)) ok = 0;
    }
    CloseClipboard();
    return ok;
}

char* pb_clipboard_get_text(void) {
    char* empty = pb_bstr_alloc("", 0);
    if (!OpenClipboard(0)) return empty;
    void* h = GetClipboardData(CF_TEXT);
    if (!h) { CloseClipboard(); return empty; }
    char* p = (char*)GlobalLock(h);
    if (!p) { CloseClipboard(); return empty; }
    unsigned long len = (unsigned long)strlen(p);
    char* r = pb_bstr_alloc(p, len);
    GlobalUnlock(h);
    CloseClipboard();
    return r;
}

int pb_clipboard_reset(void) {
    if (!OpenClipboard(0)) return -1;
    EmptyClipboard();
    CloseClipboard();
    return 0;
}

static int pb_winsock_inited = 0;
static int pb_winsock_init(void) {
    if (pb_winsock_inited) return 0;
    unsigned short ver = 0x0202; /* 2.2 */
    char data[408] = {0};
    if (WSAStartup(ver, data) != 0) return -1;
    pb_winsock_inited = 1;
    return 0;
}

void pb_host_addr(const char* host, unsigned long* out) {
    *out = 0;
    if (pb_winsock_init() != 0) return;
    char local[256] = {0};
    const char* name = host;
    if (!name || !name[0]) {
        if (gethostname(local, 255) == 0) {
            name = local;
        } else {
            return;
        }
    }
    pb_hostent* he = gethostbyname(name);
    if (!he || !he->h_addr_list || !he->h_addr_list[0]) return;
    unsigned long ip = 0;
    memcpy(&ip, he->h_addr_list[0], 4);
    *out = ip;
}

char* pb_host_name(unsigned long ip) {
    if (pb_winsock_init() != 0) return pb_bstr_alloc("", 0);
    if (ip == 0) {
        char buf[256] = {0};
        if (gethostname(buf, 255) != 0) return pb_bstr_alloc("", 0);
        return pb_bstr_alloc(buf, (unsigned int)strlen(buf));
    }
    pb_in_addr ia;
    ia.s_addr = ip;
    char* dotted = inet_ntoa(ia);
    if (!dotted) return pb_bstr_alloc("", 0);
    pb_hostent* he = gethostbyaddr((char*)&ia, 4, 2 /* AF_INET */);
    if (!he || !he->h_name) return pb_bstr_alloc("", 0);
    return pb_bstr_alloc(he->h_name, (unsigned int)strlen(he->h_name));
}

void pb_input_flush(void) {
    fflush(stdin);
}

/* ===== Batch 5: PEEK / POKE ===== */

int pb_peek8(void* a) { return *(unsigned char*)a; }
int pb_peek16(void* a) { return *(unsigned short*)a; }
long pb_peek32(void* a) { return *(long*)a; }
long long pb_peek64(void* a) { return *(long long*)a; }
float pb_peekf(void* a) { float f; memcpy(&f, a, 4); return f; }
double pb_peekd(void* a) { double d; memcpy(&d, a, 8); return d; }

void pb_poke8(void* a, int v) { *(unsigned char*)a = (unsigned char)v; }
void pb_poke16(void* a, int v) { *(unsigned short*)a = (unsigned short)v; }
void pb_poke32(void* a, long v) { *(long*)a = v; }
void pb_poke64(void* a, long long v) { *(long long*)a = v; }
void pb_pokef(void* a, float v) { memcpy(a, &v, 4); }
void pb_poked(void* a, double v) { memcpy(a, &v, 8); }

/* ===== Stubs for external DLL functions not yet available ===== */

#ifdef _WIN32
#define STDCALL __stdcall
#else
#define STDCALL
#endif

/* VARICHEK.DLL — HiScore: checks/updates high score table
 * Returns: 2 if highest score, else 1; x=-1 for check-only
 * Stubbed: linked directly into exe (cdecl, not dllimport) */
int HiScore(int x, const char* Winner, const char* PathSpec) {
    (void)x; (void)Winner; (void)PathSpec;
    return 1;  /* Not highest score */
}

/* Example DLL stub — RemarksData: returns STRPTR to a string
 * Stubbed: linked directly into exe (cdecl, not dllimport) */
int RemarksData(int x) {
    static char humor[] = "No remarks available.";
    (void)x;
    return (int)(size_t)humor;  /* Return pointer as integer (32-bit) */
}

/* EZLIB functions are now nooped in the compiler (should_noop_function).
 * No runtime stubs needed. */

/* LSET (BSTR target): left-justify src into a fixed-length PB string, pad spaces */
void pb_lset(char** dest, const char* src, int len) {
    char* old = *dest;
    char* buf = (char*)malloc((size_t)len + 1);
    int src_len = src ? (int)strlen(src) : 0;
    int i;
    for (i = 0; i < len; i++) {
        buf[i] = (i < src_len) ? src[i] : 32;
    }
    buf[len] = (char)0;
    *dest = pb_bstr_alloc(buf, (unsigned int)len);
    free(buf);
    if (old) SysFreeString(old);
}

/* CSET (BSTR target): center src in a fixed-length PB string, pad spaces */
void pb_cset(char** dest, const char* src, int len) {
    char* old = *dest;
    char* buf = (char*)malloc((size_t)len + 1);
    int src_len = src ? (int)strlen(src) : 0;
    int pad_l = (src_len < len) ? (len - src_len) / 2 : 0;
    int i;
    for (i = 0; i < len; i++) {
        if (i < pad_l) {
            buf[i] = 32;
        } else if (i - pad_l < src_len) {
            buf[i] = src[i - pad_l];
        } else {
            buf[i] = 32;
        }
    }
    buf[len] = (char)0;
    *dest = pb_bstr_alloc(buf, (unsigned int)len);
    free(buf);
    /* NB: do NOT SysFreeString the previous *dest (may be a codegen constant) */
}

/* CSET (buffer target, e.g. STRING * N): center src, pad spaces */
void pb_cset_buf(char* dest, const char* src, int len) {
    int src_len = src ? (int)strlen(src) : 0;
    int pad_l = (src_len < len) ? (len - src_len) / 2 : 0;
    int i;
    for (i = 0; i < len; i++) {
        if (i < pad_l) {
            dest[i] = 32;
        } else if (i - pad_l < src_len) {
            dest[i] = src[i - pad_l];
        } else {
            dest[i] = 32;
        }
    }
    dest[len] = (char)0;
}

/* RSET (BSTR target): right-justify src into a fixed-length PB string, pad spaces */
void pb_rset(char** dest, const char* src, int len) {
    char* old = *dest;
    char* buf = (char*)malloc((size_t)len + 1);
    int src_len = src ? (int)strlen(src) : 0;
    int pad = (src_len < len) ? (len - src_len) : 0;
    int i;
    for (i = 0; i < len; i++) {
        buf[i] = (i < pad) ? 32 : ((i - pad) < src_len ? src[i - pad] : 32);
    }
    buf[len] = (char)0;
    *dest = pb_bstr_alloc(buf, (unsigned int)len);
    free(buf);
    if (old) SysFreeString(old);
}

/* ERASE: zero-out a static array (non-string) or NULL-out string elements */
void pb_erase_array(char* base, int elem_size, int count, int is_string) {
    if (is_string) {
        char** p = (char**)base;
        int i;
        for (i = 0; i < count; i++) p[i] = NULL;
    } else {
        memset(base, 0, (size_t)elem_size * (size_t)count);
    }
}

/* LSET (buffer target, e.g. STRING * N fixed-length var): left-justify src, pad spaces */
void pb_lset_buf(char* dest, const char* src, int len) {
    int src_len = src ? (int)strlen(src) : 0;
    int i;
    for (i = 0; i < len; i++) {
        dest[i] = (i < src_len) ? src[i] : 32;
    }
    dest[len] = (char)0;
}

/* RSET (buffer target): right-justify src, pad spaces */
void pb_rset_buf(char* dest, const char* src, int len) {
    int src_len = src ? (int)strlen(src) : 0;
    int pad = (src_len < len) ? (len - src_len) : 0;
    int i;
    for (i = 0; i < len; i++) {
        dest[i] = (i < pad) ? 32 : ((i - pad) < src_len ? src[i - pad] : 32);
    }
    dest[len] = (char)0;
}

/* RESET: close all open files */
/* RESET: close all open files */
void pb_reset(void) {
    for (int i = 1; i < MAX_FILE_HANDLES; i++) {
        if (file_handles[i]) {
            fclose(file_handles[i]);
            file_handles[i] = NULL;
        }
    }
}

/* FLUSH: flush file buffers to disk */
void pb_flush(int filenum) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        fflush(file_handles[filenum]);
    }
}

/* NAME: rename a file */
int pb_name(const char* old_path, const char* new_path) {
    return rename(old_path, new_path);
}

/* WRITE # support: per-file "first field" tracking */
static int write_first_field[MAX_FILE_HANDLES] = {0};
void pb_write_file_begin(int filenum) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES) write_first_field[filenum] = 1;
}
void pb_write_file_str(int filenum, const char* s) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        if (!write_first_field[filenum]) fputc(',', file_handles[filenum]);
        write_first_field[filenum] = 0;
        fputc(34, file_handles[filenum]); /* double quote */
        fputs(s ? s : "", file_handles[filenum]);
        fputc(34, file_handles[filenum]);
    }
}
void pb_write_file_int(int filenum, long v) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        if (!write_first_field[filenum]) fputc(',', file_handles[filenum]);
        write_first_field[filenum] = 0;
        fprintf(file_handles[filenum], "%ld", v);
    }
}
void pb_write_file_dbl(int filenum, double v) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        if (!write_first_field[filenum]) fputc(',', file_handles[filenum]);
        write_first_field[filenum] = 0;
        fprintf(file_handles[filenum], "%.14g", v);
    }
}
void pb_write_file_newline(int filenum) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        fputs("\r\n", file_handles[filenum]);
        write_first_field[filenum] = 1;
        fflush(file_handles[filenum]);
    }
}

/* SEEK: position file pointer (PB is 1-based) */
long long pb_lof(int filenum) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        FILE* fp = file_handles[filenum];
        long cur = ftell(fp);
        fseek(fp, 0, SEEK_END);
        long long len = ftell(fp);
        fseek(fp, cur, SEEK_SET);
        return len;
    }
    return 0;
}

long long pb_loc(int filenum) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        return ftell(file_handles[filenum]) + 1;
    }
    return 0;
}

void pb_seek(int filenum, long pos) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        fseek(file_handles[filenum], (long)(pos - 1), SEEK_SET);
    }
}

/* GET #f [, pos], var: read raw bytes from a binary file into a variable.
   pos <= 0 means "current position" (caller passes -1 when omitted). */
void pb_get(int filenum, long long pos, char* buf, long long size) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        if (pos > 0) fseek(file_handles[filenum], (long)(pos - 1), SEEK_SET);
        fread(buf, 1, (size_t)size, file_handles[filenum]);
    }
}

/* PUT #f [, pos], var: write raw bytes from a variable to a binary file. */
void pb_put(int filenum, long long pos, char* buf, long long size) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        if (pos > 0) fseek(file_handles[filenum], (long)(pos - 1), SEEK_SET);
        fwrite(buf, 1, (size_t)size, file_handles[filenum]);
    }
}

/* ARRAY SORT helpers */
static int cmp_i32(const void* a, const void* b) {
    long x = *(const long*)a, y = *(const long*)b;
    return (x > y) - (x < y);
}
static int cmp_i64(const void* a, const void* b) {
    long long x = *(const long long*)a, y = *(const long long*)b;
    return (x > y) - (x < y);
}
static int cmp_dbl(const void* a, const void* b) {
    double x = *(const double*)a, y = *(const double*)b;
    return (x > y) - (x < y);
}
static int cmp_f32(const void* a, const void* b) {
    float x = *(const float*)a, y = *(const float*)b;
    return (x > y) - (x < y);
}
static int cmp_str(const void* a, const void* b) {
    const char* x = *(char* const*)a;
    const char* y = *(char* const*)b;
    if (!x) x = "";
    if (!y) y = "";
    return strcmp(x, y);
}
/* ARRAY SORT arr(): ascending sort of a PB array.
   type: 0=LONG(4) 1=QUAD(8) 2=DOUBLE(8) 3=STRING(ptr,8) 4=SINGLE(4) */
void pb_array_sort(char* base, int elem_size, int count, int type) {
    if (!base || count <= 1) return;
    switch (type) {
        case 0: qsort(base, (size_t)count, (size_t)elem_size, cmp_i32); break;
        case 1: qsort(base, (size_t)count, (size_t)elem_size, cmp_i64); break;
        case 2: qsort(base, (size_t)count, (size_t)elem_size, cmp_dbl); break;
        case 3: qsort(base, (size_t)count, (size_t)elem_size, cmp_str); break;
        case 4: qsort(base, (size_t)count, (size_t)elem_size, cmp_f32); break;
    }
}

void pb_array_copy(char* dest, char* src, int elem_size, long long total) {
    if (!dest || !src || total <= 0) return;
    memcpy(dest, src, (size_t)(elem_size * total));
}

void pb_array_swap(char* a, char* b, int elem_size, long long total) {
    if (!a || !b || a == b || total <= 0) return;
    size_t bytes = (size_t)(elem_size * total);
    char* tmp = (char*)malloc(bytes);
    if (!tmp) return;
    memcpy(tmp, a, bytes);
    memcpy(a, b, bytes);
    memcpy(b, tmp, bytes);
    free(tmp);
}

long long pb_array_unique(char* base, int elem_size, long long total, int is_string) {
    if (!base || total <= 1) return total;
    long long write = 0;
    for (long long i = 0; i < total; i++) {
        int dup = 0;
        for (long long j = 0; j < write; j++) {
            int eq;
            if (is_string) {
                char* a = *(char**)(base + j * elem_size);
                char* b = *(char**)(base + i * elem_size);
                eq = (a && b && strcmp(a, b) == 0) || (!a && !b);
            } else {
                eq = memcmp(base + j * elem_size, base + i * elem_size, elem_size) == 0;
            }
            if (eq) { dup = 1; break; }
        }
        if (!dup) {
            if (write != i) memmove(base + write * elem_size, base + i * elem_size, elem_size);
            write++;
        }
    }
    /* zero the tail — fixed-size array model (PB decrements UBOUND; we cannot resize) */
    for (long long k = write; k < total; k++) {
        if (is_string) {
            *(char**)(base + k * elem_size) = NULL;
        } else {
            memset(base + k * elem_size, 0, elem_size);
        }
    }
    return write;
}

/* LOCK/UNLOCK: lock a byte range of the file (C runtime _locking) */
void pb_lock(int filenum, long record, long length) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        if (record > 0) fseek(file_handles[filenum], (long)(record - 1), SEEK_SET);
        long nb = (length > 0) ? length : 1;
        _locking(_fileno(file_handles[filenum]), _LK_LOCK, nb);
    }
}
void pb_unlock(int filenum, long record, long length) {
    if (filenum >= 1 && filenum < MAX_FILE_HANDLES && file_handles[filenum]) {
        if (record > 0) fseek(file_handles[filenum], (long)(record - 1), SEEK_SET);
        long nb = (length > 0) ? length : 1;
        _locking(_fileno(file_handles[filenum]), _LK_UNLCK, nb);
    }
}

/* ===== TCP / UDP sockets (batch 19) ===== */
#ifdef _WIN64
typedef unsigned long long pb_sock_t;   /* SOCKET is 64-bit on x64 */
#else
typedef unsigned int pb_sock_t;         /* SOCKET is 32-bit on x86 (stdcall @N decoration must match) */
#endif
struct pb_sockaddr_in {
    short sin_family;
    unsigned short sin_port;
    unsigned long sin_addr;
    char sin_zero[8];
};

__declspec(dllimport) pb_sock_t __stdcall socket(int af, int type, int protocol);
__declspec(dllimport) int __stdcall connect(pb_sock_t s, const void* name, int namelen);
__declspec(dllimport) int __stdcall bind(pb_sock_t s, const void* name, int namelen);
__declspec(dllimport) int __stdcall listen(pb_sock_t s, int backlog);
__declspec(dllimport) pb_sock_t __stdcall accept(pb_sock_t s, void* addr, int* addrlen);
__declspec(dllimport) int __stdcall send(pb_sock_t s, const char* buf, int len, int flags);
__declspec(dllimport) int __stdcall recv(pb_sock_t s, char* buf, int len, int flags);
__declspec(dllimport) int __stdcall sendto(pb_sock_t s, const char* buf, int len, int flags, const void* to, int tolen);
__declspec(dllimport) int __stdcall recvfrom(pb_sock_t s, char* buf, int len, int flags, void* from, int* fromlen);
__declspec(dllimport) int __stdcall closesocket(pb_sock_t s);
__declspec(dllimport) unsigned short __stdcall htons(unsigned short hostshort);
__declspec(dllimport) unsigned long __stdcall inet_addr(const char* cp);
__declspec(dllimport) int __stdcall setsockopt(pb_sock_t s, int level, int optname, const char* optval, int optlen);

#define PB_MAX_SOCK 256
static pb_sock_t pb_sock[PB_MAX_SOCK];
static int pb_sock_state[PB_MAX_SOCK];  /* 0=free 1=tcp 2=udp 3=tcp-server */
#define PB_SOCK_INVALID ((pb_sock_t)-1)

static unsigned long pb_net_ip(const char* host) {
    unsigned long ip = inet_addr(host);
    if (ip == (unsigned long)-1) {
        pb_hostent* he = gethostbyname(host);
        if (he && he->h_addr_list && he->h_addr_list[0]) {
            memcpy(&ip, he->h_addr_list[0], 4);
        } else {
            return (unsigned long)-1;
        }
    }
    return ip;
}

static void pb_net_fill_addr(struct pb_sockaddr_in* a, unsigned long ip, int port) {
    memset(a, 0, sizeof(*a));
    a->sin_family = 2; /* AF_INET */
    a->sin_port = htons((unsigned short)port);
    a->sin_addr = ip;
}

int pb_tcp_open(int mode, int port, const char* addr, int filenum, long timeout) {
    if (pb_winsock_init() != 0) return -1;
    if (filenum < 1 || filenum >= PB_MAX_SOCK) return -1;
    if (pb_sock_state[filenum] != 0) return -1;
    pb_sock_t s = socket(2, 1, 6); /* AF_INET, SOCK_STREAM, TCP */
    if (s == PB_SOCK_INVALID) return -1;
    struct pb_sockaddr_in a;
    if (mode == 1) {
        /* server: bind + listen */
        pb_net_fill_addr(&a, 0, port);
        if (bind(s, &a, sizeof(a)) != 0 || listen(s, 8) != 0) { closesocket(s); return -1; }
        pb_sock[filenum] = s;
        pb_sock_state[filenum] = 3;
        return 0;
    }
    /* client: connect */
    unsigned long ip = pb_net_ip(addr);
    if (ip == (unsigned long)-1) { closesocket(s); return -1; }
    if (timeout > 0) {
        int t = (int)timeout;
        setsockopt(s, 0xFFFF, 0x1006, (const char*)&t, 4); /* SO_RCVTIMEO */
        setsockopt(s, 0xFFFF, 0x1005, (const char*)&t, 4); /* SO_SNDTIMEO */
    }
    pb_net_fill_addr(&a, ip, port);
    if (connect(s, &a, sizeof(a)) != 0) { closesocket(s); return -1; }
    pb_sock[filenum] = s;
    pb_sock_state[filenum] = 1;
    return 0;
}

int pb_tcp_accept(int srv, int newf) {
    if (srv < 1 || srv >= PB_MAX_SOCK || pb_sock_state[srv] != 3) return -1;
    if (newf < 1 || newf >= PB_MAX_SOCK || pb_sock_state[newf] != 0) return -1;
    struct pb_sockaddr_in a;
    int alen = sizeof(a);
    pb_sock_t s = accept(pb_sock[srv], &a, &alen);
    if (s == PB_SOCK_INVALID) return -1;
    pb_sock[newf] = s;
    pb_sock_state[newf] = 1;
    return 0;
}

int pb_tcp_send(int f, const char* data) {
    if (f < 1 || f >= PB_MAX_SOCK || (pb_sock_state[f] != 1 && pb_sock_state[f] != 3)) return -1;
    int len = (int)strlen(data ? data : "");
    int off = 0;
    while (off < len) {
        int n = send(pb_sock[f], data + off, len - off, 0);
        if (n <= 0) return -1;
        off += n;
    }
    return 0;
}

int pb_tcp_recv(int f, long count, char** out) {
    if (f < 1 || f >= PB_MAX_SOCK || (pb_sock_state[f] != 1 && pb_sock_state[f] != 3)) return -1;
    if (count < 0) count = 0;
    char* buf = pb_bstr_alloc(NULL, (unsigned int)count);
    int n = recv(pb_sock[f], buf, (int)count, 0);
    if (n <= 0) n = 0;
    buf[n] = 0;
    *out = buf;
    return n;
}

int pb_tcp_line_input(int f, char** out) {
    if (f < 1 || f >= PB_MAX_SOCK || (pb_sock_state[f] != 1 && pb_sock_state[f] != 3)) return -1;
    char tmp[4096];
    int n = 0;
    while (n < 4095) {
        char c = 0;
        int r = recv(pb_sock[f], &c, 1, 0);
        if (r <= 0) break;
        if (c == '\n') break;
        if (c != '\r') tmp[n++] = c;
    }
    char* buf = pb_bstr_alloc(NULL, (unsigned int)n);
    memcpy(buf, tmp, n);
    buf[n] = 0;
    *out = buf;
    return n;
}

int pb_tcp_print(int f, const char* data, int newline) {
    if (pb_tcp_send(f, data) != 0) return -1;
    if (newline) return pb_tcp_send(f, "\r\n");
    return 0;
}

int pb_tcp_close(int f) {
    if (f < 1 || f >= PB_MAX_SOCK || pb_sock_state[f] == 0) return -1;
    closesocket(pb_sock[f]);
    pb_sock_state[f] = 0;
    return 0;
}

int pb_udp_open(int port, int filenum, long timeout) {
    if (pb_winsock_init() != 0) return -1;
    if (filenum < 1 || filenum >= PB_MAX_SOCK) return -1;
    if (pb_sock_state[filenum] != 0) return -1;
    pb_sock_t s = socket(2, 2, 17); /* AF_INET, SOCK_DGRAM, UDP */
    if (s == PB_SOCK_INVALID) return -1;
    struct pb_sockaddr_in a;
    pb_net_fill_addr(&a, 0, port);
    if (timeout > 0) {
        int t = (int)timeout;
        setsockopt(s, 0xFFFF, 0x1006, (const char*)&t, 4);
    }
    if (bind(s, &a, sizeof(a)) != 0) { closesocket(s); return -1; }
    pb_sock[filenum] = s;
    pb_sock_state[filenum] = 2;
    return 0;
}

int pb_udp_send(int f, unsigned long ip, int port, const char* data);

int pb_udp_send_str(int f, const char* ipstr, int port, const char* data) {
    return pb_udp_send(f, inet_addr(ipstr ? ipstr : "0.0.0.0"), port, data);
}

int pb_udp_send(int f, unsigned long ip, int port, const char* data) {
    if (f < 1 || f >= PB_MAX_SOCK || pb_sock_state[f] != 2) return -1;
    struct pb_sockaddr_in a;
    pb_net_fill_addr(&a, ip, port);
    int len = (int)strlen(data ? data : "");
    int n = sendto(pb_sock[f], data, len, 0, &a, sizeof(a));
    return (n < 0) ? -1 : 0;
}


static unsigned short ntohs_s(unsigned short v) {
    return (unsigned short)((v >> 8) | (v << 8));
}

int pb_udp_recv(int f, unsigned long* ip, int* port, char** out) {
    if (f < 1 || f >= PB_MAX_SOCK || pb_sock_state[f] != 2) return -1;
    char tmp[65536];
    struct pb_sockaddr_in a;
    int alen = sizeof(a);
    int n = recvfrom(pb_sock[f], tmp, 65535, 0, &a, &alen);
    if (n <= 0) n = 0;
    char* buf = pb_bstr_alloc(NULL, (unsigned int)n);
    memcpy(buf, tmp, n);
    buf[n] = 0;
    if (ip) *ip = a.sin_addr;
    if (port) *port = ntohs_s(a.sin_port);
    *out = buf;
    return n;
}

int pb_udp_close(int f) {
    if (f < 1 || f >= PB_MAX_SOCK || pb_sock_state[f] == 0) return -1;
    closesocket(pb_sock[f]);
    pb_sock_state[f] = 0;
    return 0;
}



/* ============================================================
 * COMM serial port statements (batch 21)
 * ============================================================ */
typedef struct _pb_dcb {
    unsigned long DCBlength;
    unsigned long BaudRate;
    unsigned long fBits;
    unsigned short wReserved;
    unsigned short XonLim;
    unsigned short XoffLim;
    unsigned char ByteSize;
    unsigned char Parity;
    unsigned char StopBits;
    char XonChar;
    char XoffChar;
    char ErrorChar;
    char EofChar;
    char EvtChar;
    unsigned short wReserved1;
} pb_dcb;

typedef struct _pb_commtimeouts {
    unsigned long ReadIntervalTimeout;
    unsigned long ReadTotalTimeoutMultiplier;
    unsigned long ReadTotalTimeoutConstant;
    unsigned long WriteTotalTimeoutMultiplier;
    unsigned long WriteTotalTimeoutConstant;
} pb_commtimeouts;

#define PB_MAXDWORD 0xFFFFFFFFUL
#define PB_SETDTR 5
#define PB_CLRDTR 6
#define PB_SETRTS 3
#define PB_CLRRTS 4
#define PB_SETBREAK 8
#define PB_CLRBREAK 9
#define PB_GENERIC_READ_WRITE 0xC0000000UL
#define PB_OPEN_EXISTING 3UL

static HANDLE pb_comm_h[256];
static int pb_comm_ok[256];

int pb_comm_open(const char* port, int channel, int baud, const char* parity, int data, int stop) {
    HANDLE h;
    pb_dcb dcb;
    pb_commtimeouts to;
    if (channel < 0 || channel > 255 || port == NULL) return -1;
    if (pb_comm_ok[channel]) {
        CloseHandle(pb_comm_h[channel]);
        pb_comm_ok[channel] = 0;
        pb_comm_h[channel] = NULL;
    }
    h = CreateFileA(port, PB_GENERIC_READ_WRITE, 0, NULL, PB_OPEN_EXISTING, 0, NULL);
    if (h == PB_INVALID_HANDLE) {
        pb_comm_h[channel] = NULL;
        pb_comm_ok[channel] = 0;
        return -1;
    }
    memset(&dcb, 0, sizeof(dcb));
    dcb.DCBlength = sizeof(dcb);
    GetCommState(h, &dcb);
    dcb.BaudRate = (baud > 0) ? (unsigned long)baud : 9600UL;
    dcb.ByteSize = (unsigned char)((data > 0) ? data : 8);
    dcb.StopBits = (unsigned char)((stop > 1) ? 2 : 1);
    dcb.Parity = (unsigned char)((parity && parity[0] == 'E') ? 2 : ((parity && parity[0] == 'O') ? 1 : 0));
    dcb.fBits = 1; /* fBinary = 1 */
    SetCommState(h, &dcb);
    memset(&to, 0, sizeof(to));
    to.ReadIntervalTimeout = PB_MAXDWORD;
    to.ReadTotalTimeoutMultiplier = 0;
    to.ReadTotalTimeoutConstant = 0;
    SetCommTimeouts(h, &to);
    pb_comm_h[channel] = h;
    pb_comm_ok[channel] = 1;
    return 0;
}

int pb_comm_close(int channel) {
    if (channel < 0 || channel > 255 || !pb_comm_ok[channel]) return -1;
    CloseHandle(pb_comm_h[channel]);
    pb_comm_h[channel] = NULL;
    pb_comm_ok[channel] = 0;
    return 0;
}

void pb_comm_reset(void) {
    int i;
    for (i = 0; i < 256; i++) {
        if (pb_comm_ok[i]) pb_comm_close(i);
    }
}

int pb_comm_send(int channel, const char* s) {
    unsigned long written = 0;
    if (channel < 0 || channel > 255 || !pb_comm_ok[channel] || s == NULL) return -1;
    WriteFile(pb_comm_h[channel], s, (unsigned long)strlen(s), &written, NULL);
    FlushFileBuffers(pb_comm_h[channel]);
    return (int)written;
}

int pb_comm_recv(int channel, long long bytes, char** dest) {
    unsigned long got = 0;
    char* buf;
    long long n = (bytes > 0) ? bytes : 1;
    if (channel < 0 || channel > 255 || !pb_comm_ok[channel] || dest == NULL) return -1;
    buf = (char*)malloc((size_t)n + 1);
    if (buf == NULL) return -1;
    if (!ReadFile(pb_comm_h[channel], buf, (unsigned long)n, &got, NULL)) {
        free(buf);
        return -1;
    }
    buf[got] = '\0';
    {
        char* nb = pb_bstr_alloc(buf, (int)got);
        if (*dest) free(*dest);
        *dest = nb;
    }
    free(buf);
    return (int)got;
}

int pb_comm_line_input(int channel, char** dest) {
    int n = 0, cap = 64, c;
    char* buf;
    if (channel < 0 || channel > 255 || !pb_comm_ok[channel] || dest == NULL) return -1;
    buf = (char*)malloc((size_t)cap);
    if (buf == NULL) return -1;
    while (1) {
        unsigned long got = 0;
        char ch;
        if (!ReadFile(pb_comm_h[channel], &ch, 1, &got, NULL) || got == 0) break;
        c = (unsigned char)ch;
        if (c == '\r') continue;
        if (c == '\n') break;
        if (n + 1 >= cap) {
            cap *= 2;
            buf = (char*)realloc(buf, (size_t)cap);
            if (buf == NULL) return -1;
        }
        buf[n++] = (char)c;
    }
    buf[n] = '\0';
    {
        char* nb = pb_bstr_alloc(buf, n);
        if (*dest) free(*dest);
        *dest = nb;
    }
    free(buf);
    return n;
}

void pb_comm_print_str(int channel, const char* s) {
    if (channel >= 0 && channel <= 255 && pb_comm_ok[channel] && s != NULL) {
        unsigned long written = 0;
        WriteFile(pb_comm_h[channel], s, (unsigned long)strlen(s), &written, NULL);
    }
}

void pb_comm_print_int(int channel, long long v) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%lld", v);
    pb_comm_print_str(channel, buf);
}

void pb_comm_print_dbl(int channel, double v) {
    char buf[64];
    snprintf(buf, sizeof(buf), "%g", v);
    pb_comm_print_str(channel, buf);
}

int pb_comm_set(int channel, const char* option, int on) {
    unsigned long fn;
    char opt[8];
    int i = 0;
    if (channel < 0 || channel > 255 || !pb_comm_ok[channel] || option == NULL) return -1;
    while (option[i] && i < 7) {
        opt[i] = (char)toupper((unsigned char)option[i]);
        i++;
    }
    opt[i] = '\0';
    if (strcmp(opt, "DTR") == 0) fn = on ? PB_SETDTR : PB_CLRDTR;
    else if (strcmp(opt, "RTS") == 0) fn = on ? PB_SETRTS : PB_CLRRTS;
    else if (strcmp(opt, "BREAK") == 0) fn = on ? PB_SETBREAK : PB_CLRBREAK;
    else return -1;
    return EscapeCommFunction(pb_comm_h[channel], fn) ? 0 : -1;
}

int pb_comm_timeout(int channel, long long ms) {
    pb_commtimeouts to;
    if (channel < 0 || channel > 255 || !pb_comm_ok[channel]) return -1;
    memset(&to, 0, sizeof(to));
    if (ms > 0) {
        to.ReadIntervalTimeout = PB_MAXDWORD;
        to.ReadTotalTimeoutConstant = (unsigned long)ms;
        to.WriteTotalTimeoutConstant = (unsigned long)ms;
    }
    return SetCommTimeouts(pb_comm_h[channel], &to) ? 0 : -1;
}

/* ============================================================
 * THREAD statements (batch 21)
 *   thread id passed to PB code is a slot number (0..255),
 *   real HANDLE is stored in pb_thr[] (same pattern as GLOBALMEM).
 * ============================================================ */
typedef struct _pb_thread_slot {
    HANDLE h;
    unsigned long tid;
    int state; /* 0 free, 1 running, 2 suspended, 3 finished */
} pb_thread_slot;

static pb_thread_slot pb_thr[256];

int pb_thread_create(void* func, unsigned long* out_id) {
    int i;
    unsigned long tid = 0;
    if (func == NULL) return -1;
#ifdef _WIN64
    for (i = 0; i < 256; i++) {
        if (!pb_thr[i].h) break;
    }
    if (i >= 256) return -1;
    pb_thr[i].h = CreateThread(NULL, 0, (void* (__stdcall*)(void*))func, NULL, 0, &tid);
    if (!pb_thr[i].h) return -1;
    pb_thr[i].tid = tid;
    pb_thr[i].state = 1;
    if (out_id) *out_id = (unsigned long)i;
    return 0;
#else
    /* 32-bit: PB functions use cdecl but CreateThread requires stdcall —
       calling a cdecl function through a stdcall pointer corrupts the stack. */
    if (out_id) *out_id = 0;
    return -1;
#endif
}

static pb_thread_slot* pb_thread_slot_of(unsigned long id) {
    if (id >= 256) return NULL;
    if (!pb_thr[id].h) return NULL;
    return &pb_thr[id];
}

int pb_thread_close(unsigned long id) {
    pb_thread_slot* t = pb_thread_slot_of(id);
    if (t == NULL) return -1;
    TerminateThread(t->h, 0);
    CloseHandle(t->h);
    memset(t, 0, sizeof(*t));
    return 0;
}

int pb_thread_suspend(unsigned long id) {
    pb_thread_slot* t = pb_thread_slot_of(id);
    if (t == NULL) return -1;
    if (SuspendThread(t->h) == (unsigned long)-1) return -1;
    t->state = 2;
    return 0;
}

int pb_thread_resume(unsigned long id) {
    pb_thread_slot* t = pb_thread_slot_of(id);
    if (t == NULL) return -1;
    if (ResumeThread(t->h) == (unsigned long)-1) return -1;
    t->state = 1;
    return 0;
}

int pb_thread_status(unsigned long id) {
    pb_thread_slot* t = pb_thread_slot_of(id);
    unsigned long code = 0;
    if (t == NULL) return 0;
    GetExitCodeThread(t->h, &code);
    if (code == 0x00000103UL) { /* STILL_ACTIVE */
        return t->state; /* 1 running or 2 suspended */
    }
    t->state = 3;
    return 3;
}

int pb_thread_get_priority(unsigned long id) {
    pb_thread_slot* t = pb_thread_slot_of(id);
    if (t == NULL) return 0;
    return GetThreadPriority(t->h);
}

int pb_thread_set_priority(unsigned long id, int prio) {
    pb_thread_slot* t = pb_thread_slot_of(id);
    if (t == NULL) return -1;
    return SetThreadPriority(t->h, prio) ? 0 : -1;
}

/* ================= Batch 22: LPRINT / TRACE / IMPORT ================= */

/* Win32 constants / imports used below (file uses hand-rolled dllimport, no windows.h) */
#ifndef PB_B22_DEFS
#define PB_B22_DEFS
#define PB_GENERIC_WRITE     0x40000000UL
#define PB_FILE_SHARE_WRITE  0x00000002UL
#define PB_OPEN_ALWAYS       4UL
#define PB_FORMFEED_CHAR     12
typedef void* HMODULE_PB;
typedef void* FARPROC_PB;
__declspec(dllimport) void* __stdcall LoadLibraryA(const char* lpFileName);
__declspec(dllimport) void* __stdcall GetProcAddress(void* hModule, const char* lpProcName);
__declspec(dllimport) int __stdcall FreeLibrary(void* hLibModule);
__declspec(dllimport) int __stdcall SetConsoleTitleA(const char* lpConsoleTitle);
__declspec(dllimport) unsigned long __stdcall GetConsoleTitleA(char* lpConsoleTitle, unsigned long nSize);
#endif

/* ---- BSTR helpers (4-byte LE length prefix + payload) ---- */
static unsigned int pb_bstr_len(const char* s) {
    if (!s) return 0;
    return (unsigned int)((unsigned char)s[0] | ((unsigned char)s[1] << 8) |
                          ((unsigned char)s[2] << 16) | ((unsigned char)s[3] << 24));
}
static void pb_bstr_cpy(char* dst, size_t cap, const char* s) {
    /* copy payload of BSTR s into dst (capped, NUL-terminated) */
    if (!dst) return;
    if (!s) { dst[0] = '\0'; return; }
    unsigned int n = pb_bstr_len(s);
    if (n >= cap) n = (unsigned int)(cap - 1);
    memcpy(dst, s + 4, n);
    dst[n] = '\0';
}

/* ---- LPRINT: direct line-printer device output ---- */
static HANDLE pb_lpt_handle = NULL;
static int pb_lpt_col = 0; /* current column for comma (14-column) handling */

/* LPRINT ATTACH device$  (open device/file for direct writes; "" or NULL = close) */
int pb_lprint_attach(char* device) {
    if (pb_lpt_handle) { CloseHandle(pb_lpt_handle); pb_lpt_handle = NULL; }
    pb_lpt_col = 0;
    if (!device || strlen(device) == 0) return 0; /* close-only */
    char path[512];
    strncpy(path, device, sizeof(path) - 1);
    path[sizeof(path) - 1] = '\0';
    HANDLE h = CreateFileA(path, PB_GENERIC_WRITE, PB_FILE_SHARE_WRITE, NULL,
                           PB_OPEN_ALWAYS, 0, NULL);
    if (h == PB_INVALID_HANDLE) return -1;
    pb_lpt_handle = h;
    return 0;
}
/* LPRINT CLOSE */
void pb_lprint_close(void) {
    if (pb_lpt_handle) { CloseHandle(pb_lpt_handle); pb_lpt_handle = NULL; }
}
/* LPRINT FLUSH */
void pb_lprint_flush(void) {
    if (pb_lpt_handle) FlushFileBuffers(pb_lpt_handle);
}
/* LPRINT FORMFEED */
void pb_lprint_formfeed(void) {
    if (pb_lpt_handle) {
        char c = 12; DWORD w;
        WriteFile(pb_lpt_handle, &c, 1, &w, NULL);
        pb_lpt_col = 0;
    }
}
/* raw bytes to device */
static void pb_lpt_write(const char* buf, unsigned int len) {
    if (!pb_lpt_handle || !buf) return;
    DWORD w;
    WriteFile(pb_lpt_handle, buf, len, &w, NULL);
    pb_lpt_col += (int)len;
}
/* LPRINT "..." — BSTR payload, no CRLF */
void pb_lprint_bstr(char* s) {
    if (s) pb_lpt_write(s, (unsigned int)strlen(s));
}
void pb_lprint_int(int n) {
    char b[32]; int l = sprintf(b, "%d", n);
    pb_lpt_write(b, (unsigned int)l);
}
void pb_lprint_i64(long long n) {
    char b[32]; int l = sprintf(b, "%lld", n);
    pb_lpt_write(b, (unsigned int)l);
}
void pb_lprint_dbl(double d) {
    char b[64]; int l = sprintf(b, "%.6g", d);
    pb_lpt_write(b, (unsigned int)l);
}
/* LPRINT statement terminator: CRLF unless trailing semicolon (simplified: always CRLF) */
void pb_lprint_crlf(void) {
    pb_lpt_write("\r\n", 2);
    pb_lpt_col = 0;
}
/* LPRINT comma: advance to next 14-column position */
void pb_lprint_tab(void) {
    if (!pb_lpt_handle) return;
    int pad = (14 - (pb_lpt_col % 14));
    if (pad == 0) pad = 14;
    char buf[14]; memset(buf, ' ', 14);
    pb_lpt_write(buf, (unsigned int)pad);
}

/* ---- TRACE: explicit trace file logging ---- */
static FILE* pb_trace_fp = NULL;
static int pb_trace_enabled = 0;

/* TRACE NEW fname$ */
int pb_trace_new(char* fname) {
    if (pb_trace_fp) { fclose(pb_trace_fp); pb_trace_fp = NULL; }
    pb_trace_fp = fopen(fname ? fname : "", "w");
    pb_trace_enabled = (pb_trace_fp != NULL);
    return pb_trace_fp ? 0 : -1;
}
void pb_trace_on(void) { pb_trace_enabled = 1; }
void pb_trace_off(void) { pb_trace_enabled = 0; }
void pb_trace_print(char* s) {
    if (!pb_trace_enabled || !pb_trace_fp || !s) return;
    fputs(s, pb_trace_fp);
    fputc('\n', pb_trace_fp);
    fflush(pb_trace_fp);
}
void pb_trace_close(void) {
    if (pb_trace_fp) { fclose(pb_trace_fp); pb_trace_fp = NULL; }
    pb_trace_enabled = 0;
}

/* ---- IMPORT: explicit DLL loading ---- */
/* IMPORT ADDR ProcName$, LibName$ TO AddrVar& [,HndlVar&] */
int pb_import_addr(char* procname, char* libname, void** out_addr, void** out_hndl) {
    /* procname/libname arrive as C-string payloads. Out slots must be 8-byte
       (PB QUAD variables) because x64 system-DLL addresses exceed 32 bits. */
    char pname[512], lname[1024];
    strncpy(pname, procname ? procname : "", sizeof(pname) - 1);
    pname[sizeof(pname) - 1] = '\0';
    strncpy(lname, libname ? libname : "", sizeof(lname) - 1);
    lname[sizeof(lname) - 1] = '\0';
    void* m = LoadLibraryA(lname);
    if (!m) return -1;
    void* fp = GetProcAddress(m, pname);
    if (!fp) { FreeLibrary(m); return -1; }
    if (out_addr) *out_addr = fp;
    if (out_hndl) *out_hndl = m;
    return 0;
}
/* IMPORT CLOSE HndlVar */
void pb_import_close(void* hndl) {
    if (hndl) FreeLibrary(hndl);
}

/* ---- Batch 23: WINDOW SET/GET TEXT (console title) + TYPE SET ---- */
void pb_console_set_title(const char* s) {
    SetConsoleTitleA(s ? s : "");
}

char* pb_console_get_title(void) {
    char buf[1024];
    unsigned long n = GetConsoleTitleA(buf, 1024);
    if (n == 0) return pb_bstr_alloc("", 0);
    if (n >= sizeof(buf)) n = sizeof(buf) - 1;
    buf[n] = '\0';
    return pb_bstr_alloc(buf, (unsigned int)n);
}

void pb_type_set(void* dest, const void* src, unsigned int size) {
    if (!dest || !src || size == 0) return;
    memcpy(dest, src, size);
}

void pb_type_set_str(void* dest, const char* src, unsigned int size) {
    if (!dest || size == 0) return;
    unsigned int n = src ? (unsigned int)strlen(src) : 0;
    if (n > size) n = size;
    if (n) memcpy(dest, src, n);
    if (n < size) memset((char*)dest + n, 0, size - n);
}

/* ================= Batch 24: DIR$ / DIR statement (FindFirstFileA family) ================= */

/* WIN32_FIND_DATAA layout (hand-rolled, no windows.h):
   0  DWORD  dwFileAttributes
   4  FILETIME ftCreationTime (8)
   12 FILETIME ftLastAccessTime (8)
   20 FILETIME ftLastWriteTime (8)
   28 DWORD  nFileSizeHigh
   32 DWORD  nFileSizeLow
   36 DWORD  dwReserved0
   40 DWORD  dwReserved1
   44 CHAR   cFileName[260]
   304 CHAR  cAlternateFileName[14]
   total >= 592 bytes
*/
#define PB_FIND_DATA_SIZE 592
#define PB_FILE_ATTRIBUTE_DIRECTORY 0x10UL

#ifndef PB_B24_DEFS
#define PB_B24_DEFS
typedef void* HANDLE_PB24;
#define PB_INVALID_HANDLE ((void*)(intptr_t)-1)
__declspec(dllimport) void* __stdcall FindFirstFileA(const char* lpFileName, char* lpFindFileData);
__declspec(dllimport) int __stdcall FindNextFileA(void* hFindFile, char* lpFindFileData);
__declspec(dllimport) int __stdcall FindClose(void* hFindFile);
#endif

static void* g_dir_handle = PB_INVALID_HANDLE;
static char g_dir_find_data[PB_FIND_DATA_SIZE];
static int g_dir_only = 0;
static unsigned long g_dir_attr = 0;

static const char* g_dir_name(void) { return g_dir_find_data + 44; }
static unsigned long g_dir_attrs(void) {
    unsigned long a;
    memcpy(&a, g_dir_find_data, sizeof(a));
    return a;
}
static int g_dir_is_dot(void) {
    const char* n = g_dir_name();
    return (n[0] == '.' && n[1] == '\0') || (n[0] == '.' && n[1] == '.' && n[2] == '\0');
}
static int g_dir_match(void) {
    if (g_dir_is_dot()) return 0;
    unsigned long fa = g_dir_attrs();
    if (g_dir_only) return (fa & g_dir_attr) == g_dir_attr;
    /* default: normal files only (not directory / hidden / system / label) */
    if (fa & (PB_FILE_ATTRIBUTE_DIRECTORY | 0x2UL | 0x4UL | 0x8UL)) return 0;
    return 1;
}
static char* g_dir_make_bstr(void) {
    const char* n = g_dir_name();
    return pb_bstr_alloc(n, (unsigned int)strlen(n));
}

/* DIR$ mask [, ONLY attr]  -> first match; returns "" when none */
char* pb_dir_first(char* mask, int only, unsigned long attr) {
    if (g_dir_handle != PB_INVALID_HANDLE) {
        FindClose(g_dir_handle);
        g_dir_handle = PB_INVALID_HANDLE;
    }
    g_dir_only = only;
    g_dir_attr = attr;
    if (!mask || !*mask) return pb_bstr_alloc("", 0);
    g_dir_handle = FindFirstFileA(mask, g_dir_find_data);
    if (g_dir_handle == PB_INVALID_HANDLE) return pb_bstr_alloc("", 0);
    for (;;) {
        if (g_dir_match()) return g_dir_make_bstr();
        if (!FindNextFileA(g_dir_handle, g_dir_find_data)) {
            FindClose(g_dir_handle);
            g_dir_handle = PB_INVALID_HANDLE;
            return pb_bstr_alloc("", 0);
        }
    }
}

/* DIR$ (NEXT) -> next match; "" when exhausted */
char* pb_dir_next(void) {
    if (g_dir_handle == PB_INVALID_HANDLE) return pb_bstr_alloc("", 0);
    for (;;) {
        if (!FindNextFileA(g_dir_handle, g_dir_find_data)) {
            FindClose(g_dir_handle);
            g_dir_handle = PB_INVALID_HANDLE;
            return pb_bstr_alloc("", 0);
        }
        if (g_dir_match()) return g_dir_make_bstr();
    }
}

void pb_dir_close(void) {
    if (g_dir_handle != PB_INVALID_HANDLE) {
        FindClose(g_dir_handle);
        g_dir_handle = PB_INVALID_HANDLE;
    }
}
