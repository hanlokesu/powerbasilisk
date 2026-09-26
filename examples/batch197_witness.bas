' Batch 197 witness: does IMAGELIST NEW really emit code?
' If the statement is implemented the handle below is non-zero; if it is inert it is 0.

FUNCTION PBMAIN() AS LONG
    LOCAL h AS LONG
    LOCAL n AS LONG
    LOCAL waitk AS STRING
    PRINT "=== Batch 197 IMAGELIST witness ==="

    PRINT "--- statements from the repo's own sample ---"
    IMAGELIST NEW BITMAP 16, 16, 32, 4 TO hil
    IMAGELIST NEW ICON 16, 16, 32, 2 TO hic
    IMAGELIST KILL hil
    IMAGELIST KILL hic
    PRINT "handle after NEW = "; hil
    IF hil <> 0 THEN
        PRINT "VERDICT: code WAS emitted (handle non-zero)"
    ELSE
        PRINT "VERDICT: statement really is inert (handle 0)"
    END IF
    PRINT "done"
END FUNCTION
