'=====================================================================
' batch208_test.bas - batch 208: module-level UDT still compiles
'---------------------------------------------------------------------
' Batch 208 made a bare `TYPE` inside a procedure body a loud compile error
' instead of silently skipping the line, and its own reverse validation was that
' a *module-level* TYPE ... END TYPE block keeps working.  That probe lived in
' the work directory; this sample puts the same assertion in the corpus so the
' release gate runs it on every batch.
'
' The negative half of the batch (a bare TYPE in a body must fail the build) is
' a compile-time assertion and cannot appear here - a sample that does not
' compile cannot be a sample.  It stays in the batch note.
'
' Asserts: a module-level UDT declares, fields assign and read back.
'=====================================================================
TYPE Point
    x AS LONG
    y AS LONG
END TYPE

FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL p AS Point
    p.x = 3
    p.y = 4
    PRINT "point = "; p.x; ","; p.y
    IF p.x <> 3 THEN
        fail = fail + 1
    END IF
    IF p.y <> 4 THEN
        fail = fail + 1
    END IF
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
