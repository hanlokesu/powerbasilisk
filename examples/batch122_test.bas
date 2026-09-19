DEF fnSqr(x) = x * x
DEF fnAvg(x, y) = (x + y) / 2

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a AS LONG, b AS LONG
    LOCAL p AS LONG, o AS LONG

    PRINT "=== Batch 122: LET * + DEF inline expansion ==="
    LET *p = o
    PRINT "1 LET *p = o accepted OK"

    PRINT "2 fnSqr(5) ="; fnSqr(5)
    PRINT "3 fnSqr(9) ="; fnSqr(9)
    a = 20: b = 10
    PRINT "4 fnAvg(a,b) ="; fnAvg(a, b)

    PRINT ""
    PRINT "=== If 25, 81, 15 shown, DEF inline works ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
