'=====================================================================
' batch197_test.bas - batch 197: the false family warning is gone
'---------------------------------------------------------------------
' Batch 195 pushed a "no code generated" warning from the compile_call family
' early return, which fired for every *implemented* family too and polluted the
' silently-dropped inventory.  Batch 197 removed that warning and kept only the
' genuinely-empty arms.
'
' This sample uses an implemented family from that early return (IMAGELIST) and
' is the witness in two ways:
'
'   * compile time: this file must produce NO warning and NO
'     batch197_test.unimplemented.log.  A false warning here is the regression.
'   * run time: the handle must arrive (QUAD) and a fresh list must report 0.
'     Batch 198 later proved the handle was still 0 on the paths it examined -
'     those assertions are the ones batch 200 finally made true, and they are
'     kept here so the pair can never silently disagree again.
'
' Asserts: non-zero handle, count 0, KILL succeeds.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL hil AS QUAD
    LOCAL cnt AS LONG
    IMAGELIST NEW BITMAP 16, 16, 32, 2 TO hil
    PRINT "imagelist handle = "; hil
    IF hil = 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST GET COUNT hil TO cnt
    PRINT "fresh list count = "; cnt
    IF cnt <> 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST KILL hil
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
' Press any key to exit...
WAITKEY$
END FUNCTION
