'=====================================================================
' PBXB64 Example - batch 216 witness: a METHOD changes the object it was
' called on, and two objects keep separate state.
'---------------------------------------------------------------------
' Before batch 216 a METHOD inside a CLASS could not touch INSTANCE fields
' at all.  A bare field name in the body missed the symbol table, fell
' through to the auto-declare path and became a fresh zero-initialised
' local: the method ran, reported success, and the object was unchanged.
' Measured on the pre-batch-216 compiler (same shape as this file):
'   dotted a.v =11   dotted b.v =22
'   method set =33   method get =0   dotted after method: a.v =11
'
' What this witness pins down:
'   * the implicit BYREF receiver: <Class>_<Method>(object, args)
'   * a bare INSTANCE field name in a method body means this.<field>,
'     on both sides - writing (SetIt) and reading (GetIt)
'   * per-object state: a.v and b.v move independently
' Expected output (run mode):
'   a.v after SetIt(33) = 33
'   b.v untouched       = 22
'   a.v via GetIt()     = 33
'   b.v via GetIt()     = 22
'   === FAILURES:0 ===
' Complexity: O(1) - four field reads, five comparisons.
'=====================================================================
#COMPILE EXE
CLASS Box
    INSTANCE v AS LONG
    METHOD SetIt(n AS LONG) AS LONG
        v = n
        FUNCTION = v
    END METHOD
    METHOD GetIt() AS LONG
        FUNCTION = v
    END METHOD
END CLASS

FUNCTION PBMAIN() AS LONG
    LOCAL a AS Box
    LOCAL b AS Box
    LOCAL got AS LONG
    LOCAL fails AS LONG

    a.v = 11
    b.v = 22

    got = Box_SetIt(a, 33)
    PRINT "a.v after SetIt(33) ="; a.v
    PRINT "b.v untouched       ="; b.v
    PRINT "a.v via GetIt()     ="; Box_GetIt(a)
    PRINT "b.v via GetIt()     ="; Box_GetIt(b)

    IF got <> 33 THEN fails = fails + 1
    IF a.v <> 33 THEN fails = fails + 1
    IF b.v <> 22 THEN fails = fails + 1
    IF Box_GetIt(a) <> 33 THEN fails = fails + 1
    IF Box_GetIt(b) <> 22 THEN fails = fails + 1

    IF fails = 0 THEN
        PRINT "=== FAILURES:0 ==="
    ELSE
        PRINT "=== FAILURES:"; fails; " ==="
    END IF
    FUNCTION = 0
END FUNCTION
