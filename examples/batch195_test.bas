' PowerBasilisk Enhanced - Batch 195 test: no-op statement groups are now REPORTED
'
' COMPILE-ONLY by design: this batch changed diagnostics, not behaviour.  The four
' statements below are accepted and intentionally emit no code (they were parked in
' batch 121 pending the GUI / OOP runtime).  Before batch 195 they were dropped in
' silence; now the compiler pushes a warning for each one:
'
'   statement `INSTANCE` on line N is accepted but emits no code
'
' Verification is therefore done at compile time - see the release notes - not by
' running the program.  The program does print, so it stays safe to run headless.

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING

    PRINT "=== Batch 195: accepted-but-no-code statements are reported ==="

    INSTANCE myObj AS MyClass
    PRINT "INSTANCE: parsed (warning expected at compile time)"

    EVENTS Click, Changed
    PRINT "EVENTS: parsed (warning expected)"

    EVENT SOURCE 1
    PRINT "EVENT SOURCE: parsed (warning expected)"

    RAISEEVENT Click
    PRINT "RAISEEVENT: parsed (warning expected)"

    PRINT "=== Done: compile-only sample, nothing here depends on run-time output ==="
END FUNCTION
