'=====================================================================
' batch162_test.bas - batch 162: the docs accuracy pass
'---------------------------------------------------------------------
' statement-coverage.md still claimed two unimplemented keywords (METRICS and
' UCODE$).  Both had in fact been implemented by batch 160 - batch 162 corrected
' the stale line.  This sample is the witness for that claim: the three
' functions the corrected line talks about are called here and their results are
' asserted, so a regression re-opens the question with a failing run rather than
' with a sentence in a document.
'
' Asserts:
'   * UCODE$("ABC") has 6 bytes  (the documented "doubles the byte count")
'   * ACODE$(UCODE$("ABC")) round-trips back to "ABC"
'   * METRICS(0) (SM_CXSCREEN) is positive
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL n AS LONG
    LOCAL u AS STRING
    LOCAL back AS STRING
    n = METRICS(0)
    u = UCODE$("ABC")
    back = ACODE$(u)
    PRINT "METRICS(0)   = "; n
    PRINT "UCODE$ len   = "; LEN(u)
    PRINT "ACODE$ back  = "; back
    IF n <= 0 THEN
        fail = fail + 1
    END IF
    IF LEN(u) <> 6 THEN
        fail = fail + 1
    END IF
    IF back <> "ABC" THEN
        fail = fail + 1
    END IF
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
' Press any key to exit...
WAITKEY$
END FUNCTION
