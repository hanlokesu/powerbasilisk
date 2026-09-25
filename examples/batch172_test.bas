'=====================================================================
' PowerBasilisk Enhanced - batch 172 regression test
'---------------------------------------------------------------------
' Purpose:  batch 172 completed the TREEVIEW statement family.  Before it
'           this fork understood only RESET / GET COUNT / GET TEXT /
'           INSERT ITEM / DELETE; the other eighteen official forms parsed
'           but produced Statement::Noop, so the compiler said "success"
'           and the statement silently did nothing.
'
' Demonstrates (all 18 forms the official page documents):
'   * TREEVIEW GET BOLD / CHECK / CHILD / EXPANDED / NEXT / PARENT /
'                  PREVIOUS / ROOT / SELECT / USER           (10, with TO)
'   * TREEVIEW SELECT / UNSELECT                                  (2)
'   * TREEVIEW SET BOLD / CHECK / EXPANDED / IMAGELIST / TEXT /
'                  USER                                          (6)
'   (GET COUNT / GET TEXT / INSERT ITEM / DELETE / RESET were already
'    implemented in batch 158 and are re-exercised here as regressions.)
'
' Why two TREEVIEW controls: TREEVIEW SET CHECK / GET CHECK only mean
'   anything when the control carries %TVS_CHECKBOXES.  The official
'   CONTROL ADD TREEVIEW syntax is
'       CONTROL ADD TREEVIEW, hDlg, id&, x, y, w, h [, [style&] [, [exstyle&]]]
'   and an explicit primary style REPLACES the documented default, so the
'   first control asks for the default bits plus %TVS_CHECKBOXES
'   (0x0100) and the second one omits style entirely and keeps the
'   documented default - which has no checkboxes.  The second control is
'   the negative case: GET CHECK on a checkbox-less control must report
'   "not checked", not "checked".
'
' Expected output (run mode):
'   --- insert / count ---
'   count        -> 3
'   --- navigation ---
'   root == hRoot / child == hA / next == hB / prev == hA / parent == hRoot
'   leaf child   -> 0
'   last next    -> 0
'   first prev   -> 0
'   root parent  -> 0
'   --- GET/SET state ---
'   expanded on  -> -1     expanded off -> 0
'   bold on      -> -1     bold off     -> 0
'   check on     -> -1     check off    -> 0
'   user         -> 1234
'   --- text / selection ---
'   text         -> [Renamed]
'   select       -> hB     after unselect -> 0
'   --- checkbox negative case (control without %TVS_CHECKBOXES) ---
'   check nodefault -> 0
'   --- delete / reset / error paths ---
'   count after del -> 2   after reset -> 0
'   bad id count -> 0   bad id root -> 0   bad id bold -> 0
'   === FAILURES: 0 ===
'   (exit code 0)
'
' Complexity note: O(1) - a fixed control set and a fixed operand count.
'
' Notes:  the dialog is opened with DIALOG SHOW MODELESS and closed with
'   DIALOG END hDlg, fail, so the sample never waits for a key and is safe
'   for the non-interactive verification harness.  The exit code is the
'   number of failed assertions.
'   Handles are declared AS QUAD on purpose: an item handle is a real
'   x64 pointer and truncating it to LONG would make every comparison
'   below meaningless.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg    AS LONG
    LOCAL hTv     AS QUAD    ' default style + %TVS_CHECKBOXES
    LOCAL hTvDef  AS QUAD    ' documented default style, no checkboxes
    LOCAL hRoot   AS QUAD
    LOCAL hA      AS QUAD
    LOCAL hB      AS QUAD
    LOCAL h       AS QUAD
    LOCAL n       AS LONG
    LOCAL fail    AS LONG
    LOCAL bad     AS LONG
    LOCAL i       AS LONG
    LOCAL t       AS STRING
    LOCAL want    AS STRING

    DIALOG NEW 0, "batch172 TREEVIEW probe", 0, 0, 340, 220 TO hDlg
    DIALOG SHOW MODELESS hDlg

    ' 295 = %TVS_HASBUTTONS(1) | %TVS_HASLINES(2) | %TVS_LINESATROOT(4)
    '     | %TVS_SHOWSELALWAYS(&H20) | %TVS_CHECKBOXES(&H100)
    CONTROL ADD TREEVIEW, hDlg, 601, 10, 10, 150, 180, 295 TO hTv
    CONTROL ADD TREEVIEW, hDlg, 602, 175, 10, 150, 180 TO hTvDef

    IF hTv = 0 OR hTvDef = 0 THEN
        PRINT "FAIL: a TREEVIEW control came back NULL"
        PRINT "  tv="; hTv; " tvdef="; hTvDef
        DIALOG END hDlg, 1
        FUNCTION = 1
        EXIT FUNCTION
    END IF

    ' ---------------- regression: INSERT ITEM + GET COUNT ----------------
    PRINT "--- insert / count ---"
    ' parent 0 means "root level", hInsertAfter 0 means "append last";
    ' both are the shortcuts this fork documents for the 0xFFFF0000 /
    ' 0xFFFFFFFE literals.
    TREEVIEW INSERT ITEM hDlg, 601, 0,    0, 0, 0, "Root"    TO hRoot
    TREEVIEW INSERT ITEM hDlg, 601, hRoot, 0, 0, 0, "Child A" TO hA
    TREEVIEW INSERT ITEM hDlg, 601, hRoot, 0, 0, 0, "Child B" TO hB
    TREEVIEW GET COUNT hDlg, 601 TO n
    PRINT "count        -> "; n
    IF n <> 3 THEN fail = fail + 1
    IF hRoot = 0 OR hA = 0 OR hB = 0 THEN
        PRINT "FAIL: INSERT ITEM returned a NULL handle"
        fail = fail + 1
    END IF

    ' ---------------- GET ROOT / CHILD / NEXT / PREVIOUS / PARENT --------
    PRINT "--- navigation ---"
    h = 0
    TREEVIEW GET ROOT hDlg, 601 TO h
    PRINT "root == hRoot -> "; h; " / "; hRoot
    IF h <> hRoot THEN fail = fail + 1

    h = 0
    TREEVIEW GET CHILD hDlg, 601, hRoot TO h
    PRINT "child == hA  -> "; h; " / "; hA
    IF h <> hA THEN fail = fail + 1

    h = 0
    TREEVIEW GET NEXT hDlg, 601, hA TO h
    PRINT "next == hB   -> "; h; " / "; hB
    IF h <> hB THEN fail = fail + 1

    h = 0
    TREEVIEW GET PREVIOUS hDlg, 601, hB TO h
    PRINT "prev == hA   -> "; h; " / "; hA
    IF h <> hA THEN fail = fail + 1

    h = 0
    TREEVIEW GET PARENT hDlg, 601, hA TO h
    PRINT "parent == hRoot -> "; h; " / "; hRoot
    IF h <> hRoot THEN fail = fail + 1

    ' The four "there is no such item" paths all promise 0.
    h = 99
    TREEVIEW GET CHILD hDlg, 601, hA TO h
    PRINT "leaf child   -> "; h
    IF h <> 0 THEN fail = fail + 1

    h = 99
    TREEVIEW GET NEXT hDlg, 601, hB TO h
    PRINT "last next    -> "; h
    IF h <> 0 THEN fail = fail + 1

    h = 99
    TREEVIEW GET PREVIOUS hDlg, 601, hRoot TO h
    PRINT "first prev   -> "; h
    IF h <> 0 THEN fail = fail + 1

    h = 99
    TREEVIEW GET PARENT hDlg, 601, hRoot TO h
    PRINT "root parent  -> "; h
    IF h <> 0 THEN fail = fail + 1

    ' ---------------- SET / GET EXPANDED, BOLD, CHECK, USER -------------
    PRINT "--- GET/SET state ---"
    TREEVIEW SET EXPANDED hDlg, 601, hRoot, 1
    TREEVIEW GET EXPANDED hDlg, 601, hRoot TO n
    PRINT "expanded on  -> "; n
    IF n <> -1 THEN fail = fail + 1
    TREEVIEW SET EXPANDED hDlg, 601, hRoot, 0
    TREEVIEW GET EXPANDED hDlg, 601, hRoot TO n
    PRINT "expanded off -> "; n
    IF n <> 0 THEN fail = fail + 1

    TREEVIEW SET BOLD hDlg, 601, hA, 1
    TREEVIEW GET BOLD hDlg, 601, hA TO n
    PRINT "bold on      -> "; n
    IF n <> -1 THEN fail = fail + 1
    TREEVIEW SET BOLD hDlg, 601, hA, 0
    TREEVIEW GET BOLD hDlg, 601, hA TO n
    PRINT "bold off     -> "; n
    IF n <> 0 THEN fail = fail + 1

    TREEVIEW SET CHECK hDlg, 601, hA, 1
    TREEVIEW GET CHECK hDlg, 601, hA TO n
    PRINT "check on     -> "; n
    IF n <> -1 THEN fail = fail + 1
    TREEVIEW SET CHECK hDlg, 601, hA, 0
    TREEVIEW GET CHECK hDlg, 601, hA TO n
    PRINT "check off    -> "; n
    IF n <> 0 THEN fail = fail + 1

    TREEVIEW SET USER hDlg, 601, hA, 1234
    TREEVIEW GET USER hDlg, 601, hA TO n
    PRINT "user         -> "; n
    IF n <> 1234 THEN fail = fail + 1

    ' ---------------- SET TEXT + SELECT / UNSELECT ----------------------
    PRINT "--- text / selection ---"
    TREEVIEW SET TEXT hDlg, 601, hB, "Renamed"
    t = ""
    TREEVIEW GET TEXT hDlg, 601, hB TO t
    PRINT "text         -> ["; t; "]"
    ' Byte-wise comparison on purpose: this fork's CHR$() emits
    ' "trunc i8 to i8" for a BYTE argument and clang rejects that, so the
    ' expected string is compared through ASC()/MID$() instead.
    want = "Renamed"
    bad = 0
    IF LEN(t) <> LEN(want) THEN bad = 1
    IF LEN(t) = LEN(want) THEN
        FOR i = 1 TO LEN(want)
            IF ASC(MID$(t, i, 1)) <> ASC(MID$(want, i, 1)) THEN bad = 1
        NEXT i
    END IF
    IF bad <> 0 THEN fail = fail + 1

    TREEVIEW SELECT hDlg, 601, hB
    h = 0
    TREEVIEW GET SELECT hDlg, 601 TO h
    PRINT "select       -> "; h; " / "; hB
    IF h <> hB THEN fail = fail + 1

    TREEVIEW UNSELECT hDlg, 601
    h = 99
    TREEVIEW GET SELECT hDlg, 601 TO h
    PRINT "after unselect -> "; h
    IF h <> 0 THEN fail = fail + 1

    ' SET IMAGELIST takes an HIMAGELIST and has no read-back statement in
    ' the official set, so it carries no assertion - exactly like
    ' STATUSBAR SET PARTS / SET TEXT.  Passing 0 detaches any list.
    TREEVIEW SET IMAGELIST hDlg, 601, 0

    ' ---------------- CHECK on a control without %TVS_CHECKBOXES --------
    PRINT "--- checkbox negative case (control without %TVS_CHECKBOXES) ---"
    TREEVIEW INSERT ITEM hDlg, 602, 0, 0, 0, 0, "Plain" TO h
    n = 99
    TREEVIEW GET CHECK hDlg, 602, h TO n
    PRINT "check nodefault -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' ---------------- DELETE / RESET / error paths ----------------------
    PRINT "--- delete / reset / error paths ---"
    TREEVIEW DELETE hDlg, 601, hB
    TREEVIEW GET COUNT hDlg, 601 TO n
    PRINT "count after del -> "; n
    IF n <> 2 THEN fail = fail + 1

    TREEVIEW RESET hDlg, 601
    TREEVIEW GET COUNT hDlg, 601 TO n
    PRINT "after reset  -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' An id that does not exist must report "nothing" rather than crash:
    ' the runtime resolves it with GetDlgItem() and returns 0.
    n = 99
    TREEVIEW GET COUNT hDlg, 699 TO n
    PRINT "bad id count -> "; n
    IF n <> 0 THEN fail = fail + 1
    h = 99
    TREEVIEW GET ROOT hDlg, 699 TO h
    PRINT "bad id root  -> "; h
    IF h <> 0 THEN fail = fail + 1
    n = 99
    TREEVIEW GET BOLD hDlg, 699, 0 TO n
    PRINT "bad id bold  -> "; n
    IF n <> 0 THEN fail = fail + 1

    PRINT "=== FAILURES: "; fail; " ==="
    DIALOG END hDlg, fail
    FUNCTION = fail
END FUNCTION
