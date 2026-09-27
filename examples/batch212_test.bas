#COMPILE EXE
' =====================================================================
' batch212_test.bas - witness for "CLASS ... INSTANCE" real storage
' ---------------------------------------------------------------------
' What this asserts, and nothing else:
'   * a CLASS whose INSTANCE lines declare members now produces a real
'     object type, so two variables of that type keep INDEPENDENT values
'   * each member keeps its own slot (x and y do not alias)
'   * a member can be read back after a whole-object copy
' The official CLASS page shows exactly this shape:
'   CLASS name / INSTANCE var AS type / END CLASS
' =====================================================================
CLASS Point
    INSTANCE x AS LONG
    INSTANCE y AS LONG
END CLASS

FUNCTION PBMAIN() AS LONG
    LOCAL p AS Point
    LOCAL q AS Point
    LOCAL fails AS LONG
    LOCAL t AS Point

    fails = 0
    p.x = 11
    p.y = 22
    q.x = 33
    q.y = 44

    PRINT "p = "; p.x; ","; p.y
    PRINT "q = "; q.x; ","; q.y

    IF p.x <> 11 THEN fails = fails + 1
    IF p.y <> 22 THEN fails = fails + 1
    IF q.x <> 33 THEN fails = fails + 1
    IF q.y <> 44 THEN fails = fails + 1
    ' per-object independence: q.x must not have touched p.x
    IF p.x = q.x THEN fails = fails + 1
    ' member slots do not alias inside one object
    IF p.x = p.y THEN fails = fails + 1

    t = p
    PRINT "t = "; t.x; ","; t.y
    IF t.y <> 22 THEN fails = fails + 1

    PRINT "=== FAILURES:"; fails; "==="
    FUNCTION = 0
END FUNCTION
