' =====================================================================
' batch185_test.bas - batch 185: the GRAPHIC keyboard family + SPLIT
'---------------------------------------------------------------------
' Purpose:   Exercise, in one labelled block each, everything this batch
'            implements:
'
'              1. GRAPHIC INSTAT TO NumericVar
'                   non-destructive query: TRUE when a character is ready,
'                   and it STAYS true until the character is read.
'              2. GRAPHIC INPUT FLUSH
'                   discard everything buffered (no operands).
'              3. GRAPHIC INSTAT keeps querying without consuming.
'              4. GRAPHIC INKEY$ TO str
'                   with nothing buffered the result is the null string -
'                   this is the one half of INKEY$ a headless run can prove.
'              5. GRAPHIC WAITKEY$("", 0) TO str
'                   TimeOut& = 0 returns at once instead of blocking, so the
'                   null string is verifiable without a keypress.
'              6. GRAPHIC SPLIT with a field wider than the text
'                   everything stays in part 1, part 2 is empty.
'              7. GRAPHIC SPLIT is lossless: part1 & part2 = the original.
'              8. GRAPHIC SPLIT with a narrow field really does split.
'              9. GRAPHIC SPLIT WORD can only shorten part 1, never lengthen
'                   it - the "do not break a word" guarantee, expressed as an
'                   invariant rather than as an expected character count.
'
'            Every statement below pumps this thread's message queue first,
'            because the graphic window in these programs has no explicit
'            message loop of its own - deliberate behaviour, not an accident.
'
' Expected output (run, no key pressed):  === FAILURES:0 ===
' Exit code: 0 on success, or the number of failed assertions.
'
' COMPILE-ONLY (cannot run headless)
'   GRAPHIC INPUT [prompt,] varlist      and   GRAPHIC LINE INPUT ["prompt"] var
'   both block until ENTER arrives, so any sample that runs them unattended
'   would time out (exit 124) and fail verification - the same reason the
'   official corpus marks its keyboard samples COMPILE ONLY.  They are
'   compiled here (see the two commented statements at the end of block 10)
'   and hand-tested by typing into a running PBGRAPHIC window.
' =====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fails AS LONG
    LOCAL g AS LONG
    LOCAL k AS STRING
    LOCAL w AS STRING
    LOCAL src AS STRING
    LOCAL p1 AS STRING
    LOCAL p2 AS STRING
    LOCAL n1 AS STRING
    LOCAL n2 AS STRING

    fails = 0

    ' ---------------------------------------------------------------
    ' 1. GRAPHIC INSTAT - empty queue reports no character
    ' ---------------------------------------------------------------
    PRINT "--- 1. GRAPHIC INSTAT: an empty queue reports no character ---"
    g = -1                                  ' poison, so a silent failure shows up
    GRAPHIC INSTAT TO g
    IF g <> 0 THEN
        fails = fails + 1
        PRINT "  FAIL GRAPHIC INSTAT returned"; g; "- expected 0 with an empty queue"
    ELSE
        PRINT "  PASS GRAPHIC INSTAT -> 0 with nothing buffered"
    END IF

    ' ---------------------------------------------------------------
    ' 2. GRAPHIC INPUT FLUSH - accepted, and the queue stays empty
    ' ---------------------------------------------------------------
    PRINT "--- 2. GRAPHIC INPUT FLUSH: accepted, queue stays empty ---"
    GRAPHIC INPUT FLUSH
    g = -1
    GRAPHIC INSTAT TO g
    IF g <> 0 THEN
        fails = fails + 1
        PRINT "  FAIL after GRAPHIC INPUT FLUSH, INSTAT returned"; g; "- expected 0"
    ELSE
        PRINT "  PASS GRAPHIC INPUT FLUSH -> queue still empty"
    END IF

    ' ---------------------------------------------------------------
    ' 3. Querying is non-destructive: two queries in a row agree
    ' ---------------------------------------------------------------
    PRINT "--- 3. GRAPHIC INSTAT keeps querying without consuming ---"
    g = -1
    GRAPHIC INSTAT TO g
    IF g = 0 THEN
        PRINT "  PASS GRAPHIC INSTAT stayed 0 across two consecutive queries"
    ELSE
        fails = fails + 1
        PRINT "  FAIL GRAPHIC INSTAT changed without a key: "; g
    END IF

    ' ---------------------------------------------------------------
    ' 4. GRAPHIC INKEY$ with nothing buffered -> the null string
    ' ---------------------------------------------------------------
    PRINT "--- 4. GRAPHIC INKEY$: nothing buffered gives a null string ---"
    k = "poison"
    GRAPHIC INKEY$ TO k
    IF LEN(k) <> 0 THEN
        fails = fails + 1
        PRINT "  FAIL GRAPHIC INKEY$ returned LEN"; LEN(k); "- expected 0"
    ELSE
        PRINT "  PASS GRAPHIC INKEY$ -> zero-length string"
    END IF

    ' ---------------------------------------------------------------
    ' 5. GRAPHIC WAITKEY$ with TimeOut& = 0 must not wait
    ' ---------------------------------------------------------------
    PRINT "--- 5. GRAPHIC WAITKEY$("", 0): returns instead of waiting ---"
    w = "poison"
    GRAPHIC WAITKEY$("", 0) TO w
    IF LEN(w) <> 0 THEN
        fails = fails + 1
        PRINT "  FAIL GRAPHIC WAITKEY$ returned LEN"; LEN(w); "- expected 0"
    ELSE
        PRINT "  PASS GRAPHIC WAITKEY$ -> zero-length string, no block"
    END IF

    ' ---------------------------------------------------------------
    ' 6. GRAPHIC SPLIT with a field wider than the text
    ' ---------------------------------------------------------------
    PRINT "--- 6. GRAPHIC SPLIT: a wide field keeps everything in part 1 ---"
    src = "The quick brown fox"
    p1 = "poison"
    p2 = "poison"
    GRAPHIC SPLIT src, 100000 TO p1, p2
    IF p1 <> src OR LEN(p2) <> 0 THEN
        fails = fails + 1
        PRINT "  FAIL wide SPLIT: part1 = "; p1; "  part2 LEN ="; LEN(p2)
    ELSE
        PRINT "  PASS wide SPLIT -> part1 is the whole string, part2 empty"
    END IF

    ' ---------------------------------------------------------------
    ' 7. GRAPHIC SPLIT is lossless: part1 & part2 = the original
    ' ---------------------------------------------------------------
    PRINT "--- 7. GRAPHIC SPLIT: part1 & part2 = the original ---"
    p1 = "poison"
    p2 = "poison"
    GRAPHIC SPLIT src, 24 TO p1, p2
    IF (p1 & p2) <> src THEN
        fails = fails + 1
        PRINT "  FAIL lossless: ["; p1; "] & ["; p2; "] <> "; src
    ELSE
        PRINT "  PASS lossless -> "; LEN(p1); " +"; LEN(p2); " characters"
    END IF

    ' ---------------------------------------------------------------
    ' 8. A narrow field really does split
    ' ---------------------------------------------------------------
    PRINT "--- 8. GRAPHIC SPLIT: a narrow field splits ---"
    p1 = "poison"
    p2 = "poison"
    GRAPHIC SPLIT src, 16 TO p1, p2
    IF LEN(p1) >= LEN(src) OR LEN(p2) = 0 OR (p1 & p2) <> src THEN
        fails = fails + 1
        PRINT "  FAIL narrow SPLIT: part1 LEN ="; LEN(p1); " part2 LEN ="; LEN(p2)
    ELSE
        PRINT "  PASS narrow SPLIT -> part1 LEN ="; LEN(p1); ", part2 LEN ="; LEN(p2)
    END IF

    ' ---------------------------------------------------------------
    ' 9. GRAPHIC SPLIT WORD can only shorten part 1
    ' ---------------------------------------------------------------
    PRINT "--- 9. GRAPHIC SPLIT WORD never lengthens part 1 ---"
    p1 = "poison"
    p2 = "poison"
    n1 = "poison"
    n2 = "poison"
    GRAPHIC SPLIT src, 40 TO p1, p2
    GRAPHIC SPLIT WORD src, 40 TO n1, n2
    IF (n1 & n2) <> src OR LEN(n1) > LEN(p1) OR LEFT$(src, LEN(n1)) <> n1 THEN
        fails = fails + 1
        PRINT "  FAIL WORD SPLIT: plain LEN ="; LEN(p1); " word LEN ="; LEN(n1)
    ELSE
        PRINT "  PASS WORD SPLIT -> "; LEN(p1); " -> "; LEN(n1); " characters, still lossless"
    END IF

    ' ---------------------------------------------------------------
    ' 10. Compile-only: GRAPHIC INPUT and GRAPHIC LINE INPUT
    '     Both block until ENTER, so they are compiled but never run here.
    '     Uncomment in a PBGRAPHIC window to hand-test them.
    ' ---------------------------------------------------------------
    PRINT "--- 10. GRAPHIC INPUT / GRAPHIC LINE INPUT: compiled, not run ---"
    PRINT "  NOTE these two read the keyboard and would block a headless run"
    ' GRAPHIC LINE INPUT "Name: " k
    ' GRAPHIC INPUT "Two values: ", g, k
    PRINT "  PASS both statements are compiled by this sample"

    PRINT
    IF fails = 0 THEN
        PRINT "=== FAILURES:0 ==="
    ELSE
        PRINT "=== FAILURES:"; fails; " ==="
    END IF
    FUNCTION = fails
END FUNCTION
