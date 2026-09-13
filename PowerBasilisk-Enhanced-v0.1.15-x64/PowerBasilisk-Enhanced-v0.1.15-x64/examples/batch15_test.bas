FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL s AS STRING
    LOCAL f AS LONG
    LOCAL content AS STRING
    LOCAL w AS LONG
    LOCAL h AS LONG
    LOCAL f10 AS STRING * 10
    LOCAL ok AS LONG
    ok = 0

    ' MKBYT$ - 1-byte binary string
    s = MKBYT$(65)
    IF LEN(s) <> 1 THEN ok = ok + 1
    IF ASC(s) <> 65 THEN ok = ok + 10

    ' CSET - center in fixed-length string
    CSET f10 = "AB"
    IF LEFT$(f10, 4) <> "    " THEN ok = ok + 100
    IF RIGHT$(f10, 4) <> "    " THEN ok = ok + 1000

    ' PUT$ / GET$ - binary string I/O
    f = FREEFILE
    OPEN "b15_tmp.dat" FOR BINARY AS #f
    PUT$ #f, "Hello12345"
    SEEK #f, 1
    GET$ #f, 5, content
    IF content <> "Hello" THEN ok = ok + 10000
    CLOSE #f
    KILL "b15_tmp.dat"

    ' DESKTOP GET SIZE
    DESKTOP GET SIZE TO w, h
    IF w <= 0 OR h <= 0 THEN ok = ok + 100000

    IF ok = 0 THEN
        PRINT "BATCH15 ALL PASS"
        FUNCTION = 0
    ELSE
        PRINT "BATCH15 FAIL code="; ok
        FUNCTION = 1
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
