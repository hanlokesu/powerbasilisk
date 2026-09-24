'=====================================================================
' PowerBasilisk Enhanced - batch 166 regression test
'---------------------------------------------------------------------
' Purpose:  Two things this batch fixed or added, in one runnable file.
'
' Demonstrates:
'   * CONTROL ADD classname$ - the DDT custom-control statement, in all
'     three operand forms the official page documents.
'   * DIALOG NEW ... TO <LOCAL LONG> delivering a real handle.
'
' Why the second half matters: before batch 166 every DIALOG/CONTROL
' creation arm stored the 64-bit handle with an unconditional i64 store,
' even when the target variable was a 4-byte LOCAL LONG.  The store ran
' past the end of the alloca and the handle read back as 0, so any
' program that declared its dialog handle LOCAL got a null dialog while
' the compiler reported success.  The arms now convert the handle to the
' destination's declared type first, exactly as DIALOG GET SIZE already
' did.  Nine arms were affected.
'
' Expected output (run mode):
'   dialog hwnd   = <nonzero>
'   trackbar hwnd = <nonzero>
'   progress hwnd = <nonzero>
'   statusbar hwnd= <nonzero>
'   PASS
'   (exit code 0)
'
' Complexity note: O(1) - one dialog and three controls, no algorithm.
'
' Notes:  the dialog is opened with DIALOG SHOW MODELESS and closed with
'   DIALOG END, so the sample needs no keyboard input and is safe to run
'   in the non-interactive verification harness.
'   The class names are the documented comctl32 ones - "msctls_trackbar32",
'   "msctls_progress32", "msctls_statusbar32".  Note there is no "CLASS"
'   in these names; "MSCTLS_TRACKBAR_CLASS32" is not a real window class.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg    AS LONG      ' deliberately LOCAL - the batch 166 fix
    LOCAL hTrack  AS LONG
    LOCAL hProg   AS LONG
    LOCAL hStatus AS LONG
    LOCAL cls     AS STRING
    LOCAL res     AS LONG

    ' ---- the LOCAL dialog handle must survive DIALOG NEW ---------------
    DIALOG NEW 0, "Batch 166: custom control + local dialog handle", 100, 100, 320, 190 TO hDlg
    IF hDlg = 0 THEN
        PRINT "FAIL: DIALOG NEW gave a LOCAL handle the value 0"
        FUNCTION = 1
        EXIT FUNCTION
    END IF
    PRINT "dialog hwnd   ="; hDlg
    DIALOG SHOW MODELESS hDlg

    ' ---- 1a. literal class name, no style operands ---------------------
    ' With no style given, the runtime supplies WS_CHILD + WS_VISIBLE so
    ' the control is actually visible; the official custom-control page
    ' warns that DDT applies no default style of its own.
    CONTROL ADD "msctls_trackbar32", hDlg, 101, "", 10, 10, 120, 24 TO hTrack

    ' ---- 1b. explicit primary style + extended style -------------------
    ' &H50000000 is WS_CHILD + WS_VISIBLE written out by hand.
    CONTROL ADD "msctls_progress32", hDlg, 102, "", 10, 46, 120, 24, &H50000000, 0 TO hProg

    ' ---- 1c. the class name held in a STRING variable ------------------
    cls = "msctls_statusbar32"
    CONTROL ADD cls, hDlg, 103, "", 10, 82, 290, 24 TO hStatus

    IF hTrack = 0 OR hProg = 0 OR hStatus = 0 THEN
        PRINT "FAIL: a custom control came back NULL"
        PRINT "  trackbar ="; hTrack; " progress ="; hProg; " statusbar ="; hStatus
        DIALOG END hDlg, res
        FUNCTION = 1
        EXIT FUNCTION
    END IF

    PRINT "trackbar hwnd ="; hTrack
    PRINT "progress hwnd ="; hProg
    PRINT "statusbar hwnd="; hStatus

    DIALOG END hDlg, res
    PRINT "PASS"
    FUNCTION = 0
END FUNCTION
