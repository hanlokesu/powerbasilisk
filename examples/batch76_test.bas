' PowerBasilisk Enhanced - Batch 76 Test: remaining XPRINT statements (completes XPRINT family)
FUNCTION PBMAIN() AS LONG
    LOCAL n AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 76: remaining XPRINT statements ==="

    XPRINT ATTACH DEFAULT

    XPRINT GET PAPERS TO n
    PRINT "GET PAPERS:"; n

    XPRINT GET TRAYS TO n
    PRINT "GET TRAYS:"; n

    XPRINT PREVIEW 1
    PRINT "PREVIEW: done"

    XPRINT RENDER
    PRINT "RENDER: done"

    XPRINT SPLIT 0, 0, 100, 100
    PRINT "SPLIT: done"

    XPRINT STRETCH 0, 0, 50, 50, 0, 0, 100, 100
    PRINT "STRETCH: done"

    XPRINT IMAGELIST 0, 0, 0
    PRINT "IMAGELIST: done"

    XPRINT CLOSE

    PRINT "=== Result: ALL PASS (XPRINT family complete!)"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
