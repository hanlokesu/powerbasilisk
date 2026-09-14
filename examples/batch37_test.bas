' PowerBasilisk Enhanced - batch 37: CVx family (binary string -> value)
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        PRINT "FAIL: "; msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL b AS BYTE
    LOCAL w AS WORD
    LOCAL l AS LONG
    LOCAL q AS QUAD
    LOCAL d AS DOUBLE
    LOCAL s AS SINGLE
    LOCAL x AS STRING
    failures = 0

    ' CVBYT: 1 byte
    x = MKBYT$(65)
    b = CVBYT(x)
    Check(b = 65, "cvbyt")

    ' CVW: 2 bytes little-endian
    x = MKWRD$(&H1234)
    w = CVW(x)
    Check(w = &H1234, "cvw")

    ' CVL: 4 bytes (signed LONG)
    x = MKL$(123456)
    l = CVL(x)
    Check(l = 123456, "cvl")
    x = MKL$(-7)
    l = CVL(x)
    Check(l = -7, "cvl neg")

    ' CVDWD: 4 bytes unsigned DWORD
    x = MKDWD$(&HFFFFFFFF)
    q = CVDWD(x)
    Check(q = 4294967295, "cvdwd")

    ' CVQ: 8 bytes QUAD
    x = MKQ$(1234567890123)
    q = CVQ(x)
    Check(q = 1234567890123, "cvq")

    ' CVS: 4-byte single
    x = MKS$(1.5)
    s = CVS(x)
    Check(s = 1.5, "cvs")

    ' CVD: 8-byte double
    x = MKD$(2.25)
    d = CVD(x)
    Check(d = 2.25, "cvd")

    ' CVE: EXT = 8-byte double here
    x = MKE$(3.5)
    d = CVE(x)
    Check(d = 3.5, "cve")

    ' offset argument (1-based)
    x = "AB" + MKL$(999)
    l = CVL(x, 3)
    Check(l = 999, "cvl offset")

    IF failures = 0 THEN
        PRINT "batch37: ALL PASS"
    ELSE
        PRINT "batch37: FAILURES="; failures
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
