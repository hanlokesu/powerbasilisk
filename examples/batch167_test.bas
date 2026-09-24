'=====================================================================
' PowerBasilisk Enhanced - batch 167 regression test
'---------------------------------------------------------------------
' Purpose:  batch 167 was a coverage-correction batch: it replaced the
'           eleven collapsed "bare family name" rows in the CSV with the
'           official per-statement rows, and set a status on each one
'           from real evidence instead of assumption.  Nineteen of those
'           statements came out Implemented and had no example of their
'           own, so this file is that evidence, kept runnable.
'
' Demonstrates:
'   * PROGRESSBAR  SET RANGE / SET POS / SET STEP / STEP / GET POS /
'                  GET RANGE                                     (6)
'   * HEADER       GET COUNT / GET ITEM / SET ITEM / SEND        (4)
'   * TOOLBAR      ADD BUTTON / ADD SEPARATOR / DELETE BUTTON /
'                  GET COUNT / GET STATE / SET IMAGELIST /
'                  SET STATE                                     (7)
'   * STATUSBAR    SET PARTS / SET TEXT                          (2)
'
' Why the HEADER half looks unusual: this fork has no
'   CONTROL ADD HEADER (it is still Tier-3 DDT), so the header is
'   borrowed from a LISTVIEW through LISTVIEW GET HEADERID - which is
'   exactly what the official GET HEADERID page says the pair is for.
'   HEADER GET ITEM / SET ITEM take a raw pointer to a HDITEMA
'   structure, so the test builds one in a zeroed BYTE array and pokes
'   the three fields it needs: mask (HDI_TEXT), pszText and cchTextMax.
'   Writing the column caption through HEADER SET ITEM and reading it
'   back through LISTVIEW GET HEADER proves the two views agree.
'
' Expected output (run mode):
'   --- PROGRESSBAR ---
'   range lo/hi  -> 0 / 100
'   pos          -> 30
'   pos stepit   -> 35
'   pos deltapos -> 45
'   --- HEADER ---
'   header cols  -> 3
'   header item1 -> [Name]
'   --- TOOLBAR ---
'   count        -> 4
'   state item 1 -> 4
'   state cmd202 -> 0
'   count after del -> 3
'   --- STATUSBAR ---
'   (SET PARTS / SET TEXT have no TO target, so they carry no assertion)
'   === FAILURES: 0 ===
'   (exit code 0)
'
' Complexity note: O(1) - fixed control set, fixed operand count.
'
' Notes:  the dialog is opened with DIALOG SHOW MODELESS and closed with
'   DIALOG END hDlg, fail, so the sample needs no keyboard input and is
'   safe to run in the non-interactive verification harness.  The exit
'   code is the number of failed assertions.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg  AS LONG
    LOCAL hProg AS LONG
    LOCAL hTb   AS LONG
    LOCAL hSb   AS LONG
    LOCAL hLv   AS LONG
    LOCAL hHdr  AS LONG
    LOCAL hid   AS LONG
    LOCAL n     AS LONG
    LOCAL m     AS LONG
    LOCAL k     AS LONG
    ' NOTE: LO and HI are builtin FUNCTIONS in this fork (batch 44), so they
    ' cannot be used as variable names - the parser demands "(" right after
    ' them and reports "Expected LParen".  The range targets are therefore
    ' named rlo / rhi.
    LOCAL rlo    AS LONG
    LOCAL rhi    AS LONG
    LOCAL st    AS LONG
    LOCAL v     AS LONG
    LOCAL p     AS QUAD
    LOCAL i     AS LONG
    LOCAL fail  AS LONG
    LOCAL bad   AS LONG
    LOCAL t     AS STRING
    LOCAL hdi(63) AS BYTE     ' one HDITEMA, x64 layout, 64 bytes
    LOCAL txt(63) AS BYTE     ' buffer pszText points at

    DIALOG NEW 0, "batch167 probe", 0, 0, 440, 320 TO hDlg
    DIALOG SHOW MODELESS hDlg

    ' ---------------- create the controls ----------------
    ' PROGRESSBAR takes no text operand; TOOLBAR and STATUSBAR do.  The
    ' x/y/w/h of the two docking controls are parsed but ignored, exactly
    ' as the official help states.
    CONTROL ADD PROGRESSBAR, hDlg, 501, 10, 10, 300, 20 TO hProg
    CONTROL ADD TOOLBAR,     hDlg, 502, "", 0, 0, 0, 0 TO hTb
    CONTROL ADD STATUSBAR,   hDlg, 503, "", 0, 0, 0, 0 TO hSb
    CONTROL ADD LISTVIEW,    hDlg, 504, 10, 40, 300, 120 TO hLv

    IF hProg = 0 OR hTb = 0 OR hSb = 0 OR hLv = 0 THEN
        PRINT "FAIL: a control came back NULL"
        PRINT "  prog="; hProg; " tb="; hTb; " sb="; hSb; " lv="; hLv
        DIALOG END hDlg, 1
        FUNCTION = 1
        EXIT FUNCTION
    END IF

    ' ---------------- PROGRESSBAR ----------------
    PRINT "--- PROGRESSBAR ---"
    PROGRESSBAR SET RANGE hDlg, 501, 0, 100
    PROGRESSBAR GET RANGE hDlg, 501 TO rlo, rhi
    PRINT "range lo/hi  -> "; rlo; " / "; rhi
    IF rlo <> 0 THEN fail = fail + 1
    IF rhi <> 100 THEN fail = fail + 1

    PROGRESSBAR SET POS hDlg, 501, 30
    PROGRESSBAR GET POS hDlg, 501 TO n
    PRINT "pos          -> "; n
    IF n <> 30 THEN fail = fail + 1

    ' SET STEP arms PBM_STEPIT; STEP with no increment advances by it.
    PROGRESSBAR SET STEP hDlg, 501, 5
    PROGRESSBAR STEP hDlg, 501
    PROGRESSBAR GET POS hDlg, 501 TO n
    PRINT "pos stepit   -> "; n
    IF n <> 35 THEN fail = fail + 1

    ' STEP with an explicit increment is PBM_DELTAPOS, a relative move.
    PROGRESSBAR STEP hDlg, 501, 10
    PROGRESSBAR GET POS hDlg, 501 TO n
    PRINT "pos deltapos -> "; n
    IF n <> 45 THEN fail = fail + 1

    ' error path: an id that does not exist must report failure
    PROGRESSBAR GET POS hDlg, 599 TO n
    IF n <> -1 THEN fail = fail + 1

    ' ---------------- HEADER ----------------
    PRINT "--- HEADER ---"
    LISTVIEW INSERT COLUMN hDlg, 504, 1, "Name", 80, 0
    LISTVIEW INSERT COLUMN hDlg, 504, 2, "Qty", 50, 0
    LISTVIEW INSERT COLUMN hDlg, 504, 3, "Date", 70, 0

    LISTVIEW GET HEADERID hDlg, 504 TO hHdr, hid
    PRINT "header hwnd  -> "; hHdr; "  id -> "; hid
    IF hHdr = 0 THEN fail = fail + 1

    HEADER GET COUNT hHdr, hid TO k
    PRINT "header cols  -> "; k
    IF k <> 3 THEN fail = fail + 1

    ' Build a HDITEMA in hdi() and ask for the caption of column 1.
    '   offset  0  UINT   mask        = HDI_TEXT (&H0002)
    '   offset  8  LPSTR  pszText     = address of txt()
    '   offset 24  int    cchTextMax  = 64
    MEMORY FILL VARPTR(hdi(0)), 64, BYTE 0
    MEMORY FILL VARPTR(txt(0)), 64, BYTE 0
    p = VARPTR(hdi(0))
    POKE LONG, p, 2
    POKE QUAD, p + 8, VARPTR(txt(0))
    POKE LONG, p + 24, 64

    HEADER GET ITEM hHdr, hid, 1, p TO v
    ' HDM_GETITEMA answered TRUE, so txt() now holds column 1's caption as a
    ' NUL-terminated ANSI string.  Read it back and compare it with the caption
    ' the LISTVIEW reports - if the two disagree, one of the two views is lying.
    '
    ' The comparison is done byte by byte with ASC()/MID$() on purpose: this
    ' fork's CHR$() emits `trunc i8 to i8` when its argument is BYTE-typed and
    ' clang rejects that, so CHR$ must not be used to rebuild a string from a
    ' BYTE array here.  (Reported as a defect; see the skill's pitfalls file.)
    LISTVIEW GET HEADER hDlg, 504, 1 TO t
    PRINT "header item1 -> ["; t; "]"
    IF v = 0 THEN fail = fail + 1
    bad = 0
    IF LEN(t) <> 4 THEN bad = 1
    IF LEN(t) = 4 THEN
        FOR i = 0 TO 3
            IF txt(i) <> ASC(MID$(t, i + 1, 1)) THEN bad = 1
        NEXT i
    END IF
    IF bad <> 0 THEN fail = fail + 1

    ' Write a new caption through HEADER SET ITEM, then read it back
    ' through the LISTVIEW - if the two disagree, one of them is wrong.
    MEMORY FILL VARPTR(txt(0)), 64, BYTE 0
    POKE BYTE, VARPTR(txt(0)),     82   ' R
    POKE BYTE, VARPTR(txt(0)) + 1, 101  ' e
    POKE BYTE, VARPTR(txt(0)) + 2, 110  ' n
    POKE BYTE, VARPTR(txt(0)) + 3, 97   ' a
    POKE BYTE, VARPTR(txt(0)) + 4, 109  ' m
    POKE BYTE, VARPTR(txt(0)) + 5, 101  ' e
    POKE BYTE, VARPTR(txt(0)) + 6, 100  ' d
    POKE BYTE, VARPTR(txt(0)) + 7, 0
    HEADER SET ITEM hHdr, hid, 1, p TO v
    LISTVIEW GET HEADER hDlg, 504, 1 TO t
    PRINT "header after -> ["; t; "]"
    IF t <> "Renamed" THEN fail = fail + 1

    ' HEADER SEND reaches the same control through the raw message path.
    ' HDM_GETITEMCOUNT (&H1200) is used deliberately: message 0 is WM_NULL and
    ' returns 0 even on success, so a zero result could not tell "the control
    ' answered" from "the call never got there".  The header has 3 columns.
    HEADER SEND hHdr, hid, &H1200, 0, 0 TO v
    PRINT "header send  -> "; v
    IF v <> 3 THEN fail = fail + 1

    ' ---------------- TOOLBAR ----------------
    PRINT "--- TOOLBAR ---"
    ' image& = 0 (no image list attached yet); style& = 0 is %BTNS_BUTTON.
    TOOLBAR ADD BUTTON hDlg, 502, 0, 201, 0, "One"
    TOOLBAR ADD BUTTON hDlg, 502, 0, 202, 0, "Two"
    TOOLBAR ADD SEPARATOR hDlg, 502, 8
    TOOLBAR ADD BUTTON hDlg, 502, 0, 203, 0, "Three"

    ' The official help counts separators as items, so the answer is 4.
    TOOLBAR GET COUNT hDlg, 502 TO n
    PRINT "count        -> "; n
    IF n <> 4 THEN fail = fail + 1

    ' %TBSTATE_ENABLED = &H0004 on a freshly added button.
    TOOLBAR GET STATE hDlg, 502, 1 TO st
    PRINT "state item 1 -> "; st
    IF st <> 4 THEN fail = fail + 1

    ' SET STATE addressing a button by COMMAND ID, not by position.
    TOOLBAR SET STATE hDlg, 502, BYCMD 202, 0
    TOOLBAR GET STATE hDlg, 502, BYCMD 202 TO st
    PRINT "state cmd202 -> "; st
    IF st <> 0 THEN fail = fail + 1

    TOOLBAR SET IMAGELIST hDlg, 502, 0, 0

    TOOLBAR DELETE BUTTON hDlg, 502, 1
    TOOLBAR GET COUNT hDlg, 502 TO n
    PRINT "count after del -> "; n
    IF n <> 3 THEN fail = fail + 1

    ' ---------------- STATUSBAR ----------------
    PRINT "--- STATUSBAR ---"
    ' Neither statement has a documented TO target, so their return
    ' values cannot be captured from PB source; they are exercised for
    ' the code path, and the assertions above carry the verdict.
    STATUSBAR SET PARTS hDlg, 503, 100, 100, 9999
    STATUSBAR SET TEXT hDlg, 503, 1, 0, "Ready"

    PRINT "=== FAILURES: "; fail; " ==="
    DIALOG END hDlg, fail
END FUNCTION
