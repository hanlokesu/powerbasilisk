' PowerBasilisk Enhanced - Batch 66 test
' GRAPHIC SET FIXED + GRAPHIC SET FONT
FUNCTION PBMAIN() AS LONG
    LOCAL hBmp AS QUAD
    LOCAL hFont AS QUAD
    LOCAL ok AS LONG
    LOCAL waitk AS STRING
    ok = 0

    GRAPHIC BITMAP NEW 100, 50 TO hBmp
    GRAPHIC ATTACH hBmp

    ' SET FIXED (no-arg, restores fixed mode)
    GRAPHIC SET FIXED
    ok = ok + 1

    ' FONT NEW returns a handle via TO clause
    FONT NEW "Arial", 12, 0, 0, 0, 0 TO hFont
    IF hFont <> 0 THEN ok = ok + 1 ELSE PRINT "FAIL: FONT NEW returned 0" END IF

    ' SET FONT selects the font into the graphic DC
    GRAPHIC SET FONT hFont
    ok = ok + 1

    ' Draw text with the selected font (should not crash)
    GRAPHIC PRINT "Hello"
    ok = ok + 1

    ' FONT END deletes the font
    FONT END hFont
    ok = ok + 1

    IF ok = 5 THEN
        PRINT "ALL PASS (5/5)"
    ELSE
        PRINT "FAIL: "; ok
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
