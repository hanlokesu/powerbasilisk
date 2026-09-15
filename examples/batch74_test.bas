' PowerBasilisk Enhanced - Batch 74 Test: XPRINT printer properties SET/GET
FUNCTION PBMAIN() AS LONG
    LOCAL v AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 74: XPRINT printer properties ==="

    XPRINT ATTACH DEFAULT

    XPRINT SET COPIES 3
    XPRINT GET COPIES TO v
    PRINT "COPIES:"; v
    IF v <> 3 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET ORIENTATION 2
    XPRINT GET ORIENTATION TO v
    PRINT "ORIENTATION:"; v
    IF v <> 2 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET QUALITY 3
    XPRINT GET QUALITY TO v
    PRINT "QUALITY:"; v
    IF v <> 3 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET DUPLEX 1
    XPRINT GET DUPLEX TO v
    PRINT "DUPLEX:"; v
    IF v <> 1 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET COLLATE 1
    XPRINT GET COLLATE TO v
    PRINT "COLLATE:"; v
    IF v <> 1 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET COLORMODE 1
    XPRINT GET COLORMODE TO v
    PRINT "COLORMODE:"; v
    IF v <> 1 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET PAGES 5
    XPRINT GET PAGES TO v
    PRINT "PAGES:"; v
    IF v <> 5 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT CLOSE

    PRINT "=== Result: ";
    IF fails = 0 THEN
        PRINT "ALL PASS (7 SET/GET pairs)"
    ELSE
        PRINT fails; " FAILED"
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
