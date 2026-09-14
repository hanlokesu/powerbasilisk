# PowerBasilisk Enhanced — Official Statement Coverage Matrix

Ground truth: **PowerBASIC official documentation** (MIT license, 735 keywords / 1282 topic pages, PB/Win 10+11 / PB/CC 6+7).

- Official **statement-class** keywords total: **493**

- Official function-class: 190 (CURDIR$ / ISFILE among them — both implemented)

- Generated: 2026-09-15 (batch 36: MKE$) (batch 35: REGEXPR/REGREPL) (batch 34: PROFILE) (batch 33: CALLSTK) (batch 31: FIELD / FIELD STRING / FIELD RESET / OPEN FOR RANDOM) (batch 25: ON ERROR / RESUME / REGISTER) (audited: FOR/NEXT, SELECT CASE, LET, MID$, VAL, ASC, PARSE, FUNCTION, IF/END IF verified live)

## Summary

| Status | Count | Notes |
|--------|-------|-------|
| ✅ Implemented | 251 | Real codegen output (Win32 calls / runtime helpers / control flow) |
| 🚧 Tier-3 DDT | 151 | DDT GUI framework, high effort, deferred to a future update |
| ⬜ Not implemented | 101 | Documented upstream, no codegen evidence yet |

## ✅ Implemented (255)

| Keyword | Official kind | Implementation |
|---------|---------------|----------------|
| `FIELD` | FIELD statement (RANDOM file / dynamic string binding) | pb_open_random + pb_field_* |
| `ASM` | STATEMENT | LLVM inline assembly: `!` shortcut or `ASM` keyword; Intel dialect, PB variable operands passed by pointer (`byte/word/dword/qword ptr [$N]`), mem-to-mem and wide-immediate shuffling automatic; consecutive ASM lines merge into one asm block so register state is preserved; x87 / MMX / SSE / SIMD instructions pass through verbatim (verified FLD1/FSTP, PXOR, EMMS, XORPS on x64; 32-bit build verified via exit-code test) |
| `ASMDATA / END ASMDATA` | BLOCK | read-only data blocks (outside any Sub/Function): `ASMDATA Name` + DB/DW/DD/DQ lines (ANSI strings in DB, WIDE/UTF-16LE strings in DW) + `END ASMDATA`; packed, never aligned; addressable via `CODEPTR(Name)`; byte blob emitted as `@__asmdata_<NAME>` constant |
| `TCP OPEN` | STATEMENT | winsock socket/connect/listen/bind; SO_RCVTIMEO |
| `TCP ACCEPT` | STATEMENT | winsock accept; new file number |
| `TCP SEND` | STATEMENT | winsock send |
| `TCP RECV` | STATEMENT | winsock recv into PB string |
| `TCP LINE INPUT` | STATEMENT | byte-wise recv until LF |
| `TCP PRINT` | STATEMENT | send data + CRLF |
| `TCP CLOSE` | STATEMENT | closesocket |
| `UDP OPEN` | STATEMENT | winsock SOCK_DGRAM bind; PORT=server, no PORT=client |
| `UDP SEND` | STATEMENT | sendto; AT accepts LONG or string address |
| `UDP RECV` | STATEMENT | recvfrom; returns source ip/port |
| `UDP CLOSE` | STATEMENT | closesocket |
| `#ALIGN METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#BLOAT METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#BREAK METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#COM METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#COMPILE METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#COMPILER METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#CONSOLE METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#DEBUG BOUNDS METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#DEBUG CODE METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#DEBUG DISPLAY METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#DEBUG ERROR METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#DEBUG NUMERIC METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#DEBUG PRINT METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#DIM METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#EXPORT METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#IF/#ELSEIF/#ELSE/#ENDIF METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#INCLUDE METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#LINK METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#MESSAGES METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#OPTIMIZE METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#OPTION METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#PAGE METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#PBFORMS METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#REGISTER METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#RESOURCE METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#STACK METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#TOOLS METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#UNIQUE METASTATEMENT` | STATEMENT | compile-time directive, accepted |
| `#UTILITY METASTATEMENT` | STATEMENT | compile-time directive, accepted |

| ARRAY COPY | STATEMENT | `pb_array_copy` (fixed-array memcpy; dynamic resize not modeled) |
| ARRAY SWAP | STATEMENT | `pb_array_swap` (fixed-array block exchange) |
| ARRAY UNIQUE | STATEMENT | `pb_array_unique` (in-place dedup; UBOUND shrink not modeled) |
| ARRAY DELETE | STATEMENT | `core` |
| HOST ADDR | STATEMENT | `pb_host_addr` (gethostbyname, winsock) |
| HOST NAME | STATEMENT | `pb_host_name` (gethostbyaddr/gethostname, winsock) |

| ARRAY INSERT | STATEMENT | `core` |
| ARRAY REVERSE | STATEMENT | `core` |
| ARRAY SCAN | STATEMENT | `core` |
| ARRAY SHUFFLE | STATEMENT | `core` |
| ARRAY SORT | STATEMENT | `core` |
| ASC | STATEMENT | `core` |
| BEEP | STATEMENT | `core` |
| BIT | STATEMENT | `core` |
| BIT CALC | STATEMENT | `core` |
| CALL | STATEMENT | `core` |
| CHDIR | STATEMENT | `core` |
| CSET | STATEMENT | `pb_cset`/`pb_cset_buf` (center-justify, pads spaces) |
| CHDRIVE | STATEMENT | `core` |
| CLOSE | STATEMENT | `core` |
| CLS | STATEMENT | `PB/CC only` |
| DATA | STATEMENT | `core` |
| DECR | STATEMENT | `core` |
| DESKTOP GET SIZE | STATEMENT | `GetSystemMetrics` (SM_CXSCREEN/SM_CYSCREEN) |
| DESKTOP GET CLIENT | STATEMENT | `SystemParametersInfoA` SPI_GETWORKAREA → w,h (work area) |
| DESKTOP GET LOC | STATEMENT | `SystemParametersInfoA` SPI_GETWORKAREA → x,y (origin) |
| DESKTOP GET PPI | STATEMENT | `GetDeviceCaps` LOGPIXELSX/Y (pixels per inch) |
| DIM | STATEMENT | `core` |
| END | STATEMENT | `core` |
| ENVIRON | STATEMENT | `core` |
| ERASE | STATEMENT | `core` |
| ERROR | STATEMENT | `core` |
| EXIT | STATEMENT | `core` |
| FILECOPY | STATEMENT | `core` |
| FLUSH | STATEMENT | `core` |
| FOR / NEXT | STATEMENT | `core` |
| FUNCTION / END FUNCTION | STATEMENT | `core` |
| GET | STATEMENT | `core` |
| GET$ | STATEMENT | `pb_get_string` (read N bytes into string var) |
| GLOBALMEM | STATEMENT | `pb_globalmem_alloc/free/lock/size/unlock` (moveable global memory via slot ids) |
| IF | STATEMENT | `core` |
| IF/END IF | BLOCK | `core` |
| INCR | STATEMENT | `core` |
| INPUT# | STATEMENT | `PB/CC only` |
| ISINFINITE | STATEMENT | `core` |
| ISNORMAL | STATEMENT | `core` |
| ITERATE | STATEMENT | `core` |
| KILL | STATEMENT | `core` |
| LET | STATEMENT | `core` |
| LINE INPUT# | STATEMENT | `core` |
| LOCK | STATEMENT | `core` |
| LSET | STATEMENT | `core` |
| MID$ | STATEMENT | `core` |
| MKBYT$ | STATEMENT | `pb_mkbyt` (1-byte binary string) |
| MKCUR$ | STATEMENT | `pb_mkquad` (8-byte little-endian, currency) |
| MKCUX$ | STATEMENT | `pb_mkquad` (8-byte little-endian, extended currency) |
| MKD$ | STATEMENT | `pb_mkdouble` (8-byte IEEE-754) |
| MKDWD$ | STATEMENT | `pb_mklong` (4-byte little-endian, double-word) |
| `MAT` | Statement | matrix algebra (CON / CON(expr) / IDN / ZER / + / - / * / scalar / TRN / INV) |
| MKI$ | STATEMENT | `pb_mkint` (2-byte little-endian) |
| MKL$ | STATEMENT | `pb_mklong` (4-byte little-endian) |
| MKQ$ | STATEMENT | `pb_mkquad` (8-byte little-endian) |
| MKS$ | STATEMENT | `pb_mksingle` (4-byte IEEE-754) |
| MKWRD$ | STATEMENT | `pb_mkint` (2-byte little-endian) |
| MKDIR | STATEMENT | `core` |
| MOUSEPTR | STATEMENT | `pb_mouseptr` (stock cursors 0-13, PB/CC only) |
| MSGBOX | STATEMENT | `PB/Win only` |
| NAME | STATEMENT | `core` |
| OPEN | STATEMENT | `core` |
| PARSE | STATEMENT | `core` |
| PLAY SOUND | STATEMENT | `core` |
| PLAY WAVE | STATEMENT | `core` |
| PRINT# | STATEMENT | `core` |
| PROCESS GET PRIORITY | STATEMENT | `core` |
| PROCESS SET PRIORITY | STATEMENT | `core` |
| PUT | STATEMENT | `core` |
| PUT$ | STATEMENT | `core` |
| RANDOMIZE | STATEMENT | `core` |
| REDIM | STATEMENT | `core` |
| REPLACE | STATEMENT | `core` |
| RESET | STATEMENT | `core` |
| RETURN | STATEMENT | `core` |
| RMDIR | STATEMENT | `core` |
| ROTATE | STATEMENT | `core` |
| RSET | STATEMENT | `core` |
| SEEK | STATEMENT | `core` |
| SELECT CASE/END SELECT | BLOCK | `core` |
| SETATTR | STATEMENT | `core` |
| SETEOF | STATEMENT | `core` |
| SHELL | STATEMENT | `core` |
| SHIFT | STATEMENT | `core` |
| SLEEP | STATEMENT | `core` |
| SPLIT | STATEMENT | `core` |
| SWAP | STATEMENT | `core` |
| TIX | STATEMENT | `core` |
| UNLOCK | STATEMENT | `core` |
| UCODEPAGE | STATEMENT | `pb_ucodepage` (records ANSI/OEM/numeric codepage) |
| VAL | STATEMENT | `core` |
| WRITE# | STATEMENT | `core` |
| `ON GOTO` | STATEMENT | PB/Win + PB/CC | Computed branch to one of several labels |
| `ON GOSUB` | STATEMENT | PB/Win + PB/CC | Computed call to one of several subroutines (RETURN returns) |
| `CLIPBOARD` (SET TEXT / GET TEXT / RESET) | STATEMENT | PB/Win + PB/CC | Win32 clipboard read/write/reset |
| `INPUT FLUSH` | STATEMENT | PB/CC only | Flush console input buffer |
| `OPTION EXPLICIT` | STATEMENT | PB/Win + PB/CC | Accepted (requires explicit declarations) |
| `REM` | STATEMENT | PB/Win + PB/CC | Comments accepted at top level and in bodies |
| `GLOBAL` | STATEMENT | PB/Win + PB/CC | Global variable declarations |
| `ARRAY ARRAYIX` |
| `ARRAY ASSIGN` | STATEMENT | PB/Win + PB/CC | pb_array_copy: target() = source() element copy (batch 23) |
 STATEMENT | PB/Win + PB/CC | Each element = its index (batch 20) |
| `DECLARE` | STATEMENT | PB/Win + PB/CC | DECLARE SUB/FUNCTION prototypes (batch 20) |
| `FILESCAN` | STATEMENT | PB/Win + PB/CC | Records/width scan, INPUT+BINARY modes (batch 20) |
| `LOCAL` | STATEMENT | PB/Win + PB/CC | Local variable declarations (batch 20) |
| `TYPE/END TYPE` | BLOCK | PB/Win + PB/CC | UDT definitions (batch 20) |
| `COMM OPEN` | STATEMENT | PB/Win + PB/CC | CreateFileA + DCB/SetCommState/SetCommTimeouts; comm channel 0..255 (batch 21) |
| `COMM CLOSE` | STATEMENT | PB/Win + PB/CC | CloseHandle per channel (batch 21) |
| `COMM LINE` | STATEMENT | PB/Win + PB/CC | COMM LINE INPUT: byte-wise ReadFile until LF into PB string (batch 21) |
| `COMM PRINT` | STATEMENT | PB/Win + PB/CC | WriteFile str/int/dbl variants (batch 21) |
| `COMM RECV` | STATEMENT | PB/Win + PB/CC | ReadFile n bytes into PB string (batch 21) |
| `COMM RESET` | STATEMENT | PB/Win + PB/CC | close all open COMM channels (batch 21) |
| `COMM SEND` | STATEMENT | PB/Win + PB/CC | WriteFile + FlushFileBuffers (batch 21) |
| `COMM SET` | STATEMENT | PB/Win + PB/CC | EscapeCommFunction DTR/RTS/BREAK on/off (batch 21) |
| `COMM TIMEOUT` | STATEMENT | PB/Win + PB/CC | SetCommTimeouts read/write constants (batch 21) |
| `THREAD CLOSE` | STATEMENT | PB/Win + PB/CC | TerminateThread + CloseHandle (batch 21) |
| `THREAD CREATE` | STATEMENT | PB/Win + PB/CC | CreateThread (x64); PB slot id 0..255 (batch 21) |
| `THREADED` | STATEMENT | module-level `thread_local` global; per-thread copy, global to every Sub/Function (scalars; arrays pending) |
| `THREAD GET PRIORITY` | STATEMENT | PB/Win + PB/CC | GetThreadPriority (batch 21) |
| `THREAD RESUME` | STATEMENT | PB/Win + PB/CC | ResumeThread (batch 21) |
| `THREAD SET PRIORITY` | STATEMENT | PB/Win + PB/CC | SetThreadPriority (batch 21) |
| `THREAD STATUS` | STATEMENT | PB/Win + PB/CC | GetExitCodeThread STILL_ACTIVE; 1 run / 2 susp / 3 done (batch 21) |
| `THREAD SUSPEND` | STATEMENT | PB/Win + PB/CC | SuspendThread (batch 21) |
| `LPRINT` | STATEMENT | PB/Win + PB/CC | direct device/file output via LPRINT ATTACH (batch 22) |
| `LPRINT ATTACH` | STATEMENT | PB/Win + PB/CC | CreateFileA open device; quoted string/device name (batch 22) |
| `LPRINT CLOSE` | STATEMENT | PB/Win + PB/CC | CloseHandle (batch 22) |
| `LPRINT FLUSH` | STATEMENT | PB/Win + PB/CC | FlushFileBuffers (batch 22) |
| `LPRINT FORMFEED` | STATEMENT | PB/Win + PB/CC | form feed char 0x0C (batch 22) |
| `TRACE` | STATEMENT | PB/Win + PB/CC | TRACE NEW/ON/OFF/PRINT/CLOSE explicit log file (batch 22) |
| `IMPORT` | STATEMENT | PB/Win + PB/CC | IMPORT ADDR LoadLibraryA+GetProcAddress into QUAD vars (batch 22) |
| `CALL DWORD` | STATEMENT | PB/Win + PB/CC | indirect call via inttoptr; USING args + TO result (batch 22) |
| CALLSTK | STATEMENT | PB/Win + PB/CC | CALLSTKCOUNT depth / CALLSTK$(n) frame names / CALLSTK filename$ file dump (batch 33) |
| PROFILE | STATEMENT | PB/Win + PB/CC | per-procedure call counts + elapsed ms via the call-stack frames; PROFILE filename$ dumps "<Name>, <Call Count>, <Time mSec>" (batch 34) |
| REGEXPR | STATEMENT | PB/Win + PB/CC | documented regex subset scan; REGEXPR mask$ IN target$ [AT start&] TO iPos& [, iLen&], leftmost-longest, case-insensitive default (batch 35) |
| REGREPL | STATEMENT | PB/Win + PB/CC | documented regex subset replace; REGREPL mask$ IN target$ WITH repl$ [AT start&] TO iPos&, newtarget$, \00 = whole match (batch 35) |
| `WINDOW SET` | STATEMENT | PB/Win only | SetConsoleTitleA console title; hwnd ignored (batch 23) |
| `WINDOW GET` | STATEMENT | PB/Win only | GetConsoleTitleA into string var (batch 23) |
| `STATIC` | STATEMENT | PB/Win + PB/CC | module-global slot, persists across calls (batch 23) |
| `ON ERROR` | STATEMENT | PB/Win + PB/CC | run-time error trap: GOTO label / GOTO 0 / RESUME NEXT (batch 25) |
| `REGISTER` | STATEMENT | PB/Win + PB/CC | optimization hint, accepted as LOCAL (batch 25) |
| `RESUME` | STATEMENT | PB/Win + PB/CC | RESUME / RESUME NEXT / RESUME FLUSH / RESUME label (batch 25) |
| `TYPE SET` | STATEMENT | PB/Win + PB/CC | pb_type_set / pb_type_set_str memcpy fill (batch 23) |
| `TRY/END TRY` | BLOCK | structured error trap; CATCH/FINALLY/EXIT TRY, reuses ON ERROR machinery |
| `DIR FUNCTION AND` | STATEMENT | PB/Win + PB/CC | Proposed Improvement |
| `PREFIX` | BLOCK | preprocessor text transform; prepends source code to each line until END PREFIX |
| `LET *(WITH TYPES)*` | STATEMENT | PB/Win + PB/CC | Established |


| `GET$$` | STATEMENT | pb_get_wstring/pb_put_wstring (UTF-16LE round-trip) |
| `MACRO/END MACRO` | BLOCK | preprocessor text expansion (single-line + multi-line) |
| `ON CALL` | STATEMENT | dispatch table to SUB/FUNCTION (batch 27) |
| `PUT$$` | STATEMENT | pb_put_wstring (WIDE write, UTF-16LE) |
| MEMORY | STATEMENT | PB/Win + PB/CC | Established |
| FONT END | STATEMENT | PB/Win + PB/CC | Established |
| FONT NEW | STATEMENT | PB/Win + PB/CC | Established |
| MKE$ | STATEMENT | PB/Win + PB/CC | 8-byte binary string of an EXT value; EXT is an 8-byte IEEE-754 double in this compiler (official 80-bit format not modelled), so MKE$ == MKD$ (batch 36) |
| IMAGELIST | STATEMENT (IMAGELIST NEW BITMAP\|ICON / GET COUNT / KILL) | ImageList_Create / ImageList_GetImageCount / ImageList_Destroy (comctl32); handles are 64-bit pointers — use QUAD variables (batch 48) |
| COLOR | STATEMENT (PB/CC console text color) | pb_color — SetConsoleTextAttribute(GetStdHandle(-11)); fore/back 0-15, no args restores default (batch 49) |
| MENU NEW BAR | STATEMENT (menu bar handle) | pb_menu_new_bar — CreateMenu; handle is 64-bit (QUAD) (batch 50) |
| MENU NEW POPUP | STATEMENT (popup menu handle) | pb_menu_new_popup — CreatePopupMenu; handle is 64-bit (QUAD) (batch 50) |
| MENU ADD STRING | STATEMENT (menu item) | pb_menu_add_string — AppendMenuA MF_STRING (batch 50) |
| MENU ADD POPUP | STATEMENT (submenu) | pb_menu_add_popup — AppendMenuA MF_POPUP (batch 50) |
| MENU DELETE | STATEMENT (remove item) | pb_menu_delete — DeleteMenu MF_BYPOSITION (batch 50) |
| GRAPHIC BITMAP NEW | STATEMENT (memory DIB) | pb_gdi_bitmap_new — CreateDIBSection (top-down 32bpp); not visible (batch 51) |
| GRAPHIC BITMAP END | STATEMENT (destroy bitmap) | pb_gdi_bitmap_end — DeleteObject; no-arg form destroys last created (batch 51) |
| GRAPHIC ATTACH | STATEMENT (graphic target) | pb_graphic_attach — selects a memory bitmap as the graphic target (batch 52) |
| GRAPHIC DETACH | STATEMENT (detach target) | pb_graphic_detach — releases the graphic DC (batch 52) |
| GRAPHIC CLEAR | STATEMENT (clear target) | pb_graphic_clear — FillRect with solid brush (batch 52) |
| GRAPHIC LINE | STATEMENT (draw line) | pb_graphic_line — MoveToEx + LineTo on attached target (batch 53) |
| GRAPHIC BOX | STATEMENT (draw rectangle) | pb_graphic_box — Rectangle with optional fill (batch 53) |
| GRAPHIC ELLIPSE | STATEMENT (draw ellipse) | pb_graphic_ellipse — Ellipse with optional fill (batch 53) |
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
| `GRAPHIC SET PIXEL` | Statement | Win32/GDI | Proposed New | IMPLEMENTED |
| `GRAPHIC GET SIZE` | Statement | Win32/GDI | Proposed New | IMPLEMENTED |
| `GRAPHIC SET TEXTALIGN` | Statement | Win32/GDI | Proposed New | IMPLEMENTED |
| `GRAPHIC GET TEXTALIGN` | Statement | Win32/GDI | Proposed New | IMPLEMENTED |
| `GRAPHIC ARC` | Statement | PB/Win + PB/CC | Established | IMPLEMENTED |
| `GRAPHIC PIE` | Statement | PB/Win + PB/CC | Established | IMPLEMENTED |
| `GRAPHIC POLYLINE` | Statement | PB/Win + PB/CC | Established | IMPLEMENTED |
| `GRAPHIC PAINT` | Statement | PB/Win + PB/CC | Established | IMPLEMENTED |
| GRAPHIC GET CAPTION | console-title bridge (GetConsoleTitleA) |
| GRAPHIC GET POS | current pen position (GetCurrentPositionEx) |
| GRAPHIC GET PPI | pixels per inch (GetDeviceCaps LOGPIXELS) |
| GRAPHIC GET STRETCHMODE | current stretch mode (GetStretchBltMode) |
| GRAPHIC SET CAPTION | console-title bridge (SetConsoleTitleA) |
| GRAPHIC SET POS | move pen position (MoveToEx, optional STEP) |
| GRAPHIC SET STRETCHMODE | set stretch mode (SetStretchBltMode) |
| GRAPHIC TEXT SIZE | measure string (GetTextExtentPoint32A) 
| `MENU GET STATE` | STATEMENT | pb_menu_get_state (GetMenuState/EnableMenuItem/CheckMenuItem) |
| `MENU SET STATE` | STATEMENT | pb_menu_set_state (EnableMenuItem/CheckMenuItem) |
| `MENU GET TEXT` | STATEMENT | pb_menu_get_text (GetMenuStringA) |
| `MENU SET TEXT` | STATEMENT | pb_menu_set_text (ModifyMenuA) ||
## 🚧 Tier-3 DDT (deferred to next update)

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
| GRAPHIC BITMAP CAPTURE | STATEMENT |
| GRAPHIC BITMAP LOAD | STATEMENT |
| GRAPHIC CELL | STATEMENT |
| GRAPHIC CELL SIZE | STATEMENT |
| GRAPHIC CHR SIZE | STATEMENT |
| GRAPHIC COLOR | STATEMENT |
| GRAPHIC COPY | STATEMENT |
| GRAPHIC GET BITS | STATEMENT |
| GRAPHIC GET CANVAS | STATEMENT |
| GRAPHIC GET CLIENT | STATEMENT |
| GRAPHIC GET CLIP | STATEMENT |
| GRAPHIC GET DC | STATEMENT |
| GRAPHIC GET LINES | STATEMENT |
| GRAPHIC GET LOC | STATEMENT |
| GRAPHIC GET MIX | STATEMENT |
| GRAPHIC GET OVERLAP | STATEMENT |
| GRAPHIC GET PIXEL | STATEMENT |
| GRAPHIC GET SCALE | STATEMENT |
| GRAPHIC GET SCROLLTEXT | STATEMENT |
| GRAPHIC GET VIEW | STATEMENT |
| GRAPHIC GET WORDWRAP | STATEMENT |
| GRAPHIC GET WRAP | STATEMENT |
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
| GRAPHIC SCALE | STATEMENT |
| GRAPHIC SET AUTOSIZE | STATEMENT |
| GRAPHIC SET BITS | STATEMENT |
| GRAPHIC SET CLIENT | STATEMENT |
| GRAPHIC SET CLIP | STATEMENT |
| GRAPHIC SET FIXED | STATEMENT |
| GRAPHIC SET FOCUS | STATEMENT |
| GRAPHIC SET FONT | STATEMENT |
| GRAPHIC SET LOC | STATEMENT |
| GRAPHIC SET MIX | STATEMENT |
| GRAPHIC SET OVERLAP | STATEMENT |
| GRAPHIC SET SCROLLTEXT | STATEMENT |
| GRAPHIC SET SIZE | STATEMENT |
| GRAPHIC SET VIEW | STATEMENT |
| GRAPHIC SET VIRTUAL | STATEMENT |
| GRAPHIC SET WORDWRAP | STATEMENT |
| GRAPHIC SET WRAP | STATEMENT |
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

## ⬜ Not implemented (101, alphabetical)

| Keyword | Official kind | Platform | Status |
|---------|---------------|----------|--------|

| ARRAY ADD | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY REDIM INCR/DECR | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY SELECT | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY TAGARRAY | STATEMENT | PB/Win + PB/CC | Proposed New |
| ARRAY TAGARRAY ERASE | STATEMENT | PB/Win + PB/CC | Proposed New |

| CLASS/END CLASS | BLOCK | PB/Win + PB/CC | Established |
| DISPLAY BROWSE | STATEMENT | PB/Win only | Established |
| DISPLAY COLOR | STATEMENT | PB/Win only | Established |
| DISPLAY FONT | STATEMENT | PB/Win only | Established |
| DISPLAY OPENFILE | STATEMENT | PB/Win only | Established |
| DISPLAY SAVEFILE | STATEMENT | PB/Win only | Established |
| EVENT SOURCE | STATEMENT | PB/Win + PB/CC | Established |
| EVENTS | STATEMENT | PB/Win + PB/CC | Established |
| HEADER | STATEMENT | PB/Win only | Established |

| INSTANCE | STATEMENT | PB/Win + PB/CC | Established |
| INTERFACE / END INTERFACE (DIRECT) | BLOCK | PB/Win + PB/CC | Established |
| INTERFACE/END INTERFACE (IDBIND) | BLOCK | PB/Win + PB/CC | Established |
| LET *(WITH OBJECTS)* | STATEMENT | PB/Win + PB/CC | Established |
| LET *(WITH VARIANTS)* | STATEMENT | PB/Win + PB/CC | Established |

| METHOD / END METHOD | STATEMENT | PB/Win + PB/CC | Established |
| OBJECT | STATEMENT | PB/Win + PB/CC | Established |
| PROGRESSBAR | STATEMENT | PB/Win only | Established |
| RAISEEVENT | STATEMENT | PB/Win + PB/CC | Established |
| RESOURCE SAVE FILE | STATEMENT | PB/Win + PB/CC | Proposed New |
| TCP NOTIFY | STATEMENT | PB/Win + PB/CC | Established |

| UDP NOTIFY | STATEMENT | PB/Win + PB/CC | Established |
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

## Files

- `docs/statement-coverage.md` — this readable summary
- `docs/statement-coverage.csv` — all rows with per-keyword status (Keyword, Kind, Platform, Status, Impl)

## Method

1. Parse `keyword-index.md` from the official docs package (735 keywords, one line per keyword).
2. Keep statement-class keywords (STATEMENT / BLOCK / KEYWORD / DIRECTIVE) = 493.
3. Grep `codegen.rs` for the runtime helpers / Win32 API calls / compile_* functions each keyword maps to.
4. Classify: IMPLEMENTED (real codegen evidence) / TIER3_DDT (GUI framework, deferred) / NOT_IMPL (no evidence).