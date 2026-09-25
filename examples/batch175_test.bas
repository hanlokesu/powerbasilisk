'=====================================================================
' batch175_test.bas - the CONTROL geometry family (six statements)
'---------------------------------------------------------------------
' Purpose
'   Exercise the six DDT statements added in batch 175 and pin their
'   promises down with exact comparisons:
'
'       CONTROL GET CLIENT hDlg, id& TO nWide&, nHigh&   (client area)
'       CONTROL SET CLIENT hDlg, id&, nWide&, nHigh&
'       CONTROL GET LOC    hDlg, id& TO x&, y&           (parent client)
'       CONTROL SET LOC    hDlg, id&, x&, y&
'       CONTROL GET SIZE   hDlg, id& TO nWide&, nHigh&   (overall)
'       CONTROL SET SIZE   hDlg, id&, nWide&, nHigh&
'
'   All six address the control by (owner dialog, control id) - the handle
'   comes from GetDlgItem, exactly as PROGRESSBAR / HEADER do - and all six
'   speak the same dialog units as CONTROL ADD, so the numbers written here
'   are the numbers read back.
'
'   What the assertions prove:
'
'     * round trip       - GET reports the coordinates ADD used: a button
'                          added at "12, 12" reads back 12, 12 and a 60x24
'                          button reads back 60x24.  SET then moved it and
'                          the new values read back too.
'     * size vs client    - a borderless push button reports the same
'                          numbers for both, and SET CLIENT of 68x16 leaves
'                          GET CLIENT at 68x16 rather than a few pixels
'                          smaller (AdjustWindowRectEx did the allowance).
'     * the shared units  - batch 175 originally converted these through
'                          GetDialogBaseUnits() (8x16 on the test machine)
'                          while CONTROL ADD lays controls out through
'                          pb_dlu_to_px() (7x14).  The button added at 10,10
'                          read back 8,8 and a 60x20 button read back 52x17.
'                          Both sides now share PB_CTL_DLU_X / PB_CTL_DLU_Y,
'                          which is why exact equality is the assertion here.
'     * child coordinates - SET LOC used to add the parent's client origin
'                          before calling SetWindowPos, but SetWindowPos
'                          already interprets a CHILD's x/y as offsets from
'                          the parent's client area, so the origin landed
'                          twice: "SET LOC 20,30" arrived at 64,75.
'     * a missing id      - must be harmless (0x0, no crash).
'     * DIALOG SET SIZE   - must resize without moving: the dialog is
'                          created at 40,30 and must still be there.
'
'   Divisibility, inherited from the dialog-unit conversion: a width in
'   units is exact when it is a multiple of 4 and a height when it is a
'   multiple of 8 - one vertical unit is 1.75 px, so e.g. 30 units cannot
'   land on a whole pixel.  Every number below was chosen to be exact.
'
' Demonstrates
'   * CONTROL ADD BUTTON, hDlg, id, caption, x, y, w, h TO hBtn
'   * CONTROL GET LOC / SET LOC / GET SIZE / SET SIZE / GET CLIENT / SET CLIENT
'   * DIALOG SET SIZE / DIALOG SET LOC / DIALOG GET SIZE / DIALOG GET LOC
'
' Expected output (run mode)
'   one line per assertion, then
'   === FAILURES: 0 ===
'   (exit code 0)
'
' Notes
'   * This sample opens a MODELESS dialog briefly.  It runs no message loop
'     and waits for no key, so the verification harness can run it
'     unattended; DIALOG SHOW MODELESS is what makes the measurements
'     meaningful (a hidden window is not laid out yet).
'   * Sample files are text; keep this one headless.
' Complexity note: O(1) - a fixed sequence of control and dialog calls.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg AS LONG
    LOCAL hBtn AS QUAD
    LOCAL v1   AS LONG
    LOCAL v2   AS LONG
    LOCAL fail AS LONG

    DIALOG NEW 0, "batch175 CONTROL geometry", 40, 30, 400, 200 TO hDlg
    DIALOG SHOW MODELESS hDlg

    CONTROL ADD BUTTON, hDlg, 101, "OK", 12, 12, 60, 24 TO hBtn
    IF hBtn = 0 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL ADD BUTTON returned no handle"
    END IF

    ' ---------------------------------------------------------------
    ' The coordinates written in CONTROL ADD are the ones GET reports.
    ' ---------------------------------------------------------------
    v1 = -1 : v2 = -1
    CONTROL GET LOC hDlg, 101 TO v1, v2
    IF v1 <> 12 OR v2 <> 12 THEN
        fail = fail + 1
        PRINT "FAIL get loc after add 12,12   ="; v1; ","; v2
    ELSE
        PRINT "ok   get loc after add 12,12   = 12,12"
    END IF

    v1 = -1 : v2 = -1
    CONTROL GET SIZE hDlg, 101 TO v1, v2
    IF v1 <> 60 OR v2 <> 24 THEN
        fail = fail + 1
        PRINT "FAIL get size after add 60x24  ="; v1; "x"; v2
    ELSE
        PRINT "ok   get size after add 60x24  = 60x24"
    END IF

    v1 = -1 : v2 = -1
    CONTROL GET CLIENT hDlg, 101 TO v1, v2
    IF v1 <> 60 OR v2 <> 24 THEN
        fail = fail + 1
        PRINT "FAIL client of a borderless button ="; v1; "x"; v2; " (want 60x24)"
    ELSE
        PRINT "ok   client of a borderless button = 60x24 (same as size)"
    END IF

    ' ---------------------------------------------------------------
    ' SET LOC / SET SIZE, then read back.
    ' ---------------------------------------------------------------
    CONTROL SET LOC hDlg, 101, 20, 32
    v1 = -1 : v2 = -1
    CONTROL GET LOC hDlg, 101 TO v1, v2
    IF v1 <> 20 OR v2 <> 32 THEN
        fail = fail + 1
        PRINT "FAIL get loc after set 20,32   ="; v1; ","; v2
    ELSE
        PRINT "ok   set loc 20,32 -> get loc  = 20,32"
    END IF

    CONTROL SET SIZE hDlg, 101, 80, 24
    v1 = -1 : v2 = -1
    CONTROL GET SIZE hDlg, 101 TO v1, v2
    IF v1 <> 80 OR v2 <> 24 THEN
        fail = fail + 1
        PRINT "FAIL get size after set 80x24  ="; v1; "x"; v2
    ELSE
        PRINT "ok   set size 80x24 -> get size = 80x24"
    END IF

    ' ---------------------------------------------------------------
    ' SET CLIENT sets the CLIENT area; GET CLIENT must confirm it.
    ' ---------------------------------------------------------------
    CONTROL SET CLIENT hDlg, 101, 68, 16
    v1 = -1 : v2 = -1
    CONTROL GET CLIENT hDlg, 101 TO v1, v2
    IF v1 <> 68 OR v2 <> 16 THEN
        fail = fail + 1
        PRINT "FAIL get client after set 68x16 ="; v1; "x"; v2
    ELSE
        PRINT "ok   set client 68x16 -> get   = 68x16"
    END IF

    ' ---------------------------------------------------------------
    ' DIALOG SET SIZE resizes only: the dialog may not jump to 0,0.
    ' (The batch 174 runtime passed SWP_SHOWWINDOW and no SWP_NOMOVE,
    ' so the very same program used to print "0,0" here.)
    ' ---------------------------------------------------------------
    DIALOG SET SIZE hDlg, 300, 150
    v1 = -1 : v2 = -1
    DIALOG GET SIZE hDlg TO v1, v2
    IF v1 <> 300 OR v2 <> 150 THEN
        fail = fail + 1
        PRINT "FAIL get size after DIALOG SET SIZE ="; v1; "x"; v2
    ELSE
        PRINT "ok   dialog set size 300x150 -> 300x150"
    END IF
    v1 = -1 : v2 = -1
    DIALOG GET LOC hDlg TO v1, v2
    IF v1 <> 40 OR v2 <> 30 THEN
        fail = fail + 1
        PRINT "FAIL dialog moved on DIALOG SET SIZE ="; v1; ","; v2
    ELSE
        PRINT "ok   dialog kept its position (40,30) through DIALOG SET SIZE"
    END IF

    DIALOG SET LOC hDlg, 60, 50
    v1 = -1 : v2 = -1
    DIALOG GET LOC hDlg TO v1, v2
    IF v1 <> 60 OR v2 <> 50 THEN
        fail = fail + 1
        PRINT "FAIL dialog set loc 60,50 -> ="; v1; ","; v2
    ELSE
        PRINT "ok   dialog set loc 60,50 -> 60,50"
    END IF

    ' ---------------------------------------------------------------
    ' An id that was never created must be harmless everywhere.
    ' ---------------------------------------------------------------
    v1 = -1 : v2 = -1
    CONTROL GET LOC  hDlg, 9999 TO v1, v2
    CONTROL GET SIZE hDlg, 9999 TO v1, v2
    CONTROL SET LOC  hDlg, 9999, 5, 5
    CONTROL SET SIZE hDlg, 9999, 10, 10
    CONTROL SET CLIENT hDlg, 9999, 10, 10
    IF v1 <> 0 OR v2 <> 0 THEN
        fail = fail + 1
        PRINT "FAIL missing control id reported ="; v1; "x"; v2
    ELSE
        PRINT "ok   missing control id is harmless"
    END IF

    PRINT "=== FAILURES:"; fail; " ==="
    DIALOG END hDlg, fail
    FUNCTION = fail
END FUNCTION
