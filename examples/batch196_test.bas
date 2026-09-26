' PowerBasilisk Enhanced - Batch 196 test: one warning per statement, not two
'
' The four statements below are the group that batch 195 started reporting: the empty
' codegen arm shared by INSTANCE / EVENTS / EVENT SOURCE / RAISEEVENT / ACCEL_ATTACH
' and the "known family, no arm of its own" early return.  Batch 195 pushed a warning
' from BOTH places, so each of these statements appeared TWICE in
' examples/batch196_test.unimplemented.log.  Batch 196 keeps exactly one of the two.
'
' Verification (compile time, external): the log must list each statement once -
' 4 statements -> 4 lines.  This file is therefore COMPILE-ONLY for its assertion and
' prints nothing that a run would need to check.

FUNCTION PBMAIN() AS LONG
    INSTANCE myObj AS MyClass
    EVENTS Click, Changed
    EVENT SOURCE 1
    RAISEEVENT Click
    PRINT "Batch 196 sample: nothing here depends on run-time behaviour."
END FUNCTION
