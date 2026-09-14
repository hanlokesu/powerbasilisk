' PowerBasilisk Enhanced — batch 32 test: MAT matrix algebra
' Covers: CON / ZER / CON(expr) / assignment / + / - / scalar * / IDN / TRN / * / INV
#COMPILE EXE
#DIM ALL

FUNCTION PBMAIN() AS LONG
    LOCAL fail AS LONG
    LOCAL waitk AS STRING
    fail = 0

    ' --- MAT ZER: 2x3 LONG all zero ---
    DIM z(1 TO 2, 1 TO 3) AS LONG
    MAT z() = ZER
    IF z(1,1) <> 0 OR z(2,3) <> 0 THEN
        PRINT "FAIL ZER"
        fail = fail + 1
    END IF

    ' --- MAT CON: all ones ---
    MAT z() = CON
    IF z(1,1) <> 1 OR z(2,3) <> 1 THEN
        PRINT "FAIL CON"
        fail = fail + 1
    END IF

    ' --- MAT CON(expr): all 7 ---
    MAT z() = CON(7)
    IF z(1,2) <> 7 OR z(2,1) <> 7 THEN
        PRINT "FAIL CON(expr)"
        fail = fail + 1
    END IF

    ' --- 1-D CON / assignment ---
    DIM v(1 TO 4) AS LONG
    MAT v() = CON
    IF v(1) <> 1 OR v(4) <> 1 THEN
        PRINT "FAIL 1D CON"
        fail = fail + 1
    END IF

    ' --- MAT assignment ---
    DIM a(1 TO 2, 1 TO 3) AS LONG
    DIM b(1 TO 2, 1 TO 3) AS LONG
    a(1,1) = 1 : a(1,2) = 2 : a(1,3) = 3
    a(2,1) = 4 : a(2,2) = 5 : a(2,3) = 6
    MAT b() = a()
    IF b(1,1) <> 1 OR b(2,3) <> 6 THEN
        PRINT "FAIL assign"
        fail = fail + 1
    END IF

    ' --- MAT + ---
    DIM c(1 TO 2, 1 TO 3) AS LONG
    MAT c() = a() + b()
    IF c(1,1) <> 2 OR c(2,3) <> 12 THEN
        PRINT "FAIL add"
        fail = fail + 1
    END IF

    ' --- MAT - ---
    MAT c() = a() - b()
    IF c(1,1) <> 0 OR c(2,3) <> 0 THEN
        PRINT "FAIL sub"
        fail = fail + 1
    END IF

    ' --- MAT (expr) * array ---
    MAT c() = (3) * a()
    IF c(1,1) <> 3 OR c(2,3) <> 18 THEN
        PRINT "FAIL scale"
        fail = fail + 1
    END IF

    ' --- MAT IDN: 3x3 ---
    DIM i(1 TO 3, 1 TO 3) AS LONG
    MAT i() = IDN
    IF i(1,1) <> 1 OR i(2,2) <> 1 OR i(3,3) <> 1 OR i(1,2) <> 0 OR i(3,1) <> 0 THEN
        PRINT "FAIL IDN"
        fail = fail + 1
    END IF

    ' --- MAT TRN: 2x3 -> 3x2 ---
    DIM t(1 TO 2, 1 TO 3) AS LONG
    DIM t2(1 TO 3, 1 TO 2) AS LONG
    t(1,1) = 1 : t(1,2) = 2 : t(1,3) = 3
    t(2,1) = 4 : t(2,2) = 5 : t(2,3) = 6
    MAT t2() = TRN(t())
    IF t2(1,1) <> 1 OR t2(1,2) <> 4 OR t2(2,1) <> 2 OR t2(2,2) <> 5 OR t2(3,1) <> 3 OR t2(3,2) <> 6 THEN
        PRINT "FAIL TRN"
        fail = fail + 1
    END IF

    ' --- MAT *: (2x3)*(3x2) = 2x2 ---
    DIM x(1 TO 2, 1 TO 3) AS LONG
    DIM y(1 TO 3, 1 TO 2) AS LONG
    DIM r(1 TO 2, 1 TO 2) AS LONG
    x(1,1) = 1 : x(1,2) = 2 : x(1,3) = 3
    x(2,1) = 4 : x(2,2) = 5 : x(2,3) = 6
    y(1,1) = 7 : y(1,2) = 8
    y(2,1) = 9 : y(2,2) = 10
    y(3,1) = 11 : y(3,2) = 12
    MAT r() = x() * y()
    ' r(1,1) = 1*7 + 2*9 + 3*11 = 58
    ' r(1,2) = 1*8 + 2*10 + 3*12 = 64
    ' r(2,1) = 4*7 + 5*9 + 6*11 = 139
    ' r(2,2) = 4*8 + 5*10 + 6*12 = 154
    IF r(1,1) <> 58 OR r(1,2) <> 64 OR r(2,1) <> 139 OR r(2,2) <> 154 THEN
        PRINT "FAIL mul"
        fail = fail + 1
    END IF

    ' --- MAT INV: 2x2 DOUBLE, verify A * INV(A) == I ---
    DIM m(1 TO 2, 1 TO 2) AS DOUBLE
    DIM mi(1 TO 2, 1 TO 2) AS DOUBLE
    DIM p(1 TO 2, 1 TO 2) AS DOUBLE
    m(1,1) = 4.0 : m(1,2) = 7.0
    m(2,1) = 2.0 : m(2,2) = 6.0
    MAT mi() = INV(m())
    MAT p() = m() * mi()
    ' det = 4*6 - 7*2 = 10 ; mi = (1/10) * [6 -7; -2 4]
    IF ABS(p(1,1) - 1.0) > 0.000001 OR ABS(p(2,2) - 1.0) > 0.000001 THEN
        PRINT "FAIL INV product diag"
        fail = fail + 1
    END IF
    IF ABS(p(1,2)) > 0.000001 OR ABS(p(2,1)) > 0.000001 THEN
        PRINT "FAIL INV product off-diag"
        fail = fail + 1
    END IF

    IF fail = 0 THEN
        PRINT "ALL 12 MAT TESTS PASS"
    ELSE
        PRINT "FAILURES: "; fail
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
