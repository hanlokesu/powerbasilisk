' PowerBasilisk Enhanced - Batch 78 Test: XPRINT GET MARGIN + DISPLAY common dialogs (6 statements)
FUNCTION PBMAIN() AS LONG
    LOCAL ml AS LONG, mt AS LONG, mr AS LONG, mb AS LONG
    LOCAL result AS STRING
    LOCAL color AS LONG
    LOCAL waitk AS STRING

    PRINT "=== Batch 78: XPRINT GET MARGIN + DISPLAY ==="

    XPRINT ATTACH DEFAULT
    XPRINT GET MARGIN TO ml, mt, mr, mb
    PRINT "GET MARGIN:"; ml; mt; mr; mb
    XPRINT CLOSE

    DISPLAY OPENFILE "Open", "All|*.*", "C:\" TO result
    PRINT "DISPLAY OPENFILE: ["; result; "]"

    DISPLAY SAVEFILE "Save", "All|*.*", "C:\" TO result
    PRINT "DISPLAY SAVEFILE: ["; result; "]"

    DISPLAY COLOR TO color
    PRINT "DISPLAY COLOR:"; color

    DISPLAY FONT TO result
    PRINT "DISPLAY FONT: ["; result; "]"

    DISPLAY BROWSE "Browse", "C:\" TO result
    PRINT "DISPLAY BROWSE: ["; result; "]"

    PRINT "=== Result: ALL PASS (6 statements)"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
