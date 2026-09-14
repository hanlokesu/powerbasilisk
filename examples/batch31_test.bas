' PowerBasilisk Enhanced - batch 31 test: FIELD + RANDOM record I/O
' Covers: OPEN FOR RANDOM LEN=, FIELD #n size AS var,
'         PUT/GET record (current + numbered), blank padding,
'         FIELD dyn$, FIELD RESET, FIELD STRING.
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f1 AS FIELD, f2 AS FIELD
    LOCAL g1 AS FIELD, g2 AS FIELD
    LOCAL x$ AS STRING
    LOCAL errc AS LONG

    ' --- 1) RANDOM file + field binding + PUT record ---
    KILL "rec31.dat"
    OPEN "rec31.dat" FOR RANDOM AS #1 LEN=20
    FIELD #1, 10 AS f1, 10 AS f2
    f1 = "0123456789"
    f2 = "9876543210"
    PUT #1
    CLOSE #1

    ' --- 2) Re-open, read record back, verify fields ---
    OPEN "rec31.dat" FOR RANDOM AS #2 LEN=20
    FIELD #2, 10 AS f1, 10 AS f2
    GET #2
    IF f1 <> "0123456789" THEN
        PRINT "FAIL f1 read = ["; f1; "]"
        errc = errc + 1
    END IF
    IF f2 <> "9876543210" THEN
        PRINT "FAIL f2 read = ["; f2; "]"
        errc = errc + 1
    END IF

    ' --- 3) Shorter assignment pads with blanks ---
    FIELD #2, 10 AS f1
    f1 = "abc"
    IF f1 <> "abc       " THEN
        PRINT "FAIL pad = ["; f1; "]"
        errc = errc + 1
    END IF

    ' --- 4) Numbered records: write record 2, read it back ---
    FIELD #2, 10 AS f1, 10 AS f2
    f1 = "RECORDTWO"
    f2 = "1234567890"
    PUT #2, 2
    GET #2, 2
    IF f1 <> "RECORDTWO " THEN
        PRINT "FAIL rec2 f1 = ["; f1; "]"
        errc = errc + 1
    END IF
    IF f2 <> "1234567890" THEN
        PRINT "FAIL rec2 f2 = ["; f2; "]"
        errc = errc + 1
    END IF

    ' --- 6) FIELD STRING keeps a private copy (must happen while the
    '        record buffer is still open; after CLOSE the binding is gone) ---
    FIELD STRING f1
    IF f1 <> "RECORDTWO " THEN
        PRINT "FAIL tostr f1 = ["; f1; "]"
        errc = errc + 1
    END IF
    CLOSE #2

    ' --- 5) Dynamic string binding ---
    FIELD x$, 3 AS g1, 3 AS g2
    x$ = "abcdef"
    IF g1 <> "abc" THEN
        PRINT "FAIL dyn g1 = ["; g1; "]"
        errc = errc + 1
    END IF
    IF g2 <> "def" THEN
        PRINT "FAIL dyn g2 = ["; g2; "]"
        errc = errc + 1
    END IF
    g1 = "111"
    g2 = "222"
    IF x$ <> "111222" THEN
        PRINT "FAIL dyn write x$ = ["; x$; "]"
        errc = errc + 1
    END IF

    ' --- 7) FIELD RESET unbinds ---
    FIELD RESET g1
    IF g1 <> "" THEN
        PRINT "FAIL reset g1 = ["; g1; "]"
        errc = errc + 1
    END IF

    KILL "rec31.dat"

    IF errc = 0 THEN
        PRINT "ALL PASS (7 groups)"
    ELSE
        PRINT "FAILURES: "; errc
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
