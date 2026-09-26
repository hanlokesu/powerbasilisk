'=====================================================================
' PowerBasilisk Enhanced - batch 192 test
'---------------------------------------------------------------------
' Subject: SCROLLBAR TRACKPOS, after the batch-192 correction.
'
' What batch 192 changed
'   * A probe (2026-09-26) disproved the batch-191 note "SET/GET TRACKPOS
'     have no codegen arm":  GET TRACKPOS was implemented all along
'     (codegen arm + runtime reader over SIF_TRACKPOS).
'   * `SCROLLBAR SET TRACKPOS` is not an official form - six forms are
'     documented, none is SET TRACKPOS, the coverage CSV has no such row,
'     and Win32 SIF_TRACKPOS is read-only.  The parser now rejects it with
'       Error: SCROLLBAR SET: TRACKPOS is a GET-only sub-command on line N
'     instead of letting it fall through to a codegen "unknown statement".
'
' This sample exercises the GET side positively (it must compile and print
' FAILURES: 0).  The SET side is a compile-time rejection, so it cannot be
' asserted from inside a program; the negative probe lives in the working
' directory as _b192_probe_set_trackpos.bas.
'
' Expected output:  four "sb ..." lines and "=== FAILURES: 0 ===", exit 0
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL hDlg AS LONG
    LOCAL hSb  AS LONG
    LOCAL n    AS LONG
    LOCAL m    AS LONG
    LOCAL fail AS LONG

    DIALOG NEW 0, "batch192 SCROLLBAR TRACKPOS", 0, 0, 300, 160 TO hDlg
    DIALOG SHOW MODELESS hDlg
    CONTROL ADD HSCROLLBAR, hDlg, 501, 10, 40, 270, 20 TO hSb

    ' ---- the already-working trio, re-asserted so a regression shows up ----
    SCROLLBAR SET RANGE hDlg, 501, 0, 100
    n = -1
    m = -1
    SCROLLBAR GET RANGE hDlg, 501 TO n, m
    PRINT "sb range    -> "; n; " / "; m
    IF n <> 0 OR m <> 100 THEN fail = fail + 1

    SCROLLBAR SET PAGESIZE hDlg, 501, 10
    n = -1
    SCROLLBAR GET PAGESIZE hDlg, 501 TO n
    PRINT "sb pagesize -> "; n
    IF n <> 10 THEN fail = fail + 1

    SCROLLBAR SET POS hDlg, 501, 30
    n = -1
    SCROLLBAR GET POS hDlg, 501 TO n
    PRINT "sb pos      -> "; n
    IF n <> 30 THEN fail = fail + 1

    ' ---- the statement batch 192 is about ----
    ' TRACKPOS reports where the user is dragging the thumb; with no user
    ' input it tracks the current position, so after SET POS 30 it reads 30.
    n = -1
    SCROLLBAR GET TRACKPOS hDlg, 501 TO n
    PRINT "sb trackpos -> "; n
    IF n < 0 THEN fail = fail + 1

    DIALOG END hDlg, fail
    PRINT
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
