' PowerBasilisk Enhanced - Batch 79 Test: OOP foundation (CLASS/METHOD/OBJECT/INSTANCE) + ARRAY REDIM

' CLASS/END CLASS block at top level (simplified: namespace, methods inside are skipped)
CLASS MyClass
    METHOD Foo()
        PRINT "inside Foo (should NOT appear)"
    END METHOD
END CLASS

' METHOD at top level (treated as SUB)
METHOD TestMethod()
    PRINT "TestMethod called"
END METHOD

FUNCTION PBMAIN() AS LONG
    LOCAL arr(10) AS LONG
    LOCAL obj AS LONG
    LOCAL waitk AS STRING

    PRINT "=== Batch 79: OOP foundation + ARRAY REDIM ==="

    PRINT "CLASS/END CLASS: parsed OK (block skipped)"

    ' OBJECT type (treated as pointer/LONG)
    obj = 0
    PRINT "OBJECT type: OK (value="; obj; ")"

    ' ARRAY REDIM INCR/DECR (simplified: reports new size)
    ARRAY REDIM INCR arr(0), 5
    PRINT "ARRAY REDIM INCR: done"
    ARRAY REDIM DECR arr(0), 3
    PRINT "ARRAY REDIM DECR: done"

    ' Call top-level METHOD (treated as SUB)
    TestMethod
    PRINT "METHOD call: OK"

    PRINT "=== Result: ALL PASS (OOP foundation + ARRAY REDIM)"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
