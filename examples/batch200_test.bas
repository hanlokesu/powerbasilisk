'=====================================================================
' PowerBasilisk - batch 200 test: the 64-bit handle must reach the variable
'---------------------------------------------------------------------
' Purpose:   pin the batch 200e defect and its fix.  Before the fix, a handle assigned to a
'            variable never arrived: the generated code stored 8 bytes into a 4-byte slot, the
'            backend saw an out-of-bounds store and dropped it, so the variable stayed 0.
' Note:      an ImageList handle is pointer-sized (64-bit here), so the variable that holds it
'            must be QUAD - a LONG truncates it and later calls get an invalid handle.
' Asserts:   1. the handle is non-zero after IMAGELIST NEW
'            2. the handle still works: GET COUNT on it, then KILL
' Expected:  every printed value non-zero; count of a fresh list is 0 (correct).
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL hil AS QUAD
    LOCAL cnt AS LONG
    IMAGELIST NEW BITMAP 16, 16, 32, 4 TO hil
    PRINT "QUAD handle  = "; hil
    IF hil = 0 THEN
        PRINT "FAIL: handle lost (batch 200e defect)"
        FUNCTION = 1
        EXIT FUNCTION
    END IF
    IMAGELIST GET COUNT hil TO cnt
    PRINT "GET COUNT    = "; cnt
    PRINT "PASS: handle survived and the list is usable"
    IMAGELIST KILL hil
    FUNCTION = 0
END FUNCTION
