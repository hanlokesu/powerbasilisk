' PowerBasilisk Enhanced - Batch 68 Test: XPRINT ATTACH/CLOSE/GET PPI/GET SIZE/GET DC
' Uses screen DC as fallback when no printer is available (CI-friendly)
FUNCTION PBMAIN() AS LONG
    LOCAL hdc AS QUAD
    LOCAL hdc2 AS QUAD
    LOCAL px AS QUAD
    LOCAL py AS QUAD
    LOCAL pw AS QUAD
    LOCAL ph AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    fails = 0

    PRINT "=== Batch 68: XPRINT ==="

    ' 1. ATTACH DEFAULT (falls back to screen DC if no printer)
    XPRINT ATTACH DEFAULT
    PRINT "XPRINT ATTACH DEFAULT: done"

    ' 2. GET DC — should be non-zero
    XPRINT GET DC TO hdc
    PRINT "XPRINT GET DC: hdc="; hdc
    IF hdc = 0 THEN
        PRINT "  FAIL: hdc is zero"
        fails = fails + 1
    ELSE
        PRINT "  PASS: hdc non-zero"
    END IF

    ' 3. GET PPI — screen is typically 96 DPI
    XPRINT GET PPI TO px, py
    PRINT "XPRINT GET PPI: x="; px; " y="; py
    IF px = 0 OR py = 0 THEN
        PRINT "  FAIL: PPI is zero"
        fails = fails + 1
    ELSE
        PRINT "  PASS: PPI non-zero"
    END IF

    ' 4. GET SIZE — physical width/height in pixels
    XPRINT GET SIZE TO pw, ph
    PRINT "XPRINT GET SIZE: w="; pw; " h="; ph
    IF pw = 0 OR ph = 0 THEN
        PRINT "  FAIL: SIZE is zero"
        fails = fails + 1
    ELSE
        PRINT "  PASS: SIZE non-zero"
    END IF

    ' 5. CLOSE
    XPRINT CLOSE
    PRINT "XPRINT CLOSE: done"

    ' 6. GET DC after CLOSE — should be zero
    XPRINT GET DC TO hdc2
    PRINT "XPRINT GET DC (after close): hdc="; hdc2
    IF hdc2 <> 0 THEN
        PRINT "  FAIL: hdc should be zero after close"
        fails = fails + 1
    ELSE
        PRINT "  PASS: hdc zero after close"
    END IF

    PRINT "=== Result: ";
    IF fails = 0 THEN
        PRINT "ALL PASS (5/5)"
    ELSE
        PRINT fails; " FAILED"
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
