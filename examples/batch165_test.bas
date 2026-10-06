' =====================================================================
' batch165_test.bas - the DIALOG statement family (batch 165)
' ---------------------------------------------------------------------
' Purpose:  exercise every statement form added in batch 165.  Wherever a
'           statement has a result PB source can read back, that value is
'           asserted; the rest are driven over the real code path, so a
'           crash or a wrong exit code still fails the sample.
'
' ASSERTED
'   * DIALOG GET CLIENT on a fresh 400x240 dialog reports 0 < w < 400 and
'     0 < h < 240.  The client area is strictly smaller than the window
'     rectangle because DIALOG NEW sizes the whole window, so a result of
'     400/240 here would mean GET CLIENT was really returning GET SIZE.
'   * DIALOG SET CLIENT hDlg, 200, 96 then GET CLIENT -> exactly 200 x 96.
'   * DIALOG SET LOC hDlg, 50, 40 then GET LOC -> exactly 50 x 40.
'   * DIALOG PIXELS 40,80 TO UNITS, then DIALOG UNITS back TO PIXELS
'     round-trips to 40,80 (both directions share GetDialogBaseUnits), and
'     the dialog-unit answer is the smaller one.
'   * DIALOG GET USER on a slot that was never written -> 0.
'   * DIALOG SET USER 3, 12345 -> GET USER 3 -> 12345, while slot 4 is
'     still 0: the eight slots are independent.
'   * DIALOG SET USER with index 9 is outside the documented 1..8 range and
'     leaves index 9 reading back 0.
'   * DIALOG SEND hDlg, %WM_USER+100 -> 0, the DefWindowProc answer for a
'     message the window procedure does not handle.
'   * DIALOG SEND hDlg, %WM_GETTEXTLENGTH -> > 0, so the dialog really
'     carries the title DIALOG NEW gave it.
'   * DIALOG MINIMIZE parks the window at -32000, so GET LOC reports a
'     negative x; DIALOG NORMALIZE then reports a positive size and a
'     non-negative location.
'   * DIALOG MAXIMIZE reports a window at least as wide as the normal one.
'   * DIALOG SHOW STATE hDlg, 2 then 1, because batch 165 discovered that
'     this statement had never worked: a verb-only guard on DIALOG SHOW
'     MODAL captured it.  It passes its argument straight to ShowWindow,
'     so 2 is SW_SHOWMINIMIZED and 1 is SW_SHOWNORMAL.
'
' EXERCISED WITHOUT AN ASSERTION (no readback is reachable from PB source
' without adding statements this batch does not own): DIALOG ENABLE,
' DIALOG DISABLE, DIALOG HIDE, DIALOG SHOW MODELESS, DIALOG STABILIZE,
' DIALOG NONSTABLE, DIALOG REDRAW, DIALOG POST, DIALOG SET ICON,
' DIALOG SET COLOR, DIALOG DEFAULT FONT.
'
' Expected output (run mode): the PRINTs below, ending in PASS.
' Exit code: 0 = every check passed, 1 = at least one check failed.
' Notes:    The window never enters a message loop, so the sample finishes
'           on its own with no interaction.  %WM_USER is 1024 and
'           %WM_GETTEXTLENGTH is 14.  Colour 16711680 is 0x00FF0000, which
'           in the 0x00BBGGRR order PowerBASIC uses is pure blue.
' =====================================================================
#COMPILE EXE

GLOBAL g_hDlg AS QUAD

FUNCTION PBMAIN () AS LONG
    LOCAL ok  AS LONG
    LOCAL w   AS LONG
    LOCAL h   AS LONG
    LOCAL x   AS LONG
    LOCAL y   AS LONG
    LOCAL ux  AS LONG
    LOCAL uy  AS LONG
    LOCAL px  AS LONG
    LOCAL py  AS LONG
    LOCAL v   AS LONG
    LOCAL r   AS LONG
    LOCAL bw  AS LONG
    LOCAL bh  AS LONG

    ok = 1

    DIALOG NEW 0, "Batch 165: DIALOG family", 100, 100, 400, 240 TO g_hDlg

    ' ---- 1. GET CLIENT is the client area, not the window rectangle ---
    w = 0: h = 0
    DIALOG GET CLIENT g_hDlg TO w, h
    PRINT "client of a new 400x240 dialog ="; w; "x"; h
    IF w <= 0 OR h <= 0 THEN ok = 0
    IF w >= 400 OR h >= 240 THEN ok = 0

    ' ---- 2. SET CLIENT / GET CLIENT round trip ------------------------
    DIALOG SET CLIENT g_hDlg, 200, 96
    w = 0: h = 0
    DIALOG GET CLIENT g_hDlg TO w, h
    PRINT "client after SET CLIENT 200,96 ="; w; "x"; h
    IF w <> 200 OR h <> 96 THEN ok = 0

    ' ---- 3. SET LOC / GET LOC round trip ------------------------------
    DIALOG SET LOC g_hDlg, 50, 40
    x = 0: y = 0
    DIALOG GET LOC g_hDlg TO x, y
    PRINT "loc after SET LOC 50,40 ="; x; ","; y
    IF x <> 50 OR y <> 40 THEN ok = 0

    ' ---- 4. PIXELS / UNITS round trip ---------------------------------
    DIALOG PIXELS g_hDlg, 40, 80 TO UNITS ux, uy
    PRINT "PIXELS 40,80 -> UNITS ="; ux; ","; uy
    IF ux >= 40 OR uy >= 80 THEN ok = 0
    DIALOG UNITS g_hDlg, ux, uy TO PIXELS px, py
    PRINT "UNITS back -> PIXELS ="; px; ","; py
    IF px <> 40 OR py <> 80 THEN ok = 0

    ' ---- 5. the eight user-data slots ---------------------------------
    v = 99
    DIALOG GET USER g_hDlg, 3 TO v
    PRINT "user slot 3 before SET ="; v
    IF v <> 0 THEN ok = 0

    DIALOG SET USER g_hDlg, 3, 12345
    v = 0
    DIALOG GET USER g_hDlg, 3 TO v
    PRINT "user slot 3 after SET ="; v
    IF v <> 12345 THEN ok = 0

    v = 99
    DIALOG GET USER g_hDlg, 4 TO v
    PRINT "user slot 4 (untouched) ="; v
    IF v <> 0 THEN ok = 0

    DIALOG SET USER g_hDlg, 9, 999
    v = 99
    DIALOG GET USER g_hDlg, 9 TO v
    PRINT "user slot 9 (outside 1..8) ="; v
    IF v <> 0 THEN ok = 0

    ' ---- 6. SEND: unhandled message vs a real window query ------------
    r = 99
    DIALOG SEND g_hDlg, 1024 + 100, 0, 0 TO r
    PRINT "SEND WM_USER+100 ="; r
    IF r <> 0 THEN ok = 0

    r = 0
    DIALOG SEND g_hDlg, 14, 0, 0 TO r
    PRINT "SEND WM_GETTEXTLENGTH ="; r
    IF r <= 0 THEN ok = 0

    ' ---- 7. POST is fire and forget -----------------------------------
    DIALOG POST g_hDlg, 1024 + 101, 0, 0
    DIALOG DOEVENTS

    ' ---- 8. MINIMIZE / NORMALIZE / MAXIMIZE ---------------------------
    bw = 0: bh = 0
    DIALOG GET SIZE g_hDlg TO bw, bh
    PRINT "size normal ="; bw; "x"; bh
    IF bw <= 0 OR bh <= 0 THEN ok = 0

    DIALOG MINIMIZE g_hDlg
    x = 0: y = 0
    DIALOG GET LOC g_hDlg TO x, y
    PRINT "loc minimized ="; x; ","; y
    IF x >= 0 THEN ok = 0

    DIALOG NORMALIZE g_hDlg
    w = 0: h = 0
    DIALOG GET SIZE g_hDlg TO w, h
    x = 0: y = 0
    DIALOG GET LOC g_hDlg TO x, y
    PRINT "size/loc normalized ="; w; "x"; h; " at "; x; ","; y
    IF w <= 0 OR h <= 0 THEN ok = 0
    IF x < 0 OR y < 0 THEN ok = 0

    DIALOG MAXIMIZE g_hDlg
    w = 0: h = 0
    DIALOG GET SIZE g_hDlg TO w, h
    PRINT "size maximized ="; w; "x"; h
    IF w < bw THEN ok = 0

    DIALOG NORMALIZE g_hDlg

    ' ---- 8b. DIALOG SHOW STATE (dead until the batch 165 guard fix) ----
    DIALOG SHOW STATE g_hDlg, 2
    x = 0: y = 0
    DIALOG GET LOC g_hDlg TO x, y
    PRINT "SHOW STATE 2 (minimize) loc ="; x; ","; y
    IF x >= 0 THEN ok = 0

    DIALOG SHOW STATE g_hDlg, 1
    w = 0: h = 0
    DIALOG GET SIZE g_hDlg TO w, h
    PRINT "SHOW STATE 1 (normal) size ="; w; "x"; h
    IF w <= 0 OR h <= 0 THEN ok = 0

    ' ---- 9. exercised, no readback reachable from PB source -----------
    DIALOG DISABLE g_hDlg
    DIALOG ENABLE g_hDlg
    DIALOG SET COLOR g_hDlg, -1, 16711680
    DIALOG REDRAW g_hDlg
    DIALOG SET COLOR g_hDlg, -1, -1
    DIALOG STABILIZE g_hDlg
    DIALOG NONSTABLE g_hDlg
    DIALOG SET ICON g_hDlg, "NoSuchIconInThisModule"
    DIALOG HIDE g_hDlg
    DIALOG SHOW MODELESS g_hDlg
    DIALOG DEFAULT FONT "MS Sans Serif", 8
    DIALOG REDRAW g_hDlg

    DIALOG END g_hDlg, 1

    IF ok = 1 THEN
        PRINT "PASS"
        FUNCTION = 0
    ELSE
        PRINT "FAIL"
        FUNCTION = 1
    END IF
END FUNCTION
