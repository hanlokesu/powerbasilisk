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

    ' Official PROGRESSBAR syntax is PROGRESSBAR <GET|SET> <POS|RANGE> hDlg, id&, ...
    ' There is no dialog in this console sample, so the calls resolve to no
    ' control and return 0 - the point here is that they compile and link.
    PROGRESSBAR SET RANGE 0, 101, 0, 100
    PROGRESSBAR SET POS 0, 101, 50
    PROGRESSBAR SET STEP 0, 101, 5
    PROGRESSBAR STEP 0, 101
    PROGRESSBAR STEP 0, 101, 2
    PRINT "PROGRESSBAR: done"

    ' Official HEADER syntax is HEADER SEND hWin, ID&, Msg&, wParam&, lParam& [TO res&].
    HEADER SEND 0, 102, &H1200, 0, 0
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
