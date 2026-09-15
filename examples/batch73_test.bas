' PowerBasilisk Enhanced - Batch 73 Test: XPRINT POLYGON / POLYLINE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 73: XPRINT polygon + polyline ==="

    XPRINT ATTACH DEFAULT

    XPRINT COLOR 255, 0
    XPRINT POLYGON 100, 100, 200, 100, 150, 50
    PRINT "POLYGON (triangle): done"

    XPRINT COLOR 0, 255
    XPRINT POLYLINE 50, 200, 100, 250, 150, 200, 200, 250, 250, 200
    PRINT "POLYLINE (5 pts): done"

    XPRINT COLOR 0, 0, 255
    XPRINT POLYGON 300, 100, 400, 100, 400, 200, 300, 200
    PRINT "POLYGON (rect): done"

    XPRINT CLOSE

    PRINT "=== Result: ALL PASS (GDI calls returned, no crash)"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
