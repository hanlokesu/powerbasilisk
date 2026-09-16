' batch22_test.bas - LPRINT / TRACE / IMPORT / CALL DWORD (batch 22)
#COMPILE EXE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL addr&&, hndl&&, t&
    LOCAL s AS STRING

    ' --- LPRINT: attach to a file (device), print, formfeed, flush, close ---
    LPRINT ATTACH "lprint_test.out"
    LPRINT "Hello LPRINT"
    LPRINT "num="; 123
    LPRINT "pi="; 3.14
    LPRINT FORMFEED
    LPRINT FLUSH
    LPRINT CLOSE
    s = ""
    OPEN "lprint_test.out" FOR INPUT AS #1
    LINE INPUT #1, s
    CLOSE #1
    PRINT "lprint line1 = "; s
    IF INSTR(s, "Hello LPRINT") > 0 THEN
        PRINT "LPRINT OK"
    ELSE
        PRINT "LPRINT FAIL"
    END IF

    ' --- TRACE: explicit trace file ---
    TRACE NEW "trace_test.log"
    TRACE ON
    TRACE PRINT "marker-1"
    TRACE OFF
    TRACE PRINT "should-not-appear"
    TRACE CLOSE
    s = ""
    OPEN "trace_test.log" FOR INPUT AS #1
    LINE INPUT #1, s
    CLOSE #1
    PRINT "trace line1 = "; s
    IF INSTR(s, "marker-1") > 0 THEN
        PRINT "TRACE OK"
    ELSE
        PRINT "TRACE FAIL"
    END IF

    ' --- IMPORT ADDR + CALL DWORD (GetTickCount) ---
    IMPORT ADDR "GetTickCount", "KERNEL32.DLL" TO addr&&, hndl&&
    IF addr&& <> 0 THEN
        CALL DWORD addr&& USING GetTickCount() TO t&
        PRINT "tick = "; t&
        IF t& > 0 THEN
            PRINT "CALL DWORD OK"
        ELSE
            PRINT "CALL DWORD FAIL"
        END IF
        IMPORT CLOSE hndl&&
    ELSE
        PRINT "IMPORT ADDR FAIL"
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
