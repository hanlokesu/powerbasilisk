'=====================================================================
' PBXB64 Example - batch 214 witness 2: top-level METHOD keeps its type
'---------------------------------------------------------------------
' `METHOD Test(v AS LONG) AS LONG` written outside a CLASS is a SUB
' equivalent with a return type.  Batch 159 routed this through
' parse_sub_decl(), which has no `AS type` handling, so the return type
' was dropped and the call silently produced 0; batch 214 sends the arm
' through parse_method_decl() instead.
' Expected output (run mode):
'   triple = 30
'=====================================================================
#COMPILE EXE
METHOD Triple(v AS LONG) AS LONG
    FUNCTION = v * 3
END METHOD

FUNCTION PBMAIN() AS LONG
    PRINT "triple ="; Triple(10)
    FUNCTION = 0
END FUNCTION
