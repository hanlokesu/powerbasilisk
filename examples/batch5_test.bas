' Batch 5: PEEK / POKE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL x AS LONG
    LOCAL addr AS QUAD
    LOCAL b AS LONG

    x = 0
    addr = VARPTR(x)
    POKE LONG, addr, 12345
    IF x = 12345 THEN
        PRINT "POKE-LONG-PASS"
    ELSE
        PRINT "POKE-LONG-FAIL x="; x
    END IF

    b = PEEK(LONG, addr)
    IF b = 12345 THEN
        PRINT "PEEK-LONG-PASS"
    ELSE
        PRINT "PEEK-LONG-FAIL b="; b
    END IF

    POKE BYTE, addr, 65
    b = PEEK(addr)
    IF b = 65 THEN
        PRINT "PEEK-BYTE-PASS"
    ELSE
        PRINT "PEEK-BYTE-FAIL b="; b
    END IF

    POKE BYTE, addr, 7, 8, 9
    b = PEEK(addr)
    IF b = 7 AND PEEK(addr + 2) = 9 THEN
        PRINT "POKE-MULTI-PASS"
    ELSE
        PRINT "POKE-MULTI-FAIL b="; b
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
