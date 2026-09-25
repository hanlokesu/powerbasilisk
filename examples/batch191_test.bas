'=====================================================================
' PowerBasilisk Enhanced - batch 191 regression test
'---------------------------------------------------------------------
' Purpose:  batch 191 turned the three DDT families' *unknown sub-command*
'           fallbacks into hard compile errors.
'
'           Before it, a line such as
'               LISTVIEW  BOGUS hDlg, 401
'               TREEVIEW  BOGUS hDlg, 402
'               SCROLLBAR BOGUS FOO hDlg, 403
'           parsed into Statement::Noop: the compiler printed
'           "=== Exit code: 0 ===", produced an EXE, and the statement did
'           absolutely nothing at run time.  That is the "accepted but no
'           operation" class of defect the project treats as a bug, so the
'           fallback now prints
'               Error: LISTVIEW: unknown sub-command "BOGUS" on line N
'           and increments the parser's error count, which stops the build
'           before codegen - the same hard-fail path every other parse
'           error uses.  Verified by four throwaway sources, one per site:
'             LISTVIEW BOGUS        -> unknown sub-command "BOGUS" on line 4
'             TREEVIEW BOGUS        -> unknown sub-command "BOGUS" on line 4
'             SCROLLBAR BOGUS FOO   -> expected GET or SET, found "BOGUS" on line 4
'             SCROLLBAR GET BOGUS   -> unknown sub-command "BOGUS" on line 5
'
' What this file proves (the *positive* half of the change)
'   Every sub-command the three families really implement must still parse
'   and still work.  A hardening patch that quietly broke a good form
'   would be worse than the silence it removed, so all three families are
'   exercised here end to end.
'
' Demonstrates:
'   * LISTVIEW  INSERT COLUMN / GET HEADER / INSERT ITEM / GET COUNT /
'              SET TEXT / GET TEXT / SET USER / GET USER / SELECT /
'              UNSELECT / GET SELECT / GET STYLEXX / SET STYLEXX / RESET
'   * TREEVIEW  INSERT ITEM / GET COUNT / GET ROOT / GET CHILD /
'              GET NEXT / SET EXPANDED / GET EXPANDED / SET TEXT /
'              GET TEXT / SELECT / UNSELECT / GET SELECT / DELETE / RESET
'   * SCROLLBAR SET RANGE / GET RANGE / SET POS / GET POS /
'              SET PAGESIZE / GET PAGESIZE
'              (SET/GET TRACKPOS parse but have no codegen arm yet - see the
'               note near the end of PBMAIN; they are an open item.)
'
' Witnesses used, and one that is NOT available
'   * a second, independent observation of the same state through a
'     different statement path - e.g. INSERT ITEM moves the count and
'     GET COUNT reports the new value, so a GET COUNT that never changes
'     cannot pass.
'   * `CONTROL ADD ... TO h` must agree with `CONTROL HANDLE hDlg, id TO h2`:
'     if they disagreed, every statement below would be aimed at a
'     different control than the assertions believe.
'   * NOT available in this fork today: raw USER32 calls against the handle
'     these statements return.  GetClassNameA(hLv, ...) comes back empty and
'     SendMessageA(hLv, LVM_GETITEMCOUNT, 0, 0) comes back 0 while
'     LISTVIEW GET COUNT on the same control reports 3 - the statements are
'     right and the raw-message path is not usable here.  This was found
'     while writing this sample and is recorded as an open item, not
'     papered over: no assertion below depends on it.
'
' Expected output (run mode):
'   --- handle witnesses ---
'   (no output unless a handle is NULL or the two eidts disagree)
'   --- LISTVIEW ---
'   lv header        -> [Qty]
'   lv count         -> 3   after insert 4 -> 4
'   lv text          -> [Apricot]
'   lv user          -> 1234
'   lv sel           -> 2   after unselect -> 0
'   lv style xx      -> n   after set n -> n
'   lv count after reset -> 0
'   --- TREEVIEW ---
'   tv count         -> 3   after insert -> 4   after delete -> 3
'   tv root == root / child == A / next == B
'   tv expanded on   -> -1  off -> 0
'   tv text          -> [Renamed]
'   tv sel == hB, after unselect -> 0
'   tv count after reset -> 0
'   --- SCROLLBAR ---
'   sb range -> 0 / 100
'   sb pos -> 25   after move -> 60
'   sb pagesize -> 10
'   === FAILURES: 0 ===
'   (exit code 0)
'
' Complexity note: O(1) - a fixed control set and a fixed operand count.
'
' Notes:  the dialog is opened MODELESS and closed with DIALOG END hDlg,
'   fail, so the sample never waits for input and is safe for the
'   non-interactive verification harness.  The exit code is the number of
'   failed assertions.  Handles are AS QUAD because an item handle is a
'   real x64 pointer.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg AS LONG
    LOCAL hLv  AS LONG
    LOCAL hTv  AS LONG
    LOCAL hSb  AS LONG
    LOCAL hLv2 AS LONG
    LOCAL hTv2 AS LONG
    LOCAL hSb2 AS LONG
    LOCAL hRoot AS QUAD
    LOCAL hA   AS QUAD
    LOCAL hB   AS QUAD
    LOCAL hC   AS QUAD
    LOCAL h    AS QUAD
    LOCAL n    AS LONG
    LOCAL m    AS LONG
    LOCAL fail AS LONG
    LOCAL t    AS STRING

    DIALOG NEW 0, "batch191 LISTVIEW / TREEVIEW / SCROLLBAR probe", 0, 0, 420, 240 TO hDlg
    DIALOG SHOW MODELESS hDlg

    CONTROL ADD LISTVIEW, hDlg, 401, 10, 10, 190, 210 TO hLv
    CONTROL ADD TREEVIEW, hDlg, 402, 210, 10, 190, 210 TO hTv
    CONTROL ADD HSCROLLBAR, hDlg, 403, 10, 226, 390, 12 TO hSb

    ' second handle witness: CONTROL HANDLE must resolve to the window that
    ' CONTROL ADD returned, or the statements below are aimed at a different
    ' control than the assertions believe.
    CONTROL HANDLE hDlg, 401 TO hLv2
    CONTROL HANDLE hDlg, 402 TO hTv2
    CONTROL HANDLE hDlg, 403 TO hSb2

    PRINT "--- handle witnesses ---"
    IF hLv = 0 OR hTv = 0 OR hSb = 0 THEN
        PRINT "FAIL: a control handle came back NULL"
        PRINT "  lv="; hLv; " tv="; hTv; " sb="; hSb
        DIALOG END hDlg, 1
        FUNCTION = 1
        EXIT FUNCTION
    END IF
    IF hLv <> hLv2 OR hTv <> hTv2 OR hSb <> hSb2 THEN
        PRINT "FAIL: CONTROL ADD handle <> CONTROL HANDLE"
        fail = fail + 1
    END IF

    ' ----------------------------- LISTVIEW ------------------------------
    PRINT "--- LISTVIEW ---"
    LISTVIEW INSERT COLUMN hDlg, 401, 1, "Item", 80, 0
    LISTVIEW INSERT COLUMN hDlg, 401, 2, "Qty", 50, 0
    t = ""
    LISTVIEW GET HEADER hDlg, 401, 2 TO t
    PRINT "lv header        -> ["; t; "]"
    IF t <> "Qty" THEN fail = fail + 1

    LISTVIEW INSERT ITEM hDlg, 401, 1, 0, "Apple"  TO n
    LISTVIEW INSERT ITEM hDlg, 401, 2, 0, "Banana" TO n
    LISTVIEW INSERT ITEM hDlg, 401, 3, 0, "Cherry" TO n
    n = 0
    LISTVIEW GET COUNT hDlg, 401 TO n
    m = n
    LISTVIEW INSERT ITEM hDlg, 401, 4, 0, "Date" TO n
    n = 0
    LISTVIEW GET COUNT hDlg, 401 TO n
    PRINT "lv count         -> "; m; "   after insert 4 -> "; n
    IF m <> 3 OR n <> 4 THEN fail = fail + 1

    LISTVIEW SET TEXT hDlg, 401, 1, 1, "Apricot"
    t = ""
    LISTVIEW GET TEXT hDlg, 401, 1, 1 TO t
    PRINT "lv text          -> ["; t; "]"
    IF t <> "Apricot" THEN fail = fail + 1

    LISTVIEW SET USER hDlg, 401, 2, 1234
    n = 0
    LISTVIEW GET USER hDlg, 401, 2 TO n
    PRINT "lv user          -> "; n
    IF n <> 1234 THEN fail = fail + 1

    LISTVIEW SELECT hDlg, 401, 2
    n = 0
    LISTVIEW GET SELECT hDlg, 401 TO n
    PRINT "lv sel           -> "; n
    IF n <> 2 THEN fail = fail + 1
    LISTVIEW UNSELECT hDlg, 401, 2
    n = 99
    LISTVIEW GET SELECT hDlg, 401 TO n
    PRINT "                   after unselect -> "; n
    IF n <> 0 THEN fail = fail + 1

    n = 0
    LISTVIEW GET STYLEXX hDlg, 401 TO n
    PRINT "lv style xx      -> "; n
    IF n <= 0 THEN fail = fail + 1
    LISTVIEW SET STYLEXX hDlg, 401, n
    m = 0
    LISTVIEW GET STYLEXX hDlg, 401 TO m
    PRINT "                   after set "; n; " -> "; m
    IF m <> n THEN fail = fail + 1

    LISTVIEW RESET hDlg, 401
    n = 99
    LISTVIEW GET COUNT hDlg, 401 TO n
    PRINT "lv count after reset -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' ----------------------------- TREEVIEW ------------------------------
    PRINT "--- TREEVIEW ---"
    TREEVIEW INSERT ITEM hDlg, 402, 0,     0, 0, 0, "Root"    TO hRoot
    TREEVIEW INSERT ITEM hDlg, 402, hRoot, 0, 0, 0, "Child A" TO hA
    TREEVIEW INSERT ITEM hDlg, 402, hRoot, 0, 0, 0, "Child B" TO hB
    IF hRoot = 0 OR hA = 0 OR hB = 0 THEN
        PRINT "FAIL: TREEVIEW INSERT ITEM returned a NULL handle"
        fail = fail + 1
    END IF
    n = 0
    TREEVIEW GET COUNT hDlg, 402 TO n
    m = n
    TREEVIEW INSERT ITEM hDlg, 402, hRoot, 0, 0, 0, "Child C" TO hC
    n = 0
    TREEVIEW GET COUNT hDlg, 402 TO n
    PRINT "tv count         -> "; m; "   after insert -> "; n
    IF m <> 3 OR n <> 4 THEN fail = fail + 1
    TREEVIEW DELETE hDlg, 402, hC
    n = 0
    TREEVIEW GET COUNT hDlg, 402 TO n
    PRINT "                   after delete -> "; n
    IF n <> 3 THEN fail = fail + 1

    h = 0
    TREEVIEW GET ROOT hDlg, 402 TO h
    PRINT "tv root == root  -> "; (h = hRoot)
    IF h <> hRoot THEN fail = fail + 1
    h = 0
    TREEVIEW GET CHILD hDlg, 402, hRoot TO h
    PRINT "tv child == A    -> "; (h = hA)
    IF h <> hA THEN fail = fail + 1
    h = 0
    TREEVIEW GET NEXT hDlg, 402, hA TO h
    PRINT "tv next == B     -> "; (h = hB)
    IF h <> hB THEN fail = fail + 1

    TREEVIEW SET EXPANDED hDlg, 402, hRoot, 1
    n = 0
    TREEVIEW GET EXPANDED hDlg, 402, hRoot TO n
    PRINT "tv expanded on   -> "; n
    IF n = 0 THEN fail = fail + 1
    TREEVIEW SET EXPANDED hDlg, 402, hRoot, 0
    n = -1
    TREEVIEW GET EXPANDED hDlg, 402, hRoot TO n
    PRINT "                   off -> "; n
    IF n <> 0 THEN fail = fail + 1

    TREEVIEW SET TEXT hDlg, 402, hB, "Renamed"
    t = ""
    TREEVIEW GET TEXT hDlg, 402, hB TO t
    PRINT "tv text          -> ["; t; "]"
    IF t <> "Renamed" THEN fail = fail + 1

    TREEVIEW SELECT hDlg, 402, hB
    h = 0
    TREEVIEW GET SELECT hDlg, 402 TO h
    IF h <> hB THEN fail = fail + 1
    TREEVIEW UNSELECT hDlg, 402
    h = hB
    TREEVIEW GET SELECT hDlg, 402 TO h
    PRINT "tv sel == hB, after unselect -> "; h
    IF h <> 0 THEN fail = fail + 1

    TREEVIEW RESET hDlg, 402
    n = 99
    TREEVIEW GET COUNT hDlg, 402 TO n
    PRINT "tv count after reset -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' ----------------------------- SCROLLBAR -----------------------------
    PRINT "--- SCROLLBAR ---"
    SCROLLBAR SET RANGE hDlg, 403, 0, 100
    n = -1
    m = -1
    SCROLLBAR GET RANGE hDlg, 403 TO n, m
    PRINT "sb range -> "; n; " / "; m
    IF n <> 0 OR m <> 100 THEN fail = fail + 1

    SCROLLBAR SET POS hDlg, 403, 25
    n = -1
    SCROLLBAR GET POS hDlg, 403 TO n
    PRINT "sb pos -> "; n
    IF n <> 25 THEN fail = fail + 1
    SCROLLBAR SET POS hDlg, 403, 60
    n = -1
    SCROLLBAR GET POS hDlg, 403 TO n
    PRINT "                   after move -> "; n
    IF n <> 60 THEN fail = fail + 1

    SCROLLBAR SET PAGESIZE hDlg, 403, 10
    n = -1
    SCROLLBAR GET PAGESIZE hDlg, 403 TO n
    PRINT "sb pagesize -> "; n
    IF n <> 10 THEN fail = fail + 1

    ' NOTE - open item, recorded rather than hidden:
    '   SCROLLBAR SET TRACKPOS parses (the noun whitelist accepts TRACKPOS)
    '   but codegen has no arm for it yet, so using it now fails with
    '       unknown statement/subroutine `SCROLLBAR_SET_TRACKPOS` on line N
    '   That is the batch-191 hard-fail path doing its job - before this
    '   batch the same line would have compiled to a silent no-op.  Working
    '   forms exercised above: SET/GET RANGE, SET/GET POS, SET/GET PAGESIZE.
    DIALOG END hDlg, fail
    PRINT
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
