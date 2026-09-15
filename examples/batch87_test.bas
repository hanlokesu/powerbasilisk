' Batch 87: CSTR / CQUAD / CBYTE / CWORD / CDWORD — type conversion functions
FUNCTION PBMAIN() AS LONG
    LOCAL s AS STRING
    LOCAL q AS QUAD
    LOCAL b AS BYTE
    LOCAL w AS WORD
    LOCAL dw AS DWORD
    LOCAL waitk AS STRING
    LOCAL pass AS LONG
    pass = 0

    PRINT "=== Batch 87: CSTR / CQUAD / CBYTE / CWORD / CDWORD ==="

    ' Test 1: CSTR — numeric to string (no leading space)
    s = CSTR(123)
    IF s = "123" THEN
        PRINT "Test 1 PASS: CSTR(123) = ["; s; "]"
        pass = pass + 1
    ELSE
        PRINT "Test 1 FAIL: CSTR(123) = ["; s; "], expected [123]"
    END IF

    ' Test 2: CSTR — negative number
    s = CSTR(-456)
    IF s = "-456" THEN
        PRINT "Test 2 PASS: CSTR(-456) = ["; s; "]"
        pass = pass + 1
    ELSE
        PRINT "Test 2 FAIL: CSTR(-456) = ["; s; "], expected [-456]"
    END IF

    ' Test 3: CQUAD — convert to 64-bit integer
    q = CQUAD(123456789012345)
    IF q = 123456789012345 THEN
        PRINT "Test 3 PASS: CQUAD(123456789012345) ="; q
        pass = pass + 1
    ELSE
        PRINT "Test 3 FAIL: CQUAD ="; q; ", expected 123456789012345"
    END IF

    ' Test 4: CQUAD — from float (truncates toward zero)
    q = CQUAD(42.7)
    IF q = 42 THEN
        PRINT "Test 4 PASS: CQUAD(42.7) ="; q
        pass = pass + 1
    ELSE
        PRINT "Test 4 FAIL: CQUAD(42.7) ="; q; ", expected 42"
    END IF

    ' Test 5: CBYTE — convert to unsigned byte (0-255), truncates
    b = CBYTE(300)
    IF b = 44 THEN  ' 300 mod 256 = 44
        PRINT "Test 5 PASS: CBYTE(300) ="; b; " (300 mod 256)"
        pass = pass + 1
    ELSE
        PRINT "Test 5 FAIL: CBYTE(300) ="; b; ", expected 44"
    END IF

    ' Test 6: CBYTE — -1 wraps to 255
    b = CBYTE(-1)
    IF b = 255 THEN
        PRINT "Test 6 PASS: CBYTE(-1) ="; b; " (unsigned wrap)"
        pass = pass + 1
    ELSE
        PRINT "Test 6 FAIL: CBYTE(-1) ="; b; ", expected 255"
    END IF

    ' Test 7: CWORD — convert to unsigned word (0-65535)
    w = CWORD(70000)
    IF w = 4464 THEN  ' 70000 mod 65536 = 4464
        PRINT "Test 7 PASS: CWORD(70000) ="; w; " (70000 mod 65536)"
        pass = pass + 1
    ELSE
        PRINT "Test 7 FAIL: CWORD(70000) ="; w; ", expected 4464"
    END IF

    ' Test 8: CDWORD — convert to unsigned double word (32-bit)
    dw = CDWORD(5000000000)
    IF dw = 705032704 THEN  ' 5000000000 mod 2^32 = 705032704
        PRINT "Test 8 PASS: CDWORD(5000000000) ="; dw; " (mod 2^32)"
        pass = pass + 1
    ELSE
        PRINT "Test 8 FAIL: CDWORD(5000000000) ="; dw; ", expected 705032704"
    END IF

    PRINT "=== "; pass; "/8 TESTS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
