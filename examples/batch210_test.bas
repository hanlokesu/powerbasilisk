' PowerBasilisk Enhanced - Batch 210 test: the five statements that were falsely
' listed as Implemented, and are now reported instead of silently dropped.
'
' WHY THIS FILE EXISTS
'   docs/statement-coverage.csv listed ACCEL ATTACH / EVENT SOURCE / EVENTS /
'   RAISEEVENT / INSTANCE as "Implemented" while codegen generated no code for
'   them at all.  Batch 209 made the drop visible (compiler warning +
'   <output>.unimplemented.log); batch 210 corrected the coverage table to
'   "Not implemented" so the table and the compiler finally agree.
'
' WHAT THE COMPILER MUST DO WITH THIS FILE
'   rc = 0 (accepted, not a compile error) and exactly five report lines - one per
'   statement - both on stderr as
'       WARNING: <name> on line N ... not implemented
'   and in examples/batch210_test.unimplemented.log.  Before batch 209 these five
'   compiled clean and did nothing, which is what made the false "Implemented"
'   rows invisible.
'
' WHY IT PRINTS NOTHING USEFUL AT RUN TIME
'   The statements emit no IR, so there is no run-time behaviour to observe.  The
'   assertion lives in the compile step (warning count / log lines), which is why
'   this sample is COMPILE-ONLY in the harness classification and prints one line
'   so a headless run can still confirm it started and exited 0.

FUNCTION PBMAIN() AS LONG
    LOCAL hDlg AS LONG          ' ACCEL ATTACH would take a dialog handle
    LOCAL id(0 TO 1) AS LONG    ' ... and a table of key/command pairs

    ' 1. ACCEL ATTACH - official PB: attach an accelerator table to a dialog.
    ACCEL ATTACH hDlg, id()
    ' 2. INSTANCE - official PB: instance variables at the top of a CLASS block.
    INSTANCE myObj AS MyClass
    ' 3. EVENTS - official PB: subscribe an event handler to an event source.
    EVENTS Click, Changed
    ' 4. EVENT SOURCE - official PB: declare an event interface inside a CLASS.
    EVENT SOURCE 1
    ' 5. RAISEEVENT - official PB: call the subscribed event handler code.
    RAISEEVENT Click

    PRINT "Batch 210 sample: five statements accepted; see the compile-time report."
END FUNCTION
