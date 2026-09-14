' PowerBasilisk Enhanced - batch48_test.bas
' IMAGELIST NEW / GET COUNT / KILL (tier-3 -> implemented, batch 48)
' NOTE: IMAGELIST NEW's initial& parameter is the INITIAL CAPACITY, not the
' image count (ImageList_Create semantics) — a fresh list has GET COUNT = 0.
FUNCTION PBMAIN() AS LONG
    LOCAL himl AS QUAD
    LOCAL cnt AS LONG
    LOCAL waitk AS STRING
    LOCAL fails AS LONG

    ' IMAGELIST NEW BITMAP 16, 16, 24, 2 TO himl
    IMAGELIST NEW BITMAP 16, 16, 24, 2 TO himl
    IF himl = 0 THEN
        PRINT "FAIL: imagelist handle is zero"
        INCR fails
    ELSE
        PRINT "OK: imagelist handle "; himl
    END IF

    ' IMAGELIST GET COUNT himl TO cnt — empty list => 0
    IMAGELIST GET COUNT himl TO cnt
    IF cnt <> 0 THEN
        PRINT "FAIL: count="; cnt; " expected 0 (empty list)"
        INCR fails
    ELSE
        PRINT "OK: imagelist count="; cnt; " (empty list)"
    END IF

    ' IMAGELIST KILL himl
    IMAGELIST KILL himl
    PRINT "OK: imagelist killed"

    IF fails = 0 THEN
        PRINT "batch48: ALL PASS"
    ELSE
        PRINT "batch48: FAILURES="; fails
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
