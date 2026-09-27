'=====================================================================
' batch193_test.bas - batch 193: 21 silent Noop sites now hard-fail
'---------------------------------------------------------------------
' Batch 193 turned the last 21 silently-dropped parser sites into loud compile
' errors (14 -> 3 silent sites, the three kept on purpose: bare TYPE at module
' level, #INCLUDE, one commented-out site).
'
' A hard error cannot appear inside a compiling sample, so this file is the
' *positive control*: the statements that share those code paths - a LET, a
' module-level UDT, METRICS, CHR$ and an ImageList handle - must still compile
' and still work.  If the batch had been over-tightened, one of these breaks and
' this sample stops building, which is exactly the signal we want.
'
' Asserts: LET binds, the UDT round-trips, METRICS is positive, CHR$ works and
' the ImageList handle arrives.
'=====================================================================
TYPE Pt
    x AS LONG
    y AS LONG
END TYPE

FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL v AS LONG
    LOCAL p AS Pt
    LOCAL hil AS QUAD
    LOCAL cnt AS LONG
    LET v = 41
    v = v + 1
    PRINT "LET 41+1     = "; v
    IF v <> 42 THEN
        fail = fail + 1
    END IF
    p.x = 3
    p.y = 4
    PRINT "UDT point    = "; p.x; ","; p.y
    IF p.x <> 3 THEN
        fail = fail + 1
    END IF
    IF METRICS(0) <= 0 THEN
        fail = fail + 1
    END IF
    IF CHR$(65) <> "A" THEN
        fail = fail + 1
    END IF
    IMAGELIST NEW BITMAP 16, 16, 32, 2 TO hil
    IMAGELIST GET COUNT hil TO cnt
    PRINT "imagelist hi = "; hil; "  count = "; cnt
    IF hil = 0 THEN
        fail = fail + 1
    END IF
    IF cnt <> 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST KILL hil
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
