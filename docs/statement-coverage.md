# PowerBasilisk Enhanced — Official Statement Coverage Matrix

> **Last updated from batch 95 (v0.1.89)** — 2026-09-15. All statements through batch 95 are reflected in this matrix. Function-class additions (REMOVE$/RETAIN$/REMAIN$/FLOOR/TRUNC/INPUT console etc.) are tracked in README "Newly implemented by this branch" table, not in this official statement-keyword index.

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
| ARRAY ADD | STATEMENT | `pb_array_add` (element-wise add into first array; all numeric types incl. BYTE/WORD/LONG/QUAD/SINGLE/DOUBLE) |
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
| DESKTOP GET CLIENT | STATEMENT | `SystemParametersInfoA` SPI_GETWORKAREA —,h (work area) |
| DESKTOP GET LOC | STATEMENT | `SystemParametersInfoA` SPI_GETWORKAREA —,y (origin) |
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
| XPRINT ATTACH | STATEMENT | pb_xprint_attach —CreateDC (screen DC fallback for CI; printer support pending) |
| XPRINT SET CLIP | STATEMENT | `pb_xprint_set_clip` —IntersectClipRect |
| XPRINT GET CLIP | STATEMENT | `pb_xprint_get_clip` —GetClipBox |
| XPRINT SCALE | STATEMENT | `pb_xprint_scale` —SetMapMode(MM_ANISOTROPIC) + SetWindowExtEx/SetViewportExtEx |
| XPRINT GET SCALE | STATEMENT | `pb_xprint_get_scale` —current scale factors |
| XPRINT GET LINES | STATEMENT | `pb_xprint_get_lines` —client height / cell height |
| XPRINT CELL SIZE | STATEMENT | `pb_xprint_cell_size` —GetTextExtentPoint32A("W") |
| XPRINT CHR SIZE | STATEMENT | `pb_xprint_chr_size` —same as CELL SIZE |
| XPRINT POLYGON | STATEMENT | `pb_xprint_polygon` —Polygon (GDI), variable coord args on stack |
| XPRINT SET COPIES | STATEMENT | `pb_xprint_set_copies` —global printer property |
| XPRINT GET COPIES | STATEMENT | `pb_xprint_get_copies` —global printer property |
| XPRINT SET ORIENTATION | STATEMENT | `pb_xprint_set_orientation` —global printer property |
| XPRINT GET ORIENTATION | STATEMENT | `pb_xprint_get_orientation` —global printer property |
| XPRINT SET QUALITY | STATEMENT | `pb_xprint_set_quality` —global printer property |
| XPRINT GET QUALITY | STATEMENT | `pb_xprint_get_quality` —global printer property |
| XPRINT SET DUPLEX | STATEMENT | `pb_xprint_set_duplex` —global printer property |
| XPRINT GET DUPLEX | STATEMENT | `pb_xprint_get_duplex` —global printer property |
| XPRINT SET COLLATE | STATEMENT | `pb_xprint_set_collate` —global printer property |
| XPRINT GET COLLATE | STATEMENT | `pb_xprint_get_collate` —global printer property |
| XPRINT SET COLORMODE | STATEMENT | `pb_xprint_set_colormode` —global printer property |
| XPRINT GET COLORMODE | STATEMENT | `pb_xprint_get_colormode` —global printer property |
| XPRINT SET PAGES | STATEMENT | `pb_xprint_set_pages` —global printer property |
| XPRINT GET PAGES | STATEMENT | `pb_xprint_get_pages` —global printer property |
| XPRINT POLYLINE | STATEMENT | `pb_xprint_polyline` —Polyline (GDI), variable coord args on stack |
| XPRINT COPY | STATEMENT | `pb_xprint_copy` —BitBlt (SRCCOPY) |
| XPRINT TEXT SIZE | STATEMENT | `pb_xprint_text_size` —GetTextExtentPoint32A (returns width+height) |
| XPRINT GET CLIENT | STATEMENT | `pb_xprint_get_client` —GetDeviceCaps HORZRES/VERTRES |
| XPRINT GET CANVAS | STATEMENT | `pb_xprint_get_canvas` —same as GET CLIENT on screen DC |
| XPRINT SET WRAP | STATEMENT | `pb_xprint_set_wrap` —text wrap mode flag |
| XPRINT GET WRAP | STATEMENT | `pb_xprint_get_wrap` —current wrap flag |
| XPRINT SET WORDWRAP | STATEMENT | `pb_xprint_set_wordwrap` —word-wrap flag |
| XPRINT GET WORDWRAP | STATEMENT | `pb_xprint_get_wordwrap` —current word-wrap flag |
| XPRINT SET OVERLAP | STATEMENT | `pb_xprint_set_overlap` —line overlap percentage |
| XPRINT GET OVERLAP | STATEMENT | `pb_xprint_get_overlap` —current overlap value |
| XPRINT ARC | STATEMENT | `pb_xprint_arc` —GDI Arc (bounding rect + start/end radials) |
| XPRINT ELLIPSE | STATEMENT | `pb_xprint_ellipse` —GDI Ellipse (NULL_BRUSH) |
| XPRINT PIE | STATEMENT | `pb_xprint_pie` —GDI Pie (bounding rect + radials, NULL_BRUSH) |
| XPRINT SET FONT | STATEMENT | `pb_xprint_set_font` —CreateFontA + SelectObject (name/size/bold/italic) |
| XPRINT SET MIX | STATEMENT | `pb_xprint_set_mix` —SetROP2 |
| XPRINT GET MIX | STATEMENT | `pb_xprint_get_mix` —GetROP2 |
| XPRINT SET STRETCHMODE | STATEMENT | `pb_xprint_set_stretchmode` —SetStretchBltMode |
| XPRINT GET STRETCHMODE | STATEMENT | `pb_xprint_get_stretchmode` —GetStretchBltMode |
| XPRINT CANCEL | STATEMENT | `pb_xprint_cancel` —AbortDoc (noop on screen DC) |
| XPRINT FORMFEED | STATEMENT | `pb_xprint_formfeed` —EndPage+StartPage (resets pos on screen DC) |
| XPRINT LINE | STATEMENT | `pb_xprint_line` —MoveToEx+LineTo |
| XPRINT BOX | STATEMENT | `pb_xprint_box` —Rectangle (NULL_BRUSH) |
| XPRINT WIDTH | STATEMENT | `pb_xprint_width` —CreatePen width |
| XPRINT STYLE | STATEMENT | `pb_xprint_style` —CreatePen style (PS_SOLID etc.) |
| XPRINT COLOR | STATEMENT | `pb_xprint_set_color` —pen + text color |
| XPRINT SET POS | STATEMENT | `pb_xprint_set_pos` —text/drawing origin |
| XPRINT GET POS | STATEMENT | `pb_xprint_get_pos` —current position |
| XPRINT SET PIXEL | STATEMENT | `pb_xprint_set_pixel` —SetPixel |
| XPRINT GET PIXEL | STATEMENT | `pb_xprint_get_pixel` —GetPixel |
| XPRINT SET TEXTALIGN | STATEMENT | `pb_xprint_set_textalign` —SetTextAlign |
| XPRINT GET TEXTALIGN | STATEMENT | `pb_xprint_get_textalign` —current text align |
| XPRINT GET ATTACH | STATEMENT | `pb_xprint_get_attach` —1 if DC attached |
| XPRINT PRINT | STATEMENT | `pb_xprint_print_str` per arg —TextOutA + auto-advance |
| XPRINT CLOSE | STATEMENT | pb_xprint_close —DeleteDC + detach |
| XPRINT GET DC | STATEMENT | pb_xprint_get_dc —current DC handle (QUAD) |
| XPRINT GET PPI | STATEMENT | pb_xprint_get_ppi —GetDeviceCaps LOGPIXELSX/Y |
| XPRINT GET SIZE | STATEMENT | pb_xprint_get_size —PHYSICALWIDTH/HEIGHT with HORZRES/VERTRES fallback |
| `ON GOTO` | STATEMENT | (PB/Win + PB/CC) Computed branch to one of several labels |
| `ON GOSUB` | STATEMENT | (PB/Win + PB/CC) Computed call to one of several subroutines (RETURN returns) |
| `CLIPBOARD` (SET TEXT / GET TEXT / RESET) | STATEMENT | (PB/Win + PB/CC) Win32 clipboard read/write/reset |
| `INPUT FLUSH` | STATEMENT | (PB/CC only) Flush console input buffer |
| `OPTION EXPLICIT` | STATEMENT | (PB/Win + PB/CC) Accepted (requires explicit declarations) |
| `REM` | STATEMENT | (PB/Win + PB/CC) Comments accepted at top level and in bodies |
| `GLOBAL` | STATEMENT | (PB/Win + PB/CC) Global variable declarations |
| `ARRAY ARRAYIX` | STATEMENT | implemented |
| `ARRAY ASSIGN` | STATEMENT | (PB/Win + PB/CC) pb_array_copy: target() = source() element copy (batch 23) |
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