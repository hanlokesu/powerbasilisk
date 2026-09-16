' PowerBasilisk Enhanced - Batch 75 Test: XPRINT CELL/SELECTION/PAPER/TRAY + RESOURCE SAVE FILE
FUNCTION PBMAIN() AS LONG
    LOCAL v AS LONG
    LOCAL cx AS LONG, cy AS LONG
    LOCAL sel AS STRING
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 75: XPRINT cell + selection + paper + tray + resource ==="

    XPRINT ATTACH DEFAULT

    XPRINT CELL 5, 10
    PRINT "CELL: set (5,10) - no crash"

    XPRINT GET SELECTION TO sel$
    PRINT "SELECTION: ["; sel$; "]"
    IF sel$ <> "" THEN fails = fails + 1 : PRINT "  FAIL (expected empty)"

    XPRINT SET PAPER 9
    XPRINT GET PAPER TO v
    PRINT "PAPER:"; v
    IF v <> 9 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET TRAY 3
    XPRINT GET TRAY TO v
    PRINT "TRAY:"; v
    IF v <> 3 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT CLOSE

    RESOURCE SAVE FILE "TEST", "test_resource.tmp"
    PRINT "RESOURCE SAVE FILE: done"

    PRINT "=== Result: ";
    IF fails = 0 THEN
        PRINT "ALL PASS"
    ELSE
        PRINT fails; " FAILED"
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
