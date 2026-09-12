' OPEN FOR BINARY: existing file must NOT be truncated (PB semantics)
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f AS LONG
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL buf AS STRING * 6
    ' Step 1: create a file with 6 bytes of text
    f = FREEFILE
    OPEN "bin_test.dat" FOR OUTPUT AS #f
    PRINT #f, "ABCDEF"
    CLOSE #f
    ' Step 2: reopen BINARY (must keep existing content), read back, then append
    f = FREEFILE
    OPEN "bin_test.dat" FOR BINARY AS #f
    buf = ""
    GET #f, 1, buf
    a = 99
    PUT #f, 9, a
    CLOSE #f
    ' Step 3: reopen BINARY again and verify both parts
    f = FREEFILE
    OPEN "bin_test.dat" FOR BINARY AS #f
    buf = ""
    GET #f, 1, buf
    b = 0
    GET #f, 9, b
    CLOSE #f
    KILL "bin_test.dat"
    IF buf = "ABCDEF" AND b = 99 THEN
        PRINT "BINARY-PASS"
    ELSE
        PRINT "BINARY-FAIL buf="; buf; " b="; b
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
