'=====================================================================
' PBXB64 Example - batch 214 witness: CLASS with a real METHOD block
'---------------------------------------------------------------------
' Demonstrates:
'   * METHOD Name [(params)] [AS type] ... END METHOD inside CLASS
'   * the method leaves the parser as an ordinary FUNCTION named
'     <Class>_<Method> (here Point_Twice), so codegen needs no new
'     machinery - register_function already handles that shape
'   * END METHOD is a real block terminator, and the return type is
'     honoured (before batch 214 the class body was skipped line by line)
' Expected output (run mode):
'   twice = 42
' Complexity: O(1) - one multiply, one console write.
'=====================================================================
#COMPILE EXE
CLASS Point
    INSTANCE x AS LONG
    METHOD Twice(v AS LONG) AS LONG
        FUNCTION = v * 2
    END METHOD
END CLASS

FUNCTION PBMAIN() AS LONG
    PRINT "twice ="; Point_Twice(21)
    FUNCTION = 0
END FUNCTION
