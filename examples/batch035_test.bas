' PowerBasilisk Enhanced - batch 35: REGEXPR / REGREPL (documented subset)
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        PRINT "FAIL: "; msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL p AS LONG
    LOCAL l AS LONG
    LOCAL new$ AS STRING
    failures = 0

    ' basic literal, case-insensitive default
    REGEXPR "cat" IN "the cat sat" TO p, l
    Check(p = 5 AND l = 3, "literal")
    REGEXPR "CAT" IN "the cat sat" TO p, l
    Check(p = 5 AND l = 3, "case-insensitive")

    ' . wildcard
    REGEXPR "c.t" IN "the cat sat" TO p, l
    Check(p = 5 AND l = 3, "dot")

    ' anchors
    REGEXPR "^the" IN "the cat sat" TO p, l
    Check(p = 1 AND l = 3, "caret")
    REGEXPR "sat$" IN "the cat sat" TO p, l
    Check(p = 9 AND l = 3, "dollar")

    ' character class + range + negated class
    REGEXPR "[a-z]at" IN "the cat sat" TO p, l
    Check(p = 5 AND l = 3, "class")
    REGEXPR "[^x]at" IN "the cat sat" TO p, l
    Check(p = 5 AND l = 3, "neg class")

    ' alternation, leftmost
    REGEXPR "dog|cat" IN "the cat sat" TO p, l
    Check(p = 5 AND l = 3, "alternation")

    ' quantifier *
    REGEXPR "ca*t" IN "the caat sat" TO p, l
    Check(p = 5 AND l = 4, "star")

    ' no match
    REGEXPR "xyz" IN "the cat sat" TO p, l
    Check(p = 0 AND l = 0, "no match")

    ' AT start
    REGEXPR "cat" IN "cat cat" AT 5 TO p, l
    Check(p = 5 AND l = 3, "at start")

    ' REGREPL: replace first match
    REGREPL "cat" IN "the cat sat" WITH "dog" TO p, new$
    Check(new$ = "the dog sat", "regrepl text")
    Check(p = 8, "regrepl pos")

    ' REGREPL: no match copies target
    REGREPL "zzz" IN "the cat sat" WITH "dog" TO p, new$
    Check(new$ = "the cat sat", "regrepl no-match")
    Check(p = 0, "regrepl no-match pos")

    ' REGREPL with wildcard
    REGREPL "c.t" IN "the cat sat" WITH "cow" TO p, new$
    Check(new$ = "the cow sat", "regrepl wildcard")

    IF failures = 0 THEN
        PRINT "batch35: ALL PASS"
    ELSE
        PRINT "batch35: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
