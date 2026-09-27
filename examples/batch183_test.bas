'=====================================================================
' batch183_test.bas - batch 183: GRAPHIC BITMAP out-parameters
'---------------------------------------------------------------------
' The GRAPHIC BITMAP capture/load arms wrote their handle straight into the
' destination slot instead of routing the value through convert_value, so the
' pointer-sized handle was stored as if it were 32 bits.  Batch 183 fixed both
' sites (and widened sweep_handle_width.py, which had been blind to the shape).
'
' This sample is the witness: the handle must *arrive* in a QUAD variable
' (a LONG would truncate it - the batch 200 lesson) and be non-zero.
'
' Asserts: the bitmap handle is non-zero.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL hbmp AS QUAD
    GRAPHIC BITMAP NEW 100, 50 TO hbmp
    PRINT "bitmap handle = "; hbmp
    IF hbmp = 0 THEN
        fail = fail + 1
    END IF
    GRAPHIC BITMAP END
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
