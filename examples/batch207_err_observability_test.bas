'=====================================================================
' PowerBasilisk Enhanced - batch 207 self-check - a failure the program can read
'---------------------------------------------------------------------
' THE POINT
'   A statement can fail in two very different ways:
'     * it can return a value the program may inspect - fine;
'     * or it can fail where the program cannot see it at all.  That is the
'       dangerous one: the sample "passes", the program continues, and nothing
'       anywhere says the port was never opened.
'   `ERR` is the language's own answer.  ON ERROR and TRY/CATCH trigger on it,
'   ERRCLEAR resets it, and a plain `e = ERR` reads it.
'
' WHAT THIS PINS
'   The socket / serial / thread / random-file / sound family now sets ERR on
'   failure.  Codes are the classic BASIC numbers PowerBASIC uses elsewhere:
'     5 illegal function call   7 out of memory       52 bad file name or number
'    53 file not found         57 device I/O error   68 device unavailable
'    (where PowerBASIC's own documentation publishes no code for a statement, the
'    semantically matching classic number is used - stated here so nobody has to
'    guess why a code appears.)
'
' WHY "COM404" AND PORT 1
'   Neither can exist on any machine, so the failure path is exercised everywhere
'   instead of depending on which serial port or server happens to be present.
'
' Expected stdout:
'   COMM OPEN  failure ERR = 57 (want 57)
'   TCP connect failure ERR = 57 (want 57)
'   TCP CLOSE closed  ERR = 52 (want 52)
'   after ERRCLEAR        ERR = 0 (want 0)
'   TRY/CATCH caught the socket failure: ERR = 57
'   === FAILURES: 0
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL e AS LONG
    LOCAL fails AS LONG
    fails = 0

    ERRCLEAR
    COMM OPEN "COM404" AS #1
    e = ERR
    PRINT "COMM OPEN  failure ERR ="; e; " (want 57)"
    IF e <> 57 THEN fails = fails + 1

    ERRCLEAR
    TCP OPEN PORT 1 AT "127.0.0.1" AS #3
    e = ERR
    PRINT "TCP connect failure ERR ="; e; " (want 57)"
    IF e <> 57 THEN fails = fails + 1

    ERRCLEAR
    TCP CLOSE #9
    e = ERR
    PRINT "TCP CLOSE closed  ERR ="; e; " (want 52)"
    IF e <> 52 THEN fails = fails + 1

    ERRCLEAR
    e = ERR
    PRINT "after ERRCLEAR        ERR ="; e; " (want 0)"
    IF e <> 0 THEN fails = fails + 1

    TRY
        COMM OPEN "COM404" AS #1
    CATCH
        PRINT "TRY/CATCH caught the socket failure: ERR ="; ERR
        IF ERR <> 57 THEN fails = fails + 1
    END TRY

    IF fails = 0 THEN PRINT "=== FAILURES: 0"
    FUNCTION = 0
END FUNCTION
