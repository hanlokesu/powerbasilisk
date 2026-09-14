' PowerBasilisk Enhanced - batch 44: SWITCH / SWITCH$ / HI / LO / FILEATTR / FILENAME$ / PATHSCAN$
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        PRINT "FAIL: "; msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL n AS LONG
    LOCAL s AS STRING
    LOCAL f AS LONG
    LOCAL h AS LONG
    failures = 0

    ' SWITCH: first true condition returns its value
    n = SWITCH(1, 100, 2, 200, 3, 300)
    Check(n = 100, "switch first")
    n = SWITCH(0, 100, 1, 200, 3, 300)
    Check(n = 200, "switch second")
    n = SWITCH(0, 100, 0, 200, 0, 300)
    Check(n = 0, "switch none -> 0")

    ' SWITCH$: string variant
    s = SWITCH$(1, "one", 2, "two", 3, "three")
    Check(s = "one", "switch$ first")
    s = SWITCH$(0, "one", 0, "two", 0, "three")
    Check(s = "", "switch$ none -> empty")

    ' HI / LO
    n = HI(BYTE, &H1234)
    Check(n = &H12, "hi byte")
    n = LO(BYTE, &H1234)
    Check(n = &H34, "lo byte")
    n = HI(WORD, &H12345678)
    Check(n = &H1234, "hi word")
    n = LO(WORD, &H12345678)
    Check(n = &H5678, "lo word")
    n = HI(LONG, &H12345678)
    Check(n = 0, "hi long")
    n = LO(LONG, &H12345678)
    Check(n = &H12345678, "lo long")

    ' FILEATTR / FILENAME$: open the runtime obj as BINARY
    OPEN "pbcompiler\runtime\pb_runtime_x64.obj" FOR BINARY AS #1
    f = FILEATTR(#1, 0)
    Check(f <> 0, "fileattr open")
    f = FILEATTR(#1, 1)
    Check(f = 32, "fileattr mode binary")
    f = FILEATTR(#1, 2)
    Check(f > 0, "fileattr os handle")
    s = FILENAME$(1)
    Check(INSTR(s, "pb_runtime_x64.obj") > 0, "filename$")
    CLOSE #1
    f = FILEATTR(1, 0)
    Check(f = 0, "fileattr closed")

    ' PATHSCAN$: verify existence and resolve parts
    s = PATHSCAN$(NAME, "pb_runtime_x64.obj", "pbcompiler\runtime")
    Check(s = "pb_runtime_x64", "pathscan name")
    s = PATHSCAN$(EXTN, "pb_runtime_x64.obj", "pbcompiler\runtime")
    Check(s = ".obj", "pathscan extn")
    s = PATHSCAN$(NAME, "no_such_file_xyz.obj", "pbcompiler\runtime")
    Check(s = "", "pathscan missing")

    IF failures = 0 THEN
        PRINT "batch44: ALL PASS"
    ELSE
        PRINT "batch44: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
