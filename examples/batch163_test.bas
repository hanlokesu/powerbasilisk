' =====================================================================
' batch163_test.bas - DIALOG GET SIZE / DIALOG SET SIZE
' ---------------------------------------------------------------------
' Purpose:  exercise the two statements added in batch 163 and assert the
'           dialog-unit round trip that the official help describes.
' Tests:    * DIALOG GET SIZE immediately after DIALOG NEW reports the very
'             size DIALOG NEW was given.  The official help
'             (dialog_get_size.htm) says the values are in dialog units
'             unless the dialog was created with the PIXELS option; DIALOG
'             PIXELS is still unimplemented, so every dialog is a
'             dialog-unit dialog and the numbers must match exactly.
'           * DIALOG SET SIZE resizes the window, and a second
'             DIALOG GET SIZE reports exactly the new size.
' Expected output (run mode):
'   after DIALOG NEW   = 320 x 200
'   after DIALOG SET   = 500 x 360
'   PASS
' Exit code: 0 = both checks passed, 1 = a check failed.
' Notes:    DIALOG NEW shows the window right away (pb_window_new calls
'           ShowWindow), so a small window flashes while this runs.  The
'           program never enters a message loop, so it exits by itself and
'           needs no interaction.
' =====================================================================
#COMPILE EXE

GLOBAL g_hDlg AS QUAD

FUNCTION PBMAIN () AS LONG
    LOCAL w1 AS LONG
    LOCAL h1 AS LONG
    LOCAL w2 AS LONG
    LOCAL h2 AS LONG
    LOCAL ok AS LONG

    ok = 1

    DIALOG NEW 0, "Batch 163: DIALOG GET SIZE / SET SIZE", 100, 100, 320, 200 TO g_hDlg

    ' ---- GET SIZE on the freshly created dialog ---------------------
    w1 = 0 : h1 = 0
    DIALOG GET SIZE g_hDlg TO w1, h1
    PRINT "after DIALOG NEW   ="; w1; "x"; h1
    IF w1 <> 320 THEN ok = 0
    IF h1 <> 200 THEN ok = 0

    ' ---- SET SIZE, then read the new size back ----------------------
    DIALOG SET SIZE g_hDlg, 500, 360
    w2 = 0 : h2 = 0
    DIALOG GET SIZE g_hDlg TO w2, h2
    PRINT "after DIALOG SET   ="; w2; "x"; h2
    IF w2 <> 500 THEN ok = 0
    IF h2 <> 360 THEN ok = 0

    DIALOG END g_hDlg, 1

    IF ok = 1 THEN
        PRINT "PASS"
        FUNCTION = 0
    ELSE
        PRINT "FAIL"
        FUNCTION = 1
    END IF
END FUNCTION
