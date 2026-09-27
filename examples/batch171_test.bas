'=====================================================================
' batch171_test.bas - batch 171: CHR$() on a BYTE-typed argument
'---------------------------------------------------------------------
' Batch 171 did two things: it wrote the three samples that batches 167/168/169
' had been missing, and it fixed a real defect - CHR$() called with a BYTE-typed
' argument emitted illegal IR (a to_i32 on an already-32-bit value), which broke
' the build for a legal program.
'
' This sample is the regression witness for the second half: CHR$ takes a BYTE
' and must produce the character that byte names.  The HEADER item-index half of
' the batch is covered by the 167/168/169 samples this batch wrote.
'
' Asserts: CHR$(65) = "A" and CHR$(90) = "Z".
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL b AS BYTE
    LOCAL s AS STRING
    b = 65
    s = CHR$(b)
    PRINT "CHR$(65) = "; s
    IF s <> "A" THEN
        fail = fail + 1
    END IF
    b = 90
    s = CHR$(b)
    PRINT "CHR$(90) = "; s
    IF s <> "Z" THEN
        fail = fail + 1
    END IF
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
