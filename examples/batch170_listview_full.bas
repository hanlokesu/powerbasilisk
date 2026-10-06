'=====================================================================
' Batch 170 test - LISTVIEW: the complete statement family
'---------------------------------------------------------------------
' Batch 158 added 8 LISTVIEW statements. Batch 170 completed the family
' with the remaining 27 documented sub-commands, and moved every item
' and column number to the official 1-based convention (First = 1).
'
' This sample is self-checking. It builds a ListView, drives every
' sub-command, prints one line per assertion, and ends with
'
'     === FAILURES: n ===
'
' The process exit code is n, so 0 means every assertion held. It is a
' console program on purpose so a script can run it, and the
' DIALOG SHOW MODELESS / DIALOG END pair keeps it from hanging.
'
' Statements exercised:
'   CONTROL ADD LISTVIEW
'   LISTVIEW INSERT COLUMN / INSERT ITEM / GET COUNT / GET TEXT /
'            SET TEXT / DELETE ITEM / DELETE COLUMN / RESET
'   LISTVIEW FIND / FIND EXACT / FIT CONTENT / FIT HEADER
'   LISTVIEW GET COLUMN / SET COLUMN / GET HEADER / SET HEADER /
'            GET HEADERID / GET MODE / SET MODE / GET SELCOUNT /
'            GET SELECT / GET STATE / GET STYLEXX / SET STYLEXX /
'            GET USER / SET USER / SELECT / UNSELECT / VISIBLE /
'            SET IMAGE / SET IMAGE2 / SET OVERLAY / SET IMAGELIST /
'            SORT
'
' NOTE: the official DDT syntax addresses a control by (dialog handle,
' control id) - NOT by the control handle returned from CONTROL ADD.
'=====================================================================
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg AS LONG
    LOCAL hLV  AS LONG
    LOCAL fail AS LONG
    LOCAL n    AS LONG
    LOCAL m    AS LONG
    LOCAL k    AS LONG
    LOCAL t    AS STRING

    DIALOG NEW 0, "batch170 LISTVIEW probe", 0, 0, 420, 300 TO hDlg
    DIALOG SHOW MODELESS hDlg

    CONTROL ADD LISTVIEW, hDlg, 401, 10, 10, 390, 240 TO hLV
    PRINT "hwnd listview  -> "; hLV
    IF hLV = 0 THEN fail = fail + 1

    ' ---------------- INSERT COLUMN / INSERT ITEM ----------------
    PRINT "--- INSERT COLUMN / INSERT ITEM ---"
    LISTVIEW INSERT COLUMN hDlg, 401, 1, "Name", 80, 0
    LISTVIEW INSERT COLUMN hDlg, 401, 2, "Qty", 50, 0
    LISTVIEW INSERT COLUMN hDlg, 401, 3, "Date", 70, 0
    LISTVIEW INSERT ITEM hDlg, 401, 1, 0, "alpha"
    LISTVIEW INSERT ITEM hDlg, 401, 2, 0, "BETA"
    LISTVIEW INSERT ITEM hDlg, 401, 3, 0, "gamma"
    LISTVIEW INSERT ITEM hDlg, 401, 4, 0, "delta"

    LISTVIEW GET COUNT hDlg, 401 TO n
    PRINT "count          -> "; n
    IF n <> 4 THEN fail = fail + 1

    ' ---------------- GET / SET TEXT (1-based) ----------------
    PRINT "--- GET / SET TEXT ---"
    LISTVIEW GET TEXT hDlg, 401, 1, 1 TO t
    PRINT "text(1,1)      -> ["; t; "]"
    IF t <> "alpha" THEN fail = fail + 1
    LISTVIEW GET TEXT hDlg, 401, 4, 1 TO t
    PRINT "text(4,1)      -> ["; t; "]"
    IF t <> "delta" THEN fail = fail + 1
    LISTVIEW SET TEXT hDlg, 401, 2, 2, "20"
    LISTVIEW GET TEXT hDlg, 401, 2, 2 TO t
    PRINT "text(2,2)      -> ["; t; "]"
    IF t <> "20" THEN fail = fail + 1

    ' ---------------- GET / SET HEADER ----------------
    PRINT "--- GET / SET HEADER ---"
    LISTVIEW GET HEADER hDlg, 401, 1 TO t
    PRINT "header(1)      -> ["; t; "]"
    IF t <> "Name" THEN fail = fail + 1
    LISTVIEW SET HEADER hDlg, 401, 2, "Amount"
    LISTVIEW GET HEADER hDlg, 401, 2 TO t
    PRINT "header(2)      -> ["; t; "]"
    IF t <> "Amount" THEN fail = fail + 1

    ' ---------------- GET HEADERID ----------------
    ' The statement hands back the LISTVIEW handle plus the id of the HEADER
    ' child embedded in it; the official text promises the pair is usable
    ' with the HEADER statement, so prove it by counting the header items.
    PRINT "--- GET HEADERID ---"
    LISTVIEW GET HEADERID hDlg, 401 TO n, m
    PRINT "header hwnd    -> "; n; "  id -> "; m
    IF n = 0 THEN fail = fail + 1
    HEADER GET COUNT n, m TO k
    PRINT "header cols    -> "; k
    IF k <> 3 THEN fail = fail + 1

    ' ---------------- GET / SET COLUMN ----------------
    PRINT "--- GET / SET COLUMN ---"
    LISTVIEW GET COLUMN hDlg, 401, 1 TO n
    PRINT "colw(1)        -> "; n
    IF n <> 80 THEN fail = fail + 1
    LISTVIEW SET COLUMN hDlg, 401, 1, 120
    LISTVIEW GET COLUMN hDlg, 401, 1 TO n
    PRINT "colw(1)        -> "; n
    IF n <> 120 THEN fail = fail + 1

    ' ---------------- FIT CONTENT / FIT HEADER ----------------
    ' Give the header a far longer caption than any cell, so the two
    ' sentinels cannot be confused: FIT HEADER must end up the wider one.
    PRINT "--- FIT CONTENT / FIT HEADER ---"
    LISTVIEW SET HEADER hDlg, 401, 1, "A Very Long Column Heading Indeed"
    LISTVIEW FIT CONTENT hDlg, 401, 1
    LISTVIEW GET COLUMN hDlg, 401, 1 TO n
    PRINT "colw(1) fit    -> "; n
    IF n <= 0 THEN fail = fail + 1
    LISTVIEW FIT HEADER hDlg, 401, 1
    LISTVIEW GET COLUMN hDlg, 401, 1 TO m
    PRINT "colw(1) fithdr -> "; m
    IF m <= n THEN fail = fail + 1
    LISTVIEW SET HEADER hDlg, 401, 1, "Name"

    ' ---------------- GET / SET STYLEXX ----------------
    ' CONTROL ADD LISTVIEW starts the control with %LVS_EX_FULLROWSELECT.
    PRINT "--- GET / SET STYLEXX ---"
    LISTVIEW GET STYLEXX hDlg, 401 TO n
    PRINT "stylexx        -> &H"; HEX$(n)
    IF n <> &H20 THEN fail = fail + 1
    LISTVIEW SET STYLEXX hDlg, 401, &H21
    LISTVIEW GET STYLEXX hDlg, 401 TO n
    PRINT "stylexx        -> &H"; HEX$(n)
    IF n <> &H21 THEN fail = fail + 1

    ' ---------------- GET / SET USER ----------------
    ' Read back before any SORT: the official docs warn that sorting
    ' overwrites the per-row user value.
    PRINT "--- GET / SET USER ---"
    LISTVIEW SET USER hDlg, 401, 1, 12345
    LISTVIEW GET USER hDlg, 401, 1 TO n
    PRINT "user(1)        -> "; n
    IF n <> 12345 THEN fail = fail + 1

    ' ---------------- selection ----------------
    PRINT "--- SELECT / UNSELECT / GET SELECT / GET STATE ---"
    LISTVIEW GET SELCOUNT hDlg, 401 TO n
    PRINT "selcount       -> "; n
    IF n <> 0 THEN fail = fail + 1

    LISTVIEW SELECT hDlg, 401, 2
    LISTVIEW GET SELCOUNT hDlg, 401 TO n
    PRINT "selcount       -> "; n
    IF n <> 1 THEN fail = fail + 1

    LISTVIEW GET SELECT hDlg, 401 TO n
    PRINT "select         -> "; n
    IF n <> 2 THEN fail = fail + 1

    LISTVIEW GET STATE hDlg, 401, 2, 1 TO n
    PRINT "state(2)       -> "; n
    IF n <> -1 THEN fail = fail + 1
    LISTVIEW GET STATE hDlg, 401, 1, 1 TO n
    PRINT "state(1)       -> "; n
    IF n <> 0 THEN fail = fail + 1

    LISTVIEW UNSELECT hDlg, 401, 2
    LISTVIEW GET SELCOUNT hDlg, 401 TO n
    PRINT "selcount       -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' ---------------- FIND / FIND EXACT ----------------
    PRINT "--- FIND / FIND EXACT ---"
    LISTVIEW FIND hDlg, 401, 1, "gam" TO n
    PRINT "find 'gam'     -> "; n
    IF n <> 3 THEN fail = fail + 1
    LISTVIEW FIND EXACT hDlg, 401, 1, "gam" TO n
    PRINT "exact 'gam'    -> "; n
    IF n <> 0 THEN fail = fail + 1
    LISTVIEW FIND EXACT hDlg, 401, 1, "gamma" TO n
    PRINT "exact 'gamma'  -> "; n
    IF n <> 3 THEN fail = fail + 1
    LISTVIEW FIND hDlg, 401, 1, "zzz" TO n
    PRINT "find 'zzz'     -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' ---------------- image statements ----------------
    ' This fork has no IMAGELIST control yet, so there is no image list to
    ' attach: the statements must be accepted without disturbing the
    ' control or its item count.
    PRINT "--- SET IMAGE / IMAGE2 / OVERLAY / IMAGELIST ---"
    LISTVIEW SET IMAGE     hDlg, 401, 1, 0
    LISTVIEW SET IMAGE2    hDlg, 401, 1, 0
    LISTVIEW SET OVERLAY   hDlg, 401, 1, 0
    LISTVIEW SET IMAGELIST hDlg, 401, 0, 0
    LISTVIEW GET COUNT hDlg, 401 TO n
    PRINT "count          -> "; n
    IF n <> 4 THEN fail = fail + 1

    ' ---------------- VISIBLE ----------------
    PRINT "--- VISIBLE ---"
    LISTVIEW VISIBLE hDlg, 401, 3

    ' ---------------- SORT ----------------
    ' Items are alpha, BETA, gamma, delta. Descending by ASCII gives
    ' gamma, delta, alpha, BETA; ascending with UCASE gives alpha, BETA,
    ' delta, gamma.
    PRINT "--- SORT ---"
    LISTVIEW SORT hDlg, 401, 1, DESCEND
    LISTVIEW GET TEXT hDlg, 401, 1, 1 TO t
    PRINT "sort desc(1)   -> ["; t; "]"
    IF t <> "gamma" THEN fail = fail + 1
    LISTVIEW GET TEXT hDlg, 401, 4, 1 TO t
    PRINT "sort desc(4)   -> ["; t; "]"
    IF t <> "BETA" THEN fail = fail + 1

    LISTVIEW SORT hDlg, 401, 1, ASCEND, UCASE
    LISTVIEW GET TEXT hDlg, 401, 1, 1 TO t
    PRINT "sort asc(1)    -> ["; t; "]"
    IF t <> "alpha" THEN fail = fail + 1
    LISTVIEW GET TEXT hDlg, 401, 4, 1 TO t
    PRINT "sort asc(4)    -> ["; t; "]"
    IF t <> "gamma" THEN fail = fail + 1

    ' ---------------- DELETE COLUMN / DELETE ITEM ----------------
    PRINT "--- DELETE COLUMN / DELETE ITEM ---"
    ' Windows cannot delete column 1, so column 3 goes first.
    LISTVIEW DELETE COLUMN hDlg, 401, 3
    LISTVIEW GET HEADER hDlg, 401, 3 TO t
    PRINT "header(3)      -> ["; t; "]"
    IF t <> "" THEN fail = fail + 1

    LISTVIEW DELETE ITEM hDlg, 401, 1
    LISTVIEW GET COUNT hDlg, 401 TO n
    PRINT "count          -> "; n
    IF n <> 3 THEN fail = fail + 1
    LISTVIEW GET TEXT hDlg, 401, 1, 1 TO t
    PRINT "text(1,1)      -> ["; t; "]"
    IF t <> "BETA" THEN fail = fail + 1

    ' ---------------- GET MODE / SET MODE ----------------
    PRINT "--- GET MODE / SET MODE ---"
    LISTVIEW GET MODE hDlg, 401 TO n
    PRINT "mode           -> "; n
    IF n <> 1 THEN fail = fail + 1
    LISTVIEW SET MODE hDlg, 401, 3
    LISTVIEW GET MODE hDlg, 401 TO n
    PRINT "mode           -> "; n
    IF n <> 3 THEN fail = fail + 1
    LISTVIEW SET MODE hDlg, 401, 1
    LISTVIEW GET MODE hDlg, 401 TO n
    PRINT "mode           -> "; n
    IF n <> 1 THEN fail = fail + 1

    ' ---------------- RESET ----------------
    PRINT "--- RESET ---"
    LISTVIEW RESET hDlg, 401
    LISTVIEW GET COUNT hDlg, 401 TO n
    PRINT "count          -> "; n
    IF n <> 0 THEN fail = fail + 1

    ' ---------------- error paths ----------------
    ' Control id 499 was never created: the GET statements must report -1
    ' rather than a plausible-looking number.
    PRINT "--- error paths (control 499 does not exist) ---"
    LISTVIEW GET COUNT hDlg, 499 TO n
    PRINT "count          -> "; n
    IF n <> -1 THEN fail = fail + 1
    LISTVIEW GET COLUMN hDlg, 499, 1 TO n
    PRINT "colw           -> "; n
    IF n <> -1 THEN fail = fail + 1
    LISTVIEW GET MODE hDlg, 499 TO n
    PRINT "mode           -> "; n
    IF n <> -1 THEN fail = fail + 1
    LISTVIEW GET SELCOUNT hDlg, 499 TO n
    PRINT "selcount       -> "; n
    IF n <> -1 THEN fail = fail + 1

    PRINT "=== FAILURES: "; fail; " ==="
    DIALOG END hDlg, fail
END FUNCTION
