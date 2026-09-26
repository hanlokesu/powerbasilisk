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
    COMM OPEN "COM1" AS #2
    e = ERR
    PRINT "COM1 open (any)      ERR ="; e; " (0 when it opened)"
    COMM CLOSE 2

    ERRCLEAR
    TCP CLOSE #9
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
