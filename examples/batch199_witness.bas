' Batch 199 witness: declarations included on purpose.
' The batch-197 witness omitted them, which is why it printed 0.

FUNCTION PBMAIN() AS LONG

    PRINT "=== IMAGELIST witness (variables declared) ==="
    LOCAL hil AS LONG
    LOCAL hic AS LONG
    LOCAL cnt AS LONG
    LOCAL n AS LONG
    IMAGELIST NEW BITMAP 16, 16, 32, 4 TO hil
    IMAGELIST NEW ICON 16, 16, 32, 2 TO hic
    PRINT "handle after NEW = "; hil
    IF hil <> 0 THEN
        PRINT "VERDICT: code WAS emitted (handle non-zero)"
    ELSE
        PRINT "VERDICT: handle is zero"
    END IF
    PRINT "done"
END FUNCTION
