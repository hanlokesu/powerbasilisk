'=====================================================================
' batch209_test.bas - batch 209: the five parked drops report, exactly once each
'---------------------------------------------------------------------
' ACCEL ATTACH / EVENT SOURCE / EVENTS / RAISEEVENT / INSTANCE were parsed,
' compiled clean and produced no code - and the coverage table called them
' Implemented.  Batch 209 made the drop visible: the shared arm now pushes to
' compiler.warnings, which prints one summary line and one line per statement in
' batch209_test.unimplemented.log.
'
' The compile-time assertion (external to this file, because a warning cannot be
' observed from inside the program):
'
'   * exactly FOUR report lines here (this sample uses the four object-model
'     statements; batch210_test.bas adds ACCEL ATTACH for the fifth), and
'   * no duplicates - batch 195 pushed the same warning from two places and
'     batch 196 kept only one, so "how many lines" is a real regression signal.
'
' The run-time assertion is the positive control: the ImageList statement next
' to them must keep working while the reported ones stay parked.
'
' Asserts: the ImageList handle arrives and a fresh list reports count 0.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL hil AS QUAD
    LOCAL cnt AS LONG
    INSTANCE myObj AS MyClass
    EVENTS Click, Changed
    EVENT SOURCE 1
    RAISEEVENT Click
    IMAGELIST NEW BITMAP 16, 16, 32, 2 TO hil
    IMAGELIST GET COUNT hil TO cnt
    PRINT "imagelist handle = "; hil; "  count = "; cnt
    IF hil = 0 THEN
        fail = fail + 1
    END IF
    IF cnt <> 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST KILL hil
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
' Press any key to exit...
WAITKEY$
END FUNCTION
