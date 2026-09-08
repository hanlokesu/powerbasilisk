# PowerBasilisk Enhanced — Official Statement Coverage Matrix

Ground truth: **PowerBASIC official documentation** (MIT license, 735 keywords / 1282 topic pages, PB/Win 10+11 / PB/CC 6+7).

- Official **statement-class** keywords total: **493**

- Official function-class: 190 (CURDIR$ / ISFILE among them — both implemented)

- Generated: 2026-09-08

## Summary

| Status | Count | Notes |
|--------|-------|-------|
| ✅ Implemented | 29 | Real codegen output (Win32 calls / runtime helpers / control flow) |
| 🚧 Tier-3 DDT | 202 | DDT GUI framework, high effort, deferred to a future update |
| ⬜ Not implemented | 262 | Documented upstream, no codegen evidence yet |

## ✅ Implemented (29)

| Keyword | Official kind | Implementation |
|---------|---------------|----------------|
| CALL | STATEMENT | `core` |
| CLOSE | STATEMENT | `compile_close` |
| DECR | STATEMENT | `core` |
| DIM | STATEMENT | `compile_dim` |
| END | STATEMENT | `core` |
| ERASE | STATEMENT | `pb_erase_array` |
| EXIT | STATEMENT | `core` |
| FLUSH | STATEMENT | `pb_flush` |
| IF | STATEMENT | `core` |
| INCR | STATEMENT | `core` |
| INPUT# | STATEMENT | `compile_input_file` |
| ITERATE | STATEMENT | `core` |
| KILL | STATEMENT | `pb_kill` |
| LINE INPUT# | STATEMENT | `compile_line_input_file` |
| LOCK | STATEMENT | `pb_lock` |
| LSET | STATEMENT | `pb_lset` |
| MSGBOX | STATEMENT | `MessageBoxA` |
| NAME | STATEMENT | `pb_rename, pb_name` |
| OPEN | STATEMENT | `compile_open` |
| PRINT# | STATEMENT | `pb_write_file` |
| REDIM | STATEMENT | `compile_dim` |
| REPLACE | STATEMENT | `pb_replace` |
| RESET | STATEMENT | `pb_reset` |
| RETURN | STATEMENT | `core` |
| RSET | STATEMENT | `pb_rset` |
| SEEK | STATEMENT | `pb_seek` |
| SHELL | STATEMENT | `ShellExecuteA` |
| UNLOCK | STATEMENT | `pb_unlock` |
| WRITE# | STATEMENT | `pb_write_file` |

Function-class Win32 built-ins (also implemented):

| Keyword | Official kind | Implementation |
|---------|---------------|----------------|
| CURDIR$ | FUNCTION | `GetCurrentDirectoryA` |
| ISFILE | FUNCTION | `_access` |

## 🚧 Tier-3 DDT (deferred to next update)

| Keyword | Official kind |
|---------|---------------|
| ACCEL ATTACH | STATEMENT |
| COLOR | STATEMENT |
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
| DIALOG DOEVENTS | STATEMENT |
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
| FONT END | STATEMENT |
| FONT NEW | STATEMENT |
| GRAPHIC ARC | STATEMENT |
| GRAPHIC ATTACH | STATEMENT |
| GRAPHIC BITMAP CAPTURE | STATEMENT |
| GRAPHIC BITMAP END | STATEMENT |
| GRAPHIC BITMAP LOAD | STATEMENT |
| GRAPHIC BITMAP NEW | STATEMENT |
| GRAPHIC BOX | STATEMENT |
| GRAPHIC CELL | STATEMENT |
| GRAPHIC CELL SIZE | STATEMENT |
| GRAPHIC CHR SIZE | STATEMENT |
| GRAPHIC CLEAR | STATEMENT |
| GRAPHIC COLOR | STATEMENT |
| GRAPHIC COPY | STATEMENT |
| GRAPHIC DETACH | STATEMENT |
| GRAPHIC ELLIPSE | STATEMENT |
| GRAPHIC GET BITS | STATEMENT |
| GRAPHIC GET CANVAS | STATEMENT |
| GRAPHIC GET CAPTION | STATEMENT |
| GRAPHIC GET CLIENT | STATEMENT |
| GRAPHIC GET CLIP | STATEMENT |
| GRAPHIC GET DC | STATEMENT |
| GRAPHIC GET LINES | STATEMENT |
| GRAPHIC GET LOC | STATEMENT |
| GRAPHIC GET MIX | STATEMENT |
| GRAPHIC GET OVERLAP | STATEMENT |
| GRAPHIC GET PIXEL | STATEMENT |
| GRAPHIC GET POS | STATEMENT |
| GRAPHIC GET PPI | STATEMENT |
| GRAPHIC GET SCALE | STATEMENT |
| GRAPHIC GET SCROLLTEXT | STATEMENT |
| GRAPHIC GET SIZE | STATEMENT |
| GRAPHIC GET STRETCHMODE | STATEMENT |
| GRAPHIC GET TEXTALIGN | STATEMENT |
| GRAPHIC GET VIEW | STATEMENT |
| GRAPHIC GET WORDWRAP | STATEMENT |
| GRAPHIC GET WRAP | STATEMENT |
| GRAPHIC IMAGELIST | STATEMENT |
| GRAPHIC INKEY$ | STATEMENT |
| GRAPHIC INPUT | STATEMENT |
| GRAPHIC INPUT FLUSH | STATEMENT |
| GRAPHIC INSTAT | STATEMENT |
| GRAPHIC LINE | STATEMENT |
| GRAPHIC LINE INPUT | STATEMENT |
| GRAPHIC PAINT | STATEMENT |
| GRAPHIC PIE | STATEMENT |
| GRAPHIC POLYGON | STATEMENT |
| GRAPHIC POLYLINE | STATEMENT |
| GRAPHIC PRINT | STATEMENT |
| GRAPHIC REDRAW | STATEMENT |
| GRAPHIC RENDER | STATEMENT |
| GRAPHIC SAVE | STATEMENT |
| GRAPHIC SCALE | STATEMENT |
| GRAPHIC SET AUTOSIZE | STATEMENT |
| GRAPHIC SET BITS | STATEMENT |
| GRAPHIC SET CAPTION | STATEMENT |
| GRAPHIC SET CLIENT | STATEMENT |
| GRAPHIC SET CLIP | STATEMENT |
| GRAPHIC SET FIXED | STATEMENT |
| GRAPHIC SET FOCUS | STATEMENT |
| GRAPHIC SET FONT | STATEMENT |
| GRAPHIC SET LOC | STATEMENT |
| GRAPHIC SET MIX | STATEMENT |
| GRAPHIC SET OVERLAP | STATEMENT |
| GRAPHIC SET PIXEL | STATEMENT |
| GRAPHIC SET POS | STATEMENT |
| GRAPHIC SET SCROLLTEXT | STATEMENT |
| GRAPHIC SET SIZE | STATEMENT |
| GRAPHIC SET STRETCHMODE | STATEMENT |
| GRAPHIC SET TEXTALIGN | STATEMENT |
| GRAPHIC SET VIEW | STATEMENT |
| GRAPHIC SET VIRTUAL | STATEMENT |
| GRAPHIC SET WORDWRAP | STATEMENT |
| GRAPHIC SET WRAP | STATEMENT |
| GRAPHIC SPLIT | STATEMENT |
| GRAPHIC STRETCH | STATEMENT |
| GRAPHIC STYLE | STATEMENT |
| GRAPHIC TEXT SIZE | STATEMENT |
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
| IMAGELIST | STATEMENT |
| LISTBOX | STATEMENT |
| LISTVIEW | STATEMENT |
| MEMORY | STATEMENT |
| MENU ADD POPUP | STATEMENT |
| MENU ADD STRING | STATEMENT |
| MENU ATTACH | STATEMENT |
| MENU CONTEXT | STATEMENT |
| MENU DELETE | STATEMENT |
| MENU DRAW BAR | STATEMENT |
| MENU GET STATE | STATEMENT |
| MENU GET TEXT | STATEMENT |
| MENU NEW BAR | STATEMENT |
| MENU NEW POPUP | STATEMENT |
| MENU SET STATE | STATEMENT |
| MENU SET TEXT | STATEMENT |
| SCROLLBAR | STATEMENT |
| STATUSBAR | STATEMENT |
| TAB | STATEMENT |
| TOOLBAR | STATEMENT |
| TREEVIEW | STATEMENT |

## ⬜ Not implemented (262, alphabetical)

| Keyword | Official kind | Platform | Status |
|---------|---------------|----------|--------|
| ARRAY ADD | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY ARRAYIX | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY ASSIGN | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY COPY | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY DELETE | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY INSERT | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| ARRAY REDIM INCR/DECR | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY REVERSE | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY SCAN | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| ARRAY SELECT | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY SHUFFLE | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY SORT | STATEMENT | PB/Win + PB/CC | Established |
| ARRAY SWAP | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY TAGARRAY | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY TAGARRAY ERASE | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY UNIQUE | STATEMENT | PB/Win + PB/CC | Proposed New |
| ASC | STATEMENT | PB/Win + PB/CC | Established |
| ASM | STATEMENT | PB/Win + PB/CC | Established |
| ASMDATA / END ASMDATA | BLOCK | PB/Win + PB/CC | Established |
| BEEP | STATEMENT | PB/Win + PB/CC | Established |
| BIT | STATEMENT | PB/Win + PB/CC | Established |
| BIT CALC | STATEMENT | PB/Win + PB/CC | Established |
| CALL DWORD | STATEMENT | PB/Win + PB/CC | Established |
| CALLSTK | STATEMENT | PB/Win + PB/CC | Established |
| CHDIR | STATEMENT | PB/Win + PB/CC | Established |
| CHDRIVE | STATEMENT | PB/Win + PB/CC | Established |
| CLASS/END CLASS | BLOCK | PB/Win + PB/CC | Established |
| CLIPBOARD | STATEMENT | PB/Win + PB/CC | Established |
| CLS | STATEMENT | PB/CC only | Established |
| COMM CLOSE | STATEMENT | PB/Win + PB/CC | Established |
| COMM LINE | STATEMENT | PB/Win + PB/CC | Established |
| COMM OPEN | STATEMENT | PB/Win + PB/CC | Established |
| COMM PRINT | STATEMENT | PB/Win + PB/CC | Established |
| COMM RECV | STATEMENT | PB/Win + PB/CC | Established |
| COMM RESET | STATEMENT | PB/Win + PB/CC | Established |
| COMM SEND | STATEMENT | PB/Win + PB/CC | Established |
| COMM SET | STATEMENT | PB/Win + PB/CC | Established |
| COMM TIMEOUT | STATEMENT | PB/Win + PB/CC | Established |
| CSET | STATEMENT | PB/Win + PB/CC | Established |
| DATA | STATEMENT | PB/Win + PB/CC | Established |
| DECLARE | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| DESKTOP GET CLIENT | STATEMENT | PB/Win + PB/CC | Established |
| DESKTOP GET LOC | STATEMENT | PB/Win + PB/CC | Established |
| DESKTOP GET PPI | STATEMENT | PB/Win + PB/CC | Proposed New |
| DESKTOP GET SIZE | STATEMENT | PB/Win + PB/CC | Established |
| DIR FUNCTION AND | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| DISPLAY BROWSE | STATEMENT | PB/Win only | Established |
| DISPLAY COLOR | STATEMENT | PB/Win only | Established |
| DISPLAY FONT | STATEMENT | PB/Win only | Established |
| DISPLAY OPENFILE | STATEMENT | PB/Win only | Established |
| DISPLAY SAVEFILE | STATEMENT | PB/Win only | Established |
| ENVIRON | STATEMENT | PB/Win + PB/CC | Established |
| ERROR | STATEMENT | PB/Win + PB/CC | Established |
| EVENT SOURCE | STATEMENT | PB/Win + PB/CC | Established |
| EVENTS | STATEMENT | PB/Win + PB/CC | Established |
| FIELD | STATEMENT | PB/Win + PB/CC | Established |
| FILECOPY | STATEMENT | PB/Win + PB/CC | Established |
| FILESCAN | STATEMENT | PB/Win + PB/CC | Established |
| FOR / NEXT | STATEMENT | PB/Win + PB/CC | Established |
| FUNCTION / END FUNCTION | STATEMENT | PB/Win + PB/CC | Established |
| GET | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| GET$ | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| GET$$ | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| GLOBAL | STATEMENT | PB/Win + PB/CC | Established |
| GLOBALMEM | STATEMENT | PB/Win + PB/CC | Established |
| HEADER | STATEMENT | PB/Win only | Established |
| HOST ADDR | STATEMENT | PB/Win + PB/CC | Established |
| HOST NAME | STATEMENT | PB/Win + PB/CC | Established |
| IF/END IF | BLOCK | PB/Win + PB/CC | Established |
| IMPORT | STATEMENT | PB/Win + PB/CC | Established |
| INPUT FLUSH | STATEMENT | PB/CC only | Established |
| INSTANCE | STATEMENT | PB/Win + PB/CC | Established |
| INTERFACE / END INTERFACE (DIRECT) | BLOCK | PB/Win + PB/CC | Established |
| INTERFACE/END INTERFACE (IDBIND) | BLOCK | PB/Win + PB/CC | Established |
| ISINFINITE | STATEMENT | PB/Win + PB/CC | Proposed New |
| ISNORMAL | STATEMENT | PB/Win + PB/CC | Proposed New |
| LET | STATEMENT | PB/Win + PB/CC | Established |
| LET *(WITH OBJECTS)* | STATEMENT | PB/Win + PB/CC | Established |
| LET *(WITH TYPES)* | STATEMENT | PB/Win + PB/CC | Established |
| LET *(WITH VARIANTS)* | STATEMENT | PB/Win + PB/CC | Established |
| LOCAL | STATEMENT | PB/Win + PB/CC | Established |
| LPRINT | STATEMENT | PB/Win + PB/CC | Established |
| LPRINT ATTACH | STATEMENT | PB/Win + PB/CC | Established |
| LPRINT CLOSE | STATEMENT | PB/Win + PB/CC | Established |
| LPRINT FLUSH | STATEMENT | PB/Win + PB/CC | Established |
| LPRINT FORMFEED | STATEMENT | PB/Win + PB/CC | Established |
| MACRO/END MACRO | BLOCK | PB/Win + PB/CC | Established |
| MAT | STATEMENT | PB/Win + PB/CC | Established |
| METHOD / END METHOD | STATEMENT | PB/Win + PB/CC | Established |
| MID$ | STATEMENT | PB/Win + PB/CC | Established |
| MKBYT$, MKCUR$, MKCUX$, MKD$, MKDWD$, MKE$, MKI$, MKL$, MKQ$, MKS$ AND MKWRD$ | STATEMENT | PB/Win + PB/CC | Established |
| MKDIR | STATEMENT | PB/Win + PB/CC | Established |
| MOUSEPTR | STATEMENT | PB/CC only | Established |
| OBJECT | STATEMENT | PB/Win + PB/CC | Established |
| ON CALL | STATEMENT | PB/Win + PB/CC | Proposed New |
| ON ERROR | STATEMENT | PB/Win + PB/CC | Established |
| ON GOSUB | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| ON GOTO | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| OPTION EXPLICIT | STATEMENT | PB/Win + PB/CC | Established |
| PARSE | STATEMENT | PB/Win + PB/CC | Established |
| PLAY SOUND | STATEMENT | PB/Win + PB/CC | Proposed New |
| PLAY WAVE | STATEMENT | PB/Win + PB/CC | Established |
| PREFIX | BLOCK | PB/Win + PB/CC | Established |
| PROCESS GET PRIORITY | STATEMENT | PB/Win + PB/CC | Established |
| PROCESS SET PRIORITY | STATEMENT | PB/Win + PB/CC | Established |
| PROFILE | STATEMENT | PB/Win + PB/CC | Established |
| PROGRESSBAR | STATEMENT | PB/Win only | Established |
| PUT | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| PUT$ | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| PUT$$ | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| RAISEEVENT | STATEMENT | PB/Win + PB/CC | Established |
| RANDOMIZE | STATEMENT | PB/Win + PB/CC | Established |
| REGEXPR | STATEMENT | PB/Win + PB/CC | Established |
| REGISTER | STATEMENT | PB/Win + PB/CC | Established |
| REGREPL | STATEMENT | PB/Win + PB/CC | Established |
| REM | STATEMENT | PB/Win + PB/CC | Established |
| RESOURCE SAVE FILE | STATEMENT | PB/Win + PB/CC | Proposed New |
| RESUME | STATEMENT | PB/Win + PB/CC | Established |
| RMDIR | STATEMENT | PB/Win + PB/CC | Established |
| ROTATE | STATEMENT | PB/Win + PB/CC | Established |
| SELECT CASE/END SELECT | BLOCK | PB/Win + PB/CC | Established |
| SETATTR | STATEMENT | PB/Win + PB/CC | Established |
| SETEOF | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| SHIFT | STATEMENT | PB/Win + PB/CC | Established |
| SLEEP | STATEMENT | PB/Win + PB/CC | Established |
| SPLIT | STATEMENT | PB/Win + PB/CC | Established |
| STATIC | STATEMENT | PB/Win + PB/CC | Established |
| SWAP | STATEMENT | PB/Win + PB/CC | Established |
| TCP ACCEPT | STATEMENT | PB/Win + PB/CC | Established |
| TCP CLOSE | STATEMENT | PB/Win + PB/CC | Established |
| TCP LINE INPUT | STATEMENT | PB/Win + PB/CC | Established |
| TCP NOTIFY | STATEMENT | PB/Win + PB/CC | Established |
| TCP OPEN | STATEMENT | PB/Win + PB/CC | Established |
| TCP PRINT | STATEMENT | PB/Win + PB/CC | Established |
| TCP RECV | STATEMENT | PB/Win + PB/CC | Established |
| TCP SEND | STATEMENT | PB/Win + PB/CC | Established |
| THREAD CLOSE | STATEMENT | PB/Win + PB/CC | Established |
| THREAD CREATE | STATEMENT | PB/Win + PB/CC | Established |
| THREAD GET PRIORITY | STATEMENT | PB/Win + PB/CC | Established |
| THREAD RESUME | STATEMENT | PB/Win + PB/CC | Established |
| THREAD SET PRIORITY | STATEMENT | PB/Win + PB/CC | Established |
| THREAD STATUS | STATEMENT | PB/Win + PB/CC | Established |
| THREAD SUSPEND | STATEMENT | PB/Win + PB/CC | Established |
| THREADED | STATEMENT | PB/Win + PB/CC | Established |
| TIX | STATEMENT | PB/Win + PB/CC | Established |
| TRACE | STATEMENT | PB/Win + PB/CC | Established |
| TRY/END TRY | BLOCK | PB/Win + PB/CC | Established |
| TYPE SET | STATEMENT | PB/Win + PB/CC | Established |
| TYPE/END TYPE | BLOCK | PB/Win + PB/CC | Established |
| UCODEPAGE | STATEMENT | PB/Win + PB/CC | Established |
| UDP CLOSE | STATEMENT | PB/Win + PB/CC | Established |
| UDP NOTIFY | STATEMENT | PB/Win + PB/CC | Established |
| UDP OPEN | STATEMENT | PB/Win + PB/CC | Established |
| UDP RECV | STATEMENT | PB/Win + PB/CC | Established |
| UDP SEND | STATEMENT | PB/Win + PB/CC | Established |
| VAL | STATEMENT | PB/Win + PB/CC | Established |
| WINDOW GET | STATEMENT | PB/Win only | Established |
| WINDOW SET | STATEMENT | PB/Win only | Established |
| XPRINT ARC | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT ATTACH | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT BOX | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT CANCEL | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT CELL | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT CELL SIZE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT CHR SIZE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT CLOSE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT COLOR | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT COPY | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT ELLIPSE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT FORMFEED | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET ATTACH | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET CANVAS | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET CLIENT | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET CLIP | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET COLLATE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET COLORMODE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET COPIES | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET DC | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET DUPLEX | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET LINES | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET MARGIN | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET MIX | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET ORIENTATION | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET OVERLAP | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET PAGES | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET PAPER | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET PAPERS | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET PIXEL | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET POS | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET PPI | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET QUALITY | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET SCALE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET SELECTION | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET SIZE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET STRETCHMODE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET TEXTALIGN | STATEMENT | PB/Win + PB/CC | Proposed New |
| XPRINT GET TRAY | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET TRAYS | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET WORDWRAP | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT GET WRAP | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT IMAGELIST | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT LINE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT PIE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT POLYGON | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT POLYLINE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT PREVIEW | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT PRINT | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT RENDER | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SCALE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET CLIP | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET COLLATE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET COLORMODE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET COPIES | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET DUPLEX | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET FONT | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET MIX | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET ORIENTATION | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET OVERLAP | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET PAGES | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET PAPER | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET PIXEL | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET POS | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET QUALITY | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET STRETCHMODE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET TEXTALIGN | STATEMENT | PB/Win + PB/CC | Proposed New |
| XPRINT SET TRAY | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET WORDWRAP | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SET WRAP | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT SPLIT | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT STRETCH | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT STYLE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT TEXT SIZE | STATEMENT | PB/Win + PB/CC | Established |
| XPRINT WIDTH | STATEMENT | PB/Win + PB/CC | Established |
| \#ALIGN METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#BLOAT METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#BREAK METASTATEMENT | STATEMENT | PB/CC only | Established |
| \#COM METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#COMPILE METASTATEMENT | STATEMENT | PB/Win only | Established |
| \#COMPILER METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#CONSOLE METASTATEMENT | STATEMENT | PB/CC only | Established |
| \#DEBUG BOUNDS METASTATEMENT | STATEMENT | PB/Win + PB/CC | Proposed New |
| \#DEBUG CODE METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#DEBUG DISPLAY METASTATEMENT | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| \#DEBUG ERROR METASTATEMENT | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| \#DEBUG NUMERIC METASTATEMENT | STATEMENT | PB/Win + PB/CC | Proposed New |
| \#DEBUG PRINT METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#DIM METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#EXPORT METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#IF/#ELSEIF/#ELSE/#ENDIF METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#INCLUDE METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#LINK METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#MESSAGES METASTATEMENT | STATEMENT | PB/Win only | Established |
| \#OPTIMIZE METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#OPTION METASTATEMENT | STATEMENT | PB/Win + PB/CC | Proposed New |
| \#PAGE METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#PBFORMS METASTATEMENT | STATEMENT | PB/Win only | Established |
| \#REGISTER METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#RESOURCE METASTATEMENT | STATEMENT | PB/Win + PB/CC | Proposed New |
| \#STACK METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#TOOLS METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#UNIQUE METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |
| \#UTILITY METASTATEMENT | STATEMENT | PB/Win + PB/CC | Established |

## Files

- `docs/statement-coverage.md` — this readable summary
- `docs/statement-coverage.csv` — all rows with per-keyword status (Keyword, Kind, Platform, Status, Impl)

## Method

1. Parse `keyword-index.md` from the official docs package (735 keywords, one line per keyword).
2. Keep statement-class keywords (STATEMENT / BLOCK / KEYWORD / DIRECTIVE) = 493.
3. Grep `codegen.rs` for the runtime helpers / Win32 API calls / compile_* functions each keyword maps to.
4. Classify: IMPLEMENTED (real codegen evidence) / TIER3_DDT (GUI framework, deferred) / NOT_IMPL (no evidence).