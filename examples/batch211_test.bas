'=====================================================================
' batch211_test.bas - batch 211: ACCEL ATTACH gets a real runtime
'---------------------------------------------------------------------
' ACCEL ATTACH was one of five statements that were parsed, compiled
' cleanly and produced no code at all (ACCEL_ATTACH / EVENT_SOURCE /
' EVENTS / RAISEEVENT / INSTANCE shared one empty arm).  Batch 211
' implements the first of them for real:
'
'   * the compiler builds the key table from the array's *declared*
'     element count - the source passes no count, because a compiler
'     knows the size of a constant array;
'   * the runtime calls CreateAcceleratorTableA and remembers
'     hDlg -> hAccel in a small registry;
'   * both message pumps (the modal GetMessage loop and
'     DIALOG DOEVENTS) offer every message to the attached tables with
'     TranslateAcceleratorA, which is what makes a key fire - a table
'     nobody consults would be the same no-op as before;
'   * the optional `TO hAccel` clause keeps the table handle.
'
' Documented record layout (one QUAD per accelerator).  The machine's
' official help carries no ACCEL_ATTACH page, so this layout is the
' fork's own documented shape, not a transcription of a PB page:
'
'     bits  0-15   fVirt   FVIRTKEY / FSHIFT / FCONTROL / FALT
'     bits 16-31   key     virtual key code
'     bits 32-47   cmd     command id (WM_COMMAND's low word)
'
' Why the records below carry no command id: this dialect evaluates
' `hi * 65536 * 65536` in 32 bits, where it wraps to 0 (measured - see
' the probe note in the skill), and a 16-hex-digit literal is the only
' other way to reach bits 32-47.  The record therefore holds fVirt+key
' only; composing the command field is an open item.
'
' Coverage, stated honestly:
'   * COVERED - a real table is created: the two-element array yields a
'     non-zero handle, and the TO target really receives a value (the
'     no-count case is checked against a value it cannot coincidentally
'     already hold).
'   * NOT COVERED HERE - TranslateAcceleratorA firing a key needs a
'     window to pump messages, which cannot be exercised without going
'     interactive; the pump hook is reached by the DDT dialog samples.
'
' The four remaining statements stay parked and reported: they need a
' CLASS / INTERFACE / METHOD object model that codegen does not have
' (0 hits for all three), and a no-op wearing an Implemented label is
' exactly what batch 210 had to undo.
'
' Asserts: 1. a two-element key array produces a non-zero table handle
'          2. an argument with no element count produces 0 (no table)
'             *and* really writes the TO target (started at 12345)
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL hDlg AS LONG
    LOCAL acc AS QUAD
    LOCAL none AS QUAD
    LOCAL keys(1) AS QUAD
    LOCAL plain AS QUAD

    ' FVIRTKEY|FCONTROL (0x0009) with 'A' (0x41) and with 'B' (0x42)
    keys(0) = &H00410009
    keys(1) = &H00420009
    PRINT "keys(0) = "; keys(0)
    PRINT "keys(1) = "; keys(1)

    ACCEL ATTACH hDlg, keys() TO acc
    PRINT "accelerator table = "; acc
    IF acc = 0 THEN
        fail = fail + 1
    END IF

    ' A non-array argument carries no element count, so no table can be
    ' built: the handle must come back 0 - and the TO target must still be
    ' written, which is why it starts at a value the program recognises.
    none = 12345
    ACCEL ATTACH hDlg, plain TO none
    PRINT "no-count attach   = "; none
    IF none <> 0 THEN
        fail = fail + 1
    END IF

    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
