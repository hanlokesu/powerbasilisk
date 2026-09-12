' stmt_batch1.bas  test CLS / ERROR / ENVIRON / FILECOPY / SETATTR
' Compile: pbcompiler build stmt_batch1.bas --exe --target x86_64-pc-windows-msvc --runtime-lib pb_runtime_x64.obj
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING

    ' 1. ERROR n  set PB error code, readable via ERR
    ERRCLEAR
    ERROR 75
    IF ERR = 75 THEN
        PRINT "ERROR: OK"
    ELSE
        PRINT "ERROR: FAIL got "; ERR
    END IF

    ' 2. ENVIRON "VAR=value"  set env var, read back via ENVIRON$
    ENVIRON "PB_TEST_VAR=hello123"
    IF ENVIRON$("PB_TEST_VAR") = "hello123" THEN
        PRINT "ENVIRON: OK"
    ELSE
        PRINT "ENVIRON: FAIL got "; ENVIRON$("PB_TEST_VAR")
    END IF

    ' 3. FILECOPY src$, dst$  copy file, ERR = 0 on success
    OPEN "fc_src.txt" FOR OUTPUT AS #1
    PRINT #1, "filecopy test data"
    CLOSE #1
    ERRCLEAR
    FILECOPY "fc_src.txt", "fc_dst.txt"
    IF ERR = 0 AND ISFILE("fc_dst.txt") THEN
        PRINT "FILECOPY: OK"
    ELSE
        PRINT "FILECOPY: FAIL err="; ERR
    END IF

    ' 4. SETATTR "path", attr&  set hidden attribute (2), ERR = 0 on success
    ERRCLEAR
    SETATTR "fc_dst.txt", 2
    IF ERR = 0 THEN
        PRINT "SETATTR: OK"
    ELSE
        PRINT "SETATTR: FAIL err="; ERR
    END IF

    ' 5. CLS  clear console (no assertion; must compile & run without crash)
    CLS
    PRINT "CLS: OK"

    KILL "fc_src.txt"
    KILL "fc_dst.txt"

    PRINT "ALL DONE"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
