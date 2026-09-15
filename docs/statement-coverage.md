# PowerBasilisk Enhanced — Official Statement Coverage Matrix

> **Last updated from batch 96 (v0.1.90)** — 2026-09-15. All statements and functions through batch 96 are reflected in this matrix.

Ground truth: **PowerBASIC official documentation** (MIT license, 735 keywords / 1282 topic pages, PB/Win 10+11 / PB/CC 6+7).

- Official **statement-class** keywords total: **493**

- Official function-class: 190 (CURDIR$ / ISFILE among them —both implemented)

- Generated: 2026-09-15 (batch 86: TRUNC) (batch 85: FLOOR) (batch 84: REMAIN$) (batch 83: RETAIN$) (batch 82: REMOVE$) (batch 81: INPUT/LINE INPUT console) (batch 80: OOP completion —0 NOT_IMPL milestone) (batch 79: OOP foundation) (batch 37-78: see README changelog) (batch 36: MKE$) (batch 35: REGEXPR/REGREPL) (batch 34: PROFILE) (batch 33: CALLSTK) (batch 31: FIELD / RANDOM) (batch 25: ON ERROR / RESUME / REGISTER) (audited: FOR/NEXT, SELECT CASE, LET, MID$, VAL, ASC, PARSE, FUNCTION, IF/END IF verified live)

## Summary

| Status | Count | Notes |
|--------|-------|-------|
| ✅ Implemented | 702 | Real codegen output (Win32 calls / runtime helpers / control flow) |
| 🚧 Tier-3 DDT | 129 | DDT GUI framework, high effort, deferred to a future update |
| ⬜ Not implemented | 0 | Documented upstream, no codegen evidence yet |

## ✅ Implemented (702)
| Keyword | Kind | Platform | Status |
| --- | --- | --- | --- |
| `#ALIGN METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#BLOAT METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#BREAK METASTATEMENT` | STATEMENT | PB/CC only | Established |
| `#COM METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#COMPILE METASTATEMENT` | STATEMENT | PB/Win only | Established |
| `#COMPILER METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#CONSOLE METASTATEMENT` | STATEMENT | PB/CC only | Established |
| `#DEBUG BOUNDS METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `#DEBUG CODE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#DEBUG DISPLAY METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `#DEBUG ERROR METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `#DEBUG NUMERIC METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `#DEBUG PRINT METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#DIM METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#EXPORT METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#IF/#ELSEIF/#ELSE/#ENDIF METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#INCLUDE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#LINK METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#MESSAGES METASTATEMENT` | STATEMENT | PB/Win only | Established |
| `#OPTIMIZE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#OPTION METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `#PAGE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#PBFORMS METASTATEMENT` | STATEMENT | PB/Win only | Established |
| `#REGISTER METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#RESOURCE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `#STACK METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#TOOLS METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#UNIQUE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#UTILITY METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `ABS` | FUNCTION | LLVM intrinsic |  |
| `ACCEL ATTACH` | STATEMENT | PB/Win only | Established |
| `ACOS` | FUNCTION | LLVM intrinsic |  |
| `ACOSH` | FUNCTION | LLVM intrinsic |  |
| `ARRAY ADD` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY ARRAYIX` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY ASSIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY COPY` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY DELETE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY INSERT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `ARRAY REDIM DECR` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY REDIM INCR` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY REVERSE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY SCAN` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `ARRAY SELECT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY SHUFFLE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY SORT` | STATEMENT | PB/Win + PB/CC | Established |
| `ARRAY SWAP` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY TAGARRAY` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY TAGARRAY ERASE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY UNIQUE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY_REDIM_DECR` | FUNCTION | codegen builtin |  |
| `ARRAY_REDIM_INCR` | FUNCTION | codegen builtin |  |
| `ARRAY_SELECT` | FUNCTION | codegen builtin |  |
| `ARRAY_TAGARRAY` | FUNCTION | codegen builtin |  |
| `ARRAY_TAGARRAY_ERASE` | FUNCTION | codegen builtin |  |
| `ASC` | STATEMENT | PB/Win + PB/CC | Established |
| `ASIN` | FUNCTION | LLVM intrinsic |  |
| `ASINH` | FUNCTION | LLVM intrinsic |  |
| `ASM` | STATEMENT | PB/Win + PB/CC | Established |
| `ASMDATA / END ASMDATA` | BLOCK | PB/Win + PB/CC | Established |
| `ATANH` | FUNCTION | LLVM intrinsic |  |
| `ATN` | FUNCTION | LLVM intrinsic |  |
| `ATN2` | FUNCTION | codegen builtin |  |
| `BEEP` | STATEMENT | PB/Win + PB/CC | Established |
| `BGR` | FUNCTION | codegen builtin |  |
| `BIN` | FUNCTION | codegen builtin |  |
| `BIT` | STATEMENT | PB/Win + PB/CC | Established |
| `BIT CALC` | STATEMENT | PB/Win + PB/CC | Established |
| `BITS` | FUNCTION | codegen builtin |  |
| `BUILD` | FUNCTION | codegen builtin |  |
| `BYTE` | FUNCTION | codegen builtin |  |
| `CALL` | STATEMENT | PB/Win + PB/CC | Established |
| `CALL DWORD` | STATEMENT | PB/Win + PB/CC | Established |
| `CALLSTK` | STATEMENT | PB/Win + PB/CC | Established |
| `CALLSTKCOUNT` | FUNCTION | codegen builtin |  |
| `CBOOL` | FUNCTION | codegen builtin |  |
| `CBRT` | FUNCTION | C runtime (MSVCRT) |  |
| `CBYTE` | FUNCTION | codegen builtin |  |
| `CDBL` | FUNCTION | codegen builtin |  |
| `CDWORD` | FUNCTION | codegen builtin |  |
| `CEIL` | FUNCTION | LLVM intrinsic |  |
| `CFLT` | FUNCTION | codegen builtin |  |
| `CHDIR` | STATEMENT | PB/Win + PB/CC | Established |
| `CHDRIVE` | STATEMENT | PB/Win + PB/CC | Established |
| `CHOOSE` | FUNCTION | codegen builtin |  |
| `CHR` | FUNCTION | codegen builtin |  |
| `CHRTOOEM` | FUNCTION | codegen builtin |  |
| `CHRTOUTF8` | FUNCTION | codegen builtin |  |
| `CLASS/END CLASS` | BLOCK | PB/Win + PB/CC | Established |
| `CLIP` | FUNCTION | codegen builtin |  |
| `CLIPBOARD` | STATEMENT | PB/Win + PB/CC | Established |
| `CLOSE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `CLS` | STATEMENT | PB/CC only | Established |
| `CODEPTR` | FUNCTION | codegen builtin |  |
| `COLOR` | STATEMENT | PB/CC only | Established |
| `COMBOBOX` | STATEMENT | PB/Win only | Established |
| `COMM CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM LINE` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM OPEN` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM PRINT` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM RECV` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM RESET` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM SEND` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM SET` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM TIMEOUT` | STATEMENT | PB/Win + PB/CC | Established |
| `COMMAND` | FUNCTION | codegen builtin |  |
| `CONTROL ADD *CUSTOM CONTROL*` | STATEMENT | PB/Win only | Proposed Improvement |
| `CONTROL ADD BUTTON` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD CHECK3STATE` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD CHECKBOX` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD COMBOBOX` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD FRAME` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD GRAPHIC` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD HEADER` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD IMAGE` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD IMAGEX` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD IMGBUTTON` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD IMGBUTTONX` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD LABEL` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD LINE` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD LISTBOX` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD LISTVIEW` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD OPTION` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD PROGRESSBAR` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD SCROLLBAR` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD STATUSBAR` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD TAB` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD TEXTBOX` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD TOOLBAR` | STATEMENT | PB/Win only | Established |
| `CONTROL ADD TREEVIEW` | STATEMENT | PB/Win only | Established |
| `CONTROL DISABLE` | STATEMENT | PB/Win only | Established |
| `CONTROL ENABLE` | STATEMENT | PB/Win only | Established |
| `CONTROL GET CHECK` | STATEMENT | PB/Win only | Established |
| `CONTROL GET CLIENT` | STATEMENT | PB/Win only | Proposed Improvement |
| `CONTROL GET LOC` | STATEMENT | PB/Win only | Proposed Improvement |
| `CONTROL GET SIZE` | STATEMENT | PB/Win only | Proposed Improvement |
| `CONTROL GET TEXT` | STATEMENT | PB/Win only | Established |
| `CONTROL GET USER` | STATEMENT | PB/Win only | Established |
| `CONTROL HANDLE` | STATEMENT | PB/Win only | Established |
| `CONTROL HIDE` | STATEMENT | PB/Win only | Established |
| `CONTROL KILL` | STATEMENT | PB/Win only | Established |
| `CONTROL NORMALIZE` | STATEMENT | PB/Win only | Established |
| `CONTROL POST` | STATEMENT | PB/Win only | Established |
| `CONTROL REDRAW` | STATEMENT | PB/Win only | Established |
| `CONTROL SEND` | STATEMENT | PB/Win only | Established |
| `CONTROL SET CHECK` | STATEMENT | PB/Win only | Established |
| `CONTROL SET CLIENT` | STATEMENT | PB/Win only | Established |
| `CONTROL SET COLOR` | STATEMENT | PB/Win only | Established |
| `CONTROL SET FOCUS` | STATEMENT | PB/Win only | Established |
| `CONTROL SET FONT` | STATEMENT | PB/Win only | Established |
| `CONTROL SET IMAGE` | STATEMENT | PB/Win only | Established |
| `CONTROL SET IMAGEX` | STATEMENT | PB/Win only | Established |
| `CONTROL SET IMGBUTTON` | STATEMENT | PB/Win only | Established |
| `CONTROL SET IMGBUTTONX` | STATEMENT | PB/Win only | Established |
| `CONTROL SET LOC` | STATEMENT | PB/Win only | Proposed Improvement |
| `CONTROL SET OPTION` | STATEMENT | PB/Win only | Established |
| `CONTROL SET SIZE` | STATEMENT | PB/Win only | Proposed Improvement |
| `CONTROL SET TEXT` | STATEMENT | PB/Win only | Established |
| `CONTROL SET USER` | STATEMENT | PB/Win only | Established |
| `CONTROL SHOW STATE` | STATEMENT | PB/Win only | Established |
| `CONTROL TRAXOMATIC` | STATEMENT | PB/Win only | Proposed New |
| `COS` | FUNCTION | LLVM intrinsic |  |
| `COSH` | FUNCTION | LLVM intrinsic |  |
| `COT` | FUNCTION | C runtime (MSVCRT) |  |
| `COTH` | FUNCTION | C runtime (MSVCRT) |  |
| `CQUAD` | FUNCTION | codegen builtin |  |
| `CSC` | FUNCTION | C runtime (MSVCRT) |  |
| `CSCH` | FUNCTION | C runtime (MSVCRT) |  |
| `CSET` | STATEMENT | PB/Win + PB/CC | Established |
| `CSNG` | FUNCTION | codegen builtin |  |
| `CSTR` | FUNCTION | codegen builtin |  |
| `CULNG` | FUNCTION | codegen builtin |  |
| `CURDIR` | FUNCTION | codegen builtin |  |
| `CVBYT` | FUNCTION | codegen builtin |  |
| `CVCUX` | FUNCTION | codegen builtin |  |
| `CVDWD` | FUNCTION | codegen builtin |  |
| `CVL` | FUNCTION | codegen builtin |  |
| `CVQ` | FUNCTION | codegen builtin |  |
| `CVW` | FUNCTION | codegen builtin |  |
| `CWORD` | FUNCTION | codegen builtin |  |
| `DATA` | STATEMENT | PB/Win + PB/CC | Established |
| `DATACOUNT` | FUNCTION | codegen builtin |  |
| `DAYNAME` | FUNCTION | codegen builtin |  |
| `DEC` | FUNCTION | codegen builtin |  |
| `DECLARE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `DECR` | STATEMENT | PB/Win + PB/CC | Established |
| `DESKTOP GET CLIENT` | STATEMENT | PB/Win + PB/CC | Established |
| `DESKTOP GET LOC` | STATEMENT | PB/Win + PB/CC | Established |
| `DESKTOP GET PPI` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `DESKTOP GET SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `DIALOG DEFAULT FONT` | STATEMENT | PB/Win only | Established |
| `DIALOG DISABLE` | STATEMENT | PB/Win only | Established |
| `DIALOG DOEVENTS` | STATEMENT | PB/Win only | Established |
| `DIALOG ENABLE` | STATEMENT | PB/Win only | Established |
| `DIALOG END` | STATEMENT | PB/Win only | Established |
| `DIALOG GET CLIENT` | STATEMENT | PB/Win only | Proposed Improvement |
| `DIALOG GET LOC` | STATEMENT | PB/Win only | Proposed Improvement |
| `DIALOG GET SIZE` | STATEMENT | PB/Win only | Proposed Improvement |
| `DIALOG GET TEXT` | STATEMENT | PB/Win only | Established |
| `DIALOG GET USER` | STATEMENT | PB/Win only | Established |
| `DIALOG HIDE` | STATEMENT | PB/Win only | Established |
| `DIALOG MAXIMIZE` | STATEMENT | PB/Win only | Established |
| `DIALOG MINIMIZE` | STATEMENT | PB/Win only | Established |
| `DIALOG NEW` | STATEMENT | PB/Win only | Proposed Improvement |
| `DIALOG NONSTABLE` | STATEMENT | PB/Win only | Established |
| `DIALOG NORMALIZE` | STATEMENT | PB/Win only | Established |
| `DIALOG PIXELS` | STATEMENT | PB/Win only | Established |
| `DIALOG POST` | STATEMENT | PB/Win only | Established |
| `DIALOG REDRAW` | STATEMENT | PB/Win only | Established |
| `DIALOG SEND` | STATEMENT | PB/Win only | Established |
| `DIALOG SET CLIENT` | STATEMENT | PB/Win only | Proposed Improvement |
| `DIALOG SET COLOR` | STATEMENT | PB/Win only | Established |
| `DIALOG SET ICON` | STATEMENT | PB/Win only | Established |
| `DIALOG SET LOC` | STATEMENT | PB/Win only | Proposed Improvement |
| `DIALOG SET SIZE` | STATEMENT | PB/Win only | Proposed Improvement |
| `DIALOG SET TEXT` | STATEMENT | PB/Win only | Established |
| `DIALOG SET USER` | STATEMENT | PB/Win only | Established |
| `DIALOG SHOW MODAL` | STATEMENT | PB/Win only | Established |
| `DIALOG SHOW MODELESS` | STATEMENT | PB/Win only | Established |
| `DIALOG SHOW STATE` | STATEMENT | PB/Win only | Established |
| `DIALOG STABILIZE` | STATEMENT | PB/Win only | Established |
| `DIALOG TRAXOMATIC` | STATEMENT | PB/Win only | Proposed New |
| `DIALOG UNITS` | STATEMENT | PB/Win only | Established |
| `DIALOG XLAT` | STATEMENT | PB/Win only | Proposed New |
| `DIM` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `DIR` | FUNCTION | codegen builtin |  |
| `DIR FUNCTION AND` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `DISKFREE` | FUNCTION | codegen builtin |  |
| `DISKSIZE` | FUNCTION | codegen builtin |  |
| `DISPLAY BROWSE` | STATEMENT | PB/Win only | Established |
| `DISPLAY COLOR` | STATEMENT | PB/Win only | Established |
| `DISPLAY FONT` | STATEMENT | PB/Win only | Established |
| `DISPLAY OPENFILE` | STATEMENT | PB/Win only | Established |
| `DISPLAY SAVEFILE` | STATEMENT | PB/Win only | Established |
| `DISPLAY_BROWSE` | FUNCTION | codegen builtin |  |
| `DISPLAY_COLOR` | FUNCTION | codegen builtin |  |
| `DISPLAY_FONT` | FUNCTION | codegen builtin |  |
| `DISPLAY_OPENFILE` | FUNCTION | codegen builtin |  |
| `DISPLAY_SAVEFILE` | FUNCTION | codegen builtin |  |
| `DOUBLE` | FUNCTION | codegen builtin |  |
| `END` | STATEMENT | PB/Win + PB/CC | Established |
| `ENVIRON` | STATEMENT | PB/Win + PB/CC | Established |
| `EOF` | FUNCTION | codegen builtin |  |
| `ERASE` | STATEMENT | PB/Win + PB/CC | Established |
| `ERF` | FUNCTION | C runtime (MSVCRT) |  |
| `ERL` | FUNCTION | codegen builtin |  |
| `ERR` | FUNCTION | codegen builtin |  |
| `ERRCLEAR` | FUNCTION | codegen builtin |  |
| `ERROR` | STATEMENT | PB/Win + PB/CC | Established |
| `EVENT SOURCE` | STATEMENT | PB/Win + PB/CC | Established |
| `EVENTS` | STATEMENT | PB/Win + PB/CC | Established |
| `EXE` | FUNCTION | codegen builtin |  |
| `EXIST` | FUNCTION | codegen builtin |  |
| `EXIT` | STATEMENT | PB/Win + PB/CC | Established |
| `EXP` | FUNCTION | LLVM intrinsic |  |
| `EXP10` | FUNCTION | LLVM intrinsic |  |
| `EXP2` | FUNCTION | LLVM intrinsic |  |
| `EXPM1` | FUNCTION | C runtime (MSVCRT) |  |
| `EXTRACT` | FUNCTION | codegen builtin |  |
| `FIELD` | STATEMENT | PB/Win + PB/CC | Established |
| `FILEATTR` | FUNCTION | codegen builtin |  |
| `FILECOPY` | STATEMENT | PB/Win + PB/CC | Established |
| `FILENAME` | FUNCTION | codegen builtin |  |
| `FILESCAN` | STATEMENT | PB/Win + PB/CC | Established |
| `FIX` | FUNCTION | codegen builtin |  |
| `FLOOR` | FUNCTION | LLVM intrinsic |  |
| `FLUSH` | STATEMENT | PB/Win + PB/CC | Established |
| `FONT END` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `FONT NEW` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `FONT_END` | FUNCTION | codegen builtin |  |
| `FONT_NEW` | FUNCTION | codegen builtin |  |
| `FOR / NEXT` | STATEMENT | PB/Win + PB/CC | Established |
| `FORMAT` | FUNCTION | codegen builtin |  |
| `FRAC` | FUNCTION | codegen builtin |  |
| `FRE` | FUNCTION | codegen builtin |  |
| `FREEFILE` | FUNCTION | codegen builtin |  |
| `FUNCTION / END FUNCTION` | STATEMENT | PB/Win + PB/CC | Established |
| `GET` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GET$` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GET$$` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GET_STR` | FUNCTION | codegen builtin |  |
| `GET_WSTR` | FUNCTION | codegen builtin |  |
| `GETATTR` | FUNCTION | codegen builtin |  |
| `GLOBAL` | STATEMENT | PB/Win + PB/CC | Established |
| `GLOBALMEM` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC ARC` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC ATTACH` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC BITMAP CAPTURE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `GRAPHIC BITMAP END` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC BITMAP LOAD` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC BITMAP NEW` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC BOX` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC CELL` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC CELL SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC CHR SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC CLEAR` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC COLOR` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC COPY` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC DETACH` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC ELLIPSE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET BITS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET CANVAS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET CAPTION` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET CLIENT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC GET CLIP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET DC` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET LINES` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET LOC` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC GET MIX` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET OVERLAP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET PIXEL` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET POS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET PPI` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET SCALE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET SCROLLTEXT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET SIZE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC GET STRETCHMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET TEXTALIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `GRAPHIC GET VIEW` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET WORDWRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET WRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC IMAGELIST` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC INKEY$` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC INPUT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC INPUT FLUSH` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC INSTAT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC LINE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC LINE INPUT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC PAINT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC PIE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC POLYGON` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC POLYLINE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC PRINT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC REDRAW` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC RENDER` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SAVE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SCALE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET AUTOSIZE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC SET BITS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET CAPTION` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET CLIENT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC SET CLIP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET FIXED` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET FOCUS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET FONT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET LOC` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC SET MIX` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET OVERLAP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET PIXEL` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET POS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET SCROLLTEXT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET SIZE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC SET STRETCHMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET TEXTALIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `GRAPHIC SET VIEW` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET VIRTUAL` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC SET WORDWRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET WRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SPLIT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC STRETCH` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC STYLE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC TEXT SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WAITKEY$` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WIDTH` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WINDOW` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WINDOW CLICK` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WINDOW END` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WINDOW HIDE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WINDOW MINIMIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WINDOW NONSTABLE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WINDOW NORMALIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WINDOW STABILIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC_ARC` | FUNCTION | codegen builtin |  |
| `GRAPHIC_ATTACH` | FUNCTION | codegen builtin |  |
| `GRAPHIC_BITMAP_END` | FUNCTION | codegen builtin |  |
| `GRAPHIC_BITMAP_LOAD` | FUNCTION | codegen builtin |  |
| `GRAPHIC_BITMAP_NEW` | FUNCTION | codegen builtin |  |
| `GRAPHIC_CELL` | FUNCTION | codegen builtin |  |
| `GRAPHIC_CHR_SIZE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_CIRCLE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_CLEAR` | FUNCTION | codegen builtin |  |
| `GRAPHIC_COLOR` | FUNCTION | codegen builtin |  |
| `GRAPHIC_COPY` | FUNCTION | codegen builtin |  |
| `GRAPHIC_DETACH` | FUNCTION | codegen builtin |  |
| `GRAPHIC_ELLIPSE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_BITS` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_CAPTION` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_CLIP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_DC` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_LINES` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_LOC` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_MIX` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_PIXEL` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_POS` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_PPI` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_SCALE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_SIZE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_STRETCHMODE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_TEXTALIGN` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_VIEW` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_WORDWRAP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_WRAP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_LINE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_PAINT` | FUNCTION | codegen builtin |  |
| `GRAPHIC_PIE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_POLYGON` | FUNCTION | codegen builtin |  |
| `GRAPHIC_POLYLINE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SAVE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SCALE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SCALE_PIXELS` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_AUTOSIZE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_BITS` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_CAPTION` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_CLIP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_FIXED` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_FONT` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_MIX` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_PIXEL` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_POS` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_SIZE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_STRETCHMODE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_TEXTALIGN` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_VIEW` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_VIRTUAL` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_WORDWRAP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_WRAP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_STYLE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_TEXT_SIZE` | FUNCTION | codegen builtin |  |
| `HEADER` | STATEMENT | PB/Win only | Established |
| `HEADER_CTRL` | FUNCTION | codegen builtin |  |
| `HEX` | FUNCTION | codegen builtin |  |
| `HIWRD` | FUNCTION | codegen builtin |  |
| `HOST ADDR` | STATEMENT | PB/Win + PB/CC | Established |
| `HOST NAME` | STATEMENT | PB/Win + PB/CC | Established |
| `HYPOT` | FUNCTION | C runtime (MSVCRT) |  |
| `IF` | STATEMENT | PB/Win + PB/CC | Established |
| `IF/END IF` | BLOCK | PB/Win + PB/CC | Established |
| `IIF` | FUNCTION | codegen builtin |  |
| `IMAGELIST` | STATEMENT | PB/Win only | Established |
| `IMAGELIST_COUNT` | FUNCTION | codegen builtin |  |
| `IMAGELIST_KILL` | FUNCTION | codegen builtin |  |
| `IMAGELIST_NEW` | FUNCTION | codegen builtin |  |
| `IMPORT` | STATEMENT | PB/Win + PB/CC | Established |
| `INCR` | STATEMENT | PB/Win + PB/CC | Established |
| `INPUT FLUSH` | STATEMENT | PB/CC only | Established |
| `INPUT#` | STATEMENT | PB/CC only | Proposed Improvement |
| `INSTANCE` | STATEMENT | PB/Win + PB/CC | Established |
| `INSTR` | FUNCTION | codegen builtin |  |
| `INT` | FUNCTION | codegen builtin |  |
| `INTEGER` | FUNCTION | codegen builtin |  |
| `INTERFACE / END INTERFACE (DIRECT)` | BLOCK | PB/Win + PB/CC | Established |
| `INTERFACE/END INTERFACE (IDBIND)` | BLOCK | PB/Win + PB/CC | Established |
| `ISEVEN` | FUNCTION | codegen builtin |  |
| `ISFALSE` | FUNCTION | codegen builtin |  |
| `ISFILE` | FUNCTION | codegen builtin |  |
| `ISFOLDER` | FUNCTION | codegen builtin |  |
| `ISINFINITE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ISNORMAL` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ISODD` | FUNCTION | codegen builtin |  |
| `ISTRUE` | FUNCTION | codegen builtin |  |
| `ITERATE` | STATEMENT | PB/Win + PB/CC | Established |
| `KILL` | STATEMENT | PB/Win + PB/CC | Established |
| `LCASE` | FUNCTION | codegen builtin |  |
| `LEFT` | FUNCTION | codegen builtin |  |
| `LEN` | FUNCTION | codegen builtin |  |
| `LET` | STATEMENT | PB/Win + PB/CC | Established |
| `LET *(WITH OBJECTS)*` | STATEMENT | PB/Win + PB/CC | Established |
| `LET *(WITH TYPES)*` | STATEMENT | PB/Win + PB/CC | Established |
| `LET *(WITH VARIANTS)*` | STATEMENT | PB/Win + PB/CC | Established |
| `LINE INPUT#` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `LISTBOX` | STATEMENT | PB/Win only | Established |
| `LISTVIEW` | STATEMENT | PB/Win only | Established |
| `LO` | FUNCTION | codegen builtin |  |
| `LOCAL` | STATEMENT | PB/Win + PB/CC | Established |
| `LOCK` | STATEMENT | PB/Win + PB/CC | Established |
| `LOG` | FUNCTION | LLVM intrinsic |  |
| `LOG10` | FUNCTION | LLVM intrinsic |  |
| `LOG1P` | FUNCTION | C runtime (MSVCRT) |  |
| `LOG2` | FUNCTION | LLVM intrinsic |  |
| `LONG` | FUNCTION | codegen builtin |  |
| `LOWRD` | FUNCTION | codegen builtin |  |
| `LPRINT` | STATEMENT | PB/Win + PB/CC | Established |
| `LPRINT ATTACH` | STATEMENT | PB/Win + PB/CC | Established |
| `LPRINT CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `LPRINT FLUSH` | STATEMENT | PB/Win + PB/CC | Established |
| `LPRINT FORMFEED` | STATEMENT | PB/Win + PB/CC | Established |
| `LSET` | STATEMENT | PB/Win + PB/CC | Established |
| `LTRIM` | FUNCTION | codegen builtin |  |
| `MACRO/END MACRO` | BLOCK | PB/Win + PB/CC | Established |
| `MAK` | FUNCTION | codegen builtin |  |
| `MAT` | STATEMENT | PB/Win + PB/CC | Established |
| `MAX` | FUNCTION | codegen builtin |  |
| `MEMORY` | STATEMENT | PB/Win + PB/CC | Established |
| `MEMORY_FILL` | FUNCTION | codegen builtin |  |
| `MEMORY_FILLS` | FUNCTION | codegen builtin |  |
| `MENU ADD POPUP` | STATEMENT | PB/Win only | Established |
| `MENU ADD STRING` | STATEMENT | PB/Win only | Established |
| `MENU ATTACH` | STATEMENT | PB/Win only | Established |
| `MENU CONTEXT` | STATEMENT | PB/Win only | Established |
| `MENU DELETE` | STATEMENT | PB/Win only | Established |
| `MENU DRAW BAR` | STATEMENT | PB/Win only | Established |
| `MENU GET STATE` | STATEMENT | PB/Win only | Established |
| `MENU GET TEXT` | STATEMENT | PB/Win only | Established |
| `MENU NEW BAR` | STATEMENT | PB/Win only | Established |
| `MENU NEW POPUP` | STATEMENT | PB/Win only | Established |
| `MENU SET STATE` | STATEMENT | PB/Win only | Established |
| `MENU SET TEXT` | STATEMENT | PB/Win only | Established |
| `MENU_ADD_POPUP` | FUNCTION | codegen builtin |  |
| `MENU_ADD_STRING` | FUNCTION | codegen builtin |  |
| `MENU_DELETE` | FUNCTION | codegen builtin |  |
| `MENU_GET_STATE` | FUNCTION | codegen builtin |  |
| `MENU_GET_TEXT` | FUNCTION | codegen builtin |  |
| `MENU_NEW_POPUP` | FUNCTION | codegen builtin |  |
| `MENU_SET_STATE` | FUNCTION | codegen builtin |  |
| `MENU_SET_TEXT` | FUNCTION | codegen builtin |  |
| `METHOD / END METHOD` | STATEMENT | PB/Win + PB/CC | Established |
| `MID` | FUNCTION | codegen builtin |  |
| `MID$` | STATEMENT | PB/Win + PB/CC | Established |
| `MIN` | FUNCTION | codegen builtin |  |
| `MKBYT` | FUNCTION | codegen builtin |  |
| `MKBYT$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKCUR$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKCUX` | FUNCTION | codegen builtin |  |
| `MKCUX$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKD$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKDIR` | STATEMENT | PB/Win + PB/CC | Established |
| `MKDWD` | FUNCTION | codegen builtin |  |
| `MKDWD$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKE` | FUNCTION | codegen builtin |  |
| `MKE$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKI$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKL$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKQ$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKS` | FUNCTION | codegen builtin |  |
| `MKS$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKWRD` | FUNCTION | codegen builtin |  |
| `MKWRD$` | STATEMENT | PB/Win + PB/CC | Established |
| `MOD` | FUNCTION | codegen builtin |  |
| `MONTHNAME` | FUNCTION | codegen builtin |  |
| `MOUSEPTR` | STATEMENT | PB/CC only | Established |
| `MSGBOX` | STATEMENT | PB/Win only | Established |
| `NAME` | STATEMENT | PB/Win + PB/CC | Established |
| `OBJECT` | STATEMENT | PB/Win + PB/CC | Established |
| `OCT` | FUNCTION | codegen builtin |  |
| `OEMTOCHR` | FUNCTION | codegen builtin |  |
| `ON CALL` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ON ERROR` | STATEMENT | PB/Win + PB/CC | Established |
| `ON GOSUB` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `ON GOTO` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `OPEN` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `OPTION EXPLICIT` | STATEMENT | PB/Win + PB/CC | Established |
| `PARSE` | STATEMENT | PB/Win + PB/CC | Established |
| `PARSECOUNT` | FUNCTION | codegen builtin |  |
| `PATHNAME` | FUNCTION | codegen builtin |  |
| `PATHSCAN` | FUNCTION | codegen builtin |  |
| `PEEK` | FUNCTION | codegen builtin |  |
| `PLAY SOUND` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `PLAY WAVE` | STATEMENT | PB/Win + PB/CC | Established |
| `POKE` | FUNCTION | codegen builtin |  |
| `PREFIX` | BLOCK | PB/Win + PB/CC | Established |
| `PRINT#` | STATEMENT | PB/Win + PB/CC | Established |
| `PRINTERCOUNT` | FUNCTION | codegen builtin |  |
| `PROCESS GET PRIORITY` | STATEMENT | PB/Win + PB/CC | Established |
| `PROCESS SET PRIORITY` | STATEMENT | PB/Win + PB/CC | Established |
| `PROFILE` | STATEMENT | PB/Win + PB/CC | Established |
| `PROGRESSBAR` | STATEMENT | PB/Win only | Established |
| `PUT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `PUT$` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `PUT$$` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `PUT_STR` | FUNCTION | codegen builtin |  |
| `PUT_WSTR` | FUNCTION | codegen builtin |  |
| `QUAD` | FUNCTION | codegen builtin |  |
| `RAISEEVENT` | STATEMENT | PB/Win + PB/CC | Established |
| `RANDOMIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `READ` | FUNCTION | codegen builtin |  |
| `REDIM` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `REGEXPR` | STATEMENT | PB/Win + PB/CC | Established |
| `REGISTER` | STATEMENT | PB/Win + PB/CC | Established |
| `REGREPL` | STATEMENT | PB/Win + PB/CC | Established |
| `REM` | STATEMENT | PB/Win + PB/CC | Established |
| `REMAIN` | FUNCTION | codegen builtin |  |
| `REMOVE` | FUNCTION | codegen builtin |  |
| `REPEAT` | FUNCTION | codegen builtin |  |
| `REPLACE` | STATEMENT | PB/Win + PB/CC | Established |
| `RESET` | STATEMENT | PB/Win + PB/CC | Established |
| `RESOURCE SAVE FILE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `RESOURCE_SAVE_FILE` | FUNCTION | codegen builtin |  |
| `RESUME` | STATEMENT | PB/Win + PB/CC | Established |
| `RETAIN` | FUNCTION | codegen builtin |  |
| `RETURN` | STATEMENT | PB/Win + PB/CC | Established |
| `RIGHT` | FUNCTION | codegen builtin |  |
| `RMDIR` | STATEMENT | PB/Win + PB/CC | Established |
| `RND` | FUNCTION | codegen builtin |  |
| `ROTATE` | STATEMENT | PB/Win + PB/CC | Established |
| `ROUND` | FUNCTION | LLVM intrinsic |  |
| `RSET` | STATEMENT | PB/Win + PB/CC | Established |
| `RTRIM` | FUNCTION | codegen builtin |  |
| `SCROLLBAR` | STATEMENT | PB/Win only | Established |
| `SEC` | FUNCTION | C runtime (MSVCRT) |  |
| `SECH` | FUNCTION | C runtime (MSVCRT) |  |
| `SEEK` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `SELECT CASE/END SELECT` | BLOCK | PB/Win + PB/CC | Established |
| `SETATTR` | STATEMENT | PB/Win + PB/CC | Established |
| `SETEOF` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `SGN` | FUNCTION | codegen builtin |  |
| `SHELL` | STATEMENT | PB/Win + PB/CC | Established |
| `SHIFT` | STATEMENT | PB/Win + PB/CC | Established |
| `SHRINK` | FUNCTION | codegen builtin |  |
| `SIN` | FUNCTION | LLVM intrinsic |  |
| `SINGLE` | FUNCTION | codegen builtin |  |
| `SINH` | FUNCTION | LLVM intrinsic |  |
| `SIZEOF` | FUNCTION | codegen builtin |  |
| `SLEEP` | STATEMENT | PB/Win + PB/CC | Established |
| `SPACE` | FUNCTION | codegen builtin |  |
| `SPLIT` | STATEMENT | PB/Win + PB/CC | Established |
| `SQR` | FUNCTION | LLVM intrinsic |  |
| `STATIC` | STATEMENT | PB/Win + PB/CC | Established |
| `STATUSBAR` | STATEMENT | PB/Win + PB/CC | Established |
| `STR` | FUNCTION | codegen builtin |  |
| `STRDELETE` | FUNCTION | codegen builtin |  |
| `STRING` | FUNCTION | codegen builtin |  |
| `STRINSERT` | FUNCTION | codegen builtin |  |
| `STRPTR` | FUNCTION | codegen builtin |  |
| `STRREVERSE` | FUNCTION | codegen builtin |  |
| `SWAP` | STATEMENT | PB/Win + PB/CC | Established |
| `SWITCH$` | FUNCTION | codegen builtin |  |
| `TAB` | STATEMENT | PB/Win only | Established |
| `TALLY` | FUNCTION | codegen builtin |  |
| `TAN` | FUNCTION | LLVM intrinsic |  |
| `TANH` | FUNCTION | LLVM intrinsic |  |
| `TCP ACCEPT` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP LINE INPUT` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP NOTIFY` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP OPEN` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP PRINT` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP RECV` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP SEND` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP_NOTIFY` | FUNCTION | codegen builtin |  |
| `THREAD CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD CREATE` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD GET PRIORITY` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD RESUME` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD SET PRIORITY` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD STATUS` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD SUSPEND` | STATEMENT | PB/Win + PB/CC | Established |
| `THREADCOUNT` | FUNCTION | codegen builtin |  |
| `THREADED` | STATEMENT | PB/Win + PB/CC | Established |
| `TIMER` | FUNCTION | codegen builtin |  |
| `TIX` | STATEMENT | PB/Win + PB/CC | Established |
| `TOOLBAR` | STATEMENT | PB/Win only | Established |
| `TRACE` | STATEMENT | PB/Win + PB/CC | Established |
| `TREEVIEW` | STATEMENT | PB/Win only | Established |
| `TRIM` | FUNCTION | codegen builtin |  |
| `TRUNC` | FUNCTION | LLVM intrinsic |  |
| `TRY/END TRY` | BLOCK | PB/Win + PB/CC | Established |
| `TYPE SET` | STATEMENT | PB/Win + PB/CC | Established |
| `TYPE/END TYPE` | BLOCK | PB/Win + PB/CC | Established |
| `UCASE` | FUNCTION | codegen builtin |  |
| `UCODEPAGE` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP NOTIFY` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP OPEN` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP RECV` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP SEND` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP_NOTIFY` | FUNCTION | codegen builtin |  |
| `UNLOCK` | STATEMENT | PB/Win + PB/CC | Established |
| `UNWRAP` | FUNCTION | codegen builtin |  |
| `USING` | FUNCTION | codegen builtin |  |
| `UTF8TOCHR` | FUNCTION | codegen builtin |  |
| `VAL` | STATEMENT | PB/Win + PB/CC | Established |
| `VARPTR` | FUNCTION | codegen builtin |  |
| `VERIFY` | FUNCTION | codegen builtin |  |
| `WAITKEY` | FUNCTION | codegen builtin |  |
| `WINDOW GET` | STATEMENT | PB/Win only | Established |
| `WINDOW SET` | STATEMENT | PB/Win only | Established |
| `WORD` | FUNCTION | codegen builtin |  |
| `WRAP` | FUNCTION | codegen builtin |  |
| `WRITE` | FUNCTION | codegen builtin |  |
| `WRITE#` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `XPRINT ARC` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT ATTACH` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT BOX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT CANCEL` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT CELL` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT CELL SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT CHR SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT COLOR` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT COPY` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT ELLIPSE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT FORMFEED` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET ATTACH` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET CANVAS` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET CLIENT` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET CLIP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET COLLATE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET COLORMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET COPIES` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET DC` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET DUPLEX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET LINES` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET MARGIN` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET MIX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET ORIENTATION` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET OVERLAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PAGES` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PAPER` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PAPERS` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PIXEL` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET POS` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PPI` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET QUALITY` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET SCALE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET SELECTION` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET STRETCHMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET TEXTALIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `XPRINT GET TRAY` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET TRAYS` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET WORDWRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET WRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT IMAGELIST` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT LINE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT PIE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT POLYGON` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT POLYLINE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT PREVIEW` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT PRINT` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT RENDER` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SCALE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET CLIP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET COLLATE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET COLORMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET COPIES` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET DUPLEX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET FONT` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET MIX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET ORIENTATION` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET OVERLAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET PAGES` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET PAPER` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET PIXEL` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET POS` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET QUALITY` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET STRETCHMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET TEXTALIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `XPRINT SET TRAY` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET WORDWRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET WRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SPLIT` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT STRETCH` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT STYLE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT TEXT SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT WIDTH` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT_ARC` | FUNCTION | codegen builtin |  |
| `XPRINT_ATTACH` | FUNCTION | codegen builtin |  |
| `XPRINT_BOX` | FUNCTION | codegen builtin |  |
| `XPRINT_CANCEL` | FUNCTION | codegen builtin |  |
| `XPRINT_CELL` | FUNCTION | codegen builtin |  |
| `XPRINT_CELL_SIZE` | FUNCTION | codegen builtin |  |
| `XPRINT_CHR_SIZE` | FUNCTION | codegen builtin |  |
| `XPRINT_CLOSE` | FUNCTION | codegen builtin |  |
| `XPRINT_COPY` | FUNCTION | codegen builtin |  |
| `XPRINT_ELLIPSE` | FUNCTION | codegen builtin |  |
| `XPRINT_FORMFEED` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_ATTACH` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_CANVAS` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_CLIENT` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_CLIP` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_COLLATE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_COLOR` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_COLORMODE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_COPIES` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_DC` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_DUPLEX` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_LINES` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_MARGIN` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_MIX` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_ORIENTATION` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_OVERLAP` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PAGES` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PAPER` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PAPERS` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PIXEL` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_POS` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PPI` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_QUALITY` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_SCALE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_SELECTION` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_SIZE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_STRETCHMODE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_TEXTALIGN` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_TRAY` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_TRAYS` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_WORDWRAP` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_WRAP` | FUNCTION | codegen builtin |  |
| `XPRINT_IMAGELIST` | FUNCTION | codegen builtin |  |
| `XPRINT_LINE` | FUNCTION | codegen builtin |  |
| `XPRINT_PIE` | FUNCTION | codegen builtin |  |
| `XPRINT_POLYGON` | FUNCTION | codegen builtin |  |
| `XPRINT_POLYLINE` | FUNCTION | codegen builtin |  |
| `XPRINT_PREVIEW` | FUNCTION | codegen builtin |  |
| `XPRINT_PRINT` | FUNCTION | codegen builtin |  |
| `XPRINT_RENDER` | FUNCTION | codegen builtin |  |
| `XPRINT_SCALE` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_CLIP` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_COLLATE` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_COLOR` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_COLORMODE` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_COPIES` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_DUPLEX` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_FONT` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_MIX` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_ORIENTATION` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_OVERLAP` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_PAGES` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_PAPER` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_PIXEL` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_POS` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_QUALITY` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_STRETCHMODE` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_TEXTALIGN` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_TRAY` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_WORDWRAP` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_WRAP` | FUNCTION | codegen builtin |  |
| `XPRINT_SPLIT` | FUNCTION | codegen builtin |  |
| `XPRINT_STRETCH` | FUNCTION | codegen builtin |  |
| `XPRINT_STYLE` | FUNCTION | codegen builtin |  |
| `XPRINT_TEXT_SIZE` | FUNCTION | codegen builtin |  |
| `XPRINT_WIDTH` | FUNCTION | codegen builtin |  |
## 🚧 Tier-3 DDT (129, deferred to next update)

| Keyword | Official kind |
|---------|---------------|
| ACCEL ATTACH | STATEMENT |
| COMBOBOX | STATEMENT |
| CONTROL ADD *CUSTOM CONTROL* | STATEMENT |
| CONTROL ADD BUTTON | STATEMENT |
| CONTROL ADD CHECK3STATE | STATEMENT |
| CONTROL ADD CHECKBOX | STATEMENT |
| CONTROL ADD COMBOBOX | STATEMENT |
| CONTROL ADD FRAME | STATEMENT |
| CONTROL ADD GRAPHIC | STATEMENT |
| CONTROL ADD HEADER | STATEMENT |
| CONTROL ADD IMAGE | STATEMENT |
| CONTROL ADD IMAGEX | STATEMENT |
| CONTROL ADD IMGBUTTON | STATEMENT |
| CONTROL ADD IMGBUTTONX | STATEMENT |
| CONTROL ADD LABEL | STATEMENT |
| CONTROL ADD LINE | STATEMENT |
| CONTROL ADD LISTBOX | STATEMENT |
| CONTROL ADD LISTVIEW | STATEMENT |
| CONTROL ADD OPTION | STATEMENT |
| CONTROL ADD PROGRESSBAR | STATEMENT |
| CONTROL ADD SCROLLBAR | STATEMENT |
| CONTROL ADD STATUSBAR | STATEMENT |
| CONTROL ADD TAB | STATEMENT |
| CONTROL ADD TEXTBOX | STATEMENT |
| CONTROL ADD TOOLBAR | STATEMENT |
| CONTROL ADD TREEVIEW | STATEMENT |
| CONTROL DISABLE | STATEMENT |
| CONTROL ENABLE | STATEMENT |
| CONTROL GET CHECK | STATEMENT |
| CONTROL GET CLIENT | STATEMENT |
| CONTROL GET LOC | STATEMENT |
| CONTROL GET SIZE | STATEMENT |
| CONTROL GET TEXT | STATEMENT |
| CONTROL GET USER | STATEMENT |
| CONTROL HANDLE | STATEMENT |
| CONTROL HIDE | STATEMENT |
| CONTROL KILL | STATEMENT |
| CONTROL NORMALIZE | STATEMENT |
| CONTROL POST | STATEMENT |
| CONTROL REDRAW | STATEMENT |
| CONTROL SEND | STATEMENT |
| CONTROL SET CHECK | STATEMENT |
| CONTROL SET CLIENT | STATEMENT |
| CONTROL SET COLOR | STATEMENT |
| CONTROL SET FOCUS | STATEMENT |
| CONTROL SET FONT | STATEMENT |
| CONTROL SET IMAGE | STATEMENT |
| CONTROL SET IMAGEX | STATEMENT |
| CONTROL SET IMGBUTTON | STATEMENT |
| CONTROL SET IMGBUTTONX | STATEMENT |
| CONTROL SET LOC | STATEMENT |
| CONTROL SET OPTION | STATEMENT |
| CONTROL SET SIZE | STATEMENT |
| CONTROL SET TEXT | STATEMENT |
| CONTROL SET USER | STATEMENT |
| CONTROL SHOW STATE | STATEMENT |
| CONTROL TRAXOMATIC | STATEMENT |
| DIALOG DEFAULT FONT | STATEMENT |
| DIALOG DISABLE | STATEMENT |
| DIALOG ENABLE | STATEMENT |
| DIALOG END | STATEMENT |
| DIALOG GET CLIENT | STATEMENT |
| DIALOG GET LOC | STATEMENT |
| DIALOG GET SIZE | STATEMENT |
| DIALOG GET TEXT | STATEMENT |
| DIALOG GET USER | STATEMENT |
| DIALOG HIDE | STATEMENT |
| DIALOG MAXIMIZE | STATEMENT |
| DIALOG MINIMIZE | STATEMENT |
| DIALOG NEW | STATEMENT |
| DIALOG NONSTABLE | STATEMENT |
| DIALOG NORMALIZE | STATEMENT |
| DIALOG PIXELS | STATEMENT |
| DIALOG POST | STATEMENT |
| DIALOG REDRAW | STATEMENT |
| DIALOG SEND | STATEMENT |
| DIALOG SET CLIENT | STATEMENT |
| DIALOG SET COLOR | STATEMENT |
| DIALOG SET ICON | STATEMENT |
| DIALOG SET LOC | STATEMENT |
| DIALOG SET SIZE | STATEMENT |
| DIALOG SET TEXT | STATEMENT |
| DIALOG SET USER | STATEMENT |
| DIALOG SHOW MODAL | STATEMENT |
| DIALOG SHOW MODELESS | STATEMENT |
| DIALOG SHOW STATE | STATEMENT |
| DIALOG STABILIZE | STATEMENT |
| DIALOG TRAXOMATIC | STATEMENT |
| DIALOG UNITS | STATEMENT |
| DIALOG XLAT | STATEMENT |
| GRAPHIC BITMAP CAPTURE | STATEMENT |
| GRAPHIC BITMAP LOAD | STATEMENT |
| GRAPHIC CELL | STATEMENT |
| GRAPHIC CELL SIZE | STATEMENT |
| GRAPHIC CHR SIZE | STATEMENT |
| GRAPHIC COLOR | STATEMENT |
| GRAPHIC COPY | STATEMENT |
| GRAPHIC GET CANVAS | STATEMENT |
| GRAPHIC GET CLIENT | STATEMENT |
| GRAPHIC GET DC | STATEMENT |
| GRAPHIC GET LOC | STATEMENT |
| GRAPHIC GET MIX | STATEMENT |
| GRAPHIC GET OVERLAP | STATEMENT |
| GRAPHIC GET PIXEL | STATEMENT |
| GRAPHIC GET SCROLLTEXT | STATEMENT |
| GRAPHIC IMAGELIST | STATEMENT |
| GRAPHIC INKEY$ | STATEMENT |
| GRAPHIC INPUT | STATEMENT |
| GRAPHIC INPUT FLUSH | STATEMENT |
| GRAPHIC INSTAT | STATEMENT |
| GRAPHIC LINE INPUT | STATEMENT |
| GRAPHIC POLYGON | STATEMENT |
| GRAPHIC PRINT | STATEMENT |
| GRAPHIC REDRAW | STATEMENT |
| GRAPHIC RENDER | STATEMENT |
| GRAPHIC SAVE | STATEMENT |
| GRAPHIC SET CLIENT | STATEMENT |
| GRAPHIC SET FOCUS | STATEMENT |
| GRAPHIC SET LOC | STATEMENT |
| GRAPHIC SET MIX | STATEMENT |
| GRAPHIC SET OVERLAP | STATEMENT |
| GRAPHIC SET SCROLLTEXT | STATEMENT |
| GRAPHIC SPLIT | STATEMENT |
| GRAPHIC STRETCH | STATEMENT |
| GRAPHIC STYLE | STATEMENT |
| GRAPHIC WAITKEY$ | STATEMENT |
| GRAPHIC WIDTH | STATEMENT |
| GRAPHIC WINDOW | STATEMENT |
| GRAPHIC WINDOW CLICK | STATEMENT |
| GRAPHIC WINDOW END | STATEMENT |
| GRAPHIC WINDOW HIDE | STATEMENT |
| GRAPHIC WINDOW MINIMIZE | STATEMENT |
| GRAPHIC WINDOW NONSTABLE | STATEMENT |
| GRAPHIC WINDOW NORMALIZE | STATEMENT |
| GRAPHIC WINDOW STABILIZE | STATEMENT |
| LISTBOX | STATEMENT |
| LISTVIEW | STATEMENT |
| MENU ATTACH | STATEMENT |
| MENU CONTEXT | STATEMENT |
| MENU DRAW BAR | STATEMENT |
| SCROLLBAR | STATEMENT |
| STATUSBAR | STATEMENT |
| TAB | STATEMENT |
| TOOLBAR | STATEMENT |
| TREEVIEW | STATEMENT |

## ⬜ Not implemented (0, alphabetical)

| Keyword | Official kind | Platform | Status |
|---------|---------------|----------|--------|






## Files

- `docs/statement-coverage.md` —this readable summary
- `docs/statement-coverage.csv` —all rows with per-keyword status (Keyword, Kind, Platform, Status, Impl)

## Method

1. Parse `keyword-index.md` from the official docs package (735 keywords, one line per keyword).
2. Keep statement-class keywords (STATEMENT / BLOCK / KEYWORD / DIRECTIVE) = 493.
3. Grep `codegen.rs` for the runtime helpers / Win32 API calls / compile_* functions each keyword maps to.
4. Classify: IMPLEMENTED (real codegen evidence) / TIER3_DDT (GUI framework, deferred) / NOT_IMPL (no evidence).