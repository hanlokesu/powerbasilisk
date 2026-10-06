'=====================================================================
' PBXB64 Example - batch 214 witness 2: a top-level METHOD keeps its type
'---------------------------------------------------------------------
' `METHOD Triple(v AS LONG) AS LONG` written outside a CLASS is a SUB
' equivalent that still returns a value.  Batch 159 routed this arm through
' parse_sub_decl(), which has no `AS type` handling, so the return type was
' dropped and the call silently produced 0; batch 214 sends the arm through
' parse_method_decl() instead.
' Expected output (run mode):
'   triple =30
'   === FAILURES:0 ===
'=====================================================================
#COMPILE EXE
METHOD Triple(v AS LONG) AS LONG
    FUNCTION = v * 3
END METHOD

FUNCTION PBMAIN() AS LONG
    LOCAL got AS LONG
    got = Triple(10)
    PRINT "triple ="; got
    IF got = 30 THEN
        PRINT "=== FAILURES:0 ==="
    ELSE
        PRINT "=== FAILURES:1 ==="
    END IF
    FUNCTION = 0
' Press any key to exit...
WAITKEY$
END FUNCTION
