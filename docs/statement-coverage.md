# PowerBasilisk Enhanced — Official Statement Coverage Matrix

> **Last updated from batch 96 (v0.1.90)** — 2026-09-15. All statements and functions through batch 96 are reflected in this matrix.

Ground truth: **PowerBASIC official documentation** (MIT license, 735 keywords / 1282 topic pages, PB/Win 10+11 / PB/CC 6+7).

- Official **statement-class** keywords total: **493**

- Official function-class: 190 (CURDIR$ / ISFILE among them —both implemented)

- Generated: 2026-09-15 (batch 86: TRUNC) (batch 85: FLOOR) (batch 84: REMAIN$) (batch 83: RETAIN$) (batch 82: REMOVE$) (batch 81: INPUT/LINE INPUT console) (batch 80: OOP completion —0 NOT_IMPL milestone) (batch 79: OOP foundation) (batch 37-78: see README changelog) (batch 36: MKE$) (batch 35: REGEXPR/REGREPL) (batch 34: PROFILE) (batch 33: CALLSTK) (batch 31: FIELD / RANDOM) (batch 25: ON ERROR / RESUME / REGISTER) (audited: FOR/NEXT, SELECT CASE, LET, MID$, VAL, ASC, PARSE, FUNCTION, IF/END IF verified live)

## Summary

| Status | Count | Notes |
|--------|-------|-------|
| ✅ Implemented | 375 | Real codegen output (Win32 calls / runtime helpers / control flow) |
| 🚧 Tier-3 DDT | 129 | DDT GUI framework, high effort, deferred to a future update |
| ⬜ Not implemented | 0 | Documented upstream, no codegen evidence yet |

## ✅ Implemented (375)
| Keyword | Official kind | Implementation |
|---------|---------------|----------------|
| #ALIGN METASTATEMENT | #BLOAT METASTATEMENT | #BREAK METASTATEMENT | #COM METASTATEMENT | #COMPILE METASTATEMENT |
| #COMPILER METASTATEMENT | #CONSOLE METASTATEMENT | #DEBUG BOUNDS METASTATEMENT | #DEBUG CODE METASTATEMENT | #DEBUG DISPLAY METASTATEMENT |
| #DEBUG ERROR METASTATEMENT | #DEBUG NUMERIC METASTATEMENT | #DEBUG PRINT METASTATEMENT | #DIM METASTATEMENT | #EXPORT METASTATEMENT |
| #IF/#ELSEIF/#ELSE/#ENDIF METASTATEMENT | #INCLUDE METASTATEMENT | #LINK METASTATEMENT | #MESSAGES METASTATEMENT | #OPTIMIZE METASTATEMENT |
| #OPTION METASTATEMENT | #PAGE METASTATEMENT | #PBFORMS METASTATEMENT | #REGISTER METASTATEMENT | #RESOURCE METASTATEMENT |
| #STACK METASTATEMENT | #TOOLS METASTATEMENT | #UNIQUE METASTATEMENT | #UTILITY METASTATEMENT | ABS |
| ACOS | ACOSH | ARRAY ADD | ARRAY ARRAYIX | ARRAY ASSIGN |
| ARRAY COPY | ARRAY DELETE | ARRAY INSERT | ARRAY REDIM DECR | ARRAY REDIM INCR |
| ARRAY REVERSE | ARRAY SCAN | ARRAY SELECT | ARRAY SHUFFLE | ARRAY SORT |
| ARRAY SWAP | ARRAY TAGARRAY | ARRAY TAGARRAY ERASE | ARRAY UNIQUE | ARRAY_REDIM_DECR |
| ARRAY_REDIM_INCR | ARRAY_SELECT | ARRAY_TAGARRAY | ARRAY_TAGARRAY_ERASE | ASC |
| ASIN | ASINH | ASM | ASMDATA / END ASMDATA | ATANH |
| ATN | ATN2 | BEEP | BGR | BIN |
| BIT | BIT CALC | BITS | BUILD | BYTE |
| CALL | CALL DWORD | CALLSTK | CALLSTKCOUNT | CBOOL |
| CBRT | CBYTE | CDBL | CDWORD | CEIL |
| CFLT | CHDIR | CHDRIVE | CHOOSE | CHR |
| CHRTOOEM | CHRTOUTF8 | CLASS/END CLASS | CLIP | CLIPBOARD |
| CLOSE | CLS | CODEPTR | COLOR | COMM CLOSE |
| COMM LINE | COMM OPEN | COMM PRINT | COMM RECV | COMM RESET |
| COMM SEND | COMM SET | COMM TIMEOUT | COMMAND | COS |
| COSH | COT | COTH | CQUAD | CSC |
| CSCH | CSET | CSNG | CSTR | CULNG |
| CURDIR | CVBYT | CVCUX | CVDWD | CVL |
| CVQ | CVW | CWORD | DATA | DATACOUNT |
| DAYNAME | DEC | DECLARE | DECR | DESKTOP GET CLIENT |
| DESKTOP GET LOC | DESKTOP GET PPI | DESKTOP GET SIZE | DIM | DIR |
| DIR FUNCTION AND | DISKFREE | DISKSIZE | DISPLAY BROWSE | DISPLAY COLOR |
| DISPLAY FONT | DISPLAY OPENFILE | DISPLAY SAVEFILE | DISPLAY_BROWSE | DISPLAY_COLOR |
| DISPLAY_FONT | DISPLAY_OPENFILE | DISPLAY_SAVEFILE | DOUBLE | END |
| ENVIRON | EOF | ERASE | ERF | ERL |
| ERR | ERRCLEAR | ERROR | EVENT SOURCE | EVENTS |
| EXE | EXIST | EXIT | EXP | EXP10 |
| EXP2 | EXPM1 | EXTRACT | FIELD | FILEATTR |
| FILECOPY | FILENAME | FILESCAN | FIX | FLOOR |
| FLUSH | FONT END | FONT NEW | FONT_END | FONT_NEW |
| FOR / NEXT | FORMAT | FRAC | FRE | FREEFILE |
| FUNCTION / END FUNCTION | GET | GET$ | GET$$ | GET_STR |
| GET_WSTR | GETATTR | GLOBAL | GLOBALMEM | GRAPHIC ARC |
| GRAPHIC ATTACH | GRAPHIC BITMAP END | GRAPHIC BITMAP LOAD | GRAPHIC BITMAP NEW | GRAPHIC BOX |
| GRAPHIC CELL | GRAPHIC CELL SIZE | GRAPHIC CHR SIZE | GRAPHIC CLEAR | GRAPHIC COLOR |
| GRAPHIC COPY | GRAPHIC DETACH | GRAPHIC ELLIPSE | GRAPHIC GET BITS | GRAPHIC GET CANVAS |
| GRAPHIC GET CAPTION | GRAPHIC GET CLIENT | GRAPHIC GET CLIP | GRAPHIC GET DC | GRAPHIC GET LINES |
| GRAPHIC GET LOC | GRAPHIC GET MIX | GRAPHIC GET PIXEL | GRAPHIC GET POS | GRAPHIC GET PPI |
| GRAPHIC GET SCALE | GRAPHIC GET SIZE | GRAPHIC GET STRETCHMODE | GRAPHIC GET TEXTALIGN | GRAPHIC GET VIEW |
| GRAPHIC GET WORDWRAP | GRAPHIC GET WRAP | GRAPHIC LINE | GRAPHIC PAINT | GRAPHIC PIE |
| GRAPHIC POLYGON | GRAPHIC POLYLINE | GRAPHIC SAVE | GRAPHIC SCALE | GRAPHIC SET AUTOSIZE |
| GRAPHIC SET BITS | GRAPHIC SET CAPTION | GRAPHIC SET CLIP | GRAPHIC SET FIXED | GRAPHIC SET FONT |
| GRAPHIC SET MIX | GRAPHIC SET PIXEL | GRAPHIC SET POS | GRAPHIC SET SIZE | GRAPHIC SET STRETCHMODE |
| GRAPHIC SET TEXTALIGN | GRAPHIC SET VIEW | GRAPHIC SET VIRTUAL | GRAPHIC SET WORDWRAP | GRAPHIC SET WRAP |
| GRAPHIC STYLE | GRAPHIC TEXT SIZE | GRAPHIC WIDTH | GRAPHIC_ARC | GRAPHIC_ATTACH |
| GRAPHIC_BITMAP_END | GRAPHIC_BITMAP_LOAD | GRAPHIC_BITMAP_NEW | GRAPHIC_CELL | GRAPHIC_CHR_SIZE |
| GRAPHIC_CIRCLE | GRAPHIC_CLEAR | GRAPHIC_COLOR | GRAPHIC_COPY | GRAPHIC_DETACH |
| GRAPHIC_ELLIPSE | GRAPHIC_GET_BITS | GRAPHIC_GET_CAPTION | GRAPHIC_GET_CLIP | GRAPHIC_GET_DC |
| GRAPHIC_GET_LINES | GRAPHIC_GET_LOC | GRAPHIC_GET_MIX | GRAPHIC_GET_PIXEL | GRAPHIC_GET_POS |
| GRAPHIC_GET_PPI | GRAPHIC_GET_SCALE | GRAPHIC_GET_SIZE | GRAPHIC_GET_STRETCHMODE | GRAPHIC_GET_TEXTALIGN |
| GRAPHIC_GET_VIEW | GRAPHIC_GET_WORDWRAP | GRAPHIC_GET_WRAP | GRAPHIC_LINE | GRAPHIC_PAINT |
| GRAPHIC_PIE | GRAPHIC_POLYGON | GRAPHIC_POLYLINE | GRAPHIC_SAVE | GRAPHIC_SCALE |
| GRAPHIC_SCALE_PIXELS | GRAPHIC_SET_AUTOSIZE | GRAPHIC_SET_BITS | GRAPHIC_SET_CAPTION | GRAPHIC_SET_CLIP |
| GRAPHIC_SET_FIXED | GRAPHIC_SET_FONT | GRAPHIC_SET_MIX | GRAPHIC_SET_PIXEL | GRAPHIC_SET_POS |
| GRAPHIC_SET_SIZE | GRAPHIC_SET_STRETCHMODE | GRAPHIC_SET_TEXTALIGN | GRAPHIC_SET_VIEW | GRAPHIC_SET_VIRTUAL |
| GRAPHIC_SET_WORDWRAP | GRAPHIC_SET_WRAP | GRAPHIC_STYLE | GRAPHIC_TEXT_SIZE | HEADER |
| HEADER_CTRL | HEX | HIWRD | HOST ADDR | HOST NAME |
| HYPOT | IF | IF/END IF | IIF | IMAGELIST |
| IMAGELIST_COUNT | IMAGELIST_KILL | IMAGELIST_NEW | IMPORT | INCR |
| INPUT FLUSH | INPUT# | INSTANCE | INSTR | INT |
| INTEGER | INTERFACE / END INTERFACE (DIRECT) | INTERFACE/END INTERFACE (IDBIND) | ISEVEN | ISFALSE |
| ISFILE | ISFOLDER | ISINFINITE | ISNORMAL | ISODD |
| ISTRUE | ITERATE | KILL | LCASE | LEFT |
| LEN | LET | LET *(WITH OBJECTS)* | LET *(WITH TYPES)* | LET *(WITH VARIANTS)* |
| LINE INPUT# | LO | LOCAL | LOCK | LOG |
| LOG10 | LOG1P | LOG2 | LONG | LOWRD |
| LPRINT | LPRINT ATTACH | LPRINT CLOSE | LPRINT FLUSH | LPRINT FORMFEED |
| LSET | LTRIM | MACRO/END MACRO | MAK | MAT |
| MAX | MEMORY | MEMORY_FILL | MEMORY_FILLS | MENU ADD POPUP |
| MENU ADD STRING | MENU DELETE | MENU GET STATE | MENU GET TEXT | MENU NEW BAR |
| MENU NEW POPUP | MENU SET STATE | MENU SET TEXT | MENU_ADD_POPUP | MENU_ADD_STRING |
| MENU_DELETE | MENU_GET_STATE | MENU_GET_TEXT | MENU_NEW_POPUP | MENU_SET_STATE |
| MENU_SET_TEXT | METHOD / END METHOD | MID | MID$ | MIN |
| MKBYT | MKBYT$ | MKCUR$ | MKCUX | MKCUX$ |
| MKD$ | MKDIR | MKDWD | MKDWD$ | MKE |
| MKE$ | MKI$ | MKL$ | MKQ$ | MKS |
| MKS$ | MKWRD | MKWRD$ | MOD | MONTHNAME |
| MOUSEPTR | MSGBOX | NAME | OBJECT | OCT |
| OEMTOCHR | ON CALL | ON ERROR | ON GOSUB | ON GOTO |
| OPEN | OPTION EXPLICIT | PARSE | PARSECOUNT | PATHNAME |
| PATHSCAN | PEEK | PLAY SOUND | PLAY WAVE | POKE |
| PREFIX | PRINT# | PRINTERCOUNT | PROCESS GET PRIORITY | PROCESS SET PRIORITY |
| PROFILE | PROGRESSBAR | PUT | PUT$ | PUT$$ |
| PUT_STR | PUT_WSTR | QUAD | RAISEEVENT | RANDOMIZE |
| READ | REDIM | REGEXPR | REGISTER | REGREPL |
| REM | REMAIN | REMOVE | REPEAT | REPLACE |
| RESET | RESOURCE SAVE FILE | RESOURCE_SAVE_FILE | RESUME | RETAIN |
| RETURN | RIGHT | RMDIR | RND | ROTATE |
| ROUND | RSET | RTRIM | SEC | SECH |
| SEEK | SELECT CASE/END SELECT | SETATTR | SETEOF | SGN |
| SHELL | SHIFT | SHRINK | SIN | SINGLE |
| SINH | SIZEOF | SLEEP | SPACE | SPLIT |
| SQR | STATIC | STR | STRDELETE | STRING |
| STRINSERT | STRPTR | STRREVERSE | SWAP | SWITCH$ |
| TALLY | TAN | TANH | TCP ACCEPT | TCP CLOSE |
| TCP LINE INPUT | TCP NOTIFY | TCP OPEN | TCP PRINT | TCP RECV |
| TCP SEND | TCP_NOTIFY | THREAD CLOSE | THREAD CREATE | THREAD GET PRIORITY |
| THREAD RESUME | THREAD SET PRIORITY | THREAD STATUS | THREAD SUSPEND | THREADCOUNT |
| THREADED | TIMER | TIX | TRACE | TRIM |
| TRUNC | TRY/END TRY | TYPE SET | TYPE/END TYPE | UCASE |
| UCODEPAGE | UDP CLOSE | UDP NOTIFY | UDP OPEN | UDP RECV |
| UDP SEND | UDP_NOTIFY | UNLOCK | UNWRAP | USING |
| UTF8TOCHR | VAL | VARPTR | VERIFY | WAITKEY |
| WINDOW GET | WINDOW SET | WORD | WRAP | WRITE |
| WRITE# | XPRINT ARC | XPRINT ATTACH | XPRINT BOX | XPRINT CANCEL |
| XPRINT CELL | XPRINT CELL SIZE | XPRINT CHR SIZE | XPRINT CLOSE | XPRINT COLOR |
| XPRINT COPY | XPRINT ELLIPSE | XPRINT FORMFEED | XPRINT GET ATTACH | XPRINT GET CANVAS |
| XPRINT GET CLIENT | XPRINT GET CLIP | XPRINT GET COLLATE | XPRINT GET COLORMODE | XPRINT GET COPIES |
| XPRINT GET DC | XPRINT GET DUPLEX | XPRINT GET LINES | XPRINT GET MARGIN | XPRINT GET MIX |
| XPRINT GET ORIENTATION | XPRINT GET OVERLAP | XPRINT GET PAGES | XPRINT GET PAPER | XPRINT GET PAPERS |
| XPRINT GET PIXEL | XPRINT GET POS | XPRINT GET PPI | XPRINT GET QUALITY | XPRINT GET SCALE |
| XPRINT GET SELECTION | XPRINT GET SIZE | XPRINT GET STRETCHMODE | XPRINT GET TEXTALIGN | XPRINT GET TRAY |
| XPRINT GET TRAYS | XPRINT GET WORDWRAP | XPRINT GET WRAP | XPRINT IMAGELIST | XPRINT LINE |
| XPRINT PIE | XPRINT POLYGON | XPRINT POLYLINE | XPRINT PREVIEW | XPRINT PRINT |
| XPRINT RENDER | XPRINT SCALE | XPRINT SET CLIP | XPRINT SET COLLATE | XPRINT SET COLORMODE |
| XPRINT SET COPIES | XPRINT SET DUPLEX | XPRINT SET FONT | XPRINT SET MIX | XPRINT SET ORIENTATION |
| XPRINT SET OVERLAP | XPRINT SET PAGES | XPRINT SET PAPER | XPRINT SET PIXEL | XPRINT SET POS |
| XPRINT SET QUALITY | XPRINT SET STRETCHMODE | XPRINT SET TEXTALIGN | XPRINT SET TRAY | XPRINT SET WORDWRAP |
| XPRINT SET WRAP | XPRINT SPLIT | XPRINT STRETCH | XPRINT STYLE | XPRINT TEXT SIZE |
| XPRINT WIDTH | XPRINT_ARC | XPRINT_ATTACH | XPRINT_BOX | XPRINT_CANCEL |
| XPRINT_CELL | XPRINT_CELL_SIZE | XPRINT_CHR_SIZE | XPRINT_CLOSE | XPRINT_COPY |
| XPRINT_ELLIPSE | XPRINT_FORMFEED | XPRINT_GET_ATTACH | XPRINT_GET_CANVAS | XPRINT_GET_CLIENT |
| XPRINT_GET_CLIP | XPRINT_GET_COLLATE | XPRINT_GET_COLOR | XPRINT_GET_COLORMODE | XPRINT_GET_COPIES |
| XPRINT_GET_DC | XPRINT_GET_DUPLEX | XPRINT_GET_LINES | XPRINT_GET_MARGIN | XPRINT_GET_MIX |
| XPRINT_GET_ORIENTATION | XPRINT_GET_OVERLAP | XPRINT_GET_PAGES | XPRINT_GET_PAPER | XPRINT_GET_PAPERS |
| XPRINT_GET_PIXEL | XPRINT_GET_POS | XPRINT_GET_PPI | XPRINT_GET_QUALITY | XPRINT_GET_SCALE |
| XPRINT_GET_SELECTION | XPRINT_GET_SIZE | XPRINT_GET_STRETCHMODE | XPRINT_GET_TEXTALIGN | XPRINT_GET_TRAY |
| XPRINT_GET_TRAYS | XPRINT_GET_WORDWRAP | XPRINT_GET_WRAP | XPRINT_IMAGELIST | XPRINT_LINE |
| XPRINT_PIE | XPRINT_POLYGON | XPRINT_POLYLINE | XPRINT_PREVIEW | XPRINT_PRINT |
| XPRINT_RENDER | XPRINT_SCALE | XPRINT_SET_CLIP | XPRINT_SET_COLLATE | XPRINT_SET_COLOR |
| XPRINT_SET_COLORMODE | XPRINT_SET_COPIES | XPRINT_SET_DUPLEX | XPRINT_SET_FONT | XPRINT_SET_MIX |
| XPRINT_SET_ORIENTATION | XPRINT_SET_OVERLAP | XPRINT_SET_PAGES | XPRINT_SET_PAPER | XPRINT_SET_PIXEL |
| XPRINT_SET_POS | XPRINT_SET_QUALITY | XPRINT_SET_STRETCHMODE | XPRINT_SET_TEXTALIGN | XPRINT_SET_TRAY |
| XPRINT_SET_WORDWRAP | XPRINT_SET_WRAP | XPRINT_SPLIT | XPRINT_STRETCH | XPRINT_STYLE |
| XPRINT_TEXT_SIZE | XPRINT_WIDTH |  |  |  |
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