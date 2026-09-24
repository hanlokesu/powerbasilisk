'=====================================================================
' PowerBasilisk Enhanced - batch 169 regression test
'---------------------------------------------------------------------
' Purpose:  batch 169 implemented the TAB control family and left this
'           probe behind as its evidence.  It is kept here so the
'           statements can be re-checked on any later build.
'
' Demonstrates (14 statements):
'   * CONTROL ADD TAB
'   * TAB INSERT PAGE / GET COUNT / GET SELECT / GET TEXT / SET TEXT /
'     GET DIALOG / GET PAGE / SELECT / GET IMAGE / SET IMAGE /
'     SET IMAGELIST / DELETE / RESET
'
' Why it matters: batch 169 added pb_lookup_callback_hwnd() and the
'   WM_NOTIFY branch, fixing a pre-existing defect where the callback
'   registry was written but never read - a registered control callback
'   could never fire.  It also pinned the family to 1-based indices,
'   which is what the official pages specify.
'
' Expected output (run mode):
'   hwnd tab=<nonzero>
'   ... one line per assertion, then:
'   === FAILURES: 0 ===
'   (exit code 0)
'
' Complexity note: O(1) - fixed operand counts, no algorithm.
'
' Notes:  TAB GET PAGE takes a PAGE DIALOG handle, not the tab handle -
'   that asymmetry is the official one, and the last assertion checks
'   that an unrelated handle reports page 0 rather than a page number.
'   The dialog is opened with DIALOG SHOW MODELESS and closed with
'   DIALOG END hDlg, fail, so the sample needs no keyboard input and is
'   safe to run in the non-interactive verification harness.  The exit
'   code is the number of failed assertions.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg  AS LONG
    LOCAL hTab  AS LONG
    LOCAL fail  AS LONG
    LOCAL n     AS LONG
    LOCAL m     AS LONG
    LOCAL t     AS STRING
    LOCAL d1    AS LONG
    LOCAL d2    AS LONG
    LOCAL d3    AS LONG
    LOCAL back  AS LONG

    DIALOG NEW 0, "batch169 TAB probe", 0, 0, 360, 260 TO hDlg
    DIALOG SHOW MODELESS hDlg

    CONTROL ADD TAB, hDlg, 301, 10, 10, 330, 200 TO hTab
    PRINT "hwnd tab="; hTab
    IF hTab = 0 THEN fail = fail + 1

    ' ---------------- TAB INSERT PAGE ----------------
    PRINT "--- TAB INSERT PAGE ---"
    TAB INSERT PAGE hDlg, 301, 1, 0, "first"  TO d1
    PRINT "insert 1 -> "; d1
    IF d1 = 0 THEN fail = fail + 1
    TAB INSERT PAGE hDlg, 301, 2, 0, "second" TO d2
    PRINT "insert 2 -> "; d2
    IF d2 = 0 THEN fail = fail + 1
    TAB INSERT PAGE hDlg, 301, 3, 0, "third"  TO d3
    PRINT "insert 3 -> "; d3
    IF d3 = 0 THEN fail = fail + 1
    IF d1 = d2 THEN fail = fail + 1
    IF d2 = d3 THEN fail = fail + 1

    TAB GET COUNT hDlg, 301 TO n
    PRINT "count    -> "; n
    IF n <> 3 THEN fail = fail + 1

    ' the first page ever inserted becomes current
    TAB GET SELECT hDlg, 301 TO n
    PRINT "select   -> "; n
    IF n <> 1 THEN fail = fail + 1

    ' ---------------- TAB GET/SET TEXT ----------------
    PRINT "--- TAB GET/SET TEXT ---"
    TAB GET TEXT hDlg, 301, 1 TO t
    PRINT "text(1)  -> ["; t; "]"
    IF t <> "first" THEN fail = fail + 1
    TAB GET TEXT hDlg, 301, 3 TO t
    PRINT "text(3)  -> ["; t; "]"
    IF t <> "third" THEN fail = fail + 1

    TAB SET TEXT hDlg, 301, 2, "SECOND"
    TAB GET TEXT hDlg, 301, 2 TO t
    PRINT "text(2)  -> ["; t; "]"
    IF t <> "SECOND" THEN fail = fail + 1

    ' ---------------- TAB GET DIALOG / TAB GET PAGE ----------------
    PRINT "--- TAB GET DIALOG / GET PAGE ---"
    TAB GET DIALOG hDlg, 301, 1 TO n
    PRINT "dlg(1)   -> "; n
    IF n <> d1 THEN fail = fail + 1
    TAB GET DIALOG hDlg, 301, 2 TO n
    PRINT "dlg(2)   -> "; n
    IF n <> d2 THEN fail = fail + 1
    TAB GET DIALOG hDlg, 301, 9 TO n
    PRINT "dlg(9)   -> "; n
    IF n <> 0 THEN fail = fail + 1

    TAB GET PAGE d1 TO back
    PRINT "page(d1) -> "; back
    IF back <> 1 THEN fail = fail + 1
    TAB GET PAGE d3 TO back
    PRINT "page(d3) -> "; back
    IF back <> 3 THEN fail = fail + 1
    TAB GET PAGE hDlg TO back
    PRINT "page(hD) -> "; back
    IF back <> 0 THEN fail = fail + 1

    ' ---------------- TAB SELECT ----------------
    PRINT "--- TAB SELECT ---"
    TAB SELECT hDlg, 301, 2
    TAB GET SELECT hDlg, 301 TO n
    PRINT "sel(2)   -> "; n
    IF n <> 2 THEN fail = fail + 1

    ' ---------------- TAB GET/SET IMAGE ----------------
    PRINT "--- TAB GET/SET IMAGE ---"
    TAB GET IMAGE hDlg, 301, 1 TO n
    PRINT "image(1) -> "; n
    IF n <> 0 THEN fail = fail + 1
    TAB SET IMAGE hDlg, 301, 2, 3
    TAB GET IMAGE hDlg, 301, 2 TO n
    PRINT "image(2) -> "; n
    IF n <> 3 THEN fail = fail + 1

    ' ---------------- TAB SET IMAGELIST ----------------
    ' no IMAGELIST control exists in this fork yet, so the handle is 0: the
    ' statement must accept it and report success.
    TAB SET IMAGELIST hDlg, 301, 0

    ' ---------------- TAB DELETE ----------------
    PRINT "--- TAB DELETE ---"
    TAB DELETE hDlg, 301, 1
    TAB GET COUNT hDlg, 301 TO n
    PRINT "count    -> "; n
    IF n <> 2 THEN fail = fail + 1
    ' pages after the deleted one shift down by one
    TAB GET TEXT hDlg, 301, 1 TO t
    PRINT "text(1)  -> ["; t; "]"
    IF t <> "SECOND" THEN fail = fail + 1
    TAB GET DIALOG hDlg, 301, 1 TO n
    PRINT "dlg(1)   -> "; n
    IF n <> d2 THEN fail = fail + 1

    ' ---------------- TAB RESET ----------------
    PRINT "--- TAB RESET ---"
    TAB RESET hDlg, 301
    TAB GET COUNT hDlg, 301 TO n
    PRINT "count    -> "; n
    IF n <> 0 THEN fail = fail + 1
    TAB GET SELECT hDlg, 301 TO n
    PRINT "select   -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' error path: a control id that does not exist must report failure
    TAB GET COUNT hDlg, 399 TO n
    PRINT "bad id cnt-> "; n
    IF n <> -1 THEN fail = fail + 1

    PRINT "=== FAILURES: "; fail; " ==="
    DIALOG END hDlg, fail
END FUNCTION
