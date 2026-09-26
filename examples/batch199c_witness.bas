' batch 199c witness - handles held in QUAD (pointer-sized on x64)
FUNCTION PBMAIN () AS LONG
    LOCAL hil AS QUAD
    LOCAL hic AS QUAD
    LOCAL cnt AS LONG
    LOCAL k AS LONG
    PRINT "=== IMAGELIST witness (batch 199c) ==="
    IMAGELIST NEW BITMAP 16, 16, 32, 4 TO hil
    IMAGELIST NEW ICON 16, 16, 32, 4 TO hic
    PRINT "handle bitmap list = "; hil
    PRINT "handle icon   list = "; hic
    IMAGELIST GET COUNT hil TO cnt
    PRINT "GET COUNT hil      = "; cnt
    IMAGELIST KILL hil
    IMAGELIST KILL hic
    PRINT "killed both; done"
    FUNCTION = 0
END FUNCTION
