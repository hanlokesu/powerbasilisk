# PowerBasilisk Enhanced

[![CI](https://github.com/hanlokesu/powerbasilisk/actions/workflows/ci.yml/badge.svg)](https://github.com/hanlokesu/powerbasilisk/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/hanlokesu/powerbasilisk)](https://github.com/hanlokesu/powerbasilisk/releases)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)


![demo](assets/powerbasilisk-demo.gif)

An enhanced 64-bit PowerBASIC compiler, forked from
[`benstopics/powerbasilisk`](https://github.com/benstopics/powerbasilisk).

**PowerBasilisk** is an open-source compiler that translates PowerBASIC source
code (`.bas`) into LLVM IR and then into native 64-bit Windows executables.
The toolchain is written in Rust and has zero external crate dependencies.

This repository is an **enhanced branch** that fixes an upstream bug and adds
several frequently-used PowerBASIC statements/functions that were previously
silently dropped during code generation.

---

## What's New vs. Upstream

### Fixed
- **`-lui` link flag bug** — removed a stale `-lui` from the exe linker
  arguments. Modern Windows SDKs no longer ship `ui.lib`, so the upstream
  linker command failed whenever `--lib-dir` was used. This branch links
  correctly against current Windows SDKs.
- **Auto-detect the Windows SDK** — `--lib-dir` is now optional. When it is
  omitted, the compiler scans the standard install roots
  (`C:\Program Files (x86)\Windows Kits\10\Lib` and the 64-bit sibling) and
  picks the **newest installed SDK version** whose `um\x64` folder exists, so
  each user does not need to know their SDK version number. If no SDK is
  found, a warning is printed and linking will fail with a clear message.

### New Built-ins (previously silently discarded)
> **Early snapshot** — the first implementations from the initial releases of
> this fork (derived from [benstopics/powerbasilisk](https://github.com/benstopics/powerbasilisk)).
> Later batches (1-27) were added after this table was written; the complete,
> current list of every statement/function this branch implements is in the
> [Newly implemented by this branch](#newly-implemented-by-this-branch)
> table below (196 implemented / 105 not implemented / 202 tier-3 DDT).
> **Why this matters:** upstream `pbcompiler` would report "compiled
> successfully" while silently dropping these calls at codegen time — > `Unknown sub — skip` for bare statements and `Unknown function — 0` for
> expressions. Programs built this way ran but did nothing. This branch wires
> them to real Win32 / CRT calls and is verified against running executables.

### Diagnostics: know when your code is silently dropped
Upstream would compile a `.bas` that uses an unimplemented statement, produce
a working `.exe`, and never tell you that whole lines of your code did
nothing. This branch adds an **unimplemented-statement report**:

- Every statement that is parsed but produces **no code** is recorded.
- After each build, the compiler prints a summary to stderr:
  `[pbcompiler] WARNING: N statement(s) not implemented (silently dropped)`.
- A full report is written next to your output, e.g.
  `program.unimplemented.log`, listing **the source line and the statement
  name** for every silent drop, so you can tell exactly what will not run.

Example report from a program using DDT GUI statements:

```text
PowerBasilisk Enhanced - unimplemented / silently-dropped statement report
3 statement(s) parsed but produced NO code. These make the .exe run but do nothing.
Check each line below against your source:
  line 5: statement `DIALOG` parsed but NOT implemented (NOOP) - no code generated
  line 6: statement `XPRINT` parsed but NOT implemented (NOOP) - no code generated
  line 7: statement `GARBAGE_STMT` has no codegen implementation - skipped
```

This covers all three silent-drop paths: parser-level `NOOP`s (known but
unimplemented statements), bare statements with no codegen (`Unknown sub`),
and expression functions with no implementation (`Unknown function — 0`).

### Implementation notes (gotchas fixed)
- **LSET / RSET memory model.** A PowerBASIC fixed-length string
  (`STRING * N`) is a **direct char buffer**, not a `BSTR` pointer variable.
  The first attempt used `pb_lset(char**, ...)` (pointer-to-pointer) and
  produced garbage. The fix is a buffer variant (`pb_lset_buf` / `pb_rset_buf`)
  that writes straight into the fixed buffer, selected automatically based on
  the target variable's type.

---

## Getting Started (new users)

**Option A — no toolchain needed (recommended): download the prebuilt
package from [Releases](https://github.com/hanlokesu/powerbasilisk/releases).**
Pick the latest `PowerBasilisk-Enhanced-vX.Y.Z-x64.zip`; it already contains
the compiled `pbcompiler.exe`, the 64-bit runtime `pb_runtime_x64.obj`, sample
programs and a one-click `compile.bat`. Unzip and run:

```bat
cd PowerBasilisk-Enhanced-v0.1.21-x64
compile.bat          :: builds examples\demo.bas -> examples\demo.exe
```

> **Which download should I use?** The green **Code → Download ZIP** button
> (named `powerbasilisk-main.zip` by GitHub) is the **raw source tree only** —
> no executable inside; it is meant for developers building from source. New
> users who just want to compile PB programs should use the **Releases**
> package instead. (GitHub also auto-attaches "Source code (zip)" archives to
> every Release — those are source-only as well, ignore them.)

**Option B — build from source:** the quickest path on a brand-new machine:

1. **Double-click `setup.bat`** (or run
   `powershell -NoProfile -ExecutionPolicy Bypass -File setup.ps1`).
   It checks for and installs (via `winget`, if missing):
   - Rust toolchain (`Rustlang.Rustup`)
   - LLVM / Clang (`LLVM.LLVM`, ~500 MB download; a UAC prompt may appear
     - click YES)
   - Windows SDK (`Microsoft.WindowsSDK.10.0.26100`)
   Then it builds `pb_runtime_x64.obj` and the release `pbcompiler.exe`
   for you.
2. **Compile your first program:**

   ```bash
   pbcompiler build your_program.bas --exe --target x86_64-pc-windows-msvc --runtime-lib pb_runtime_x64.obj
   ```

   (`--lib-dir` is optional — the compiler auto-detects the Windows SDK.)

That is all a new user needs to know. The sections below explain the build
in detail for contributors.

---

## Build

Prerequisites: a Rust toolchain (`rustup`) and, for linking, LLVM/Clang.

```bash
# inside the workspace root (pbsrc/)
cargo build --release -p pbcompiler
# binary: target/release/pbcompiler.exe
```

## Usage

Compile a PB program to a 64-bit exe:

```bash
pbcompiler build program.bas --exe \
  --target x86_64-pc-windows-msvc \
  --runtime-lib pb_runtime_x64.obj \
  --lib-dir "<Windows SDK>\Lib\<ver>\um\x64"
```

- `--runtime-lib` — points to the precompiled `pb_runtime.c` object.
- `--lib-dir`  — optional. Directory containing `user32.lib`,
  `shell32.lib`, etc. Required for `MSGBOX` / `SHELL` / Win32 API usage.
  If omitted, the compiler auto-detects the newest installed Windows SDK.

---

## Verified

All added built-ins are tested by compiling and **running** the generated
64-bit executables:

- `ISFILE` — returns correct result for existing and missing files.
- `CURDIR$` — returns the real current working directory.
- `MSGBOX` — a modal dialog is shown with the correct title.
- `SHELL` — launching `calc.exe` starts the Calculator application.

Tier 2 additions are verified by compiling and running a combined test
program (`test_enhance2.bas`, exit code 0):

- `REPLACE` — `"the cat sat on the cat mat"` — `"the dog sat on the dog mat"`.
- `ERASE` — a `LONG` array's summed elements return 0; a `STRING` array's
  first element length returns 0.
- `LSET` / `RSET` — a `STRING * 10` variable shows left/right-justified text
  padded to exactly 10 characters.

The upstream official test suite (14 programs) continues to build, run, and
pass with exit code 0, and the user's real-world `.bas` files now emit real
`MessageBoxA` / `ShellExecuteA` / `GetCurrentDirectoryA` / `_access` calls
instead of being silently dropped.

**SDK auto-detection verified** - every build listed above (the 14 official
tests, the Tier 2A and Tier 2B tests, the file I/O round trip, and the
user's real-world `.bas` program) was compiled and linked **without
`--lib-dir`**. The compiler auto-detected the newest installed Windows SDK
(`C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64` on the
test machine, which also has the older `10.0.19041.0` installed) and
linked every program successfully.

**Tier 2B file-statement test** (`test_tier2b.bas`, exit code 0) covers the
remaining Tier-2 file statements end to end:

- `WRITE #` — writes CSV-style records; reading them back with `LINE INPUT #`
  yields `"hello",42,3.5` and `"world",7` exactly.
- `SEEK #` — repositions to byte 1 and re-reads the first record correctly.
- `LOCK` / `UNLOCK #` — a byte range is locked and released without error.
- `FLUSH #` — buffers are flushed mid-program.
- `NAME ... AS ...` — renames the test file on disk.
- `RESET` — closes every open file handle; the renamed file is then deleted
  with `KILL` and no temporary files remain.

**File I/O round trip** — a full write→read→verify→cleanup cycle passes with
exit code 0:

- `fileio_writer.bas` opens `testdata.txt` `FOR OUTPUT` and writes 9 lines via
  `PRINT #` (text, numbers, a float, loop-built rows, and a line produced by
  the new `REPLACE` statement).
- `fileio_reader.bas` opens it `FOR INPUT`, reads all 9 lines back with
  `LINE INPUT #` inside `WHILE NOT EOF(f)`, verifies the count, then deletes
  the file with `KILL`.
- Every line read back matches what was written, byte for byte. This confirms
  the file pipeline (`FREEFILE`, `OPEN`, `PRINT #`, `LINE INPUT #`, `EOF`,
  `CLOSE`, `KILL`) executes real I/O — not empty shells.

---


## Statement Support Matrix

Status legend: **✅** implemented and verified · **⚠️** parsed but produces
NO code — reported in `*.unimplemented.log` at build time · **🔲** future

> **Official coverage audit** — every keyword below has been checked against
> the PowerBASIC official documentation (MIT-licensed keyword index,
> 735 keywords / 1282 topic pages, PB/Win 10+11 / PB/CC 6+7):
> [**statement-coverage.md**](docs/statement-coverage.md) · full data:
> [**statement-coverage.csv**](docs/statement-coverage.csv).
> Summary: **197** statement-class keywords implemented · **202** DDT/GUI-class
> deferred (Tier 3) · **104** documented upstream with no codegen evidence yet.
> (2026-09-15: +1 official keyword from batch 34 — PROFILE (per-procedure call counts and elapsed ms collected by the call-stack instrumentation; PROFILE filename$ writes "<Name>, <Call Count>, <Time mSec>" per line, PB-compatible).
> (2026-09-15: +1 official keyword from batch 33 — CALLSTK call-stack tracing (CALLSTKCOUNT current depth, CALLSTK$(n) frame names 1-based innermost-first, CALLSTK filename$ writes the stack to a sequential file; pb_callstk_push/pop/count/get/dump).
> (2026-09-15: +1 official keyword from batch 32 — MAT matrix algebra (CON / CON(expr) / IDN / ZER / elementwise + - assignment / scalar (expr)*a / 2-D TRN / * matrix multiply / INV Gauss-Jordan inverse; runtime pb_mat_* family with is_float element decoding).
> (2026-09-15: +1 official keyword from batch 31 — FIELD (field variables bound to RANDOM record buffers or to dynamic-string payload slots by reference: FIELD #f, n AS var / FIELD dyn$, n AS var / FIELD STRING / FIELD RESET, OPEN ... FOR RANDOM AS #f LEN=reclen, numbered PUT #f,rec / GET #f,rec record I/O, blank padding).
> (2026-09-14: +1 official keyword from batch 30 — ASMDATA/END ASMDATA
> read-only data blocks outside any Sub/Function: `ASMDATA Name` + `DB`/`DW`/`DD`/`DQ`
> lines + `END ASMDATA`, packed contiguously and never aligned, ANSI strings in DB,
> WIDE UTF-16LE strings in DW, addressed via `CODEPTR(Name)` (emitted as
> `@__asmdata_<NAME>` constant), verified byte-for-byte via `PEEK`. +1 from batch 29 —
> ASM inline assembly (`!` shortcut or `ASM` keyword): LLVM `inteldialect` asm,
> PB variable operands passed by pointer, mem-to-mem / wide-immediate shuffling
> automatic, x87 / MMX / SSE pass through verbatim, verified on x86-64 and i686.
> +1 from batch 28 — THREADED thread-local storage declaration, LLVM `thread_local`
> globals with per-thread copies.)
> (2026-09-14: +4 official keywords from batch 27 — ON CALL computed
> procedure dispatch, GET$$/PUT$$ wide UTF-16LE string I/O, MACRO/END MACRO
> compile-time text substitution. +2 from batch 26 — PREFIX/END PREFIX
> compile-time text transform, TRY/CATCH/FINALLY/EXIT TRY structured
> error trapping. Batch 25 added ON ERROR trapping, RESUME, REGISTER.)
> (Earlier: +5 official keywords from batch 23 — real STATIC semantics,
> ARRAY ASSIGN, TYPE SET, WINDOW SET/GET TEXT console-title bridge, plus a
> TYPE fixed-string field assignment bug fix; +16 official keywords from batch 21 — COMM serial port
> OPEN/CLOSE/LINE/PRINT/RECV/RESET/SEND/SET/TIMEOUT + THREAD
> CREATE/CLOSE/SUSPEND/RESUME/STATUS/GET+SET PRIORITY — real Win32
> CreateFileA/DCB serial + CreateThread thread control, verified live via
> a thread spin-loop test; +11 official keywords from batch 19 — TCP OPEN/ACCEPT/SEND/RECV/
> LINE INPUT/PRINT/CLOSE + UDP OPEN/SEND/RECV/CLOSE — Winsock sockets, verified
> live via loopback TCP/UDP echo; 2026-09-12: +59 official keywords from batches 1-18 (incl. 29 #-metastatements, all verified accepted) — TIX, MKBYT$, PEEK/POKE,
> SHIFT/ROTATE, DATA/READ/RESTORE, PLAY WAVE/SOUND, SPLIT, ARRAY REVERSE/SHUFFLE,
> CHDRIVE, SETEOF, PUT$, ISINFINITE/ISNORMAL, MKx binary-string family,
> DESKTOP GET CLIENT/LOC/PPI — all sample-verified live.)

### Newly implemented by this branch
| PB statement / function | Status | Batch | Maps to |
| --- | --- | --- | --- |
| `TCP OPEN/ACCEPT/SEND/RECV/LINE INPUT/PRINT/CLOSE` | ✅ | 19 (v0.1.12) | Winsock `socket/connect/bind/listen/accept/send/recv/closesocket` + `pb_*` helpers |
| `COMM OPEN/CLOSE/LINE/PRINT/RECV/RESET/SEND/SET/TIMEOUT` | ✅ | 21 (v0.1.15) | CreateFileA + DCB/SetCommState/SetCommTimeouts; channel 0..255 |
| `THREAD CREATE/CLOSE/SUSPEND/RESUME/STATUS/GET+SET PRIORITY` | ✅ | 21 (v0.1.15) | CreateThread/ResumeThread/SuspendThread/TerminateThread/GetExitCodeThread (x64, slot ids 0..255) |
| `FIELD` (`#f`/`dyn$` bind, STRING, RESET, RANDOM) | ✅ | 31 (v0.1.25) | `pb_open_random` + `pb_field_bind_file/str` + `pb_field_set/get/tostr/reset` + `pb_put/get_record` + `pb_seek_record` (RANDOM record I/O) |
| `ASMDATA / END ASMDATA` | ✅ | 30 (v0.1.24) | read-only data blocks outside any Sub/Function: `ASMDATA Name` + `DB`/`DW`/`DD`/`DQ` lines + `END ASMDATA`; packed, never aligned; ANSI strings in DB, WIDE UTF-16LE strings in DW; emitted as `@__asmdata_<NAME>` constant; address via `CODEPTR(Name)` |
| `ASM` (`!` shortcut or `ASM` keyword) | ✅ | 29 (v0.1.23) | LLVM inline assembly — Intel dialect; PB variable operands passed by pointer (`byte/word/dword/qword ptr [$N]`); mem-to-mem and wide-immediate shuffling automatic; consecutive ASM lines merge into one asm block (register state preserved); x87 / MMX / SSE / SIMD pass through verbatim; works on both x86-64 and i686 targets |
| `THREADED` | ✅ | 28 (v0.1.22) | LLVM `thread_local` global; per-thread copy, global to every Sub/Function (scalars; arrays pending) |
| `UDP OPEN/SEND/RECV/CLOSE` | ✅ | 19 (v0.1.12) | Winsock `SOCK_DGRAM` + `sendto/recvfrom`; `UDP SEND AT` accepts LONG or string IP |
| `MSGBOX` / `SHELL` / `CURDIR$` / `ISFILE` | ✅ | v0.1.0 | `MessageBoxA` / `ShellExecuteA` / `GetCurrentDirectoryA` / `_access` |
| `REPLACE old$ WITH new$ IN target$` | ✅ | v0.1.0 | `pb_replace` |
| `ERASE array` | ✅ | v0.1.0 | `pb_erase_array` |
| `LSET var$ = expr` / `RSET var$ = expr` | ✅ | v0.1.0 | `pb_lset(_buf)` / `pb_rset(_buf)` |
| `WRITE #f, ...` | ✅ | v0.1.0 | `pb_write_file_begin/str/int/dbl/newline` |
| `SEEK #f, pos` | ✅ | v0.1.0 | `pb_seek` |
| `LOCK #f` / `UNLOCK #f` | ✅ | v0.1.0 | `pb_lock` / `pb_unlock` |
| `RESET` / `FLUSH #f` | ✅ | v0.1.0 | `pb_reset` / `pb_flush` |
| `NAME old$ AS new$` | ✅ | v0.1.0 | `pb_name` |
| `BEEP` | ✅ | early | `Beep(800, 300)` (kernel32) |
| `SWAP a, b` | ✅ | 2 (v0.1.03) | register-level load/store exchange |
| `MKDIR` / `RMDIR` / `CHDIR` / `KILL` + `ERR` / `ERRCLEAR` | ✅ | early | `_mkdir` / `_rmdir` / `_chdir` / `pb_kill` + `@pb_err` global — PB-compatible error codes (75/76/53) on failure |
| Built-in string equates — all 18 ANSI forms (`$CRLF`, `$TAB`, `$DQ`, `$WHITESPACE`, …) | ✅ | 17 (v0.1.10) | compile-time string constants (byte-verified against the official table); `$$` wide single-char forms as numeric constants |
| `CHR$(a, b, c)` multi-argument | ✅ | early | one byte per argument, concatenated (`CHR$(13,10)` = CR+LF) |
| `RND` bare form (no parens) | ✅ | early | same as `RND()` — random double in [0,1) |
| `INPUT #f, s$` reading `WRITE #` output | ✅ | v0.1.0 | CSV double-quotes stripped per PB semantics |
| `PRINT` console output | ✅ | early | flushed immediately after each line (visible under redirection / on abort) |
| `CLS` | ✅ | early | `pb_cls` → clears the console screen (PB/CC) |
| `ERROR n` | ✅ | early | sets the PB error code (readable via `ERR`) |
| `ENVIRON "VAR=value"` | ✅ | early | `pb_environ_set` → `_putenv`; bare `ENVIRON "VAR"` removes the variable |
| `FILECOPY src$, dst$` | ✅ | early | `pb_filecopy` → `CopyFileA`, PB-compatible `ERR` on failure (53/70/76) |
| `SETATTR "path", attr&` | ✅ | early | `pb_setattr` → `SetFileAttributesA`, PB-compatible `ERR` on failure |
| `TIX` | ✅ | 1 (v0.1.03) | `pb_tix` → 64-bit millisecond tick counter |
| `MKBYT$(n)` | ✅ | 1 (v0.1.03) | `pb_mkbyt` → one-byte string |
| `ISINFINITE(x)` / `ISNORMAL(x)` | ✅ | 1 (v0.1.03) | `pb_isinfinite` / `pb_isnormal` — IEEE-754 checks (-1/0) |
| `PLAY WAVE "file.wav"` | ✅ | 1 (v0.1.03) | `PlaySoundA` (async) |
| `PLAY SOUND freq, dur` | ✅ | 3 (v0.1.03) | `Beep(freq, dur)` (kernel32) |
| `CHDRIVE "C:"` | ✅ | 1 (v0.1.03) | `_chdrive` — PB-compatible `ERR` (68) on failure |
| `DIR$` / `DIR` function + statement family | ✅ | 24 (v0.1.18) | `FindFirstFileA/FindNextFileA/FindClose` — `DIR$(mask)` / `DIR$(NEXT)` / `DIR mask [ONLY attr] TO s$` / `DIR NEXT TO s$` / `DIR CLOSE` |
| `LET t2 = t1` (whole TYPE) |
| `MAT a() = CON / CON(expr) / IDN / ZER / a() + b() / a() - b() / a() * b() / (expr) * a() / TRN(a()) / INV(a())` | ✅ | 32 (v0.1.26) | `pb_mat_fill/copy/add/scale/identity/trn/mul/inv` — matrix algebra, is_float element decoding (batch 32) |
| `CALLSTK` (CALLSTKCOUNT / CALLSTK$(n) / CALLSTK filename$ dump) | ✅ | 33 (v0.1.27) | `pb_callstk_push/pop/count/get/dump` — per-procedure call-stack tracing, 1-based innermost-first frame names (batch 33) |
| `PROFILE filename$` | ✅ | 34 (v0.1.28) | `pb_profile_enable/dump` — call counts + elapsed ms per procedure, PB-compatible "<Name>, <Call Count>, <Time mSec>" report (batch 34) | ✅ | 24 (v0.1.18) | `pb_type_set` — full user-defined-type copy incl. fixed-string fields |
| `SETEOF #f` | ✅ | 1 (v0.1.03) | `pb_seteof` → truncates file at current position |
| `SHIFT LEFT/RIGHT var, n` · `SHIFT SIGNED LEFT/RIGHT var, n` | ✅ | 2 (v0.1.03) | `pb_shift_left/right` (logical) + `pb_shift_sleft/sright` (arithmetic) |
| `ROTATE LEFT/RIGHT var, n` | ✅ | 2 (v0.1.03) | `pb_rotate_left/right` (wrapping) |
| `ARRAY REVERSE arr` | ✅ | 2 (v0.1.03) | `pb_array_reverse` — in-place element reversal |
| `ARRAY SHUFFLE arr` | ✅ | 3 (v0.1.03) | `pb_array_shuffle` — in-place Fisher-Yates |
| `PUT$ = ...` | ✅ | 2 (v0.1.03) | `pb_put_string` — string to file (binary) |
| `GET$ #f, count, var$` | ✅ | 15 (v0.1.08) | `pb_get_string` — read count bytes from a binary file into a string |
| `SPLIT [WORD] src$, a TO b, c` | ✅ | 3 (v0.1.03) | `pb_split` — returns pieces via `PARSE$`-compatible out-params |
| `DATA ...` / `READ var, ...` / `RESTORE` | ✅ | 4 (v0.1.03) | `pb_data_append` / `pb_read_data_str/num` / `pb_data_reset` — DATA pool with cursor + RESTORE rewind |
| `PEEK(datatype, addr)` / `POKE datatype, addr, v, ...` | ✅ | 5 (v0.1.03) | `pb_peek8/16/32/64/f/d` / `pb_poke8/16/32/64/f/d` — BYTE/WORD/DWORD/INTEGER/LONG/QUAD/SINGLE/DOUBLE; addresses are 64-bit (use `QUAD` vars for `VARPTR`) |
| `BIT` function / `BIT SET/RESET/TOGGLE var, n` / `BIT CALC var, n, expr` | ✅ | 6 (v0.1.04) | register-level bit ops (in-place, any integral var) |
| `PROCESS GET PRIORITY TO var` / `PROCESS SET PRIORITY pri` | ✅ | 6 (v0.1.04) | `GetPriorityClass` / `SetPriorityClass` |
| `LOF(f)` / `LOC(f)` / `SEEK(f)` | ✅ | 7 (v0.1.04) | `pb_lof` / `pb_loc` — file length / current position (QUAD) |
| `ARRAY DELETE arr(i) [FOR count]` | ✅ | 8 (v0.1.04) | `pb_array_delete` — element(s) removed, tail zeroed |
| `ARRAY INSERT arr(i), value` | ✅ | 9 (v0.1.04) | `pb_array_insert_num/str` — element inserted, last shifts out (fixed arrays) |
| `ARRAY SCAN arr(), OP expr, TO var` | ✅ | 10 (v0.1.04) | `pb_array_scan_num/str` — first matching relative index, 0 = none (`= <> < > <= >=`) |
| `MKI$` / `MKWRD$` | ✅ | 16 (v0.1.09) | `pb_mkint` (2-byte little-endian) |
| `MKL$` / `MKDWD$` | ✅ | 16 (v0.1.09) | `pb_mklong` (4-byte little-endian) |
| `MKQ$` / `MKCUR$` / `MKCUX$` | ✅ | 16 (v0.1.09) | `pb_mkquad` (8-byte little-endian) |
| `MKS$` | ✅ | 16 (v0.1.09) | `pb_mksingle` (4-byte IEEE-754) |
| `MKD$` | ✅ | 16 (v0.1.09) | `pb_mkdouble` (8-byte IEEE-754) |
| `DESKTOP GET CLIENT TO w&, h&` | ✅ | 16 (v0.1.09) | work-area size (`SystemParametersInfoA` SPI_GETWORKAREA) |
| `DESKTOP GET LOC TO x&, y&` | ✅ | 16 (v0.1.09) | work-area origin (same call) |
| `DESKTOP GET PPI TO x&, y&` | ✅ | 16 (v0.1.09) | `GetDeviceCaps` LOGPIXELSX/Y |
| `DESKTOP GET SIZE TO w&, h&` | ✅ | 15 (v0.1.08) | screen size in pixels (`GetSystemMetrics` SM_CXSCREEN/SM_CYSCREEN) |
| `LEN(str)` fix | ✅ | 16 (v0.1.09) | BSTR byte-length prefix (`pb_str_len`) — correct length for strings containing NUL bytes |
| `ON ERROR GOTO / GOTO 0 / RESUME NEXT` | ✅ | 25 (v0.1.19) | per-function run-time error trap + disarm |
| `RESUME / RESUME NEXT / RESUME FLUSH / RESUME label` | ✅ | 25 (v0.1.19) | four continuation forms after error handler |
| `REGISTER` | ✅ | 25 (v0.1.19) | optimization hint, accepted as LOCAL |
| `PREFIX "..." / END PREFIX` | ✅ | 26 (v0.1.20) | preprocessor text transform — prepends source to every line between |
| `TRY / CATCH / FINALLY / EXIT TRY` | ✅ | 26 (v0.1.20) | structured run-time error trapping reusing the ON ERROR machinery |
| `ON CALL` | ✅ | 27 (v0.1.21) | `ON expr CALL proc(args), fn(args) TO var` — 1-based dispatch to SUB/FUNCTION targets, out-of-range falls through |
| `GET$$ #f, count, var$` / `PUT$$ #f, expr$` | ✅ | 27 (v0.1.21) | WIDE (UTF-16LE) string I/O — `pb_get_wstring` / `pb_put_wstring` via MultiByteToWideChar / WideCharToMultiByte |
| `MACRO / END MACRO` | ✅ | 27 (v0.1.21) | preprocessor text substitution — single-line expression macros + multi-line statement macros |
| `STATIC` (real semantics) | ✅ | 23 (v0.1.17) | module-global slot keeps value across calls |
| `ARRAY ASSIGN dst() = src()` | ✅ | 23 (v0.1.17) | `pb_array_copy` — whole-array copy |
| `TYPE SET t2 = t1` | ✅ | 23 (v0.1.17) | `pb_type_set` — same machinery as `LET` with TYPEs |
| `WINDOW SET TEXT s$` / `WINDOW GET TEXT TO s$` | ✅ | 23 (v0.1.17) | `SetConsoleTitleA` / `GetConsoleTitleA` console-title bridge |
| `LPRINT` / `LPRINT ATTACH/CLOSE/FLUSH/FORMFEED` | ✅ | 22 (v0.1.16) | `pb_lprint_*` — printer device output |
| `TRACE` / `TRACE PRINT` | ✅ | 22 (v0.1.16) | `pb_trace_new` — trace buffer flushed to file |
| `IMPORT ADDR func$ TO addr&` / `IMPORT CLOSE` | ✅ | 22 (v0.1.16) | `pb_import_addr` — runtime GetProcAddress |
| `CALL DWORD target` | ✅ | 22 (v0.1.16) | indirect call through an imported / QUAD address |
| `FILESCAN #f, RECORDS TO n, WIDTH TO w` | ✅ | 20 (v0.1.13) | `pb_filescan` — record count / max record width |
| `ARRAY ARRAYIX arr(), i` | ✅ | 20 (v0.1.13) | element = index |
| `DECLARE` / `TYPE/END TYPE` | ✅ | 20 (v0.1.13) | external declarations + user-defined types |
| `ON GOTO n, ...` / `ON GOSUB n, ...` | ✅ | 12 (v0.1.05) | dispatch to line labels by expression value (1-based, out-of-range continues) |
| `OPEN file FOR BINARY AS #f` + `GET #f, pos, var` / `PUT #f, pos, var` | ✅ | early | random-access binary I/O — `pb_open` r+b mode (no truncate) + `pb_get` / `pb_put` |
| `CLIPBOARD SET TEXT s$` / `GET TEXT TO s$` / `RESET` | ✅ | 13 (v0.1.06) | `pb_clipboard_set_text/get_text/reset` — GlobalAlloc + Set/GetClipboardData |
| `GLOBALMEM ALLOC/FREE/LOCK/SIZE/UNLOCK` | ✅ | 17 (v0.1.10) | `pb_globalmem_*` — Win32 global-memory heap |
| `MOUSEPTR` | ✅ | 17 (v0.1.10) | `pb_mouseptr` — LoadCursorA cursor style |
| `UCODEPAGE` | ✅ | 17 (v0.1.10) | `pb_ucodepage` — console output code page |
| `HOST ADDR "name" TO a&` / `HOST NAME TO a&` | ✅ | 14 (v0.1.07) | `pb_host_addr` (gethostbyname) / `pb_host_name` (gethostname) |
| `INPUT FLUSH` | ✅ | 13 (v0.1.06) | `pb_input_flush` — clears the keyboard type-ahead buffer |
| `OPTION EXPLICIT` / `REM` | ✅ | 13 (v0.1.06) | strict declaration checking / comment statement |
| `CSET var$ = expr` | ✅ | 15 (v0.1.08) | `pb_cset(_buf)` — assign into fixed-string buffer |
| `HEX$` | ✅ | v0.1.0 | 64-bit integer → hex string |
| `WAITKEY$` | ✅ | v0.1.14 | `pb_waitkey` — console `_getch`, redirected `getchar` dual mode (v0.1.14) |
| `ARRAY SORT arr()` | ✅ | early | `pb_array_sort` — in-place sort |
| `ARRAY COPY a() TO b()` / `SWAP a(), b()` / `UNIQUE a()` | ✅ | 14 (v0.1.07) | `pb_array_copy` / `pb_array_swap` / `pb_array_unique` |

### Core language (upstream, verified by the 15 official tests)
`PRINT`, `OPEN`, `CLOSE`, `PRINT #`, `LINE INPUT #`, `INPUT #`, `EOF`,
`FREEFILE`, `KILL`, `IF/THEN/ELSE`, `FOR/NEXT`, `WHILE/WEND`, `DO/LOOP`,
`GOTO` + labels, `GOSUB/RETURN`, `FUNCTION`/`CALL`, `DIM`/`GLOBAL`/`LOCAL`,
arrays, and core string/numeric built-ins — **✅**

### Live demos
- `examples/demo.bas` — **full-feature showcase**: control flow, all 18 string
  equates, REPLACE/LSET/RSET, arrays+ERASE, file I/O (WRITE#/SEEK#/LOCK/UNLOCK/
  RESET/FLUSH/NAME/KILL), directories + PB-compatible `ERR` codes, RANDOMIZE/RND,
  SWAP, CURDIR$/ISFILE, BEEP, SLEEP, MSGBOX and SHELL. Compiles with one command
  and prints `ALL FEATURES VERIFIED OK` to the console (plus a final MSGBOX).
- `official_hello.bas` — the **original PowerBASIC 10 samples `Hello.bas`**
  (from a licensed PB/Win 10 install) compiles unmodified after charset
  conversion and runs as a 64-bit native exe, proving drop-in compatibility
  with the official sample suite (sample itself is (c) PowerBASIC, Inc.).

### Parsed but produces NO code (reported, not silent)
| Statement | Notes |
| --- | --- |
| `INPUT` (console) | ⚠️ console input not implemented |
| `ON ERROR GOTO` / `ON ERROR` / `RESUME` | ⚠️ error handling deferred |
| `REMOVE` | ⚠️ |
| `#INCLUDE` (inside a SUB) | ⚠️ only top-level include works |
| `%CONSTANT` | ⚠️ |
| `END` (mismatched / standalone) | ⚠️ |
| `LINE INPUT` (console, no `#`) | ⚠️ |
| `LINE` (drawing) | ⚠️ |
| `OPEN` (unknown mode) | ⚠️ |
| `CLOSE` (no file number) | ⚠️ |
| `DIALOG` / `CONTROL` / `MENU` / `TOOLBAR` / `STATUSBAR` | 🔲 Tier 3 GUI |
| `COMBOBOX` / `LISTBOX` / `TREEVIEW` / `LISTVIEW` / `XPRINT` | 🔲 Tier 3 GUI |

> Every ⚠️ / 🔲 line is reported in `*.unimplemented.log` after each build
> with its exact source line, so nothing is silently dropped.

---

## Changelog

### v0.1.28 (2026-09-15) — Batch 34: PROFILE per-procedure profiling
One more *Not implemented* item moved to *Implemented* (coverage: **197 implemented / 104 not implemented / 202 tier-3 DDT**):
- **PROFILE filename$** — per-procedure execution report: every procedure's call count and total elapsed time in milliseconds, written as `<Name>, <Call Count>, <Time mSec>` per line (PB-compatible format).
- The existing CALLSTK call-stack frames now also record a high-resolution entry tick when profiling is enabled (codegen enables it at the `main` entry, so PROFILE placed last in PBMAIN sees the full picture). Pop accumulates elapsed ms on the frame that owns the tick, so nested calls are attributed to the correct procedure.
- Runtime: `pb_profile_enable` + `pb_profile_dump` (GetTickCount64). No profiling overhead when no PROFILE statement exists (single flag branch in push/pop).
- Tests: examples/batch34_test.bas (2/2 — WORK called 3 times ≈ 60+ ms in profile.log), official regression 14/14 ALL PASS, fmt + clippy clean.

### v0.1.27 (2026-09-15) — Batch 33: CALLSTK call-stack tracing
One more *Not implemented* item moved to *Implemented* (coverage: **196 implemented / 105 not implemented / 202 tier-3 DDT**):
- **CALLSTKCOUNT** — returns the current call-stack depth as a LONG (1 = PBMAIN; 2 = PBMAIN + one called procedure, ...).
- **CALLSTK$(n)** — returns the procedure name of the n-th frame (1-based, innermost first); out-of-range returns an empty string. Names are the source identifiers as parsed (case-insensitive, stored uppercase).
- **CALLSTK filename$** — writes every active frame to the sequential file, innermost first, one per line (e.g. TestB / TestA / PBMAIN).
- Codegen pushes the procedure name at every function/sub entry and pops on every exit path (tail return, EXIT SUB, EXIT FUNCTION). Runtime: `pb_callstk_push/pop/count/get/dump` (max 256 frames). Parameter VALUES are not captured yet — names only, per the official docs' value display (documented limitation).
- Tests: examples/batch33_test.bas (7/7), official regression 14/14 ALL PASS, fmt + clippy clean.

### v0.1.26 (2026-09-15) — Batch 32: MAT matrix algebra
One more *Not implemented* item moved to *Implemented* (coverage: **195 implemented / 106 not implemented / 202 tier-3 DDT**):
- **MAT a() = RHS** — matrix algebra statement: `CON` (all ones), `CON(expr)`, `ZER`, whole-array assignment, elementwise `+` and `-`, scalar `(expr) * a()`, 2-D `IDN` (square identity), `TRN` (transpose, dst dims swapped), `*` (l×m × m×n multiply), `INV` (square inverse via Gauss-Jordan on the augmented [A|I]).
- Runtime `pb_mat_*` family (fill / copy / add / scale / identity / trn / mul / inv) with `is_float` element decoding (SINGLE/DOUBLE IEEE vs sign-extended integers; es 1/2/4/8). No bounds checking, per PB semantics.
- Parser: `parse_mat_statement` (bare or `()` array names; parenthesized scalar RHS forms).
- Tests: examples/batch32_test.bas (12/12), official regression 14/14 ALL PASS, fmt + clippy clean.

## Changelog

### v0.1.25 (2026-09-15) — Batch 31: FIELD / RANDOM record I/O

One more *Not implemented* item moved to *Implemented* (coverage: **194 implemented / 107 not implemented / 202 tier-3 DDT**):

- **FIELD** — the official FIELD statement family for random-file and dynamic-string field binding:
  - `FIELD #f, nSize AS fieldvar [, FROM nStart TO nEnd AS fieldvar ...]` binds a field variable to a sub-section of a RANDOM file's record buffer.
  - `FIELD dyn$, nSize AS fieldvar` binds **by reference** to a string variable's payload slot — reassigning the string follows automatically; assignments to a FIELD-bound string copy into a fresh mutable buffer (a plain pointer store would land in a read-only string constant and crash on write).
  - `FIELD STRING var` copies the current sub-section into a private buffer; `FIELD RESET var` unbinds (field reads as empty).
  - `OPEN "file" FOR RANDOM AS #n LEN=reclen` opens/creates a fixed-record-length file; `PUT #n` / `GET #n` (current record) and `PUT #n, rec` / `GET #n, rec` (numbered records) move the record pointer; short assignments pad with blanks per PB semantics.
  - Field variables must be declared (`LOCAL f AS FIELD`, 24-byte internal storage). RANDOM record buffers live only while the file is open — `FIELD STRING` must happen before `CLOSE`.
- Tests: examples/batch31_test.bas (7/7), official regression 14/14 ALL PASS, fmt + clippy clean.

### v0.1.24 (2026-09-14) — Batch 30: ASMDATA / END ASMDATA

One more *Not implemented* item moved to *Implemented* (coverage: **193 implemented / 108 not implemented / 202 tier-3 DDT**):

- **ASMDATA / END ASMDATA** — read-only data blocks defined outside any Sub/Function:
  `ASMDATA BlockName` followed by `DB` / `DW` / `DD` / `DQ` lines and terminated by `END ASMDATA`.
  Data is packed contiguously and **never aligned** (per the PB manual), so every item's byte offset is
  exact. ANSI string literals go in `DB`, WIDE (UTF-16LE) string literals go in `DW`; decimal and `&H`
  hex literals are supported in all four widths. The block is emitted as a `@__asmdata_<NAME>` private
  constant byte blob and its address is obtained with `CODEPTR(BlockName)` — the PB-documented access
  path (the ASM-side `LEA`/`MOV ..., Offset Name` form is left to a future batch). Read-back verified
  byte-for-byte with `PEEK` (BYTE / WORD / DWORD / QUAD).
- Bug fixed on the way: `PEEK(DWORD, addr)` was mapped to the 2-byte `pb_peek16` helper (batch-5 era), so
  it returned only the low 16 bits; it now calls `pb_peek32` (4 bytes) like `PEEK(LONG)` already did.

Verified: `examples/batch30_test.bas` (14/14 PASS — byte layout of DB/DW/DD/DQ, ANSI + WIDE strings,
CODEPTR address), official regression 15/15 ALL PASS, fmt + clippy clean.

### v0.1.23 (2026-09-14) — Batch 29: Inline ASM (`!` and `ASM` statements)

One more *Not implemented* item moved to *Implemented* (coverage: **192 implemented / 109 not implemented / 202 tier-3 DDT**):

- **ASM** — inline assembly via the `!` shortcut or the `ASM` keyword. Each ASM line is emitted as an
  LLVM `call void asm sideeffect inteldialect ...` instruction; **consecutive ASM lines are merged into one
  asm block so register state is preserved** (e.g. `! MOV EAX, [x]` then `! MOV y, EAX`). PB variable
  operands are passed by pointer (`byte/word/dword/qword ptr [$N]`) with the width taken from the declared
  PB type. Automatic register-shuffling handles the two x86 cases that cannot be encoded directly:
  mem-to-mem operands (source loaded into a constraint-allocated scratch register) and 64-bit stores with an
  immediate larger than i32 (split into lo/hi dword stores, which is also what makes QUAD stores work on
  i686). Registers, immediates, bracketed memory operands and quoted strings pass through verbatim, so the
  full instruction set is available — 8086→Pentium, x87 floating point (`FLD1`/`FSTP` to a DOUBLE),
  MMX (`PXOR`/`EMMS`) and SSE (`XORPS`) were all compile- and run-verified.
- Honest limits (documented): one run of consecutive ASM lines preserves registers, but there is no
  label/jump support across statements; callee-saved registers are assumed preserved by the user;
  `ASMDATA/END ASMDATA` data blocks were shipped in v0.1.24 (next batch).

Verified: `examples/batch29_test.bas` (11/11 PASS on x86-64, incl. x87/MMX/SSE), `examples/batch29_x86_test.bas`
(32-bit, exit code 0 — avoids the 32-bit `_printf` symbol gap in PRINT, which is a separate upstream issue),
official regression 15/15 ALL PASS, fmt + clippy clean.

### v0.1.22 (2026-09-14) — Batch 28: THREADED (thread-local storage)

One more *Not implemented* item moved to *Implemented*
(coverage: **191 implemented / 110 not implemented / 202 tier-3 DDT**):

- **THREADED** — `THREADED var [()] [AS type] [, ...]` declares variables
  that are global to every Sub/Function but **not shared across threads**:
  each thread gets its own independent copy. Implemented as LLVM
  `thread_local` globals (`@__threaded_<NAME>`), with a dedup set so repeated
  declarations in several procedures emit one symbol. Scalars are supported
  (LONG / STRING / numeric); THREADED arrays (`THREADED arr()` + `DIM`) are
  not implemented yet and stay documented as pending.
  Verified: main sets tcount=1/tmsg="main", a `THREAD CREATE`d child writes
  its own tcount=2/tmsg="worker" (surfaced through plain globals), main still
  reads 1/"main" — per-thread isolation confirmed. Note: the test waits with
  `SLEEP` rather than a busy loop, because an optimizer may hoist an
  invariant global load out of a spin loop.
- Tests: examples/batch28_test.bas (1/1), official regression 15/15 ALL PASS,
  fmt + clippy clean.
### v0.1.21 (2026-09-14) — Batch 27: ON CALL / GET$$+PUT$$ / MACRO (4 statements)

Four more *Not implemented* items moved to *Implemented*
(coverage: **190 implemented / 111 not implemented / 202 tier-3 DDT**):

- **ON CALL** — `ON expr CALL proc1(args), func2(args) TO var, ...` dispatches
  to one of several procedures based on the value of an integral expression
  (1-based; out-of-range values fall through with no call). SUB and FUNCTION
  targets may be mixed; FUNCTION results land in the TO variable. Implemented
  as an if-chain dispatch table like ON GOTO / ON GOSUB. Verified: three SUBs
  selected by n=1..3, FUNCTION TO with STATIC counter, out-of-range no-op.
- **GET$$ / PUT$$** — wide-character (UTF-16LE) string I/O on binary files:
  - `PUT$$ #f, expr$` converts the ANSI string to UTF-16LE and writes it.
  - `GET$$ #f, count, var$` reads count WIDE characters (count*2 bytes),
    converts back to ANSI, and assigns the string variable.
  - Runtime helpers `pb_put_wstring` / `pb_get_wstring` use hand-rolled
    kernel32 dllimports of MultiByteToWideChar / WideCharToMultiByte.
  - Verified: PUT$$ "AB"+"CD" then SEEK 1 + GET$$ 2 twice reads back AB, CD.
- **MACRO / END MACRO** — compile-time text substitution in the preprocessor:
  - Single-line macros `MACRO name(p1, p2) = replacement` expand anywhere in
    a line (expression position), with parameter substitution; no-argument
    macros (`MACRO AppTitle = "..."`) expand as plain tokens.
  - Multi-line macros `MACRO name(...) ... END MACRO` expand at statement
    position (line start) into their replacement lines, with parameter
    substitution.
  - Macro functions (`MACRO FUNCTION` / `END MACRO = expr`), MACROTEMP
    unique-renaming and EXIT MACRO are not expanded yet (definitions are
    consumed and skipped).
  - Verified: expression macro `muldivide(3,3,2)+10` -> 14, no-arg constant,
    and a Swap2(a,b) multi-line macro (STATIC-style local DIM inside).
- Fixed the lexer: `$` identifier suffix now consumes `$$` too, so `GET$$` /
  `PUT$$` lex as a single identifier (previously the second `$` was dropped).
- Verified in examples/batch27_test.bas (7 scenarios). Official regression
  **14/14 ALL PASS**, fmt + clippy clean.

### v0.1.20 (2026-09-14) — Batch 26: PREFIX / TRY (2 statements)

Two more *Not implemented* items moved to *Implemented*
(coverage: **190 implemented / 111 not implemented / 202 tier-3 DDT**):

- **PREFIX / END PREFIX** — compile-time text transform implemented in the
  preprocessor: every line between `PREFIX "source code"` and `END PREFIX`
  has the given source code prepended (e.g. `PREFIX "PRINT "` turns the
  next lines into PRINT statements). Reduces repetitive typing for object
  members, UDT fields and command prefixes. Verified: two prefixed PRINT
  lines expand and run correctly.
- **TRY / CATCH / FINALLY / EXIT TRY** — structured run-time error trapping:
  - Statements in the TRY body run normally; the first statement that sets
    a run-time error (ERR <> 0) jumps to the CATCH block.
  - CATCH runs only when an error occurred; trapping is disabled inside it,
    so you read ERR with a conventional `IF ERR = ...` test.
  - FINALLY runs unconditionally (error or not), then execution continues
    after END TRY.
  - EXIT TRY jumps to the statement following END TRY.
  - TRY structures nest; each structure clears and restores the error flags
    (documented approximation: ERR is reset to 0 on exit rather than
    restored to the pre-TRY value, and EXIT TRY skips FINALLY).
  - Reuses the batch-25 ON ERROR trap machinery, so MKDIR / RMDIR / KILL
    and friends trigger CATCH exactly like they trigger ON ERROR handlers.
- Verified in examples/batch26_test.bas (7 scenarios: PREFIX expansion,
  TRY/CATCH on ERR=75, no-error CATCH skip, CATCH+FINALLY, FINALLY-only,
  EXIT TRY, nested TRY). Official regression **14/14 ALL PASS**,
  fmt + clippy clean.

### v0.1.19 (2026-09-14) — Batch 25: ON ERROR / RESUME / REGISTER (3 statements)

Three more *Not implemented* items moved to *Implemented*
(coverage: **184 implemented / 117 not implemented / 202 tier-3 DDT**):

- **ON ERROR GOTO** — run-time error trapping:
  - ON ERROR GOTO {label|line} arms a per-function handler; the trap
    fires when a statement sets a run-time error (ERR <> 0), records the
    failing statement, and jumps to the handler.
  - ON ERROR GOTO 0 / ON ERROR RESUME NEXT disarm the trap.
  - Trapping is suspended while the handler runs, so handler code can call
    statements without re-triggering.
- **RESUME** — four continuation forms (all verified):
  - RESUME re-executes the statement that failed.
  - RESUME NEXT continues on the statement after the failed one.
  - RESUME FLUSH does not transfer control — execution simply continues
    on the line after the RESUME FLUSH (per the official docs).
  - RESUME label continues at a local label.
- **REGISTER** — accepted as an optimization hint with LOCAL
  semantics (declarations and typing work exactly like LOCAL).
- Error checking covers the runtime-call statements that set ERR
  (MKDIR / RMDIR / KILL / ...). As in PB, numeric errors (divide-by-zero,
  overflow) are not trapped and array bounds checks need #DEBUG ERROR ON.
- Verified in examples/batch25_test.bas (6 scenarios: REGISTER typing,
  GOTO+RESUME NEXT, RESUME retry, RESUME label, GOTO 0 disarm,
  RESUME FLUSH, no-error no-trap). Official 14 tests: 14/14 pass;
  fmt + clippy clean.

### v0.1.18 (2026-09-13) — Batch 24: DIR function/statement family + LET with TYPEs (2 statements)

Two more *Not implemented* items moved to *Implemented*
(coverage: **181 implemented / 120 not implemented / 202 tier-3 DDT**):

- **DIR FUNCTION AND** — the full `DIR`/`DIR$` family backed by
  `FindFirstFileA`/`FindNextFileA`/`FindClose` (hand-rolled dllimport in
  the runtime):
  - Function form: `s$ = DIR$(mask)` finds the first matching file,
    `s$ = DIR$(NEXT)` returns each following match, and an empty string
    means no more matches.
  - Statement form: `DIR mask TO s$`, `DIR NEXT TO s$`, and
    `DIR CLOSE` / `DIR$ CLOSE`.
  - Attribute filtering: `DIR mask, ONLY attr TO s$` (and the equivalent
    function form) returns only files whose attributes exactly match
    `attr` (2=hidden, 4=system, 8=volume label); without `ONLY` only
    normal files are returned and directories are skipped.
  - Verified in `examples/batch24_test.bas`: `DIR$("batch24_dir_*.tmp")`
    → first file, `DIR$(NEXT)` → second file, and the statement forms
    reproduce the same sequence.
- **LET *(WITH TYPES)*** — whole-TYPE assignment `t2 = t1` copies the
  entire user-defined-type value (including fixed-length string fields)
  in one operation. Verified in `examples/batch24_test.bas`.

Also confirmed working in this batch (already implemented upstream, now
explicitly covered by the official docs): `GET$` (read N bytes from a
binary file into a string) and `PUT$` (write a string's bytes to a
binary file) — `examples/batch24_test.bas` does a full
`OPEN ... FOR BINARY` → `PUT$` → `SEEK` → `GET$` round-trip.

### v0.1.17 (2026-09-13) — Batch 23: real STATIC semantics + ARRAY ASSIGN + TYPE SET + WINDOW console title (5 statements)

Five long-standing *Not implemented* items moved to *Implemented*
(coverage: **179 implemented / 122 not implemented / 202 tier-3 DDT**):

- **STATIC** — variables declared with `STATIC` are now stored in
  module-global slots (per-function unique names), so the value **persists
  across calls** instead of being reset like `LOCAL`. `STATIC counter AS
  LONG` now counts 1, 2, 3 across three calls (verified in
  `examples/batch23_test.bas`).
- **ARRAY ASSIGN** — `ARRAY ASSIGN target() = source()` copies the source
  elements into the target array via `pb_array_copy` (element count =
  min of both declared sizes).
- **TYPE SET** — `TYPE SET dest = src` fills a TYPE variable with the
  bytes of another TYPE variable (`pb_type_set`, raw memcpy) or of a
  STRING (`pb_type_set_str`, memcpy min(len, size) + zero-fill).
- **WINDOW SET TEXT / WINDOW GET TEXT** — console-title bridge:
  `WINDOW SET TEXT hwnd, text$` calls SetConsoleTitleA and
  `WINDOW GET TEXT hwnd TO s$` reads it back via GetConsoleTitleA
  (the hwnd argument is ignored in console builds).

Bug fixed along the way: assigning to a `STRING * N` field of a TYPE
variable used to store a pointer into the fixed buffer (corrupting it);
the TypeMember assignment path now uses strncpy + NUL-termination, the
same as top-level fixed strings.

### v0.1.16 (2026-09-13) — Batch 22: LPRINT + TRACE + IMPORT ADDR + CALL DWORD (8 statements)

Two statement families and the dynamic-library bridge moved from *Not
implemented* to *Implemented* (coverage: **174 implemented / 127 not
implemented / 202 tier-3 DDT**):

- **LPRINT** — `LPRINT ATTACH` (CreateFileA open of a device or file;
  quoted string or device name), `LPRINT` (write text/number/CRLF),
  `LPRINT CLOSE` (CloseHandle), `LPRINT FLUSH` (FlushFileBuffers),
  `LPRINT FORMFEED` (form-feed 0x0C). Output goes to the attached device
  until detached.
- **TRACE** — `TRACE NEW` (open explicit trace log file), `TRACE ON` /
  `TRACE OFF` (enable/disable gating), `TRACE PRINT` (append a line;
  numbers are formatted through the numeric-to-string path), `TRACE
  CLOSE`. Unlike upstream's silent drop, the log file is real and gated.
- **IMPORT / CALL DWORD** — `IMPORT ADDR "proc", "dll" TO a&&, h&&`
  resolves LoadLibraryA + GetProcAddress into **QUAD (8-byte) variables**
  — required because x64 system-DLL addresses exceed 32 bits; storing a
  truncated DWORD and zero-extending it produces a bad pointer. `CALL
  DWORD a&& USING fn() TO r&` performs the indirect call (USING argument
  list + optional TO result supported), and `IMPORT CLOSE h&&` releases
  the module.

Runtime notes: the new `pb_lprint_*` / `pb_trace_*` / `pb_import_*`
helpers follow the established payload-pointer convention (runtime
arguments are C-string payloads; numeric TRACE arguments skip the 4-byte
BSTR prefix in codegen). The official 14-test suite still passes 14/14.

### v0.1.15 (2026-09-13) — Batch 21: COMM serial port + THREAD control (16 statements)

Two statement families moved from *Not implemented* to *Implemented*
(coverage: **166 implemented / 135 not implemented / 202 tier-3 DDT**):

- **COMM** serial-port statements — `COMM OPEN` (CreateFileA + DCB
  BaudRate/ByteSize/Parity/StopBits + SetCommTimeouts; PB comm channel
  0..255), `COMM CLOSE`, `COMM RESET`, `COMM SEND`, `COMM RECV` (n bytes
  into a PB string), `COMM LINE INPUT` (byte-wise ReadFile until LF),
  `COMM PRINT` (str/int/dbl variants), `COMM SET` (EscapeCommFunction
  DTR/RTS/BREAK on/off), `COMM TIMEOUT` (SetCommTimeouts constants).
- **THREAD** control statements — `THREAD CREATE` (CreateThread on x64;
  the PB-side id is a slot number 0..255 holding the real HANDLE, same
  pattern as GLOBALMEM), `THREAD CLOSE` (TerminateThread + CloseHandle),
  `THREAD SUSPEND` / `THREAD RESUME`, `THREAD STATUS` (GetExitCodeThread
  STILL_ACTIVE: 1 running / 2 suspended / 3 finished), `THREAD GET
  PRIORITY` / `THREAD SET PRIORITY` (Get/SetThreadPriority).
  On 32-bit, THREAD CREATE deliberately fails closed (PB functions are
  cdecl; calling through a stdcall thread-proc pointer would corrupt the
  stack), so no crash is possible.
- Fixed along the way: bare `WAITKEY$` as a statement now also generates
  code (previously only `x$ = WAITKEY$` worked); `THREAD RESUME/CLOSE`
  parsing now handles RESUME/CLOSE as reserved-word tokens.
- Verified live: `examples/batch21_test.bas` — COMM gracefully fails on a
  missing COM port (no crash); thread spin-loop reports id=0, status
  1 (running) -> suspend 2 -> resume 1 -> close, priority 0; exit 0.
- Official regression: **14/14 ALL PASS**, fmt + clippy clean, coverage
  CSV/MD fully synced.

### v0.1.14 (2026-09-13) — WAITKEY$ + press-any-key exit on every example

- **WAITKEY$** implemented (official PB console function). Interactive consoles
  use `_getch` (returns the moment a key is pressed, no Enter needed); when
  stdin is redirected (pipes / CI) it reads a char from stdin instead, so
  automated tests can feed a key — verified live: `x | example.exe` exits
  cleanly with the key echoed back.
- **All 41 `examples/*.bas` now end with a user-visible wait** so the output
  stays on screen until the user presses a key: console programs print
  `Press any key to exit...` then `waitk = WAITKEY$`; GUI programs
  (`#CONSOLE OFF`) show a `MSGBOX "Press OK to exit."`.
- Verified: 41/41 examples compile, representative runs exit only after the
  fed key, official regression **14/14 ALL PASS**, fmt + clippy clean.

### v0.1.13 (2026-09-13) — Batch 20: array element ops + file scanning, coverage cleanup
 — Batch 20: array element ops + file scanning, coverage cleanup

Five statements moved from *Not implemented* to *Implemented*
(coverage: **150 implemented / 151 not implemented / 202 tier-3 DDT**):

- **ARRAY ARRAYIX** `arr()` — set every element to its own element index
  (numeric and string arrays; batch 20).
- **FILESCAN** `[#] fnum&, RECORDS TO y& [, WIDTH TO x&]` — count records in an
  open file: INPUT mode counts CRLF-delimited records and longest record width;
  BINARY mode counts PB packed strings (2-byte length prefix, `0xFFFF` marker +
  4-byte length for strings > 65535 bytes). Runtime now tracks the open mode
  (`file_modes[]`) so the same function serves both file kinds.
- **LOCAL** / **DECLARE** / **TYPE/END TYPE** — promoted to implemented after a
  live declaration test (local/static variables, `DECLARE SUB` prototypes, UDT
  definitions and field access verified end-to-end).
- Note: `STATIC` remains Not implemented — it currently behaves like LOCAL
  (value resets on every call); a real static-storage implementation is tracked
  for a later batch.
- Verified live: `examples/batch20_test.bas` — ARRAYIX `1,2,3,4,5`, SCAN >20 = 3,
  SCAN =25 = 4, DELETE/INSERT shifts correct, FILESCAN 3 records / width 16.
- Official regression: **14/14 ALL PASS**, fmt + clippy clean.

### v0.1.12 (2026-09-13) — Batch 19: TCP + UDP sockets (11 statements)
 — Batch 19: TCP + UDP sockets (11 statements)

Real Winsock networking for PB programs — the first network layer in the enhanced
compiler. 11 statements moved from *Not implemented* to *Implemented*
(coverage: **145 implemented / 156 not implemented / 202 tier-3 DDT**):

- **TCP OPEN** `[SERVER] {PORT p | srvc} [AT addr$] AS #f [TIMEOUT t]` — Winsock
  socket + connect (client) or bind/listen (server); SO_RCVTIMEO from TIMEOUT.
- **TCP ACCEPT** `#srv AS #new` — accept a pending connection into a new file number.
- **TCP SEND** / **TCP RECV** — send / receive raw bytes (RECV into a PB string).
- **TCP LINE INPUT** — read one CRLF-terminated line into a PB string.
- **TCP PRINT** — send text + CRLF.
- **TCP CLOSE** — close a socket.
- **UDP OPEN** `[PORT p] AS #f [TIMEOUT t]` — SOCK_DGRAM; with PORT = server
  (bind), without PORT = client (random local port, per official docs).
- **UDP SEND** `#f, AT ip&, pNum&, data$` — sendto; **AT accepts either a LONG
  IP value or a string like "127.0.0.1"** (runtime converts via inet_addr).
- **UDP RECV** `#f, FROM ip&, pNum&, buf$` — recvfrom; writes source ip/port.
- **UDP CLOSE** — close a UDP socket.

Implementation notes (gotchas fixed in this batch):

- TCP/UDP **OPEN / PRINT / CLOSE are reserved-word tokens** (`Token::Open`,
  `Token::Print`, `Token::Close`), not identifiers — the parser op-dispatch must
  match them explicitly or the whole statement silently became a NOOP.
- `TCP ACCEPT #1 AS #2` — `AS #` needs an explicit `#` skip before parsing the
  new file number; without it `parse_expression` hit `#` and the statement was
  silently dropped (no codegen at all).
- Winsock is declared by hand (`__declspec(dllimport)`) with a self-contained
  `struct pb_sockaddr_in` — no `<winsock2.h>`; `ntohs` hand-rolled as
  byte-swap (`ntohs_s`) and defined **before** first use.
- Runtime socket table `pb_sock[256]` + `pb_sock_state[256]` (0 free / 1 tcp /
  2 udp / 3 tcp-server).
- Loopback-verified on this machine: TCP echo (client `BACK: echo-back`, server
  `GOT: hello-from-client`) and UDP echo (both directions) — see
  `examples/tcp_echo_server.bas`, `examples/tcp_echo_client.bas`,
  `examples/udp_echo_server.bas`, `examples/udp_echo_client.bas`.

- Tests: official regression **15/15 ALL PASS** (compiler now reports 15 with
  crash_test included), fmt + clippy clean.

### v0.1.11 (2026-09-13) — Batch 18: #-metastatement audit (29 directives)

All 29 PowerBASIC **metastatements** (`#COMPILE`, `#DIM`, `#IF/#ELSEIF/#ELSE/#ENDIF`,
`#INCLUDE`, `#OPTION`, `#LINK`, `#STACK`, `#ALIGN`, `#BLOAT`, `#BREAK`, `#COM`,
`#COMPILER`, `#CONSOLE`, `#DEBUG *`, `#EXPORT`, `#MESSAGES`, `#OPTIMIZE`, `#PAGE`,
`#PBFORMS`, `#REGISTER`, `#RESOURCE`, `#TOOLS`, `#UNIQUE`, `#UTILITY`) are now
formally **implemented as compile-time directives**: the preprocessor/parser accept
them, conditionals (`#IF/#ELSEIF/#ELSE/#ENDIF`) are honored, and nothing leaks into
`*.unimplemented.log`. Verified with a dedicated test source exercising every
directive; behavior was already working, the audit documents it and removes them
from the unimplemented list.

- Tests: `examples/meta_test.bas` (compiles clean, runs, no unimplemented report),
  official regression **15/15 ALL PASS**, fmt + clippy clean.

### v0.1.10 (2026-09-13) — Batch 17: GLOBALMEM, MOUSEPTR, UCODEPAGE

- **GLOBALMEM ALLOC count TO h&** — allocate movable global memory
  (`GlobalAlloc(GMEM_MOVEABLE|GMEM_ZEROINIT)`). The 64-bit handle is stored in a
  runtime slot table and the PB variable receives a 1-based **slot id**, so it
  always fits a LONG/DWORD (no truncation).
- **GLOBALMEM SIZE h& TO size&** — `GlobalSize` of the block.
- **GLOBALMEM LOCK h& TO ptr** — `GlobalLock`, returns the pointer (0 on failure).
- **GLOBALMEM UNLOCK h& TO locked&** — `GlobalUnlock`, 1 = still locked, 0 = fully unlocked.
- **GLOBALMEM FREE h& TO result&** — `GlobalFree`, result 0 on success, nonzero on failure.
- **MOUSEPTR style [TO prev&]** — console cursor styles 0-13 mapped to Win32 stock
  cursors (0/12 hide the cursor, 13 = app-starting hourglass; PB/CC only).
- **UCODEPAGE ANSI|OEM|num [TO prev&]** — records the desired codepage
  (ANSI=CP_ACP, OEM=CP_OEMCP, or an explicit numeric codepage); returns the
  previous setting. Stored for future ANSI<->UNICODE conversions.
- Tests: `examples/batch17_test.bas` (9/9), official regression **15/15 ALL PASS**,
  fmt + clippy clean.

### v0.1.09 (2026-09-12) — Batch 16: MKx binary-string family + DESKTOP GET CLIENT/LOC/PPI

- **MKx binary-string family** — numeric values to fixed-length little-endian
  ANSI strings (`pb_mkint` / `pb_mklong` / `pb_mkquad` / `pb_mksingle` / `pb_mkdouble`):
  - `MKI$` / `MKWRD$` → 2 bytes · `MKL$` / `MKDWD$` → 4 bytes ·
    `MKQ$` / `MKCUR$` / `MKCUX$` → 8 bytes · `MKS$` → 4-byte single ·
    `MKD$` → 8-byte double.
  - `MKE$` (10-byte extended precision) remains unimplemented (x87 format).
  - Compatible with the CVx family (`CVI`/`CVL`/`CVQ`/...) for round-tripping.
- **DESKTOP GET CLIENT TO w&, h&** — size of the desktop work area (screen minus
  system tray), via `SystemParametersInfoA(SPI_GETWORKAREA)`.
- **DESKTOP GET LOC TO x&, y&** — origin of the work area (0,0 with bottom/right
  tray; TrayWidth/TrayHeight when tray is left/top).
- **DESKTOP GET PPI TO x&, y&** — display resolution in pixels per inch
  (`GetDeviceCaps` LOGPIXELSX/Y).
- **Fixed: `LEN()` on binary strings** — was `strlen` (stopped at the first NUL
  byte); now uses the BSTR byte-length prefix (`pb_str_len`). String literals now
  carry a 4-byte length prefix like runtime BSTRs, so `LEN(MKL$(1000))` = 4,
  `LEN(MKQ$(1000))` = 8, etc. Fixed-length (`STRING * N`) buffers keep strlen
  semantics.
- Tests: `examples/batch16_test.bas` (11/11), official regression **15/15 ALL PASS**,
  fmt + clippy clean.

### v0.1.08 (2026-09-12) — batch 15: CSET, GET$, DESKTOP GET SIZE (+ MKBYT$ confirmed)

- **CSET** `result_var = expr`: center-justifies a string in a fixed-length buffer
  (`pb_cset` / `pb_cset_buf`, pad left `(len-src)/2` spaces). ABS/USING not yet.
- **GET$** `[#]filenum&, Count&, StrgVar`: reads `Count` bytes from a BINARY file
  into a string variable (`pb_get_string`).
- **DESKTOP GET SIZE TO w&, h&**: screen size via `GetSystemMetrics` (SM_CXSCREEN /
  SM_CYSCREEN).
- **MKBYT$** confirmed implemented (runtime + codegen existed; coverage CSV/MD rows
  were malformed and are now fixed and marked implemented).
- Runtime note: string-writing helpers no longer `SysFreeString` the previous
  variable value — PB vars are often initialized to codegen string constants
  (not BSTRs) and freeing them crashed (0xC0000005). Old BSTRs leak instead.
- Tests: `examples/batch15_test.bas` (5/5), official regression **15/15 ALL PASS**,
  fmt + clippy clean.

### v0.1.07 (2026-09-12) — Batch 14: ARRAY COPY / SWAP / UNIQUE + HOST ADDR / HOST NAME
- `ARRAY COPY src(), dest()` — duplicate a whole array into another (fixed-array memcpy).
- `ARRAY SWAP a(), b()` — exchange all elements of two arrays.
- `ARRAY UNIQUE arr()` — remove duplicate elements in place (LONG/STRING), dedupes full array.
- `HOST ADDR [hostname$] TO ip&` — resolve a host name to an IP address (winsock `gethostbyname`).
- `HOST NAME [ip&] TO hostname$` — resolve an IP address to a host name (`gethostbyaddr` / `gethostname`).
- Links `ws2_32` for all EXE/DLL targets; requires Windows SDK lib dir (auto-detected).
- **Fixed** re-REDIM bug: a second `REDIM` of an already-declared array was silently dropped (array kept its first size, causing out-of-bounds writes). Arrays are now pre-scanned per function and stack-allocated at their maximum declared size; each `REDIM` refreshes the active bounds.


### v0.1.06 — batch 13: clipboard + misc (2026-09-11)

`CLIPBOARD SET TEXT / GET TEXT / RESET` implemented via Win32 clipboard APIs
(OpenClipboard / SetClipboardData / GetClipboardData), `INPUT FLUSH` added,
and `OPTION EXPLICIT` / `REM` / `GLOBAL` verified as supported and marked
implemented in the coverage matrix. Sample-verified 4/4 + validation 3/3.

### v0.1.05 — batch 12: computed branches (2026-09-11)

`ON GOTO` / `ON GOSUB` implemented (parser + codegen + interpreter), sample-verified
4/4 including out-of-range fallthrough. Fixes an infinite loop in the GOSUB
dispatch when a stale return address survived an `ON GOSUB` fallthrough
(return address is now cleared at the merge point).

### v0.1.04 — batch statement expansion, round 2 (2026-09-11)

18 statements/functions implemented and sample-verified (batches 6-10), all
with real codegen, 7 official keywords flipped in
[`statement-coverage.md`](docs/statement-coverage.md) (LOF / LOC join the
SEEK entry as file-position functions):

| Batch | Items | Verification |
|-------|-------|--------------|
| 6 | `BIT` function, `BIT SET/RESET/TOGGLE`, `BIT CALC`, `PROCESS GET PRIORITY`, `PROCESS SET PRIORITY` | 7/7 |
| 7 | `LOF`, `LOC`, `SEEK` functions | 3/3 |
| 8 | `ARRAY DELETE` (`[FOR count]`) | 2/2 |
| 9 | `ARRAY INSERT` (fixed arrays: last element shifts out) | 1/1 |
| 10 | `ARRAY SCAN` (`= <> < > <= >=`, numeric + string arrays) | 5/5 |

Notable notes:
- `BIT` works on any integral variable in-place (SET/RESET/TOGGLE/CALC) and as
  a function (`BIT(x, n)` returns 0/1).
- `PROCESS GET/SET PRIORITY` map to `GetPriorityClass`/`SetPriorityClass`
  (`%NORMAL_PRIORITY_CLASS` = 32, `%IDLE` = 64, `%HIGH` = 128, ...).
- `ARRAY SCAN` returns the 1-based relative index or 0 when nothing matches;
  the optional `FOR count` sub-range is accepted but currently scans the whole
  array (documented limitation).
- `ARRAY INSERT` on a fixed-size array cannot grow the array — the last
  element is shifted out (documented limitation vs. PB's dynamic REDIM).

Regression: official 15/15 tests pass; fmt + clippy 0 warnings.

### v0.1.03 — batch statement expansion (2026-09-11)

23 statements/functions implemented and sample-verified (batches 1-5), all
with real codegen (no silent drops), 15 official keywords flipped in
[`statement-coverage.md`](docs/statement-coverage.md):

| Batch | Items | Verification |
|-------|-------|--------------|
| 1 | `TIX`, `MKBYT$`, `ISINFINITE`, `ISNORMAL`, `PLAY WAVE`, `CHDRIVE`, `SETEOF` | 7/7 |
| 2 | `SWAP`, `SHIFT LEFT/RIGHT`, `SHIFT SIGNED LEFT/RIGHT`, `ROTATE LEFT/RIGHT`, `ARRAY REVERSE`, `PUT$` | 8/8 |
| 3 | `PLAY SOUND`, `SPLIT`, `ARRAY SHUFFLE` | 3/3 |
| 4 | `DATA`, `READ`, `RESTORE` | 3/3 |
| 5 | `PEEK` (8 datatypes), `POKE` (8 datatypes, multi-value) | 4/4 |

Notable fixes in this release:
- **x64 addresses**: `VARPTR`/`STRPTR` now return full 64-bit pointers
  (`ptrtoint64`); the old 32-bit truncation crashed any PEEK/POKE on a
  stack/heap address. Address variables should be declared `QUAD`.
- **Datatype keywords as arguments**: `PEEK(LONG, addr)` / `POKE LONG, addr, v`
  now parse (LONG/DOUBLE/DWORD/INTEGER/QUAD/SINGLE are reserved-word tokens;
  BYTE/WORD are identifiers — both paths handled).
- **DATA runtime bug**: `pb_read_data_str` had an undefined C evaluation order
  (`data_cursor++` inside a call argument) — a 1-byte garbage string could be
  returned. Fixed by copying the item first, then advancing the cursor.
- Known limitation (documented): unquoted text items in `DATA` are uppercased
  by the lexer, e.g. `DATA World` reads back `"WORLD"`; use `DATA "World"` for
  case-sensitive text.

Regression: official 15/15 tests pass; fmt + clippy 0 warnings; CI green.

### v0.1.02 — bug-fix release (2026-09-11)

Four real bugs found by sample-driven testing were fixed:

| # | Bug | Before | After |
|---|-----|--------|-------|
| 1 | `REDIM` of a `STRING` array without `AS` | array was typed `LONG` (`[4 x i32]`) — string data corrupted | inherits the declared element type (`[4 x ptr]` for `STRING`) |
| 2 | List declarations, e.g. `LOCAL a, b AS QUAD` | only `b` became `QUAD`; `a` silently fell back to `LONG` | the trailing `AS` type-fills the **whole** list (PB semantics, per the official docs: `LOCAL aaa, bbb, ccc AS INTEGER`) |
| 3 | `PRINT` of a `QUAD` value | truncated to 32 bits (`987654321012345` printed as `821493369`) | printed as full 64-bit (`%lld`); `PRINT #` and number-to-string conversion no longer round through `double` either |
| 4 | `OPEN file FOR BINARY` | opened with `"w+b"` — **truncated** an existing file on open | opens read/write **without truncating** (`r+b`), creates the file only if it does not exist — matches PowerBASIC semantics |

Regression: 15/15 official tests pass, `cargo clippy --all-targets -- -D warnings` clean, CI green.

---

## Roadmap / Known Limitations

- **Tier 2 (done):** `REPLACE`, `LSET`, `RSET`, `ERASE`, `WRITE #`, `SEEK`,
  `LOCK/UNLOCK`, `RESET`, `FLUSH`, and `NAME` are implemented and verified.
  Still open: `ON ERROR GOTO` - parsed and reported in
  `*.unimplemented.log` (not silently dropped), but produces no code yet;
  a real implementation needs a runtime error-handling mechanism
  (an error latch + a check after every failing call + a branch to the
  error handler), a structural change to codegen, and is deferred.
- **Tier 3 (future, large):** the DDT GUI framework — `DIALOG`, `CONTROL`,
  `MENU`, `TOOLBAR`, `STATUSBAR`, `COMBOBOX`, `LISTBOX`, `TREEVIEW`,
  `LISTVIEW`, `XPRINT` — effectively a rewrite of the entire windowing
  framework.

---

## Credits & License

Original project and code: [Ben Ward (benstopics)](https://github.com/benstopics)
— see upstream `LICENSE`.

This enhanced branch is maintained by **Hanlo**, with AI assistance from
**Doubao**. The enhancements are additive and do not remove any upstream
copyright notice.

Licensed under the **Apache License 2.0**. See the `LICENSE` file (from
upstream) for the full license text.

---

## Disclaimer

This is a community enhancement of an open-source project. PowerBASIC is a
trademark of its respective owner; this project is not affiliated with or
endorsed by the PowerBASIC company.
