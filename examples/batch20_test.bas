#COMPILE EXE
' batch20_test.bas - ARRAY ARRAYIX / ARRAY SCAN / ARRAY INSERT / ARRAY DELETE / FILESCAN
' Status changes (batch 20): ARRAY SCAN/INSERT/DELETE promoted to IMPLEMENTED (verified),
' ARRAY ARRAYIX and FILESCAN newly implemented.
FUNCTION PBMAIN() AS LONG
    DIM a(1 TO 5) AS LONG
    a(1) = 10
    a(2) = 20
    a(3) = 30
    a(4) = 25
    a(5) = 5
    ' ARRAY ARRAYIX: each element = its index
    ARRAY ARRAYIX a()
    PRINT "ARRAYIX=" + STR$(a(1)) + "," + STR$(a(2)) + "," + STR$(a(3)) + "," + STR$(a(4)) + "," + STR$(a(5))
    ' reset values
    a(1) = 10
    a(2) = 20
    a(3) = 30
    a(4) = 25
    a(5) = 5
    ' ARRAY SCAN
    DIM idx AS LONG
    ARRAY SCAN a(), > 20, TO idx
    PRINT "SCAN1=" + STR$(idx)
    ARRAY SCAN a(), = 25, TO idx
    PRINT "SCAN2=" + STR$(idx)
    ' ARRAY INSERT / DELETE
    ARRAY DELETE a(2) FOR 1
    PRINT "DEL=" + STR$(a(2)) + "," + STR$(a(3))
    ARRAY INSERT a(3), 99
    PRINT "INS=" + STR$(a(3)) + "," + STR$(a(4))
    ' FILESCAN (INPUT mode)
    OPEN "b20_scan.txt" FOR OUTPUT AS #1
    PRINT #1, "line one"
    PRINT #1, "two"
    PRINT #1, "three words here"
    CLOSE #1
    DIM nrec AS LONG
    DIM wid AS LONG
    OPEN "b20_scan.txt" FOR INPUT AS #1
    FILESCAN #1, RECORDS TO nrec, WIDTH TO wid
    PRINT "FSCAN=" + STR$(nrec) + "," + STR$(wid)
    CLOSE #1
    KILL "b20_scan.txt"
    FUNCTION = 0
END FUNCTION
