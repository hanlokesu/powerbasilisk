'=====================================================================
' PowerBasilisk Enhanced - batch 202 self-check - THREAD CREATE without TO
'---------------------------------------------------------------------
' THE DEFECT THIS FILE GUARDS
'   The official spelling of THREAD CREATE makes the TO clause optional:
'       THREAD CREATE MyThread          ' start it, no handle wanted
'       THREAD CREATE MyThread TO h     ' start it and keep the handle
'   The codegen arm opened with `if call.args.len() >= 2`, and the parser only
'   produces two arguments when TO is present.  So the one-argument form parsed,
'   compiled and linked cleanly and then did NOTHING - the thread never started.
'   That is the same shape as the GLOBALMEM defect in batch 201: a guard that
'   silently drops the statement instead of executing it.
'
' WHAT THIS PROGRAM CHECKS
'   1. THREAD CREATE Worker          -> Worker really runs (g_ran becomes 1)
'   2. THREAD CREATE Worker2 TO h    -> Worker2 really runs (g_two becomes 1)
'   3. the handle slot is a small non-negative index (the runtime stores the
'      slot number, so the FIRST thread's id is legitimately 0 - do not compare
'      the handle against 0 to mean "failed")
' Expected output:
'   no-TO thread ran:  1
'   TO thread ran:  1
'   === FAILURES: 0
'=====================================================================
GLOBAL g_ran AS LONG
GLOBAL g_two AS LONG

FUNCTION Worker () AS LONG
    g_ran = 1
    FUNCTION = 0
END FUNCTION

FUNCTION Worker2 () AS LONG
    g_two = 1
    FUNCTION = 0
END FUNCTION

FUNCTION PBMAIN () AS LONG
    LOCAL fails AS LONG
    LOCAL h AS QUAD
    fails = 0
    ' --- case 1: no TO clause -----------------------------------------
    THREAD CREATE Worker
    SLEEP 500
    PRINT "no-TO thread ran: "; g_ran
    IF g_ran <> 1 THEN fails = fails + 1
    ' --- case 2: with TO clause --------------------------------------
    THREAD CREATE Worker2 TO h
    SLEEP 500
    PRINT "TO thread ran: "; g_two
    IF g_two <> 1 THEN fails = fails + 1
    PRINT "=== FAILURES: "; fails
    FUNCTION = 0
END FUNCTION
