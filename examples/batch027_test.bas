#COMPILE EXE
#DIM ALL
' batch 27: ON CALL / GET$$+PUT$$ / MACRO
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL i AS LONG
    LOCAL n AS LONG
    LOCAL r AS LONG
    LOCAL s AS STRING
    LOCAL f AS LONG
    LOCAL ok AS LONG

    ok = 0

    ' --- 1. ON CALL: SUB targets, selected by n ---
    ON 1 CALL OneProc(77), TwoProc(11), ThreeProc()
    ON 2 CALL OneProc(77), TwoProc(11), ThreeProc()
    ON 3 CALL OneProc(77), TwoProc(11), ThreeProc()
    ON 5 CALL OneProc(77), TwoProc(11), ThreeProc()  ' out of range: no call

    ' --- 2. ON CALL with FUNCTION TO var ---
    r = 0
    n = 0
    ON 1 CALL GetDouble() TO r, GetDouble() TO n
    IF r = 42 AND n = 0 THEN ok = ok + 1
    PRINT "oncall-fn1: r="; r; " n="; n
    r = 0
    n = 0
    ON 2 CALL GetDouble() TO r, GetDouble() TO n
    IF r = 0 AND n = 84 THEN ok = ok + 1
    PRINT "oncall-fn2: r="; r; " n="; n

    ' --- 3. GET$$ / PUT$$: wide string round-trip ---
    OPEN "WIDETEST.DAT" FOR BINARY AS #1
    PUT$$ #1, "AB"
    PUT$$ #1, "CD"
    SEEK #1, 1
    GET$$ #1, 2, s
    PRINT "wide-read1: "; s
    IF s = "AB" THEN ok = ok + 1
    GET$$ #1, 2, s
    PRINT "wide-read2: "; s
    IF s = "CD" THEN ok = ok + 1
    CLOSE #1
    KILL "WIDETEST.DAT"

    ' --- 4. Single-line MACRO in an expression ---
    MACRO muldivide(p1, p2, p3) = ((p1 * p2) / p3)
    x = muldivide(3, 3, 2) + 10
    PRINT "macro-expr: "; x
    IF x = 14 THEN ok = ok + 1

    ' --- 5. No-arg single-line macro ---
    MACRO AppTitle = "PB27-MACRO"
    s = AppTitle
    PRINT "macro-const: "; s
    IF s = "PB27-MACRO" THEN ok = ok + 1

    ' --- 6. Multi-line MACRO at statement position ---
    MACRO Swap2(a, b)
    DIM t AS LONG
    t = a
    a = b
    b = t
    END MACRO
    n = 5
    i = 9
    Swap2(n, i)
    PRINT "macro-swap: n="; n; " i="; i
    IF n = 9 AND i = 5 THEN ok = ok + 1

    PRINT "batch27 ok="; ok; " / 7"
    IF ok = 7 THEN
        PRINT "ALL PASS"
    ELSE
        PRINT "FAIL"
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION

SUB OneProc(v AS LONG)
    PRINT "oncall-sub1: "; v
END SUB

SUB TwoProc(v AS LONG)
    PRINT "oncall-sub2: "; v
END SUB

SUB ThreeProc()
    PRINT "oncall-sub3"
END SUB

FUNCTION GetDouble() AS LONG
    STATIC ctr AS LONG
    INCR ctr
    FUNCTION = ctr * 42
END FUNCTION
