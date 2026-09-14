' PowerBasilisk Enhanced - batch 45: ERL$ / EXTRACT$ / RGB / BGR
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        PRINT "FAIL: "; msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL s AS STRING
    LOCAL n AS LONG
    failures = 0

    ' EXTRACT$: from position 1 to first match
    s = EXTRACT$("the cat sat on the mat", " sat")
    Check(s = "the cat", "extract basic")
    ' EXTRACT$ with start
    s = EXTRACT$(5, "the cat sat on the mat", " on")
    Check(s = "cat sat", "extract start")
    ' EXTRACT$ ANY: stop at any char of match set
    s = EXTRACT$("hello world", " ", "world")  ' first space
    Check(s = "hello", "extract space")
    ' EXTRACT$ ANY marker form
    s = EXTRACT$("ab,cd;ef", ",;", ANY)  ' stop at first , or ;
    Check(s = "ab", "extract any")
    ' EXTRACT$ missing match -> whole remainder
    s = EXTRACT$("abcdef", "xyz")
    Check(s = "abcdef", "extract no match")
    ' EXTRACT$ start beyond length -> empty
    s = EXTRACT$(99, "abcdef", "x")
    Check(s = "", "extract beyond")

    ' RGB 3-arg: red + green<<8 + blue<<16
    n = RGB(255, 0, 0)
    Check(n = &HFF, "rgb red")
    n = RGB(0, 255, 0)
    Check(n = &HFF00, "rgb green")
    n = RGB(0, 0, 255)
    Check(n = &HFF0000, "rgb blue")
    n = RGB(1, 2, 3)
    Check(n = &H30201, "rgb mix")

    ' BGR 3-arg: swapped order
    n = BGR(255, 0, 0)
    Check(n = &HFF0000, "bgr red")
    n = BGR(1, 2, 3)
    Check(n = &H10203, "bgr mix")

    ' RGB 1-arg byte swap (BGR -> RGB)
    n = RGB(&H30201)
    Check(n = &H10203, "rgb swap")
    n = BGR(&HFF0000)
    Check(n = &HFF, "bgr swap")

    ' ERL$ inside the error handler: NAME of a nonexistent file raises the trap
    ' (checkpoint id recorded), ERL$ returns that id as a non-empty string.
    ON ERROR GOTO errHandler
    NAME "no_such_file_xyz.bas" AS "abc.bas"
    GOTO skipHandler
errHandler:
    s = ERL$
    Check(LEN(s) > 0, "erl$ non-empty")
    RESUME NEXT
skipHandler:
    ON ERROR GOTO 0

    IF failures = 0 THEN
        PRINT "batch45: ALL PASS"
    ELSE
        PRINT "batch45: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
