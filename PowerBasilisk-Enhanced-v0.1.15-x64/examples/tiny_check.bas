' tiny_check.bas  
' BEEP, SWAP, SLEEP, MKDIR, RMDIR, RANDOMIZE
'  tiny_result.txt MSGBOX

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL p AS STRING
    LOCAL f AS LONG
    LOCAL ok AS LONG

    ok = 1

    ' 1. RANDOMIZE  
    RANDOMIZE 42

    ' 2. MKDIR  
    p = "tiny_demo_dir"
    MKDIR p
    IF ISFILE(p) = 0 THEN ok = 0

    ' 3. SWAP  
    a = 111
    b = 222
    SWAP a, b
    IF a <> 222 OR b <> 111 THEN ok = 0

    ' 4. BEEP  
    BEEP

    ' 5. SLEEP   300ms
    SLEEP 300

    ' 6. RMDIR  
    RMDIR p
    IF ISFILE(p) <> 0 THEN ok = 0

    ' 
    f = FREEFILE
    OPEN "tiny_result.txt" FOR OUTPUT AS #f
    IF ok = 1 THEN
        PRINT #f, "ALL OK: swap=" + STR$(a) + "," + STR$(b) + " rand+mkdir+beep+sleep+rmdir ran"
    ELSE
        PRINT #f, "FAILED: a=" + STR$(a) + " b=" + STR$(b)
    END IF
    CLOSE #f

    FUNCTION = 0
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
