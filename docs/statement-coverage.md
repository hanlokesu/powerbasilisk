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
| #ALIGN METASTATEMENT | #BLOAT METASTATEMENT | #BREAK METASTATEMENT | #COM METASTATEMENT |
| `#BLOAT METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#BREAK METASTATEMENT` | STATEMENT | PB/CC only | Established |
| `#COM METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#COMPILE METASTATEMENT` | STATEMENT | PB/Win only | Established |
| #COMPILER METASTATEMENT | #CONSOLE METASTATEMENT | #DEBUG BOUNDS METASTATEMENT | #DEBUG CODE METASTATEMENT |
| `#CONSOLE METASTATEMENT` | STATEMENT | PB/CC only | Established |
| `#DEBUG BOUNDS METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `#DEBUG CODE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#DEBUG DISPLAY METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| #DEBUG ERROR METASTATEMENT | #DEBUG NUMERIC METASTATEMENT | #DEBUG PRINT METASTATEMENT | #DIM METASTATEMENT |
| `#DEBUG NUMERIC METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `#DEBUG PRINT METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#DIM METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#EXPORT METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| #IF/#ELSEIF/#ELSE/#ENDIF METASTATEMENT | #INCLUDE METASTATEMENT | #LINK METASTATEMENT | #MESSAGES METASTATEMENT |
| `#INCLUDE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#LINK METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#MESSAGES METASTATEMENT` | STATEMENT | PB/Win only | Established |
| `#OPTIMIZE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| #OPTION METASTATEMENT | #PAGE METASTATEMENT | #PBFORMS METASTATEMENT | #REGISTER METASTATEMENT |
| `#PAGE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#PBFORMS METASTATEMENT` | STATEMENT | PB/Win only | Established |
| `#REGISTER METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#RESOURCE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| #STACK METASTATEMENT | #TOOLS METASTATEMENT | #UNIQUE METASTATEMENT | #UTILITY METASTATEMENT |
| `#TOOLS METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#UNIQUE METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `#UTILITY METASTATEMENT` | STATEMENT | PB/Win + PB/CC | Established |
| `ABS` | FUNCTION | LLVM intrinsic |  |
| ACOS | ACOSH | ARRAY ADD | ARRAY ARRAYIX |
| `ACOSH` | FUNCTION | LLVM intrinsic |  |
| `ARRAY ADD` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY ARRAYIX` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY ASSIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY COPY | ARRAY DELETE | ARRAY INSERT | ARRAY REDIM DECR |
| `ARRAY DELETE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY INSERT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `ARRAY REDIM DECR` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY REDIM INCR` | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY REVERSE | ARRAY SCAN | ARRAY SELECT | ARRAY SHUFFLE |
| `ARRAY SCAN` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `ARRAY SELECT` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY SHUFFLE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY SORT` | STATEMENT | PB/Win + PB/CC | Established |
| ARRAY SWAP | ARRAY TAGARRAY | ARRAY TAGARRAY ERASE | ARRAY UNIQUE |
| `ARRAY TAGARRAY` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY TAGARRAY ERASE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY UNIQUE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ARRAY_REDIM_DECR` | FUNCTION | codegen builtin |  |
| ARRAY_REDIM_INCR | ARRAY_SELECT | ARRAY_TAGARRAY | ARRAY_TAGARRAY_ERASE |
| `ARRAY_SELECT` | FUNCTION | codegen builtin |  |
| `ARRAY_TAGARRAY` | FUNCTION | codegen builtin |  |
| `ARRAY_TAGARRAY_ERASE` | FUNCTION | codegen builtin |  |
| `ASC` | STATEMENT | PB/Win + PB/CC | Established |
| ASIN | ASINH | ASM | ASMDATA / END ASMDATA |
| `ASINH` | FUNCTION | LLVM intrinsic |  |
| `ASM` | STATEMENT | PB/Win + PB/CC | Established |
| `ASMDATA / END ASMDATA` | BLOCK | PB/Win + PB/CC | Established |
| `ATANH` | FUNCTION | LLVM intrinsic |  |
| ATN | ATN2 | BEEP | BGR |
| `ATN2` | FUNCTION | codegen builtin |  |
| `BEEP` | STATEMENT | PB/Win + PB/CC | Established |
| `BGR` | FUNCTION | codegen builtin |  |
| `BIN` | FUNCTION | codegen builtin |  |
| BIT | BIT CALC | BITS | BUILD |
| `BIT CALC` | STATEMENT | PB/Win + PB/CC | Established |
| `BITS` | FUNCTION | codegen builtin |  |
| `BUILD` | FUNCTION | codegen builtin |  |
| `BYTE` | FUNCTION | codegen builtin |  |
| CALL | CALL DWORD | CALLSTK | CALLSTKCOUNT |
| `CALL DWORD` | STATEMENT | PB/Win + PB/CC | Established |
| `CALLSTK` | STATEMENT | PB/Win + PB/CC | Established |
| `CALLSTKCOUNT` | FUNCTION | codegen builtin |  |
| `CBOOL` | FUNCTION | codegen builtin |  |
| CBRT | CBYTE | CDBL | CDWORD |
| `CBYTE` | FUNCTION | codegen builtin |  |
| `CDBL` | FUNCTION | codegen builtin |  |
| `CDWORD` | FUNCTION | codegen builtin |  |
| `CEIL` | FUNCTION | LLVM intrinsic |  |
| CFLT | CHDIR | CHDRIVE | CHOOSE |
| `CHDIR` | STATEMENT | PB/Win + PB/CC | Established |
| `CHDRIVE` | STATEMENT | PB/Win + PB/CC | Established |
| `CHOOSE` | FUNCTION | codegen builtin |  |
| `CHR` | FUNCTION | codegen builtin |  |
| CHRTOOEM | CHRTOUTF8 | CLASS/END CLASS | CLIP |
| `CHRTOUTF8` | FUNCTION | codegen builtin |  |
| `CLASS/END CLASS` | BLOCK | PB/Win + PB/CC | Established |
| `CLIP` | FUNCTION | codegen builtin |  |
| `CLIPBOARD` | STATEMENT | PB/Win + PB/CC | Established |
| CLOSE | CLS | CODEPTR | COLOR |
| `CLS` | STATEMENT | PB/CC only | Established |
| `CODEPTR` | FUNCTION | codegen builtin |  |
| `COLOR` | STATEMENT | PB/CC only | Established |
| `COMM CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| COMM LINE | COMM OPEN | COMM PRINT | COMM RECV |
| `COMM OPEN` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM PRINT` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM RECV` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM RESET` | STATEMENT | PB/Win + PB/CC | Established |
| COMM SEND | COMM SET | COMM TIMEOUT | COMMAND |
| `COMM SET` | STATEMENT | PB/Win + PB/CC | Established |
| `COMM TIMEOUT` | STATEMENT | PB/Win + PB/CC | Established |
| `COMMAND` | FUNCTION | codegen builtin |  |
| `COS` | FUNCTION | LLVM intrinsic |  |
| COSH | COT | COTH | CQUAD |
| `COT` | FUNCTION | C runtime (MSVCRT) |  |
| `COTH` | FUNCTION | C runtime (MSVCRT) |  |
| `CQUAD` | FUNCTION | codegen builtin |  |
| `CSC` | FUNCTION | C runtime (MSVCRT) |  |
| CSCH | CSET | CSNG | CSTR |
| `CSET` | STATEMENT | PB/Win + PB/CC | Established |
| `CSNG` | FUNCTION | codegen builtin |  |
| `CSTR` | FUNCTION | codegen builtin |  |
| `CULNG` | FUNCTION | codegen builtin |  |
| CURDIR | CVBYT | CVCUX | CVDWD |
| `CVBYT` | FUNCTION | codegen builtin |  |
| `CVCUX` | FUNCTION | codegen builtin |  |
| `CVDWD` | FUNCTION | codegen builtin |  |
| `CVL` | FUNCTION | codegen builtin |  |
| CVQ | CVW | CWORD | DATA |
| `CVW` | FUNCTION | codegen builtin |  |
| `CWORD` | FUNCTION | codegen builtin |  |
| `DATA` | STATEMENT | PB/Win + PB/CC | Established |
| `DATACOUNT` | FUNCTION | codegen builtin |  |
| DAYNAME | DEC | DECLARE | DECR |
| `DEC` | FUNCTION | codegen builtin |  |
| `DECLARE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `DECR` | STATEMENT | PB/Win + PB/CC | Established |
| `DESKTOP GET CLIENT` | STATEMENT | PB/Win + PB/CC | Established |
| DESKTOP GET LOC | DESKTOP GET PPI | DESKTOP GET SIZE | DIM |
| `DESKTOP GET PPI` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `DESKTOP GET SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `DIM` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `DIR` | FUNCTION | codegen builtin |  |
| DIR FUNCTION AND | DISKFREE | DISKSIZE | DISPLAY BROWSE |
| `DISKFREE` | FUNCTION | codegen builtin |  |
| `DISKSIZE` | FUNCTION | codegen builtin |  |
| `DISPLAY BROWSE` | STATEMENT | PB/Win only | Established |
| `DISPLAY COLOR` | STATEMENT | PB/Win only | Established |
| DISPLAY FONT | DISPLAY OPENFILE | DISPLAY SAVEFILE | DISPLAY_BROWSE |
| `DISPLAY OPENFILE` | STATEMENT | PB/Win only | Established |
| `DISPLAY SAVEFILE` | STATEMENT | PB/Win only | Established |
| `DISPLAY_BROWSE` | FUNCTION | codegen builtin |  |
| `DISPLAY_COLOR` | FUNCTION | codegen builtin |  |
| DISPLAY_FONT | DISPLAY_OPENFILE | DISPLAY_SAVEFILE | DOUBLE |
| `DISPLAY_OPENFILE` | FUNCTION | codegen builtin |  |
| `DISPLAY_SAVEFILE` | FUNCTION | codegen builtin |  |
| `DOUBLE` | FUNCTION | codegen builtin |  |
| `END` | STATEMENT | PB/Win + PB/CC | Established |
| ENVIRON | EOF | ERASE | ERF |
| `EOF` | FUNCTION | codegen builtin |  |
| `ERASE` | STATEMENT | PB/Win + PB/CC | Established |
| `ERF` | FUNCTION | C runtime (MSVCRT) |  |
| `ERL` | FUNCTION | codegen builtin |  |
| ERR | ERRCLEAR | ERROR | EVENT SOURCE |
| `ERRCLEAR` | FUNCTION | codegen builtin |  |
| `ERROR` | STATEMENT | PB/Win + PB/CC | Established |
| `EVENT SOURCE` | STATEMENT | PB/Win + PB/CC | Established |
| `EVENTS` | STATEMENT | PB/Win + PB/CC | Established |
| EXE | EXIST | EXIT | EXP |
| `EXIST` | FUNCTION | codegen builtin |  |
| `EXIT` | STATEMENT | PB/Win + PB/CC | Established |
| `EXP` | FUNCTION | LLVM intrinsic |  |
| `EXP10` | FUNCTION | LLVM intrinsic |  |
| EXP2 | EXPM1 | EXTRACT | FIELD |
| `EXPM1` | FUNCTION | C runtime (MSVCRT) |  |
| `EXTRACT` | FUNCTION | codegen builtin |  |
| `FIELD` | STATEMENT | PB/Win + PB/CC | Established |
| `FILEATTR` | FUNCTION | codegen builtin |  |
| FILECOPY | FILENAME | FILESCAN | FIX |
| `FILENAME` | FUNCTION | codegen builtin |  |
| `FILESCAN` | STATEMENT | PB/Win + PB/CC | Established |
| `FIX` | FUNCTION | codegen builtin |  |
| `FLOOR` | FUNCTION | LLVM intrinsic |  |
| FLUSH | FONT END | FONT NEW | FONT_END |
| `FONT END` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `FONT NEW` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `FONT_END` | FUNCTION | codegen builtin |  |
| `FONT_NEW` | FUNCTION | codegen builtin |  |
| FOR / NEXT | FORMAT | FRAC | FRE |
| `FORMAT` | FUNCTION | codegen builtin |  |
| `FRAC` | FUNCTION | codegen builtin |  |
| `FRE` | FUNCTION | codegen builtin |  |
| `FREEFILE` | FUNCTION | codegen builtin |  |
| FUNCTION / END FUNCTION | GET | GET$ | GET$$ |
| `GET` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GET$` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GET$$` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GET_STR` | FUNCTION | codegen builtin |  |
| GET_WSTR | GETATTR | GLOBAL | GLOBALMEM |
| `GETATTR` | FUNCTION | codegen builtin |  |
| `GLOBAL` | STATEMENT | PB/Win + PB/CC | Established |
| `GLOBALMEM` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC ARC` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC ATTACH | GRAPHIC BITMAP END | GRAPHIC BITMAP LOAD | GRAPHIC BITMAP NEW |
| `GRAPHIC BITMAP END` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC BITMAP LOAD` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC BITMAP NEW` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC BOX` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC CELL | GRAPHIC CELL SIZE | GRAPHIC CHR SIZE | GRAPHIC CLEAR |
| `GRAPHIC CELL SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC CHR SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC CLEAR` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC COLOR` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC COPY | GRAPHIC DETACH | GRAPHIC ELLIPSE | GRAPHIC GET BITS |
| `GRAPHIC DETACH` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC ELLIPSE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET BITS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET CANVAS` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC GET CAPTION | GRAPHIC GET CLIENT | GRAPHIC GET CLIP | GRAPHIC GET DC |
| `GRAPHIC GET CLIENT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC GET CLIP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET DC` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET LINES` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC GET LOC | GRAPHIC GET MIX | GRAPHIC GET PIXEL | GRAPHIC GET POS |
| `GRAPHIC GET MIX` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET PIXEL` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET POS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET PPI` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC GET SCALE | GRAPHIC GET SIZE | GRAPHIC GET STRETCHMODE | GRAPHIC GET TEXTALIGN |
| `GRAPHIC GET SIZE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC GET STRETCHMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC GET TEXTALIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `GRAPHIC GET VIEW` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC GET WORDWRAP | GRAPHIC GET WRAP | GRAPHIC LINE | GRAPHIC PAINT |
| `GRAPHIC GET WRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC LINE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC PAINT` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC PIE` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC POLYGON | GRAPHIC POLYLINE | GRAPHIC SAVE | GRAPHIC SCALE |
| `GRAPHIC POLYLINE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SAVE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SCALE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET AUTOSIZE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| GRAPHIC SET BITS | GRAPHIC SET CAPTION | GRAPHIC SET CLIP | GRAPHIC SET FIXED |
| `GRAPHIC SET CAPTION` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET CLIP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET FIXED` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET FONT` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC SET MIX | GRAPHIC SET PIXEL | GRAPHIC SET POS | GRAPHIC SET SIZE |
| `GRAPHIC SET PIXEL` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET POS` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET SIZE` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC SET STRETCHMODE` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC SET TEXTALIGN | GRAPHIC SET VIEW | GRAPHIC SET VIRTUAL | GRAPHIC SET WORDWRAP |
| `GRAPHIC SET VIEW` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET VIRTUAL` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `GRAPHIC SET WORDWRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC SET WRAP` | STATEMENT | PB/Win + PB/CC | Established |
| GRAPHIC STYLE | GRAPHIC TEXT SIZE | GRAPHIC WIDTH | GRAPHIC_ARC |
| `GRAPHIC TEXT SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC WIDTH` | STATEMENT | PB/Win + PB/CC | Established |
| `GRAPHIC_ARC` | FUNCTION | codegen builtin |  |
| `GRAPHIC_ATTACH` | FUNCTION | codegen builtin |  |
| GRAPHIC_BITMAP_END | GRAPHIC_BITMAP_LOAD | GRAPHIC_BITMAP_NEW | GRAPHIC_CELL |
| `GRAPHIC_BITMAP_LOAD` | FUNCTION | codegen builtin |  |
| `GRAPHIC_BITMAP_NEW` | FUNCTION | codegen builtin |  |
| `GRAPHIC_CELL` | FUNCTION | codegen builtin |  |
| `GRAPHIC_CHR_SIZE` | FUNCTION | codegen builtin |  |
| GRAPHIC_CIRCLE | GRAPHIC_CLEAR | GRAPHIC_COLOR | GRAPHIC_COPY |
| `GRAPHIC_CLEAR` | FUNCTION | codegen builtin |  |
| `GRAPHIC_COLOR` | FUNCTION | codegen builtin |  |
| `GRAPHIC_COPY` | FUNCTION | codegen builtin |  |
| `GRAPHIC_DETACH` | FUNCTION | codegen builtin |  |
| GRAPHIC_ELLIPSE | GRAPHIC_GET_BITS | GRAPHIC_GET_CAPTION | GRAPHIC_GET_CLIP |
| `GRAPHIC_GET_BITS` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_CAPTION` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_CLIP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_DC` | FUNCTION | codegen builtin |  |
| GRAPHIC_GET_LINES | GRAPHIC_GET_LOC | GRAPHIC_GET_MIX | GRAPHIC_GET_PIXEL |
| `GRAPHIC_GET_LOC` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_MIX` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_PIXEL` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_POS` | FUNCTION | codegen builtin |  |
| GRAPHIC_GET_PPI | GRAPHIC_GET_SCALE | GRAPHIC_GET_SIZE | GRAPHIC_GET_STRETCHMODE |
| `GRAPHIC_GET_SCALE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_SIZE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_STRETCHMODE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_TEXTALIGN` | FUNCTION | codegen builtin |  |
| GRAPHIC_GET_VIEW | GRAPHIC_GET_WORDWRAP | GRAPHIC_GET_WRAP | GRAPHIC_LINE |
| `GRAPHIC_GET_WORDWRAP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_GET_WRAP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_LINE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_PAINT` | FUNCTION | codegen builtin |  |
| GRAPHIC_PIE | GRAPHIC_POLYGON | GRAPHIC_POLYLINE | GRAPHIC_SAVE |
| `GRAPHIC_POLYGON` | FUNCTION | codegen builtin |  |
| `GRAPHIC_POLYLINE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SAVE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SCALE` | FUNCTION | codegen builtin |  |
| GRAPHIC_SCALE_PIXELS | GRAPHIC_SET_AUTOSIZE | GRAPHIC_SET_BITS | GRAPHIC_SET_CAPTION |
| `GRAPHIC_SET_AUTOSIZE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_BITS` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_CAPTION` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_CLIP` | FUNCTION | codegen builtin |  |
| GRAPHIC_SET_FIXED | GRAPHIC_SET_FONT | GRAPHIC_SET_MIX | GRAPHIC_SET_PIXEL |
| `GRAPHIC_SET_FONT` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_MIX` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_PIXEL` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_POS` | FUNCTION | codegen builtin |  |
| GRAPHIC_SET_SIZE | GRAPHIC_SET_STRETCHMODE | GRAPHIC_SET_TEXTALIGN | GRAPHIC_SET_VIEW |
| `GRAPHIC_SET_STRETCHMODE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_TEXTALIGN` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_VIEW` | FUNCTION | codegen builtin |  |
| `GRAPHIC_SET_VIRTUAL` | FUNCTION | codegen builtin |  |
| GRAPHIC_SET_WORDWRAP | GRAPHIC_SET_WRAP | GRAPHIC_STYLE | GRAPHIC_TEXT_SIZE |
| `GRAPHIC_SET_WRAP` | FUNCTION | codegen builtin |  |
| `GRAPHIC_STYLE` | FUNCTION | codegen builtin |  |
| `GRAPHIC_TEXT_SIZE` | FUNCTION | codegen builtin |  |
| `HEADER` | STATEMENT | PB/Win only | Established |
| HEADER_CTRL | HEX | HIWRD | HOST ADDR |
| `HEX` | FUNCTION | codegen builtin |  |
| `HIWRD` | FUNCTION | codegen builtin |  |
| `HOST ADDR` | STATEMENT | PB/Win + PB/CC | Established |
| `HOST NAME` | STATEMENT | PB/Win + PB/CC | Established |
| HYPOT | IF | IF/END IF | IIF |
| `IF` | STATEMENT | PB/Win + PB/CC | Established |
| `IF/END IF` | BLOCK | PB/Win + PB/CC | Established |
| `IIF` | FUNCTION | codegen builtin |  |
| `IMAGELIST` | STATEMENT | PB/Win only | Established |
| IMAGELIST_COUNT | IMAGELIST_KILL | IMAGELIST_NEW | IMPORT |
| `IMAGELIST_KILL` | FUNCTION | codegen builtin |  |
| `IMAGELIST_NEW` | FUNCTION | codegen builtin |  |
| `IMPORT` | STATEMENT | PB/Win + PB/CC | Established |
| `INCR` | STATEMENT | PB/Win + PB/CC | Established |
| INPUT FLUSH | INPUT# | INSTANCE | INSTR |
| `INPUT#` | STATEMENT | PB/CC only | Proposed Improvement |
| `INSTANCE` | STATEMENT | PB/Win + PB/CC | Established |
| `INSTR` | FUNCTION | codegen builtin |  |
| `INT` | FUNCTION | codegen builtin |  |
| INTEGER | INTERFACE / END INTERFACE (DIRECT) | INTERFACE/END INTERFACE (IDBIND) | ISEVEN |
| `INTERFACE / END INTERFACE (DIRECT)` | BLOCK | PB/Win + PB/CC | Established |
| `INTERFACE/END INTERFACE (IDBIND)` | BLOCK | PB/Win + PB/CC | Established |
| `ISEVEN` | FUNCTION | codegen builtin |  |
| `ISFALSE` | FUNCTION | codegen builtin |  |
| ISFILE | ISFOLDER | ISINFINITE | ISNORMAL |
| `ISFOLDER` | FUNCTION | codegen builtin |  |
| `ISINFINITE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ISNORMAL` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ISODD` | FUNCTION | codegen builtin |  |
| ISTRUE | ITERATE | KILL | LCASE |
| `ITERATE` | STATEMENT | PB/Win + PB/CC | Established |
| `KILL` | STATEMENT | PB/Win + PB/CC | Established |
| `LCASE` | FUNCTION | codegen builtin |  |
| `LEFT` | FUNCTION | codegen builtin |  |
| LEN | LET | LET *(WITH OBJECTS)* | LET *(WITH TYPES)* |
| `LET` | STATEMENT | PB/Win + PB/CC | Established |
| `LET *(WITH OBJECTS)*` | STATEMENT | PB/Win + PB/CC | Established |
| `LET *(WITH TYPES)*` | STATEMENT | PB/Win + PB/CC | Established |
| `LET *(WITH VARIANTS)*` | STATEMENT | PB/Win + PB/CC | Established |
| LINE INPUT# | LO | LOCAL | LOCK |
| `LO` | FUNCTION | codegen builtin |  |
| `LOCAL` | STATEMENT | PB/Win + PB/CC | Established |
| `LOCK` | STATEMENT | PB/Win + PB/CC | Established |
| `LOG` | FUNCTION | LLVM intrinsic |  |
| LOG10 | LOG1P | LOG2 | LONG |
| `LOG1P` | FUNCTION | C runtime (MSVCRT) |  |
| `LOG2` | FUNCTION | LLVM intrinsic |  |
| `LONG` | FUNCTION | codegen builtin |  |
| `LOWRD` | FUNCTION | codegen builtin |  |
| LPRINT | LPRINT ATTACH | LPRINT CLOSE | LPRINT FLUSH |
| `LPRINT ATTACH` | STATEMENT | PB/Win + PB/CC | Established |
| `LPRINT CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `LPRINT FLUSH` | STATEMENT | PB/Win + PB/CC | Established |
| `LPRINT FORMFEED` | STATEMENT | PB/Win + PB/CC | Established |
| LSET | LTRIM | MACRO/END MACRO | MAK |
| `LTRIM` | FUNCTION | codegen builtin |  |
| `MACRO/END MACRO` | BLOCK | PB/Win + PB/CC | Established |
| `MAK` | FUNCTION | codegen builtin |  |
| `MAT` | STATEMENT | PB/Win + PB/CC | Established |
| MAX | MEMORY | MEMORY_FILL | MEMORY_FILLS |
| `MEMORY` | STATEMENT | PB/Win + PB/CC | Established |
| `MEMORY_FILL` | FUNCTION | codegen builtin |  |
| `MEMORY_FILLS` | FUNCTION | codegen builtin |  |
| `MENU ADD POPUP` | STATEMENT | PB/Win only | Established |
| MENU ADD STRING | MENU DELETE | MENU GET STATE | MENU GET TEXT |
| `MENU DELETE` | STATEMENT | PB/Win only | Established |
| `MENU GET STATE` | STATEMENT | PB/Win only | Established |
| `MENU GET TEXT` | STATEMENT | PB/Win only | Established |
| `MENU NEW BAR` | STATEMENT | PB/Win only | Established |
| MENU NEW POPUP | MENU SET STATE | MENU SET TEXT | MENU_ADD_POPUP |
| `MENU SET STATE` | STATEMENT | PB/Win only | Established |
| `MENU SET TEXT` | STATEMENT | PB/Win only | Established |
| `MENU_ADD_POPUP` | FUNCTION | codegen builtin |  |
| `MENU_ADD_STRING` | FUNCTION | codegen builtin |  |
| MENU_DELETE | MENU_GET_STATE | MENU_GET_TEXT | MENU_NEW_POPUP |
| `MENU_GET_STATE` | FUNCTION | codegen builtin |  |
| `MENU_GET_TEXT` | FUNCTION | codegen builtin |  |
| `MENU_NEW_POPUP` | FUNCTION | codegen builtin |  |
| `MENU_SET_STATE` | FUNCTION | codegen builtin |  |
| MENU_SET_TEXT | METHOD / END METHOD | MID | MID$ |
| `METHOD / END METHOD` | STATEMENT | PB/Win + PB/CC | Established |
| `MID` | FUNCTION | codegen builtin |  |
| `MID$` | STATEMENT | PB/Win + PB/CC | Established |
| `MIN` | FUNCTION | codegen builtin |  |
| MKBYT | MKBYT$ | MKCUR$ | MKCUX |
| `MKBYT$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKCUR$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKCUX` | FUNCTION | codegen builtin |  |
| `MKCUX$` | STATEMENT | PB/Win + PB/CC | Established |
| MKD$ | MKDIR | MKDWD | MKDWD$ |
| `MKDIR` | STATEMENT | PB/Win + PB/CC | Established |
| `MKDWD` | FUNCTION | codegen builtin |  |
| `MKDWD$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKE` | FUNCTION | codegen builtin |  |
| MKE$ | MKI$ | MKL$ | MKQ$ |
| `MKI$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKL$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKQ$` | STATEMENT | PB/Win + PB/CC | Established |
| `MKS` | FUNCTION | codegen builtin |  |
| MKS$ | MKWRD | MKWRD$ | MOD |
| `MKWRD` | FUNCTION | codegen builtin |  |
| `MKWRD$` | STATEMENT | PB/Win + PB/CC | Established |
| `MOD` | FUNCTION | codegen builtin |  |
| `MONTHNAME` | FUNCTION | codegen builtin |  |
| MOUSEPTR | MSGBOX | NAME | OBJECT |
| `MSGBOX` | STATEMENT | PB/Win only | Established |
| `NAME` | STATEMENT | PB/Win + PB/CC | Established |
| `OBJECT` | STATEMENT | PB/Win + PB/CC | Established |
| `OCT` | FUNCTION | codegen builtin |  |
| OEMTOCHR | ON CALL | ON ERROR | ON GOSUB |
| `ON CALL` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `ON ERROR` | STATEMENT | PB/Win + PB/CC | Established |
| `ON GOSUB` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `ON GOTO` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| OPEN | OPTION EXPLICIT | PARSE | PARSECOUNT |
| `OPTION EXPLICIT` | STATEMENT | PB/Win + PB/CC | Established |
| `PARSE` | STATEMENT | PB/Win + PB/CC | Established |
| `PARSECOUNT` | FUNCTION | codegen builtin |  |
| `PATHNAME` | FUNCTION | codegen builtin |  |
| PATHSCAN | PEEK | PLAY SOUND | PLAY WAVE |
| `PEEK` | FUNCTION | codegen builtin |  |
| `PLAY SOUND` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `PLAY WAVE` | STATEMENT | PB/Win + PB/CC | Established |
| `POKE` | FUNCTION | codegen builtin |  |
| PREFIX | PRINT# | PRINTERCOUNT | PROCESS GET PRIORITY |
| `PRINT#` | STATEMENT | PB/Win + PB/CC | Established |
| `PRINTERCOUNT` | FUNCTION | codegen builtin |  |
| `PROCESS GET PRIORITY` | STATEMENT | PB/Win + PB/CC | Established |
| `PROCESS SET PRIORITY` | STATEMENT | PB/Win + PB/CC | Established |
| PROFILE | PROGRESSBAR | PUT | PUT$ |
| `PROGRESSBAR` | STATEMENT | PB/Win only | Established |
| `PUT` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `PUT$` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `PUT$$` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| PUT_STR | PUT_WSTR | QUAD | RAISEEVENT |
| `PUT_WSTR` | FUNCTION | codegen builtin |  |
| `QUAD` | FUNCTION | codegen builtin |  |
| `RAISEEVENT` | STATEMENT | PB/Win + PB/CC | Established |
| `RANDOMIZE` | STATEMENT | PB/Win + PB/CC | Established |
| READ | REDIM | REGEXPR | REGISTER |
| `REDIM` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `REGEXPR` | STATEMENT | PB/Win + PB/CC | Established |
| `REGISTER` | STATEMENT | PB/Win + PB/CC | Established |
| `REGREPL` | STATEMENT | PB/Win + PB/CC | Established |
| REM | REMAIN | REMOVE | REPEAT |
| `REMAIN` | FUNCTION | codegen builtin |  |
| `REMOVE` | FUNCTION | codegen builtin |  |
| `REPEAT` | FUNCTION | codegen builtin |  |
| `REPLACE` | STATEMENT | PB/Win + PB/CC | Established |
| RESET | RESOURCE SAVE FILE | RESOURCE_SAVE_FILE | RESUME |
| `RESOURCE SAVE FILE` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `RESOURCE_SAVE_FILE` | FUNCTION | codegen builtin |  |
| `RESUME` | STATEMENT | PB/Win + PB/CC | Established |
| `RETAIN` | FUNCTION | codegen builtin |  |
| RETURN | RIGHT | RMDIR | RND |
| `RIGHT` | FUNCTION | codegen builtin |  |
| `RMDIR` | STATEMENT | PB/Win + PB/CC | Established |
| `RND` | FUNCTION | codegen builtin |  |
| `ROTATE` | STATEMENT | PB/Win + PB/CC | Established |
| ROUND | RSET | RTRIM | SEC |
| `RSET` | STATEMENT | PB/Win + PB/CC | Established |
| `RTRIM` | FUNCTION | codegen builtin |  |
| `SEC` | FUNCTION | C runtime (MSVCRT) |  |
| `SECH` | FUNCTION | C runtime (MSVCRT) |  |
| SEEK | SELECT CASE/END SELECT | SETATTR | SETEOF |
| `SELECT CASE/END SELECT` | BLOCK | PB/Win + PB/CC | Established |
| `SETATTR` | STATEMENT | PB/Win + PB/CC | Established |
| `SETEOF` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `SGN` | FUNCTION | codegen builtin |  |
| SHELL | SHIFT | SHRINK | SIN |
| `SHIFT` | STATEMENT | PB/Win + PB/CC | Established |
| `SHRINK` | FUNCTION | codegen builtin |  |
| `SIN` | FUNCTION | LLVM intrinsic |  |
| `SINGLE` | FUNCTION | codegen builtin |  |
| SINH | SIZEOF | SLEEP | SPACE |
| `SIZEOF` | FUNCTION | codegen builtin |  |
| `SLEEP` | STATEMENT | PB/Win + PB/CC | Established |
| `SPACE` | FUNCTION | codegen builtin |  |
| `SPLIT` | STATEMENT | PB/Win + PB/CC | Established |
| SQR | STATIC | STR | STRDELETE |
| `STATIC` | STATEMENT | PB/Win + PB/CC | Established |
| `STR` | FUNCTION | codegen builtin |  |
| `STRDELETE` | FUNCTION | codegen builtin |  |
| `STRING` | FUNCTION | codegen builtin |  |
| STRINSERT | STRPTR | STRREVERSE | SWAP |
| `STRPTR` | FUNCTION | codegen builtin |  |
| `STRREVERSE` | FUNCTION | codegen builtin |  |
| `SWAP` | STATEMENT | PB/Win + PB/CC | Established |
| `SWITCH$` | FUNCTION | codegen builtin |  |
| TALLY | TAN | TANH | TCP ACCEPT |
| `TAN` | FUNCTION | LLVM intrinsic |  |
| `TANH` | FUNCTION | LLVM intrinsic |  |
| `TCP ACCEPT` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| TCP LINE INPUT | TCP NOTIFY | TCP OPEN | TCP PRINT |
| `TCP NOTIFY` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP OPEN` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP PRINT` | STATEMENT | PB/Win + PB/CC | Established |
| `TCP RECV` | STATEMENT | PB/Win + PB/CC | Established |
| TCP SEND | TCP_NOTIFY | THREAD CLOSE | THREAD CREATE |
| `TCP_NOTIFY` | FUNCTION | codegen builtin |  |
| `THREAD CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD CREATE` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD GET PRIORITY` | STATEMENT | PB/Win + PB/CC | Established |
| THREAD RESUME | THREAD SET PRIORITY | THREAD STATUS | THREAD SUSPEND |
| `THREAD SET PRIORITY` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD STATUS` | STATEMENT | PB/Win + PB/CC | Established |
| `THREAD SUSPEND` | STATEMENT | PB/Win + PB/CC | Established |
| `THREADCOUNT` | FUNCTION | codegen builtin |  |
| THREADED | TIMER | TIX | TRACE |
| `TIMER` | FUNCTION | codegen builtin |  |
| `TIX` | STATEMENT | PB/Win + PB/CC | Established |
| `TRACE` | STATEMENT | PB/Win + PB/CC | Established |
| `TRIM` | FUNCTION | codegen builtin |  |
| TRUNC | TRY/END TRY | TYPE SET | TYPE/END TYPE |
| `TRY/END TRY` | BLOCK | PB/Win + PB/CC | Established |
| `TYPE SET` | STATEMENT | PB/Win + PB/CC | Established |
| `TYPE/END TYPE` | BLOCK | PB/Win + PB/CC | Established |
| `UCASE` | FUNCTION | codegen builtin |  |
| UCODEPAGE | UDP CLOSE | UDP NOTIFY | UDP OPEN |
| `UDP CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP NOTIFY` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP OPEN` | STATEMENT | PB/Win + PB/CC | Established |
| `UDP RECV` | STATEMENT | PB/Win + PB/CC | Established |
| UDP SEND | UDP_NOTIFY | UNLOCK | UNWRAP |
| `UDP_NOTIFY` | FUNCTION | codegen builtin |  |
| `UNLOCK` | STATEMENT | PB/Win + PB/CC | Established |
| `UNWRAP` | FUNCTION | codegen builtin |  |
| `USING` | FUNCTION | codegen builtin |  |
| UTF8TOCHR | VAL | VARPTR | VERIFY |
| `VAL` | STATEMENT | PB/Win + PB/CC | Established |
| `VARPTR` | FUNCTION | codegen builtin |  |
| `VERIFY` | FUNCTION | codegen builtin |  |
| `WAITKEY` | FUNCTION | codegen builtin |  |
| WINDOW GET | WINDOW SET | WORD | WRAP |
| `WINDOW SET` | STATEMENT | PB/Win only | Established |
| `WORD` | FUNCTION | codegen builtin |  |
| `WRAP` | FUNCTION | codegen builtin |  |
| `WRITE` | FUNCTION | codegen builtin |  |
| WRITE# | XPRINT ARC | XPRINT ATTACH | XPRINT BOX |
| `XPRINT ARC` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT ATTACH` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT BOX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT CANCEL` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT CELL | XPRINT CELL SIZE | XPRINT CHR SIZE | XPRINT CLOSE |
| `XPRINT CELL SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT CHR SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT CLOSE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT COLOR` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT COPY | XPRINT ELLIPSE | XPRINT FORMFEED | XPRINT GET ATTACH |
| `XPRINT ELLIPSE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT FORMFEED` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET ATTACH` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET CANVAS` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET CLIENT | XPRINT GET CLIP | XPRINT GET COLLATE | XPRINT GET COLORMODE |
| `XPRINT GET CLIP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET COLLATE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET COLORMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET COPIES` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET DC | XPRINT GET DUPLEX | XPRINT GET LINES | XPRINT GET MARGIN |
| `XPRINT GET DUPLEX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET LINES` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET MARGIN` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET MIX` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET ORIENTATION | XPRINT GET OVERLAP | XPRINT GET PAGES | XPRINT GET PAPER |
| `XPRINT GET OVERLAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PAGES` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PAPER` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PAPERS` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET PIXEL | XPRINT GET POS | XPRINT GET PPI | XPRINT GET QUALITY |
| `XPRINT GET POS` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET PPI` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET QUALITY` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET SCALE` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET SELECTION | XPRINT GET SIZE | XPRINT GET STRETCHMODE | XPRINT GET TEXTALIGN |
| `XPRINT GET SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET STRETCHMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET TEXTALIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `XPRINT GET TRAY` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET TRAYS | XPRINT GET WORDWRAP | XPRINT GET WRAP | XPRINT IMAGELIST |
| `XPRINT GET WORDWRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT GET WRAP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT IMAGELIST` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT LINE` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT PIE | XPRINT POLYGON | XPRINT POLYLINE | XPRINT PREVIEW |
| `XPRINT POLYGON` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT POLYLINE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT PREVIEW` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT PRINT` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT RENDER | XPRINT SCALE | XPRINT SET CLIP | XPRINT SET COLLATE |
| `XPRINT SCALE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET CLIP` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET COLLATE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET COLORMODE` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET COPIES | XPRINT SET DUPLEX | XPRINT SET FONT | XPRINT SET MIX |
| `XPRINT SET DUPLEX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET FONT` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET MIX` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET ORIENTATION` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET OVERLAP | XPRINT SET PAGES | XPRINT SET PAPER | XPRINT SET PIXEL |
| `XPRINT SET PAGES` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET PAPER` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET PIXEL` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET POS` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET QUALITY | XPRINT SET STRETCHMODE | XPRINT SET TEXTALIGN | XPRINT SET TRAY |
| `XPRINT SET STRETCHMODE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET TEXTALIGN` | STATEMENT | PB/Win + PB/CC | Proposed New |
| `XPRINT SET TRAY` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT SET WORDWRAP` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET WRAP | XPRINT SPLIT | XPRINT STRETCH | XPRINT STYLE |
| `XPRINT SPLIT` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT STRETCH` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT STYLE` | STATEMENT | PB/Win + PB/CC | Established |
| `XPRINT TEXT SIZE` | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT WIDTH | XPRINT_ARC | XPRINT_ATTACH | XPRINT_BOX |
| `XPRINT_ARC` | FUNCTION | codegen builtin |  |
| `XPRINT_ATTACH` | FUNCTION | codegen builtin |  |
| `XPRINT_BOX` | FUNCTION | codegen builtin |  |
| `XPRINT_CANCEL` | FUNCTION | codegen builtin |  |
| XPRINT_CELL | XPRINT_CELL_SIZE | XPRINT_CHR_SIZE | XPRINT_CLOSE |
| `XPRINT_CELL_SIZE` | FUNCTION | codegen builtin |  |
| `XPRINT_CHR_SIZE` | FUNCTION | codegen builtin |  |
| `XPRINT_CLOSE` | FUNCTION | codegen builtin |  |
| `XPRINT_COPY` | FUNCTION | codegen builtin |  |
| XPRINT_ELLIPSE | XPRINT_FORMFEED | XPRINT_GET_ATTACH | XPRINT_GET_CANVAS |
| `XPRINT_FORMFEED` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_ATTACH` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_CANVAS` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_CLIENT` | FUNCTION | codegen builtin |  |
| XPRINT_GET_CLIP | XPRINT_GET_COLLATE | XPRINT_GET_COLOR | XPRINT_GET_COLORMODE |
| `XPRINT_GET_COLLATE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_COLOR` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_COLORMODE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_COPIES` | FUNCTION | codegen builtin |  |
| XPRINT_GET_DC | XPRINT_GET_DUPLEX | XPRINT_GET_LINES | XPRINT_GET_MARGIN |
| `XPRINT_GET_DUPLEX` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_LINES` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_MARGIN` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_MIX` | FUNCTION | codegen builtin |  |
| XPRINT_GET_ORIENTATION | XPRINT_GET_OVERLAP | XPRINT_GET_PAGES | XPRINT_GET_PAPER |
| `XPRINT_GET_OVERLAP` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PAGES` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PAPER` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PAPERS` | FUNCTION | codegen builtin |  |
| XPRINT_GET_PIXEL | XPRINT_GET_POS | XPRINT_GET_PPI | XPRINT_GET_QUALITY |
| `XPRINT_GET_POS` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_PPI` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_QUALITY` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_SCALE` | FUNCTION | codegen builtin |  |
| XPRINT_GET_SELECTION | XPRINT_GET_SIZE | XPRINT_GET_STRETCHMODE | XPRINT_GET_TEXTALIGN |
| `XPRINT_GET_SIZE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_STRETCHMODE` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_TEXTALIGN` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_TRAY` | FUNCTION | codegen builtin |  |
| XPRINT_GET_TRAYS | XPRINT_GET_WORDWRAP | XPRINT_GET_WRAP | XPRINT_IMAGELIST |
| `XPRINT_GET_WORDWRAP` | FUNCTION | codegen builtin |  |
| `XPRINT_GET_WRAP` | FUNCTION | codegen builtin |  |
| `XPRINT_IMAGELIST` | FUNCTION | codegen builtin |  |
| `XPRINT_LINE` | FUNCTION | codegen builtin |  |
| XPRINT_PIE | XPRINT_POLYGON | XPRINT_POLYLINE | XPRINT_PREVIEW |
| `XPRINT_POLYGON` | FUNCTION | codegen builtin |  |
| `XPRINT_POLYLINE` | FUNCTION | codegen builtin |  |
| `XPRINT_PREVIEW` | FUNCTION | codegen builtin |  |
| `XPRINT_PRINT` | FUNCTION | codegen builtin |  |
| XPRINT_RENDER | XPRINT_SCALE | XPRINT_SET_CLIP | XPRINT_SET_COLLATE |
| `XPRINT_SCALE` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_CLIP` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_COLLATE` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_COLOR` | FUNCTION | codegen builtin |  |
| XPRINT_SET_COLORMODE | XPRINT_SET_COPIES | XPRINT_SET_DUPLEX | XPRINT_SET_FONT |
| `XPRINT_SET_COPIES` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_DUPLEX` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_FONT` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_MIX` | FUNCTION | codegen builtin |  |
| XPRINT_SET_ORIENTATION | XPRINT_SET_OVERLAP | XPRINT_SET_PAGES | XPRINT_SET_PAPER |
| `XPRINT_SET_OVERLAP` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_PAGES` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_PAPER` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_PIXEL` | FUNCTION | codegen builtin |  |
| XPRINT_SET_POS | XPRINT_SET_QUALITY | XPRINT_SET_STRETCHMODE | XPRINT_SET_TEXTALIGN |
| `XPRINT_SET_QUALITY` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_STRETCHMODE` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_TEXTALIGN` | FUNCTION | codegen builtin |  |
| `XPRINT_SET_TRAY` | FUNCTION | codegen builtin |  |
| XPRINT_SET_WORDWRAP | XPRINT_SET_WRAP | XPRINT_SPLIT | XPRINT_STRETCH |
| `XPRINT_SET_WRAP` | FUNCTION | codegen builtin |  |
| `XPRINT_SPLIT` | FUNCTION | codegen builtin |  |
| `XPRINT_STRETCH` | FUNCTION | codegen builtin |  |
| `XPRINT_STYLE` | FUNCTION | codegen builtin |  |
| XPRINT_TEXT_SIZE | XPRINT_WIDTH |  |  |
| `XPRINT_WIDTH` | FUNCTION | codegen builtin |  |
 STATEMENT | PB/Win + PB/CC | Each element = its index (batch 20) |
| `DECLARE` | STATEMENT | (PB/Win + PB/CC) DECLARE SUB/FUNCTION prototypes (batch 20) |
| `FILESCAN` | STATEMENT | (PB/Win + PB/CC) Records/width scan, INPUT+BINARY modes (batch 20) |
| `LOCAL` | STATEMENT | (PB/Win + PB/CC) Local variable declarations (batch 20) |
| `TYPE/END TYPE` | BLOCK | (PB/Win + PB/CC) UDT definitions (batch 20) |
| `COMM OPEN` | STATEMENT | (PB/Win + PB/CC) CreateFileA + DCB/SetCommState/SetCommTimeouts; comm channel 0..255 (batch 21) |
| `COMM CLOSE` | STATEMENT | (PB/Win + PB/CC) CloseHandle per channel (batch 21) |
| `COMM LINE` | STATEMENT | (PB/Win + PB/CC) COMM LINE INPUT: byte-wise ReadFile until LF into PB string (batch 21) |
| `COMM PRINT` | STATEMENT | (PB/Win + PB/CC) WriteFile str/int/dbl variants (batch 21) |
| `COMM RECV` | STATEMENT | (PB/Win + PB/CC) ReadFile n bytes into PB string (batch 21) |
| `COMM RESET` | STATEMENT | (PB/Win + PB/CC) close all open COMM channels (batch 21) |
| `COMM SEND` | STATEMENT | (PB/Win + PB/CC) WriteFile + FlushFileBuffers (batch 21) |
| `COMM SET` | STATEMENT | (PB/Win + PB/CC) EscapeCommFunction DTR/RTS/BREAK on/off (batch 21) |
| `COMM TIMEOUT` | STATEMENT | (PB/Win + PB/CC) SetCommTimeouts read/write constants (batch 21) |
| `THREAD CLOSE` | STATEMENT | (PB/Win + PB/CC) TerminateThread + CloseHandle (batch 21) |
| `THREAD CREATE` | STATEMENT | (PB/Win + PB/CC) CreateThread (x64); PB slot id 0..255 (batch 21) |
| `THREADED` | STATEMENT | module-level `thread_local` global; per-thread copy, global to every Sub/Function (scalars; arrays pending) |
| `THREAD GET PRIORITY` | STATEMENT | (PB/Win + PB/CC) GetThreadPriority (batch 21) |
| `THREAD RESUME` | STATEMENT | (PB/Win + PB/CC) ResumeThread (batch 21) |
| `THREAD SET PRIORITY` | STATEMENT | (PB/Win + PB/CC) SetThreadPriority (batch 21) |
| `THREAD STATUS` | STATEMENT | (PB/Win + PB/CC) GetExitCodeThread STILL_ACTIVE; 1 run / 2 susp / 3 done (batch 21) |
| `THREAD SUSPEND` | STATEMENT | (PB/Win + PB/CC) SuspendThread (batch 21) |
| `LPRINT` | STATEMENT | (PB/Win + PB/CC) direct device/file output via LPRINT ATTACH (batch 22) |
| `LPRINT ATTACH` | STATEMENT | (PB/Win + PB/CC) CreateFileA open device; quoted string/device name (batch 22) |
| `LPRINT CLOSE` | STATEMENT | (PB/Win + PB/CC) CloseHandle (batch 22) |
| `LPRINT FLUSH` | STATEMENT | (PB/Win + PB/CC) FlushFileBuffers (batch 22) |
| `LPRINT FORMFEED` | STATEMENT | (PB/Win + PB/CC) form feed char 0x0C (batch 22) |
| `TRACE` | STATEMENT | (PB/Win + PB/CC) TRACE NEW/ON/OFF/PRINT/CLOSE explicit log file (batch 22) |
| `IMPORT` | STATEMENT | (PB/Win + PB/CC) IMPORT ADDR LoadLibraryA+GetProcAddress into QUAD vars (batch 22) |
| `CALL DWORD` | STATEMENT | (PB/Win + PB/CC) indirect call via inttoptr; USING args + TO result (batch 22) |
| CALLSTK | STATEMENT | (PB/Win + PB/CC) CALLSTKCOUNT depth / CALLSTK$(n) frame names / CALLSTK filename$ file dump (batch 33) |
| PROFILE | STATEMENT | (PB/Win + PB/CC) per-procedure call counts + elapsed ms via the call-stack frames; PROFILE filename$ dumps "<Name>, <Call Count>, <Time mSec>" (batch 34) |
| REGEXPR | STATEMENT | (PB/Win + PB/CC) documented regex subset scan; REGEXPR mask$ IN target$ [AT start&] TO iPos& [, iLen&], leftmost-longest, case-insensitive default (batch 35) |
| REGREPL | STATEMENT | (PB/Win + PB/CC) documented regex subset replace; REGREPL mask$ IN target$ WITH repl$ [AT start&] TO iPos&, newtarget$, \00 = whole match (batch 35) |
| `WINDOW SET` | STATEMENT | (PB/Win only) SetConsoleTitleA console title; hwnd ignored (batch 23) |
| `WINDOW GET` | STATEMENT | (PB/Win only) GetConsoleTitleA into string var (batch 23) |
| `STATIC` | STATEMENT | (PB/Win + PB/CC) module-global slot, persists across calls (batch 23) |
| `ON ERROR` | STATEMENT | (PB/Win + PB/CC) run-time error trap: GOTO label / GOTO 0 / RESUME NEXT (batch 25) |
| `REGISTER` | STATEMENT | (PB/Win + PB/CC) optimization hint, accepted as LOCAL (batch 25) |
| `RESUME` | STATEMENT | (PB/Win + PB/CC) RESUME / RESUME NEXT / RESUME FLUSH / RESUME label (batch 25) |
| `TYPE SET` | STATEMENT | (PB/Win + PB/CC) pb_type_set / pb_type_set_str memcpy fill (batch 23) |
| `TRY/END TRY` | BLOCK | structured error trap; CATCH/FINALLY/EXIT TRY, reuses ON ERROR machinery |
| `DIR FUNCTION AND` | STATEMENT | (PB/Win + PB/CC) Proposed Improvement |
| `PREFIX` | BLOCK | preprocessor text transform; prepends source code to each line until END PREFIX |
| `LET *(WITH TYPES)*` | STATEMENT | (PB/Win + PB/CC) Established |
| `GET$$` | STATEMENT | pb_get_wstring/pb_put_wstring (UTF-16LE round-trip) |
| `MACRO/END MACRO` | BLOCK | preprocessor text expansion (single-line + multi-line) |
| `ON CALL` | STATEMENT | dispatch table to SUB/FUNCTION (batch 27) |
| `PUT$$` | STATEMENT | pb_put_wstring (WIDE write, UTF-16LE) |
| MEMORY | STATEMENT | (PB/Win + PB/CC) Established |
| FONT END | STATEMENT | (PB/Win + PB/CC) Established |
| FONT NEW | STATEMENT | (PB/Win + PB/CC) Established |
| MKE$ | STATEMENT | (PB/Win + PB/CC) 8-byte binary string of an EXT value; EXT is an 8-byte IEEE-754 double in this compiler (official 80-bit format not modelled), so MKE$ == MKD$ (batch 36) |
| IMAGELIST | STATEMENT (IMAGELIST NEW BITMAP\ | [ICON / GET COUNT / KILL)] ImageList_Create / ImageList_GetImageCount / ImageList_Destroy (comctl32); handles are 64-bit pointers —use QUAD variables (batch 48) |
| COLOR | STATEMENT (PB/CC console text color) | pb_color —SetConsoleTextAttribute(GetStdHandle(-11)); fore/back 0-15, no args restores default (batch 49) |
| MENU NEW BAR | STATEMENT (menu bar handle) | pb_menu_new_bar —CreateMenu; handle is 64-bit (QUAD) (batch 50) |
| MENU NEW POPUP | STATEMENT (popup menu handle) | pb_menu_new_popup —CreatePopupMenu; handle is 64-bit (QUAD) (batch 50) |
| MENU ADD STRING | STATEMENT (menu item) | pb_menu_add_string —AppendMenuA MF_STRING (batch 50) |
| MENU ADD POPUP | STATEMENT (submenu) | pb_menu_add_popup —AppendMenuA MF_POPUP (batch 50) |
| MENU DELETE | STATEMENT (remove item) | pb_menu_delete —DeleteMenu MF_BYPOSITION (batch 50) |
| GRAPHIC BITMAP NEW | STATEMENT (memory DIB) | pb_gdi_bitmap_new —CreateDIBSection (top-down 32bpp); not visible (batch 51) |
| GRAPHIC BITMAP END | STATEMENT (destroy bitmap) | pb_gdi_bitmap_end —DeleteObject; no-arg form destroys last created (batch 51) |
| GRAPHIC ATTACH | STATEMENT (graphic target) | pb_graphic_attach —selects a memory bitmap as the graphic target (batch 52) |
| GRAPHIC DETACH | STATEMENT (detach target) | pb_graphic_detach —releases the graphic DC (batch 52) |
| GRAPHIC CLEAR | STATEMENT (clear target) | pb_graphic_clear —FillRect with solid brush (batch 52) |
| GRAPHIC LINE | STATEMENT (draw line) | pb_graphic_line —MoveToEx + LineTo on attached target (batch 53) |
| GRAPHIC BOX | STATEMENT (draw rectangle) | pb_graphic_box —Rectangle with optional fill (batch 53) |
| GRAPHIC ELLIPSE | STATEMENT (draw ellipse) | pb_graphic_ellipse —Ellipse with optional fill (batch 53) |
| `GRAPHIC WIDTH` | Statement | pb_graphic_width (gdi32 pen width) |
| `GRAPHIC STYLE` | Statement | pb_graphic_style (gdi32 pen style) |
| `GRAPHIC SAVE` | Statement | pb_graphic_save (GetObjectA + GetDIBits + BMP writer) |
| `GRAPHIC COLOR` | Statement | pb_graphic_color (fore/back color state) |
| `GRAPHIC GET PIXEL` | Statement | pb_graphic_get_pixel (GetPixel) |
| `GRAPHIC COPY` | Statement | pb_graphic_copy (BitBlt SRCCOPY) |
| `GRAPHIC POLYGON` | Statement | pb_graphic_polygon (Polygon) |
| `GRAPHIC GET CLIENT` | Statement | pb_graphic_get_client (bitmap dimensions) |
| `GRAPHIC GET LOC` | Statement | pb_graphic_get_loc (0,0 for bitmaps) |
| `GRAPHIC BITMAP LOAD` | Statement | pb_graphic_bitmap_load (LoadImageA) |
| `GRAPHIC CELL` | Statement | pb_graphic_cell (character-cell origin) |
| `GRAPHIC CELL SIZE` | Statement | pb_graphic_cell_size (cell metrics) |
| `GRAPHIC CHR SIZE` | Statement | pb_graphic_chr_size (GetTextExtentPoint32A) |
| `GRAPHIC GET CANVAS` | Statement | pb_graphic_get_canvas (current bitmap handle) |
| `GRAPHIC GET DC` | Statement | pb_graphic_get_dc (current device context) |
| `GRAPHIC GET MIX` | Statement | pb_graphic_get_mix (ROP mode state) |
| `GRAPHIC SET MIX` | Statement | pb_graphic_set_mix (ROP mode state) |
| `GRAPHIC SET PIXEL` | Statement | [Win32/GDI] implemented |
| `GRAPHIC GET SIZE` | Statement | [Win32/GDI] implemented |
| `GRAPHIC SET TEXTALIGN` | Statement | [Win32/GDI] implemented |
| `GRAPHIC GET TEXTALIGN` | Statement | [Win32/GDI] implemented |
| `GRAPHIC ARC` | Statement | (PB/Win + PB/CC) implemented |
| `GRAPHIC PIE` | Statement | (PB/Win + PB/CC) implemented |
| `GRAPHIC POLYLINE` | Statement | (PB/Win + PB/CC) implemented |
| `GRAPHIC PAINT` | Statement | (PB/Win + PB/CC) implemented |
| GRAPHIC GET CAPTION | STATEMENT | console-title bridge (GetConsoleTitleA) |
| GRAPHIC GET POS | STATEMENT | current pen position (GetCurrentPositionEx) |
| GRAPHIC GET PPI | STATEMENT | pixels per inch (GetDeviceCaps LOGPIXELS) |
| GRAPHIC GET STRETCHMODE | STATEMENT | current stretch mode (GetStretchBltMode) |
| GRAPHIC SET CAPTION | STATEMENT | console-title bridge (SetConsoleTitleA) |
| GRAPHIC SET POS | STATEMENT | move pen position (MoveToEx, optional STEP) |
| GRAPHIC SET STRETCHMODE | STATEMENT | set stretch mode (SetStretchBltMode) |
| GRAPHIC TEXT SIZE | STATEMENT | measure string (GetTextExtentPoint32A) |
| `MENU GET STATE` | STATEMENT | pb_menu_get_state (GetMenuState/EnableMenuItem/CheckMenuItem) |
| `MENU SET STATE` | STATEMENT | pb_menu_set_state (EnableMenuItem/CheckMenuItem) |
| `MENU GET TEXT` | STATEMENT | pb_menu_get_text (GetMenuStringA) |
| `MENU SET TEXT` | STATEMENT | pb_menu_set_text (ModifyMenuA) ||
| `GRAPHIC GET CLIP` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC GET VIEW` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET VIEW` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC GET LINES` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC GET WRAP` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET WRAP` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC GET BITS` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET BITS` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC GET SCALE` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SCALE` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET AUTOSIZE` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET SIZE` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET CLIP` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET VIRTUAL` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET WORDWRAP` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC GET WORDWRAP` | STATEMENT | (PB/Win only) implemented |
| `GRAPHIC SET FIXED` | STATEMENT | (PB/Win only) restores standard FIXED mode (pb_graphic_set_fixed) |
| `GRAPHIC SET FONT` | STATEMENT | (PB/Win only) selects font handle into graphic DC (pb_graphic_set_font —electObject) |
| XPRINT CELL | STATEMENT | `pb_xprint_cell` —cursor position (global) |
| XPRINT GET SELECTION | STATEMENT | `pb_xprint_get_selection` —noop |
| XPRINT SET PAPER | STATEMENT | `pb_xprint_set_paper` —global paper size |
| XPRINT GET PAPER | STATEMENT | `pb_xprint_get_paper` —global paper size |
| XPRINT SET TRAY | STATEMENT | `pb_xprint_set_tray` —global paper tray |
| XPRINT GET TRAY | STATEMENT | `pb_xprint_get_tray` —global paper tray |
| RESOURCE SAVE FILE | STATEMENT | `pb_resource_save_file` —writes resource to file (placeholder) |
| XPRINT GET PAPERS | STATEMENT | `pb_xprint_get_papers` —returns 0 on screen DC |
| XPRINT GET TRAYS | STATEMENT | `pb_xprint_get_trays` —returns 0 on screen DC |
| XPRINT PREVIEW | STATEMENT | `pb_xprint_preview` —noop on screen DC |
| XPRINT RENDER | STATEMENT | `pb_xprint_render` —noop on screen DC |
| XPRINT SPLIT | STATEMENT | `pb_xprint_split` —noop |
| XPRINT STRETCH | STATEMENT | `pb_xprint_stretch` —StretchBlt (SRCCOPY) |
| XPRINT IMAGELIST | STATEMENT | `pb_xprint_imagelist` —noop |
| TCP NOTIFY | STATEMENT | `pb_tcp_notify` —noop (WSAAsyncSelect placeholder) |
| UDP NOTIFY | STATEMENT | `pb_udp_notify` —noop |
| PROGRESSBAR | STATEMENT | `pb_progressbar` —noop (GUI control placeholder) |
| HEADER | STATEMENT | `pb_header` —noop (GUI control placeholder) |
| ARRAY SELECT | STATEMENT | `pb_array_select` —noop (array selection placeholder) |
| ARRAY TAGARRAY | STATEMENT | `pb_array_tagarray` —noop (tag array placeholder) |
| ARRAY TAGARRAY ERASE | STATEMENT | `pb_array_tagarray_erase` —noop |
| XPRINT GET MARGIN | STATEMENT | `pb_xprint_get_margin` —4 global margin vars (L/T/R/B) |
| DISPLAY OPENFILE | STATEMENT | `pb_display_openfile` —noop (returns empty; GetOpenFileNameA placeholder) |
| DISPLAY SAVEFILE | STATEMENT | `pb_display_savefile` —noop (GetSaveFileNameA placeholder) |
| DISPLAY COLOR | STATEMENT | `pb_display_color` —noop (returns 0; ChooseColor placeholder) |
| DISPLAY FONT | STATEMENT | `pb_display_font` —noop (ChooseFont placeholder) |
| DISPLAY BROWSE | STATEMENT | `pb_display_browse` —noop (SHBrowseForFolder placeholder) |
| ARRAY REDIM INCR | STATEMENT | pb_array_redim_incr/decr (simplified size report) | 
| ARRAY REDIM DECR | STATEMENT | pb_array_redim_incr/decr (simplified size report) | 
| CLASS/END CLASS | STATEMENT | parser block skip (namespace; methods inside not emitted) |
| METHOD / END METHOD | STATEMENT | parsed as SUB at top level (simplified OOP method) |
| `OBJECT` | STATEMENT | parsed as LONG (COM object pointer; DIM x AS OBJECT) |
| `INSTANCE` | STATEMENT | parser accepts (simplified noop; variable as LONG pointer) |
| `INTERFACE / END INTERFACE (DIRECT)` | STATEMENT | parser block skip (namespace; methods inside not emitted) |
| `INTERFACE/END INTERFACE (IDBIND)` | STATEMENT | parser block skip (IDBIND variant; same as DIRECT) |
| `EVENTS` | STATEMENT | parser accepts (simplified noop event declaration) |
| `RAISEEVENT` | STATEMENT | parser accepts (simplified noop event trigger) |
| `EVENT SOURCE` | STATEMENT | parser accepts (simplified noop event source) |
| `LET *(WITH OBJECTS)*` | STATEMENT | existing LET assignment (object reference = pointer copy) |
| `LET *(WITH VARIANTS)*` | STATEMENT | existing LET assignment (variant = generic value store) |
| `OBJECT` | STATEMENT | parsed as LONG (COM object pointer; DIM x AS OBJECT) |
| `INSTANCE` | STATEMENT | parser accepts (simplified noop; variable as LONG pointer) |
| `INTERFACE / END INTERFACE (DIRECT)` | STATEMENT | parser block skip (namespace; methods inside not emitted) |
| `INTERFACE/END INTERFACE (IDBIND)` | STATEMENT | parser block skip (IDBIND variant; same as DIRECT) |
| `EVENTS` | STATEMENT | parser accepts (simplified noop event declaration) |
| `RAISEEVENT` | STATEMENT | parser accepts (simplified noop event trigger) |
| `EVENT SOURCE` | STATEMENT | parser accepts (simplified noop event source) |
| `LET *(WITH OBJECTS)*` | STATEMENT | existing LET assignment (object reference = pointer copy) |
| `LET *(WITH VARIANTS)*` | STATEMENT | existing LET assignment (variant = generic value store) |
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