' PowerBasilisk Enhanced - batch 39: BIN$ / OCT$ / DEC$ / VERIFY / MOD / GETATTR / DISKFREE / DISKSIZE
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        PRINT "FAIL: "; msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL r AS STRING
    LOCAL n AS LONG
    LOCAL q AS QUAD
    LOCAL f AS LONG
    failures = 0

    ' BIN$
    r = BIN$(5)
    Check(r = "101", "bin 5")
    r = BIN$(0)
    Check(r = "0", "bin 0")
    r = BIN$(13)
    Check(r = "1101", "bin 13")

    ' OCT$
    r = OCT$(8)
    Check(r = "10", "oct 8")
    r = OCT$(64)
    Check(r = "100", "oct 64")

    ' DEC$
    r = DEC$(255)
    Check(r = "255", "dec 255")
    r = DEC$(-7)
    Check(r = "-7", "dec neg")

    ' VERIFY
    n = VERIFY("abc", "xyz")
    Check(n = 1, "verify first")
    n = VERIFY("abc", "abcxyz")
    Check(n = 0, "verify all match")
    n = VERIFY(2, "abc", "ab")
    Check(n = 3, "verify from 2")

    ' MOD (truncated remainder, same as C srem)
    n = 10 MOD 3
    Check(n = 1, "mod 10 3")
    n = 13 MOD 5
    Check(n = 3, "mod 13 5")
    n = -7 MOD 3
    Check(n = -1, "mod neg")

    ' GETATTR
    f = GETATTR(".")
    Check(f <> -1, "getattr dot exists")
    f = GETATTR("Z:\no_such_file_xyz_123")
    Check(f = -1, "getattr missing")

    ' DISKFREE / DISKSIZE (bytes)
    q = DISKFREE("C:\")
    Check(q > 0, "diskfree c")
    q = DISKSIZE("C:\")
    Check(q > 0, "disksize c")
    q = DISKFREE("")
    Check(q > 0, "diskfree default")

    IF failures = 0 THEN
        PRINT "batch39: ALL PASS"
    ELSE
        PRINT "batch39: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
