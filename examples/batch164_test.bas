' =====================================================================
' batch164_test.bas - TOOLBAR and STATUSBAR (batch 164)
' ---------------------------------------------------------------------
' Purpose:  exercise every statement form added in batch 164 and assert
'           real behaviour, not just "it compiled".
' Tests:
'   * CONTROL ADD TOOLBAR / CONTROL ADD STATUSBAR both hand back a real
'     window handle (0 would mean the control was never created).
'   * TOOLBAR ADD BUTTON x3 + TOOLBAR ADD SEPARATOR x1 -> GET COUNT = 4.
'     The official help counts separators as items, so 4 is the documented
'     answer, not 3.
'   * TOOLBAR GET STATE on a fresh button reports %TBSTATE_ENABLED (4).
'   * TOOLBAR SET STATE with BYCMD 202 (a command id, not a position)
'     disables that button, and reading it back reports 0.
'   * TOOLBAR DELETE BUTTON by 1-based position removes one item ->
'     GET COUNT = 3.
'   * STATUSBAR SET PARTS / STATUSBAR SET TEXT run without crashing.
'     Neither statement has a documented TO target, so their return
'     values cannot be captured from PB source; they are exercised for
'     the code path, and the toolbar checks carry the assertions.
' Expected output (run mode):
'   toolbar handle  = 1 (non-zero)
'   statusbar handle= 1 (non-zero)
'   count after adds= 4
'   state item 1    = 4
'   state cmd 202   = 0 (after disable)
'   count after del = 3
'   PASS
' Exit code: 0 = every check passed, 1 = at least one check failed.
' Notes:    The x/y/width/height operands of CONTROL ADD TOOLBAR and
'           CONTROL ADD STATUSBAR are parsed but ignored, exactly as the
'           official help states - both controls dock themselves inside
'           the parent according to their %CCS_* style bits.  The window
'           is shown by DIALOG NEW and never enters a message loop, so
'           this sample finishes on its own with no interaction.
' =====================================================================
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL g_hTb  AS QUAD
GLOBAL g_hSb  AS QUAD

FUNCTION PBMAIN () AS LONG
    LOCAL n   AS LONG
    LOCAL st  AS LONG
    LOCAL ok  AS LONG

    ok = 1

    DIALOG NEW 0, "Batch 164: TOOLBAR + STATUSBAR", 100, 100, 400, 240 TO g_hDlg

    ' ---- create the two common controls -----------------------------
    CONTROL ADD TOOLBAR,   g_hDlg, 100, "", 0, 0, 0, 0 TO g_hTb
    CONTROL ADD STATUSBAR, g_hDlg, 101, "", 0, 0, 0, 0 TO g_hSb

    IF g_hTb <> 0 THEN
        PRINT "toolbar handle  = 1 (non-zero)"
    ELSE
        PRINT "toolbar handle  = 0 (CONTROL ADD TOOLBAR failed)"
        ok = 0
    END IF
    IF g_hSb <> 0 THEN
        PRINT "statusbar handle= 1 (non-zero)"
    ELSE
        PRINT "statusbar handle= 0 (CONTROL ADD STATUSBAR failed)"
        ok = 0
    END IF

    ' ---- fill the toolbar: 3 buttons + 1 separator -------------------
    ' image& = 0 because no image list is attached; style& = 0 is
    ' %BTNS_BUTTON, the plain push-button style.
    TOOLBAR ADD BUTTON g_hDlg, 100, 0, 201, 0, "One"
    TOOLBAR ADD BUTTON g_hDlg, 100, 0, 202, 0, "Two"
    TOOLBAR ADD SEPARATOR g_hDlg, 100, 8
    TOOLBAR ADD BUTTON g_hDlg, 100, 0, 203, 0, "Three"

    n = 0
    TOOLBAR GET COUNT g_hDlg, 100 TO n
    PRINT "count after adds="; n
    IF n <> 4 THEN ok = 0

    ' ---- read the state of the first button --------------------------
    st = 0
    TOOLBAR GET STATE g_hDlg, 100, 1 TO st
    PRINT "state item 1    ="; st
    ' %TBSTATE_ENABLED = &H0004
    IF st <> 4 THEN ok = 0

    ' ---- disable button 202 by COMMAND ID, then read it back ---------
    TOOLBAR SET STATE g_hDlg, 100, BYCMD 202, 0
    st = 99
    TOOLBAR GET STATE g_hDlg, 100, BYCMD 202 TO st
    PRINT "state cmd 202   ="; st; " (after disable)"
    IF st <> 0 THEN ok = 0

    ' ---- delete the first button by 1-based position -----------------
    TOOLBAR DELETE BUTTON g_hDlg, 100, 1
    n = 0
    TOOLBAR GET COUNT g_hDlg, 100 TO n
    PRINT "count after del ="; n
    IF n <> 3 THEN ok = 0

    ' ---- statusbar: three parts, then text in part 1 -----------------
    STATUSBAR SET PARTS g_hDlg, 101, 100, 100, 9999
    STATUSBAR SET TEXT g_hDlg, 101, 1, 0, "Ready"

    DIALOG END g_hDlg, 1

    IF ok = 1 THEN
        PRINT "PASS"
        FUNCTION = 0
    ELSE
        PRINT "FAIL"
        FUNCTION = 1
    END IF
END FUNCTION
