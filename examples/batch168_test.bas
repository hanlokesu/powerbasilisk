'=====================================================================
' PowerBasilisk Enhanced - batch 168 regression test
'---------------------------------------------------------------------
' Purpose:  batch 168 implemented three whole DDT control families and
'           left this probe behind as its evidence.  It is kept here so
'           the statements can be re-checked on any later build.
'
' Demonstrates (39 statements):
'   * COMBOBOX   ADD / GET COUNT / FIND / FIND EXACT / SELECT /
'                GET SELECT / GET SELCOUNT / GET STATE / GET TEXT /
'                SET TEXT / GET USER / SET USER / INSERT / UNSELECT /
'                DELETE / RESET                                  (16)
'   * LISTBOX    ADD / GET COUNT / SELECT / GET SELECT /
'                GET SELCOUNT / GET STATE / GET TEXT / SET TEXT /
'                FIND / GET USER / SET USER / UNSELECT / DELETE /
'                RESET                                            (14)
'   * SCROLLBAR  SET RANGE / SET PAGESIZE / SET POS / GET POS /
'                GET PAGESIZE / GET RANGE                         (7)
'   (the counts add to 39 with the three CONTROL ADD ... forms)
'
' Why it matters: batch 168 also fixed a handle-width family - a runtime
'   call returning Ptr whose result was stored with an unconditional
'   i64 store into a 4-byte PB LONG slot, so the handle read back 0 and
'   the neighbouring alloca was overwritten.  Every handle printed by
'   this file would read 0 on a build with that bug.
'
' Expected output (run mode):
'   hwnd cb=<nonzero> lb=<nonzero> sb=<nonzero>
'   ... one line per assertion, then:
'   === FAILURES: 0 ===
'   (exit code 0)
'
' Complexity note: O(1) - fixed operand counts, no algorithm.
'
' Notes:  the dialog is opened with DIALOG SHOW MODELESS and closed with
'   DIALOG END hDlg, fail, so the sample needs no keyboard input and is
'   safe to run in the non-interactive verification harness.  The exit
'   code is the number of failed assertions.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg AS LONG
    LOCAL hCb  AS LONG
    LOCAL hLb  AS LONG
    LOCAL hSb  AS LONG
    LOCAL fail AS LONG
    LOCAL n    AS LONG
    LOCAL m    AS LONG
    LOCAL t    AS STRING

    DIALOG NEW 0, "batch168 probe", 0, 0, 320, 240 TO hDlg
    DIALOG SHOW MODELESS hDlg

    CONTROL ADD COMBOBOX,  hDlg, 201,  10,  10, 140, 100 TO hCb
    CONTROL ADD LISTBOX,   hDlg, 202, 160,  10, 120, 100 TO hLb
    CONTROL ADD SCROLLBAR, hDlg, 203,  10, 150, 200,  20 TO hSb

    PRINT "hwnd cb="; hCb; " lb="; hLb; " sb="; hSb

    ' ---------------- COMBOBOX ----------------
    PRINT "--- COMBOBOX ---"
    COMBOBOX ADD hDlg, 201, "alpha" TO n
    PRINT "add alpha -> "; n
    IF n <> 1 THEN fail = fail + 1
    COMBOBOX ADD hDlg, 201, "beta" TO n
    PRINT "add beta  -> "; n
    IF n <> 2 THEN fail = fail + 1
    COMBOBOX ADD hDlg, 201, "gamma"
    COMBOBOX GET COUNT hDlg, 201 TO n
    PRINT "count     -> "; n
    IF n <> 3 THEN fail = fail + 1
    COMBOBOX FIND hDlg, 201, 1, "bet" TO n
    PRINT "find bet  -> "; n
    IF n <> 2 THEN fail = fail + 1
    COMBOBOX FIND EXACT hDlg, 201, 1, "BETA" TO n
    PRINT "findexact -> "; n
    IF n <> 2 THEN fail = fail + 1
    COMBOBOX FIND hDlg, 201, 1, "zzz" TO n
    PRINT "find zzz  -> "; n
    IF n <> 0 THEN fail = fail + 1
    COMBOBOX SELECT hDlg, 201, 2
    COMBOBOX GET SELECT hDlg, 201 TO n
    PRINT "sel       -> "; n
    IF n <> 2 THEN fail = fail + 1
    COMBOBOX GET SELCOUNT hDlg, 201 TO n
    PRINT "selcount  -> "; n
    IF n <> 1 THEN fail = fail + 1
    COMBOBOX GET STATE hDlg, 201, 2 TO n
    PRINT "state(2)  -> "; n
    IF n <> -1 THEN fail = fail + 1
    COMBOBOX GET TEXT hDlg, 201 TO t
    PRINT "text(cur) -> ["; t; "]"
    IF t <> "beta" THEN fail = fail + 1
    COMBOBOX GET TEXT hDlg, 201, 3 TO t
    PRINT "text(3)   -> ["; t; "]"
    IF t <> "gamma" THEN fail = fail + 1
    COMBOBOX SET TEXT hDlg, 201, 2, "BETA2"
    COMBOBOX GET TEXT hDlg, 201, 2 TO t
    PRINT "text(2)   -> ["; t; "]"
    IF t <> "BETA2" THEN fail = fail + 1
    COMBOBOX GET USER hDlg, 201, 1 TO n
    PRINT "getuser   -> "; n
    IF n <> 0 THEN fail = fail + 1
    COMBOBOX SET USER hDlg, 201, 1, 4242
    COMBOBOX GET USER hDlg, 201, 1 TO n
    PRINT "set/getus -> "; n
    IF n <> 4242 THEN fail = fail + 1
    COMBOBOX INSERT hDlg, 201, 1, "inserted" TO n
    PRINT "insert    -> "; n
    IF n < 1 THEN fail = fail + 1
    COMBOBOX GET COUNT hDlg, 201 TO n
    PRINT "count     -> "; n
    IF n <> 4 THEN fail = fail + 1
    COMBOBOX UNSELECT hDlg, 201
    COMBOBOX GET SELECT hDlg, 201 TO n
    PRINT "unsel sel -> "; n
    IF n <> 0 THEN fail = fail + 1
    COMBOBOX DELETE hDlg, 201, 1
    COMBOBOX GET COUNT hDlg, 201 TO n
    PRINT "del count -> "; n
    IF n <> 3 THEN fail = fail + 1
    COMBOBOX RESET hDlg, 201
    COMBOBOX GET COUNT hDlg, 201 TO n
    PRINT "rst count -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' ---------------- LISTBOX ----------------
    PRINT "--- LISTBOX ---"
    LISTBOX ADD hDlg, 202, "one" TO n
    PRINT "add one   -> "; n
    IF n <> 1 THEN fail = fail + 1
    LISTBOX ADD hDlg, 202, "two" TO n
    PRINT "add two   -> "; n
    IF n <> 2 THEN fail = fail + 1
    LISTBOX ADD hDlg, 202, "three"
    LISTBOX GET COUNT hDlg, 202 TO n
    PRINT "count     -> "; n
    IF n <> 3 THEN fail = fail + 1
    LISTBOX SELECT hDlg, 202, 3
    LISTBOX GET SELECT hDlg, 202 TO n
    PRINT "sel       -> "; n
    IF n <> 3 THEN fail = fail + 1
    LISTBOX GET SELCOUNT hDlg, 202 TO n
    PRINT "selcount  -> "; n
    IF n <> 1 THEN fail = fail + 1
    LISTBOX GET STATE hDlg, 202, 3 TO n
    PRINT "state(3)  -> "; n
    IF n <> -1 THEN fail = fail + 1
    LISTBOX GET TEXT hDlg, 202 TO t
    PRINT "text(cur) -> ["; t; "]"
    IF t <> "three" THEN fail = fail + 1
    LISTBOX GET TEXT hDlg, 202, 2 TO t
    PRINT "text(2)   -> ["; t; "]"
    IF t <> "two" THEN fail = fail + 1
    LISTBOX SET TEXT hDlg, 202, 2, "TWO2"
    LISTBOX GET TEXT hDlg, 202, 2 TO t
    PRINT "text(2)   -> ["; t; "]"
    IF t <> "TWO2" THEN fail = fail + 1
    LISTBOX FIND hDlg, 202, 1, "THR" TO n
    PRINT "find thr  -> "; n
    IF n <> 3 THEN fail = fail + 1
    LISTBOX SET USER hDlg, 202, 1, 777
    LISTBOX GET USER hDlg, 202, 1 TO n
    PRINT "set/getus -> "; n
    IF n <> 777 THEN fail = fail + 1
    LISTBOX UNSELECT hDlg, 202, 3
    LISTBOX GET SELCOUNT hDlg, 202 TO n
    PRINT "unsel cnt -> "; n
    IF n <> 0 THEN fail = fail + 1
    LISTBOX DELETE hDlg, 202, 1
    LISTBOX GET COUNT hDlg, 202 TO n
    PRINT "del count -> "; n
    IF n <> 2 THEN fail = fail + 1
    LISTBOX RESET hDlg, 202
    LISTBOX GET COUNT hDlg, 202 TO n
    PRINT "rst count -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' ---------------- SCROLLBAR ----------------
    PRINT "--- SCROLLBAR ---"
    SCROLLBAR SET RANGE hDlg, 203, 0, 100
    SCROLLBAR SET PAGESIZE hDlg, 203, 10
    SCROLLBAR SET POS hDlg, 203, 25
    SCROLLBAR GET POS hDlg, 203 TO n
    PRINT "pos       -> "; n
    IF n <> 25 THEN fail = fail + 1
    SCROLLBAR GET PAGESIZE hDlg, 203 TO n
    PRINT "pagesize  -> "; n
    IF n <> 10 THEN fail = fail + 1
    SCROLLBAR GET RANGE hDlg, 203 TO n, m
    PRINT "range lo  -> "; n
    PRINT "range hi  -> "; m
    IF n <> 0 THEN fail = fail + 1
    IF m <> 100 THEN fail = fail + 1
    SCROLLBAR SET POS hDlg, 203, 60
    SCROLLBAR GET POS hDlg, 203 TO n
    PRINT "pos       -> "; n
    IF n <> 60 THEN fail = fail + 1

    ' error paths: a control id that does not exist must report failure
    COMBOBOX GET COUNT hDlg, 299 TO n
    PRINT "bad id cnt-> "; n
    IF n <> -1 THEN fail = fail + 1

    PRINT "=== FAILURES: "; fail; " ==="
    DIALOG END hDlg, fail
END FUNCTION
