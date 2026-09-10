' GET/PUT binary file I/O + list declarations (LOCAL a, b AS TYPE)
FUNCTION PBMAIN() AS LONG
    LOCAL f, a, b AS LONG
    LOCAL q1, q2 AS QUAD
    f = FREEFILE
    OPEN "getput_test.dat" FOR BINARY AS #f
    a = 123456789
    PUT #f, 1, a
    b = 0
    GET #f, 1, b
    q1 = 987654321012345
    PUT #f, 9, q1
    q2 = 0
    GET #f, 9, q2
    CLOSE #f
    KILL "getput_test.dat"
    IF b = 123456789 AND q2 = 987654321012345 THEN
        PRINT "GETPUT-PASS b="; b; " q="; q2
    ELSE
        PRINT "GETPUT-FAIL b="; b; " q="; q2
    END IF
END FUNCTION
