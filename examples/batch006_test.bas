' Batch 6: BIT / BIT SET/RESET/TOGGLE / BIT CALC / PROCESS PRIORITY
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f AS LONG
    LOCAL p AS LONG

    f = 5
    IF BIT(f, 0) = 1 AND BIT(f, 2) = 1 AND BIT(f, 1) = 0 THEN
        PRINT "BIT-FUNC-PASS"
    ELSE
        PRINT "BIT-FUNC-FAIL"
    END IF

    BIT SET f, 1
    IF f = 7 THEN
        PRINT "BIT-SET-PASS"
    ELSE
        PRINT "BIT-SET-FAIL f="; f
    END IF

    BIT RESET f, 0
    IF f = 6 THEN
        PRINT "BIT-RESET-PASS"
    ELSE
        PRINT "BIT-RESET-FAIL f="; f
    END IF

    BIT TOGGLE f, 2
    IF f = 2 THEN
        PRINT "BIT-TOGGLE-PASS"
    ELSE
        PRINT "BIT-TOGGLE-FAIL f="; f
    END IF

    f = 0
    BIT CALC f, 3, 1
    IF f = 8 THEN
        PRINT "BIT-CALC-PASS"
    ELSE
        PRINT "BIT-CALC-FAIL f="; f
    END IF

    PROCESS GET PRIORITY TO p
    IF p > 0 THEN
        PRINT "PROCESS-GET-PASS p="; p
    ELSE
        PRINT "PROCESS-GET-FAIL p="; p
    END IF

    PROCESS SET PRIORITY 32
    PROCESS GET PRIORITY TO p
    IF p = 32 THEN
        PRINT "PROCESS-SET-PASS"
    ELSE
        PRINT "PROCESS-SET-FAIL p="; p
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
