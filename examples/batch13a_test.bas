' Batch 13a: OPTION EXPLICIT / REM / GLOBAL validation
OPTION EXPLICIT

REM this is a top-level comment
' single-quote comment also fine

GLOBAL g_count AS LONG

SUB Bump(n AS LONG)
    REM comment inside sub
    g_count = g_count + n
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    REM comment inside main
    LOCAL s AS STRING
    g_count = 10
    Bump 5
    IF g_count = 15 THEN
        PRINT "OPTION-REM-GLOBAL-PASS"
    ELSE
        PRINT "FAIL g_count="; g_count
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
