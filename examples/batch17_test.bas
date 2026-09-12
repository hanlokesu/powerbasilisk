#COMPILE EXE
#DIM ALL
FUNCTION PBMAIN() AS LONG
    LOCAL h1, sz, lk, h2, old, p2, prev AS LONG
    LOCAL p AS QUAD
    LOCAL fails AS LONG

    GLOBALMEM ALLOC 100 TO h1
    IF h1 > 0 THEN PRINT "gm-alloc-PASS" ELSE PRINT "gm-alloc-FAIL": INCR fails

    GLOBALMEM SIZE h1 TO sz
    IF sz >= 100 THEN PRINT "gm-size-PASS" ELSE PRINT "gm-size-FAIL": INCR fails

    GLOBALMEM LOCK h1 TO p
    IF p <> 0 THEN PRINT "gm-lock-PASS" ELSE PRINT "gm-lock-FAIL": INCR fails
    IF p <> 0 THEN
        POKE BYTE, p, 65
        IF PEEK(p) = 65 THEN PRINT "gm-rw-PASS" ELSE PRINT "gm-rw-FAIL": INCR fails
    END IF

    GLOBALMEM UNLOCK h1 TO lk
    IF lk = 0 THEN PRINT "gm-unlock-PASS" ELSE PRINT "gm-unlock-FAIL": INCR fails

    GLOBALMEM FREE h1 TO h2
    IF h2 = 0 THEN PRINT "gm-free-PASS" ELSE PRINT "gm-free-FAIL": INCR fails

    MOUSEPTR 1 TO old
    IF old = 1 THEN PRINT "mouseptr-PASS" ELSE PRINT "mouseptr-FAIL": INCR fails

    UCODEPAGE OEM TO prev
    IF prev = 0 THEN PRINT "ucode-oem-PASS" ELSE PRINT "ucode-oem-FAIL": INCR fails

    UCODEPAGE 850 TO p2
    IF p2 = 1 THEN PRINT "ucode-num-PASS" ELSE PRINT "ucode-num-FAIL": INCR fails

    IF fails = 0 THEN PRINT "BATCH17 ALL PASS" ELSE PRINT "BATCH17 FAIL count="; fails
    FUNCTION = fails
END FUNCTION
