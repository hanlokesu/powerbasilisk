' err_demo.bas  D- ERR  PB 
' MKDIR 75 / RMDIR 75 / CHDIR 76 / KILL 53
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f AS LONG
    LOCAL ok AS LONG
    LOCAL msg AS STRING

    ok = 1

    ' 1. MKDIR   ERR  75
    MKDIR "err_dir"
    MKDIR "err_dir"   ' 
    IF ERR <> 75 THEN
        msg = msg + "FAIL1: MKDIR exists ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    ERRCLEAR

    ' 2. RMDIR   ERR  75
    RMDIR "no_such_dir_abc"
    IF ERR <> 75 THEN
        msg = msg + "FAIL2: RMDIR missing ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    ERRCLEAR

    ' 3. CHDIR   ERR  76
    CHDIR "no_such_dir_def"
    IF ERR <> 76 THEN
        msg = msg + "FAIL3: CHDIR invalid ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    ERRCLEAR

    ' 4. KILL   ERR  53
    KILL "no_such_file.txt"
    IF ERR <> 53 THEN
        msg = msg + "FAIL4: KILL missing ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    ERRCLEAR

    ' 5.  ERR  0
    MKDIR "err_dir_new"
    IF ERR <> 0 THEN
        msg = msg + "FAIL5: MKDIR success ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    RMDIR "err_dir_new"   '  ERR  75

    ' 
    f = FREEFILE
    OPEN "err_result.txt" FOR OUTPUT AS #f
    IF ok = 1 THEN
        PRINT #f, "ALL OK: ERR semantics match official PB (75/75/76/53/0)"
    ELSE
        PRINT #f, "FAILED:" + msg
    END IF
    CLOSE #f

    ' 
    RMDIR "err_dir"

    FUNCTION = 0
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
