' =====================================================================
' batch160_test.bas — METRICS, UCODE$ and ACODE$
' ---------------------------------------------------------------------
' Purpose:  exercise the three functions added in batch 160 and print the
'           values so the numbers can be checked against the Windows SDK.
' Tests:    * METRICS with a dotted name (Scroll.Horz, Border.X, ...)
'           * METRICS with a three-segment name (Frame.Fixed.X)
'           * METRICS with the single-word names (Caption, Menubar)
'           * METRICS with a plain numeric metric index
'           * UCODE$ doubles the byte count while keeping the characters
'           * ACODE$ is the exact inverse of UCODE$
' Expected output: the metric values are machine-dependent, so only the
'           structural checks are asserted.  Exit code 0 = all checks passed,
'           1 = a check failed.
' =====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL n AS LONG
    LOCAL u AS STRING
    LOCAL back AS STRING
    LOCAL ok AS LONG

    ok = 1

    ' ---- METRICS: dotted names -------------------------------------
    n = METRICS(Scroll.Horz)
    PRINT "Scroll.Horz    ="; n
    IF n <= 0 THEN ok = 0

    n = METRICS(Scroll.Vert)
    PRINT "Scroll.Vert    ="; n
    IF n <= 0 THEN ok = 0

    n = METRICS(Border.X)
    PRINT "Border.X       ="; n
    IF n <= 0 THEN ok = 0

    n = METRICS(Icon.X)
    PRINT "Icon.X         ="; n
    IF n <= 0 THEN ok = 0

    ' ---- METRICS: three-segment name -------------------------------
    n = METRICS(Frame.Fixed.X)
    PRINT "Frame.Fixed.X  ="; n
    IF n <= 0 THEN ok = 0

    n = METRICS(Frame.Resize.X)
    PRINT "Frame.Resize.X ="; n
    IF n <= 0 THEN ok = 0

    ' ---- METRICS: single-word names --------------------------------
    n = METRICS(Caption)
    PRINT "Caption        ="; n
    IF n <= 0 THEN ok = 0

    n = METRICS(Menubar)
    PRINT "Menubar        ="; n
    IF n <= 0 THEN ok = 0

    ' ---- METRICS: a plain metric index (SM_CXSCREEN = 0) ------------
    n = METRICS(0)
    PRINT "METRICS(0)     ="; n
    IF n <= 0 THEN ok = 0

    ' ---- UCODE$ / ACODE$ -------------------------------------------
    u = UCODE$("ABC")
    PRINT "UCODE$ byte len ="; LEN(u)
    IF LEN(u) <> 6 THEN ok = 0

    back = ACODE$(u)
    PRINT "ACODE$ restored ="; back
    IF back <> "ABC" THEN ok = 0

    back = UCODE$("Hello") : back = ACODE$(back)
    PRINT "round trip      ="; back
    IF back <> "Hello" THEN ok = 0

    ' ---- result ----------------------------------------------------
    IF ok = 1 THEN
        PRINT "PASS"
        FUNCTION = 0
    ELSE
        PRINT "FAIL"
        FUNCTION = 1
    END IF
END FUNCTION
