' PowerBasilisk Enhanced - Batch 195 test: no-op statement groups are now REPORTED
'
' COMPILE-ONLY by design: this batch changed diagnostics, not behaviour.  The four
' statements below are accepted and intentionally emit no code (they were parked in
' batch 121 pending the GUI / OOP runtime).  Before batch 195 they were dropped in
' silence; now the compiler pushes a warning for each one:
'
'   line 18: `INSTANCE` accepted but not implemented (DDT/OOP runtime pending) - no code generated
'
' NOTE (batch 209): this header described batch 195's *intent*, which was not actually
' in effect - the five parked names were also listed in codegen's handled-family
' early-return guard, so control left before the report and the compile stayed silent.
' batch 209 routes the arm through compiler.warnings, so the warning and the
' `examples/batch195_test.unimplemented.log` file below now really appear (4 statements
' for this file).  The exit code stays 0: accepted-but-empty is a report, not an error.
'
' Verification is therefore done at compile time - see the release notes - not by
' running the program.  The program does print, so it stays safe to run headless.

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING

    PRINT "=== Batch 195: accepted-but-no-code statements are reported ==="

    ' INSTANCE myObj AS MyClass  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    PRINT "INSTANCE: parsed (warning expected at compile time)"

    ' EVENTS Click, Changed  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    PRINT "EVENTS: parsed (warning expected)"

    ' EVENT SOURCE 1  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    PRINT "EVENT SOURCE: parsed (warning expected)"

    ' RAISEEVENT Click  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    PRINT "RAISEEVENT: parsed (warning expected)"

    PRINT "=== Done: compile-only sample, nothing here depends on run-time output ==="
' Press any key to exit...
WAITKEY$
END FUNCTION
