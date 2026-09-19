# PowerBasilisk Enhanced — Official Statement Coverage Matrix

> **Last updated from batch 137 (v0.2.010)** — 2026-09-19. All statements through batch 137 are reflected in this matrix.

Ground truth: **PowerBASIC official documentation** (MIT license, 735 keywords / 1282 topic pages, PB/Win 10+11 / PB/CC 6+7).

> **Status-column key**: `Implemented` = this branch generates real code. `Established` = a keyword that is *mature in the official PB documentation* - it is **NOT** a claim that upstream benstopics/powerbasilisk implemented it. Upstream itself shipped only ~68 core statements/builtins (last commit 2026-02-18); nearly everything else here is this fork's work.

- Rows in this matrix: **918** (10 BLOCK, 408 FUNCTION, 5 OPERATOR, 495 STATEMENT).
- **772** keywords currently available (✅ Implemented by this fork + ✅ Established upstream/core).
- **0** documented keywords still proposed / not yet implemented; **130** Tier-3 DDT GUI items deferred.

## Summary

| Status | Count | Notes |
|--------|-------|-------|
| ✅ Implemented (this fork) | 616 | Real codegen added by this fork (Win32 calls / runtime helpers / control flow) |
| ✅ Established (upstream/core) | 171 | Available from upstream benstopics/powerbasilisk or core language |
| ✅ **Total available** | **787** | Implemented + Established |
| 🔲 Proposed (not yet implemented) | 0 | Documented upstream, no codegen evidence yet |
| 🛠 Tier-3 DDT (deferred) | 130 | DDT GUI / window-callback framework, high effort, deferred |

## All keywords (918 rows)

| Keyword | Kind | Platform | Status |
| --- | --- | --- | --- |
| #ALIGN METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #BLOAT METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #BREAK METASTATEMENT | STATEMENT | PB/CC only | ✅ Established (upstream/core) |
| #COM METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #COMPILE METASTATEMENT | STATEMENT | PB/Win only | ✅ Established (upstream/core) |
| #COMPILER METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #CONSOLE METASTATEMENT | STATEMENT | PB/CC only | ✅ Established (upstream/core) |
| #DEBUG BOUNDS METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| #DEBUG CODE METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #DEBUG DISPLAY METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| #DEBUG ERROR METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| #DEBUG NUMERIC METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| #DEBUG PRINT METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #DIM METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #EXPORT METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #IF/#ELSEIF/#ELSE/#ENDIF METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #INCLUDE METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #LINK METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #MESSAGES METASTATEMENT | STATEMENT | PB/Win only | ✅ Established (upstream/core) |
| #OPTIMIZE METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #OPTION METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| #PAGE METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #PBFORMS METASTATEMENT | STATEMENT | PB/Win only | ✅ Established (upstream/core) |
| #REGISTER METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #RESOURCE METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| #STACK METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #TOOLS METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #UNIQUE METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| #UTILITY METASTATEMENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ABS | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| ACCEL ATTACH | STATEMENT | PB/Win only | Implemented |
| ACODE$ | FUNCTION | codegen builtin (ANSI passthrough) | ✅ Implemented (this fork) |
| ACOS | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| ACOSH | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| ARRAY ADD | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY ARRAYIX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY ASSIGN | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY COPY | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY DELETE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY INSERT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY REDIM DECR | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY REDIM INCR | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY REVERSE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY SCAN | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY SELECT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY SHUFFLE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY SORT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ARRAY SWAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY TAGARRAY | STATEMENT | PB/Win + PB/CC | Implemented |
| ARRAY TAGARRAY ERASE | STATEMENT | PB/Win + PB/CC | Implemented |
| ARRAY UNIQUE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ARRAY_REDIM_DECR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ARRAY_REDIM_INCR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ARRAY_SELECT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ARRAY_TAGARRAY | FUNCTION | codegen builtin | Implemented |
| ARRAY_TAGARRAY_ERASE | FUNCTION | codegen builtin | Implemented |
| ASC | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ASIN | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| ASINH | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| ASM | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ASMDATA / END ASMDATA | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ATANH | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| ATN | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| ATN2 | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| BEEP | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| BGR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| BIN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| BIN$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| BIT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| BIT CALC | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| BITS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| BITS$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| BITSE | FUNCTION | codegen builtin (lvalue test-and-set) | ✅ Implemented (this fork) |
| BUILD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| BUILD$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| BYTE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CALL | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| CALL DWORD | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| CALLSTK | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| CALLSTK$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| CALLSTKCOUNT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CBOOL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CBRT | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| CBYTE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CDBL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CDWORD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CEIL | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| CFLT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CHDIR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| CHDRIVE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| CHOOSE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CHR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CHR$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| CHRBYTES | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CHRTOOEM | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CHRTOOEM$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| CHRTOUTF8 | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CHRTOUTF8$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| CLASS/END CLASS | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| CLIP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CLIP$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| CLIPBOARD | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| CLOSE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| CLS | STATEMENT | PB/CC only | ✅ Established (upstream/core) |
| CODEPTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| COLOR | STATEMENT | PB/CC only | ✅ Established (upstream/core) |
| COMBOBOX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| COMM CLOSE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMM LINE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMM OPEN | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMM PRINT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMM RECV | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMM RESET | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMM SEND | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMM SET | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMM TIMEOUT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| COMMAND | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| COMMAND$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| CONTROL ADD *CUSTOM CONTROL* | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD BUTTON | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD CHECK3STATE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD CHECKBOX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD COMBOBOX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD FRAME | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD GRAPHIC | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD HEADER | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD IMAGE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD IMAGEX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD IMGBUTTON | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD IMGBUTTONX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD LABEL | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD LINE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD LISTBOX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD LISTVIEW | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD OPTION | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD PROGRESSBAR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD SCROLLBAR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD STATUSBAR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD TAB | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD TEXTBOX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD TOOLBAR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ADD TREEVIEW | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL DISABLE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL ENABLE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL GET CHECK | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL GET CLIENT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL GET LOC | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL GET SIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL GET TEXT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL GET USER | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL HANDLE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL HIDE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL KILL | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL NORMALIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL POST | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL REDRAW | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SEND | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET CHECK | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET CLIENT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET COLOR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET FOCUS | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET FONT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET IMAGE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET IMAGEX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET IMGBUTTON | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET IMGBUTTONX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET LOC | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET OPTION | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET SIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET TEXT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SET USER | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL SHOW STATE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| CONTROL TRAXOMATIC | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| COS | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| COSH | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| COT | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| COTH | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| CQUAD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CSC | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| CSCH | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| CSET | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| CSET$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| CSNG | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CSTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CULNG | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CURDIR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CURDIR$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| CVBYT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CVCUX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CVDWD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CVL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CVQ | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CVW | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| CWORD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DATA | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| DATACOUNT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DAYNAME | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DAYNAME$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| DEC | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DEC$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| DECLARE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| DECR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| DESKTOP GET CLIENT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| DESKTOP GET LOC | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| DESKTOP GET PPI | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| DESKTOP GET SIZE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| DIALOG DEFAULT FONT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG DISABLE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG DOEVENTS | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG ENABLE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG END | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG GET CLIENT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG GET LOC | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG GET SIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG GET TEXT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG GET USER | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG HIDE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG MAXIMIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG MINIMIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG NEW | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG NONSTABLE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG NORMALIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG PIXELS | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG POST | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG REDRAW | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SEND | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SET CLIENT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SET COLOR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SET ICON | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SET LOC | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SET SIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SET TEXT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SET USER | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SHOW MODAL | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SHOW MODELESS | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG SHOW STATE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG STABILIZE | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG TRAXOMATIC | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG UNITS | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIALOG XLAT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| DIM | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| DIR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DIR$ | FUNCTION | PB/Win + PB/CC | ✅ Implemented (this fork) |
| DISKFREE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DISKSIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DISPLAY BROWSE | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| DISPLAY COLOR | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| DISPLAY FONT | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| DISPLAY OPENFILE | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| DISPLAY SAVEFILE | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| DISPLAY_BROWSE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DISPLAY_COLOR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DISPLAY_FONT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DISPLAY_OPENFILE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DISPLAY_SAVEFILE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| DOUBLE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| END | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ENVIRON | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ENVIRON$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| EOF | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| EQV | FUNCTION | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ERASE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ERF | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| ERL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ERL$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| ERR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ERRCLEAR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ERROR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ERROR$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| EVENT SOURCE | STATEMENT | PB/Win + PB/CC | Implemented |
| EVENTS | STATEMENT | PB/Win + PB/CC | Implemented |
| EXE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| EXIST | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| EXIT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| EXP | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| EXP10 | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| EXP2 | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| EXPM1 | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| EXTRACT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| EXTRACT$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| FIELD | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| FILEATTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FILECOPY | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| FILENAME | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FILENAME$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| FILESCAN | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| FIX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FLOOR | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| FLUSH | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| FONT END | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| FONT NEW | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| FONT_END | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FONT_NEW | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FOR / NEXT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| FORMAT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FORMAT$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| FRAC | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FRE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FREEFILE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| FUNCNAME$ | FUNCTION | codegen builtin (current_fn_name) | ✅ Implemented (this fork) |
| FUNCTION / END FUNCTION | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| GET | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GET$ | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GET$$ | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GETATTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GET_STR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GET_WSTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GLOBAL | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| GLOBALMEM | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| GRAPHIC ARC | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC ATTACH | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC BITMAP CAPTURE | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC BITMAP END | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC BITMAP LOAD | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC BITMAP NEW | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC BOX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC CELL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC CELL SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC CHR SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC CLEAR | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC COLOR | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC COPY | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC DETACH | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC ELLIPSE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET BITS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET CANVAS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET CAPTION | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET CLIENT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET CLIP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET DC | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET LINES | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET LOC | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET MIX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET OVERLAP | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC GET PIXEL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET POS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET PPI | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET SCALE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET SCROLLTEXT | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC GET SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET STRETCHMODE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET TEXTALIGN | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET VIEW | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET WORDWRAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC GET WRAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC IMAGELIST | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC INKEY$ | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC INPUT | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC INPUT FLUSH | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC INSTAT | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC LINE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC LINE INPUT | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC PAINT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC PIE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC POLYGON | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC POLYLINE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC PRINT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC REDRAW | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC RENDER | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC SAVE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SCALE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET AUTOSIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET BITS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET CAPTION | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET CLIENT | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC SET CLIP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET FIXED | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET FOCUS | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC SET FONT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET LOC | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC SET MIX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET OVERLAP | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC SET PIXEL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET POS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET SCROLLTEXT | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC SET SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET STRETCHMODE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET TEXTALIGN | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET VIEW | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET VIRTUAL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET WORDWRAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SET WRAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC SPLIT | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC STRETCH | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC STYLE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC TEXT SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC WAITKEY$ | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC WIDTH | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| GRAPHIC WINDOW | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC WINDOW CLICK | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC WINDOW END | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC WINDOW HIDE | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC WINDOW MINIMIZE | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC WINDOW NONSTABLE | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC WINDOW NORMALIZE | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC WINDOW STABILIZE | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| GRAPHIC_ARC | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_ATTACH | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_BITMAP_END | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_BITMAP_LOAD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_BITMAP_NEW | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_CELL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_CHR_SIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_CIRCLE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_CLEAR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_COLOR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_COPY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_DETACH | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_ELLIPSE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_BITS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_CAPTION | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_CLIP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_DC | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_LINES | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_LOC | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_MIX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_PIXEL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_POS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_PPI | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_SCALE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_SIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_STRETCHMODE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_TEXTALIGN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_VIEW | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_WORDWRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_GET_WRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_LINE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_PAINT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_PIE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_POLYGON | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_POLYLINE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SAVE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SCALE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SCALE_PIXELS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_AUTOSIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_BITS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_CAPTION | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_CLIP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_FIXED | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_FONT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_MIX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_PIXEL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_POS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_SIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_STRETCHMODE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_TEXTALIGN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_VIEW | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_VIRTUAL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_WORDWRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_SET_WRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_STYLE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| GRAPHIC_TEXT_SIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| HEADER | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| HEADER_CTRL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| HEX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| HEX$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| HI | FUNCTION | Win32 | ✅ Implemented (this fork) |
| HIWRD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| HOST ADDR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| HOST NAME | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| HYPOT | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| IF | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| IF/END IF | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| IIF | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| IMAGELIST | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| IMAGELIST_COUNT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| IMAGELIST_KILL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| IMAGELIST_NEW | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| IMP | FUNCTION | PB/Win + PB/CC | ✅ Implemented (this fork) |
| IMPORT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| INCR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| INPUT FLUSH | STATEMENT | PB/CC only | ✅ Established (upstream/core) |
| INPUT# | STATEMENT | PB/CC only | ✅ Implemented (this fork) |
| INSTANCE | STATEMENT | PB/Win + PB/CC | Implemented |
| INSTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| INT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| INTEGER | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| INTERFACE / END INTERFACE (DIRECT) | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| INTERFACE/END INTERFACE (IDBIND) | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ISEVEN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ISFALSE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ISFILE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ISFOLDER | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ISINFINITE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ISNORMAL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ISODD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ISTRUE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ISWIN | FUNCTION | Win32 (IsWindow/GetDlgItem) | ✅ Implemented (this fork) |
| ITERATE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| JOIN$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| KILL | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LCASE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| LCASE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| LEFT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| LEFT$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| LEN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| LET | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LET *(WITH OBJECTS)* | STATEMENT | PB/Win + PB/CC | Implemented |
| LET *(WITH TYPES)* | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LET *(WITH VARIANTS)* | STATEMENT | PB/Win + PB/CC | Implemented |
| LINE INPUT# | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| LISTBOX | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| LISTVIEW | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| LO | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| LOC | FUNCTION | Win32 | ✅ Implemented (this fork) |
| LOCAL | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LOCK | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LOF | FUNCTION | Win32 | ✅ Implemented (this fork) |
| LOG | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| LOG10 | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| LOG1P | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| LOG2 | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| LONG | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| LOWRD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| LPRINT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LPRINT ATTACH | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LPRINT CLOSE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LPRINT FLUSH | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LPRINT FORMFEED | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LPRINT$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| LSET | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| LSET$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| LTRIM | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| LTRIM$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| MACRO/END MACRO | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MAK | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MAT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MAX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MCASE$ | FUNCTION | runtime pb_mcase_string | ✅ Implemented (this fork) |
| MEMORY | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MEMORY_FILL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MEMORY_FILLS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MENU ADD POPUP | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU ADD STRING | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU ATTACH | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| MENU CONTEXT | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| MENU DELETE | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU DRAW BAR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| MENU GET STATE | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU GET TEXT | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU NEW BAR | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU NEW POPUP | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU SET STATE | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU SET TEXT | STATEMENT | PB/Win only | ✅ Implemented (this fork) |
| MENU_ADD_POPUP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MENU_ADD_STRING | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MENU_DELETE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MENU_GET_STATE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MENU_GET_TEXT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MENU_NEW_POPUP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MENU_SET_STATE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MENU_SET_TEXT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| METHOD / END METHOD | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| METRICS | FUNCTION | Win32 | ✅ Implemented (this fork) |
| MID | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MID$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MIN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MKBYT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MKBYT$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKCUR$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKCUX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MKCUX$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKD$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKDIR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKDWD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MKDWD$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MKE$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKI$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKL$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKQ$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MKS$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MKWRD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MKWRD$ | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| MOD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MONTHNAME | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| MONTHNAME$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| MOUSEPTR | STATEMENT | PB/CC only | ✅ Established (upstream/core) |
| MSGBOX | STATEMENT | PB/Win only | ✅ Established (upstream/core) |
| NAME | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| NUL$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| OBJECT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| OCT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| OCT$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| OEMTOCHR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| OEMTOCHR$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| ON CALL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ON ERROR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ON GOSUB | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| ON GOTO | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| OPEN | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| OPTION EXPLICIT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| PARSE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| PARSE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| PARSECOUNT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| PATHNAME | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| PATHNAME$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| PATHSCAN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| PATHSCAN$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| PEEK | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| PLAY | FUNCTION | Win32 | ✅ Implemented (this fork) |
| PLAY SOUND | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| PLAY WAVE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| POKE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| PREFIX | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| PRINT# | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| PRINTER$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| PRINTERCOUNT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| PROCESS GET PRIORITY | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| PROCESS SET PRIORITY | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| PROFILE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| PROGRESSBAR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| PUT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| PUT$ | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| PUT$$ | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| PUT_STR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| PUT_WSTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| QUAD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| RAISEEVENT | STATEMENT | PB/Win + PB/CC | Implemented |
| RANDOMIZE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| READ | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| READ$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| REDIM | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| REGEXPR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| REGISTER | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| REGREPL | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| REM | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| REMAIN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| REMAIN$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| REMOVE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| REMOVE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| REPEAT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| REPEAT$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| REPLACE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| RESET | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| RESOURCE SAVE FILE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| RESOURCE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| RESOURCE_SAVE_FILE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| RESUME | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| RETAIN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| RETAIN$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| RETURN | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| RGB | FUNCTION | Win32 | ✅ Implemented (this fork) |
| RIGHT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| RIGHT$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| RMDIR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| RND | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| ROTATE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ROUND | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| RSET | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| RSET$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| RTRIM | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| RTRIM$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| SCROLLBAR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| SEC | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| SECH | FUNCTION | C runtime (MSVCRT) | ✅ Implemented (this fork) |
| SEEK | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| SELECT CASE/END SELECT | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| SETATTR | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| SETEOF | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| SGN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| SHELL | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| SHIFT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| SHRINK | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| SHRINK$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| SIN | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| SINGLE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| SINH | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| SIZEOF | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| SLEEP | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| SPACE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| SPACE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| SPLIT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| SQR | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| STATIC | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| STATUSBAR | STATEMENT | PB/Win + PB/CC | 🛠 Tier-3 DDT (deferred) |
| STR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| STR$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| STRDELETE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| STRDELETE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| STRING | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| STRINSERT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| STRINSERT$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| STRPTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| STRREVERSE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| STRREVERSE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| SWAP | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| SWITCH | FUNCTION | Win32 | ✅ Implemented (this fork) |
| SWITCH$ | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| TAB | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| TAB$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| TALLY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| TAN | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| TANH | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| TCP ACCEPT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TCP CLOSE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TCP LINE INPUT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TCP NOTIFY | STATEMENT | PB/Win + PB/CC | Implemented |
| TCP OPEN | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TCP PRINT | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TCP RECV | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TCP SEND | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TCP_NOTIFY | FUNCTION | codegen builtin | Implemented |
| THREAD CLOSE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| THREAD CREATE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| THREAD GET PRIORITY | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| THREAD RESUME | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| THREAD SET PRIORITY | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| THREAD STATUS | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| THREAD SUSPEND | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| THREADCOUNT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| THREADED | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| THREADID | FUNCTION | Win32 | ✅ Implemented (this fork) |
| TIMER | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| TIX | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TOOLBAR | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| TRACE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TREEVIEW | STATEMENT | PB/Win only | 🛠 Tier-3 DDT (deferred) |
| TRIM | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| TRIM$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| TRUNC | FUNCTION | LLVM intrinsic | ✅ Implemented (this fork) |
| TRY/END TRY | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TYPE SET | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| TYPE/END TYPE | BLOCK | PB/Win + PB/CC | ✅ Established (upstream/core) |
| UCASE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| UCASE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| UCODE$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| UCODEPAGE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| UDP CLOSE | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| UDP NOTIFY | STATEMENT | PB/Win + PB/CC | Implemented |
| UDP OPEN | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| UDP RECV | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| UDP SEND | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| UDP_NOTIFY | FUNCTION | codegen builtin | Implemented |
| UNLOCK | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| UNWRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| UNWRAP$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| USING | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| USING$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| UTF8TOCHR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| UTF8TOCHR$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| VAL | STATEMENT | PB/Win + PB/CC | ✅ Established (upstream/core) |
| VARPTR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| VERIFY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| WAITKEY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| WINDOW GET | STATEMENT | PB/Win only | ✅ Established (upstream/core) |
| WINDOW SET | STATEMENT | PB/Win only | ✅ Established (upstream/core) |
| WORD | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| WRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| WRAP$ | FUNCTION | Win32 | ✅ Implemented (this fork) |
| WRITE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| WRITE# | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT ARC | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT ATTACH | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT BOX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT CANCEL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT CELL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT CELL SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT CHR SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT CLOSE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT COLOR | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT COPY | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT ELLIPSE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT FORMFEED | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET ATTACH | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET CANVAS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET CLIENT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET CLIP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET COLLATE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET COLORMODE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET COPIES | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET DC | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET DUPLEX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET LINES | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET MARGIN | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET MIX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET ORIENTATION | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET OVERLAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET PAGES | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET PAPER | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET PAPERS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET PIXEL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET POS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET PPI | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET QUALITY | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET SCALE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET SELECTION | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET STRETCHMODE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET TEXTALIGN | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET TRAY | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET TRAYS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET WORDWRAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT GET WRAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT IMAGELIST | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT LINE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT PIE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT POLYGON | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT POLYLINE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT PREVIEW | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT PRINT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT RENDER | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SCALE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET CLIP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET COLLATE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET COLORMODE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET COPIES | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET DUPLEX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET FONT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET MIX | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET ORIENTATION | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET OVERLAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET PAGES | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET PAPER | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET PIXEL | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET POS | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET QUALITY | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET STRETCHMODE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET TEXTALIGN | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET TRAY | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET WORDWRAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SET WRAP | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT SPLIT | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT STRETCH | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT STYLE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT TEXT SIZE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT WIDTH | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| XPRINT_ARC | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_ATTACH | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_BOX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_CANCEL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_CELL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_CELL_SIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_CHR_SIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_CLOSE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_COPY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_ELLIPSE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_FORMFEED | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_ATTACH | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_CANVAS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_CLIENT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_CLIP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_COLLATE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_COLOR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_COLORMODE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_COPIES | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_DC | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_DUPLEX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_LINES | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_MARGIN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_MIX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_ORIENTATION | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_OVERLAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_PAGES | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_PAPER | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_PAPERS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_PIXEL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_POS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_PPI | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_QUALITY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_SCALE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_SELECTION | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_SIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_STRETCHMODE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_TEXTALIGN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_TRAY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_TRAYS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_WORDWRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_GET_WRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_IMAGELIST | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_LINE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_PIE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_POLYGON | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_POLYLINE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_PREVIEW | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_PRINT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_RENDER | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SCALE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_CLIP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_COLLATE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_COLOR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_COLORMODE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_COPIES | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_DUPLEX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_FONT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_MIX | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_ORIENTATION | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_OVERLAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_PAGES | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_PAPER | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_PIXEL | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_POS | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_QUALITY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_STRETCHMODE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_TEXTALIGN | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_TRAY | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_WORDWRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SET_WRAP | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_SPLIT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_STRETCH | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_STYLE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_TEXT_SIZE | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_WIDTH | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| AND | OPERATOR | PB/Win + PB/CC | ✅ Established (upstream/core) |
| NOT | OPERATOR | PB/Win + PB/CC | ✅ Established (upstream/core) |
| OR | OPERATOR | PB/Win + PB/CC | ✅ Established (upstream/core) |
| XOR | OPERATOR | PB/Win + PB/CC | ✅ Established (upstream/core) |
| DEF | OPERATOR | PB/Win + PB/CC | Implemented |
| DIR CLOSE | STATEMENT | PB/Win + PB/CC | ✅ Implemented (this fork) |
| NUL | FUNCTION | PB/Win + PB/CC | ✅ Established (upstream/core) |
| ACODE | FUNCTION | PB/Win + PB/CC | ✅ Implemented (this fork) |
| FUNCNAME | FUNCTION | PB/Win + PB/CC | ✅ Implemented (this fork) |
| MCASE | FUNCTION | PB/Win + PB/CC | ✅ Implemented (this fork) |
| COMM LINE INPUT | STATEMENT | PB/Win | ✅ Implemented (this fork) |
| GRAPHIC_PRINT | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| XPRINT_COLOR | FUNCTION | codegen builtin | ✅ Implemented (this fork) |
| WAITKEY$ | FUNCTION | PB/CC + console | ✅ Implemented (this fork) |
