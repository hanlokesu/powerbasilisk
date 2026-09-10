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
| PB statement / function | Maps to | Notes |
| --- | --- | --- |
| `MSGBOX text$ [, style& [, title$]]` | `MessageBoxA` (user32) | modal message box |
| `SHELL command$ [, mode&]` | `ShellExecuteA` (shell32) | launch a program / document |
| `CURDIR$` | `GetCurrentDirectoryA` (kernel32) | current working directory (no-parens call supported) |
| `ISFILE(path$)` | `_access` (C runtime) | returns -1 if the file exists, 0 if not |
| `REPLACE old$ WITH new$ IN target$` | `pb_replace` (runtime) | replace every occurrence of `old$` in `target$` |
| `ERASE array` | `pb_erase_array` (runtime) | zero numeric arrays, null string arrays (static arrays) |
| `LSET var$ = expr` | `pb_lset` / `pb_lset_buf` (runtime) | left-justify into a fixed-length string, pad with spaces |
| `RSET var$ = expr` | `pb_rset` / `pb_rset_buf` (runtime) | right-justify into a fixed-length string, pad with spaces |
| `WRITE #f, ...` | `pb_write_file_*` (runtime) | CSV-style record output: strings quoted, numbers raw, CRLF row terminator |
| `SEEK #f, pos` | `pb_seek` (runtime) | 1-based byte repositioning (`fseek` under the hood) |
| `LOCK #f [, rec [, len]]` | `pb_lock` (runtime) | byte-range file lock via CRT `_locking` |
| `UNLOCK #f [, rec [, len]]` | `pb_unlock` (runtime) | release a byte-range file lock |
| `RESET` | `pb_reset` (runtime) | close every open file handle |
| `FLUSH #f` | `pb_flush` (runtime) | `fflush` a file buffer to disk |
| `NAME old$ AS new$` | `pb_name` (runtime) | rename a file (`rename`) |

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

The quickest path on a brand-new machine:

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
> Summary: **41** statement-class keywords implemented · **202** DDT/GUI-class
> deferred (Tier 3) · **250** documented upstream with no codegen evidence yet.

### Newly implemented by this branch
| PB statement / function | Status | Maps to |
| --- | --- | --- |
| `MSGBOX` / `SHELL` / `CURDIR$` / `ISFILE` | ✅ | `MessageBoxA` / `ShellExecuteA` / `GetCurrentDirectoryA` / `_access` |
| `REPLACE old$ WITH new$ IN target$` | ✅ | `pb_replace` |
| `ERASE array` | ✅ | `pb_erase_array` |
| `LSET var$ = expr` / `RSET var$ = expr` | ✅ | `pb_lset(_buf)` / `pb_rset(_buf)` |
| `WRITE #f, ...` | ✅ | `pb_write_file_begin/str/int/dbl/newline` |
| `SEEK #f, pos` | ✅ | `pb_seek` |
| `LOCK #f` / `UNLOCK #f` | ✅ | `pb_lock` / `pb_unlock` |
| `RESET` / `FLUSH #f` | ✅ | `pb_reset` / `pb_flush` |
| `NAME old$ AS new$` | ✅ | `pb_name` |
| `BEEP` | ✅ | `Beep(800, 300)` (kernel32) |
| `SWAP a, b` | ✅ | register-level load/store exchange |
| `MKDIR` / `RMDIR` / `CHDIR` / `KILL` + `ERR` / `ERRCLEAR` | ✅ | `_mkdir` / `_rmdir` / `_chdir` / `pb_kill` + `@pb_err` global — PB-compatible error codes (75/76/53) on failure |
| Built-in string equates — all 18 ANSI forms (`$CRLF`, `$TAB`, `$DQ`, `$WHITESPACE`, …) | ✅ | compile-time string constants (byte-verified against the official table); `$$` wide single-char forms as numeric constants |
| `CHR$(a, b, c)` multi-argument | ✅ | one byte per argument, concatenated (`CHR$(13,10)` = CR+LF) |
| `RND` bare form (no parens) | ✅ | same as `RND()` — random double in [0,1) |
| `INPUT #f, s$` reading `WRITE #` output | ✅ | CSV double-quotes stripped per PB semantics |
| `PRINT` console output | ✅ | flushed immediately after each line (visible under redirection / on abort) |
| `CLS` | ✅ | `pb_cls` → clears the console screen (PB/CC) |
| `ERROR n` | ✅ | sets the PB error code (readable via `ERR`) |
| `ENVIRON "VAR=value"` | ✅ | `pb_environ_set` → `_putenv`; bare `ENVIRON "VAR"` removes the variable |
| `FILECOPY src$, dst$` | ✅ | `pb_filecopy` → `CopyFileA`, PB-compatible `ERR` on failure (53/70/76) |
| `SETATTR "path", attr&` | ✅ | `pb_setattr` → `SetFileAttributesA`, PB-compatible `ERR` on failure |

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
