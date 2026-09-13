#COMPILE EXE
TYPE MyType
    n AS LONG
    d AS DOUBLE
    s AS STRING * 12
END TYPE

FUNCTION IncStatic() AS LONG
    STATIC counter AS LONG
    counter = counter + 1
    FUNCTION = counter
END FUNCTION

FUNCTION PBMAIN() AS LONG
    LOCAL i AS LONG
    LOCAL a(4) AS LONG
    LOCAL b(4) AS LONG
    LOCAL t1 AS MyType
    LOCAL t2 AS MyType
    LOCAL title AS STRING

    PRINT "=== Batch 23: STATIC / ARRAY ASSIGN / WINDOW / TYPE SET ==="

    ' 1. STATIC persists across calls
    FOR i = 1 TO 3
        PRINT "IncStatic = "; IncStatic()
    NEXT i

    ' 2. ARRAY ASSIGN b() = a()
    a(0) = 10 : a(1) = 20 : a(2) = 30 : a(3) = 40 : a(4) = 50
    ARRAY ASSIGN b() = a()
    PRINT "b(0) = "; b(0); " b(4) = "; b(4)

    ' 3. WINDOW SET TEXT / WINDOW GET TEXT (console title)
    WINDOW SET TEXT 0, "PowerBasilisk Batch23"
    WINDOW GET TEXT 0 TO title
    PRINT "Title = "; title

    ' 4. TYPE SET from a TYPE variable
    t1.n = 123
    t1.d = 4.5
    t1.s = "hello"
    TYPE SET t2 = t1
    PRINT "t2.n = "; t2.n; " t2.d = "; t2.d; " t2.s = "; TRIM$(t2.s)

    ' 5. TYPE SET from a STRING (fills the UDT bytes)
    TYPE SET t2 = "TYPE SET FROM STRING"
    PRINT "t2.n(1st4 bytes) = "; t2.n

    PRINT "Press any key to exit..."
    WAITKEY$
END FUNCTION
