' PowerBasilisk Enhanced - Batch 69 Test: XPRINT drawing + text + attributes
FUNCTION PBMAIN() AS LONG
    LOCAL hdc AS QUAD
    LOCAL attached AS LONG
    LOCAL px AS LONG, py AS LONG
    LOCAL col AS LONG
    LOCAL pix AS LONG
    LOCAL ta AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 69: XPRINT drawing + text ==="

    XPRINT ATTACH DEFAULT
    XPRINT GET ATTACH TO attached
    PRINT "GET ATTACH:"; attached
    IF attached <> 1 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT GET DC TO hdc
    IF hdc = 0 THEN fails = fails + 1 : PRINT "  FAIL: dc zero"

    XPRINT SET POS 100, 100
    XPRINT GET POS TO px, py
    PRINT "SET/GET POS:"; px; py
    IF px <> 100 OR py <> 100 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT SET COLOR 255
    XPRINT GET COLOR TO col
    PRINT "SET/GET COLOR:"; col
    IF col <> 255 THEN fails = fails + 1 : PRINT "  FAIL"

    XPRINT WIDTH 3
    XPRINT STYLE 0
    XPRINT LINE 10, 10, 200, 200
    XPRINT BOX 10, 10, 200, 200
    PRINT "LINE/BOX: done"

    XPRINT SET PIXEL 50, 50, 255
    XPRINT GET PIXEL 50, 50 TO pix
    PRINT "SET/GET PIXEL:"; pix
    IF pix = -1 THEN fails = fails + 1 : PRINT "  FAIL (CLR_INVALID)"

    XPRINT SET TEXTALIGN 0
    XPRINT GET TEXTALIGN TO ta
    PRINT "SET/GET TEXTALIGN:"; ta

    XPRINT SET POS 50, 300
    XPRINT PRINT "Hello from XPRINT!"
    PRINT "XPRINT PRINT: done"

    XPRINT FORMFEED
    XPRINT GET POS TO px, py
    PRINT "FORMFEED resets pos:"; px; py

    XPRINT CANCEL
    PRINT "CANCEL: done"

    XPRINT CLOSE
    XPRINT GET ATTACH TO attached
    IF attached <> 0 THEN fails = fails + 1 : PRINT "  FAIL: still attached after close"

    PRINT "=== Result: ";
    IF fails = 0 THEN
        PRINT "ALL PASS"
    ELSE
        PRINT fails; " FAILED"
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
