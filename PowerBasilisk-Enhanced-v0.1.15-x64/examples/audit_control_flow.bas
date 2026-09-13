' Coverage audit verification: LET/IF/FOR/SELECT/VAL/ASC/MID$/FUNCTION
FUNCTION Add2(x AS LONG) AS LONG
    FUNCTION = x + 2
END FUNCTION

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a, b, i, t AS LONG
    LOCAL s AS STRING
    ' LET (implicit) + IF/END IF
    a = 1
    IF a = 1 THEN
        b = 2
    ELSE
        b = 3
    END IF
    t = b
    ' FOR / NEXT
    FOR i = 1 TO 3
        t = t + i
    NEXT i
    ' SELECT CASE / END SELECT
    SELECT CASE a
        CASE 1
            t = t + 100
        CASE ELSE
            t = 0
    END SELECT
    ' VAL / ASC / MID$ (function form)
    s = "abc123"
    t = t + VAL("45") + ASC("A") + VAL(MID$(s, 4, 3))
    ' user FUNCTION
    t = t + Add2(10)
    PRINT "T="; t
    IF t = 353 THEN
        PRINT "AUDIT-PASS"
    ELSE
        PRINT "AUDIT-FAIL T="; t
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
