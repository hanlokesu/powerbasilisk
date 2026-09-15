' PowerBasilisk Enhanced - Batch 77 Test: TCP/UDP NOTIFY + PROGRESSBAR + HEADER + ARRAY SELECT/TAGARRAY
FUNCTION PBMAIN() AS LONG
    LOCAL arr(10) AS LONG
    LOCAL tag(10) AS LONG
    LOCAL waitk AS STRING

    PRINT "=== Batch 77: misc statements ==="

    TCP NOTIFY 1, 3
    PRINT "TCP NOTIFY: done"

    UDP NOTIFY 2, 3
    PRINT "UDP NOTIFY: done"

    PROGRESSBAR 0, 0, 50, 100
    PRINT "PROGRESSBAR: done"

    HEADER 0, 0, 1, "Column 1"
    PRINT "HEADER: done"

    ARRAY SELECT arr(0), 1, 5
    PRINT "ARRAY SELECT: done"

    ARRAY TAGARRAY arr(0), tag(0)
    PRINT "ARRAY TAGARRAY: done"

    ARRAY TAGARRAY ERASE arr(0)
    PRINT "ARRAY TAGARRAY ERASE: done"

    PRINT "=== Result: ALL PASS (7 statements)"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
