' PowerBasilisk Enhanced - batch 33: CALLSTK call-stack tracing
' Tests: CALLSTKCOUNT depth, CALLSTK$(n) frame names, CALLSTK file dump
GLOBAL failures AS LONG

FUNCTION PBMAIN() AS LONG
    LOCAL n AS LONG
    LOCAL waitk AS STRING
    failures = 0

    ' depth 1: only PBMAIN on the stack
    n = CALLSTKCOUNT
    IF n <> 1 THEN PRINT "FAIL: PBMAIN depth="; n: failures = failures + 1

    CALL TestA()

    IF failures = 0 THEN
        PRINT "batch33: ALL PASS"
    ELSE
        PRINT "batch33: FAILURES="; failures
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION

SUB TestA()
    LOCAL n AS LONG
    n = CALLSTKCOUNT
    IF n <> 2 THEN PRINT "FAIL: TestA depth="; n: failures = failures + 1
    IF CALLSTK$(1) <> "TESTA" THEN PRINT "FAIL: innermost="; CALLSTK$(1): failures = failures + 1
    IF CALLSTK$(2) <> "PBMAIN" THEN PRINT "FAIL: frame2="; CALLSTK$(2): failures = failures + 1
    IF CALLSTK$(99) <> "" THEN PRINT "FAIL: OOR not empty": failures = failures + 1
    CALL TestB()
    ' depth back to 2 after TestB returns
    n = CALLSTKCOUNT
    IF n <> 2 THEN PRINT "FAIL: after TestB depth="; n: failures = failures + 1
END SUB

SUB TestB()
    LOCAL n AS LONG
    n = CALLSTKCOUNT
    IF n <> 3 THEN PRINT "FAIL: TestB depth="; n: failures = failures + 1
    CALLSTK "callstk.log"
END SUB
