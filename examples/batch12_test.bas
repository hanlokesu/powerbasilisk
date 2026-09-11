' Batch 12: ON GOTO / ON GOSUB
FUNCTION PBMAIN() AS LONG
    LOCAL i AS LONG
    LOCAL r AS LONG
    r = 0

    ' ON GOTO: select label by index (1-based)
    i = 2
    ON i GOTO one, two, three
    r = r + 100
    GOTO done
one:
    r = r + 1
    GOTO done
two:
    r = r + 2
    GOTO done
three:
    r = r + 3
done:
    IF r = 2 THEN
        PRINT "ON-GOTO-PASS"
    ELSE
        PRINT "ON-GOTO-FAIL r="; r
    END IF

    ' ON GOTO: out of range falls through
    r = 0
    i = 5
    ON i GOTO o1, o2
    r = r + 50
    GOTO odone
o1:
    r = r + 1
    GOTO odone
o2:
    r = r + 2
odone:
    IF r = 50 THEN
        PRINT "ON-GOTO-RANGE-PASS"
    ELSE
        PRINT "ON-GOTO-RANGE-FAIL r="; r
    END IF

    ' ON GOSUB: select subroutine by index
    r = 0
    i = 3
    ON i GOSUB s1, s2, s3
    IF r = 3 THEN
        PRINT "ON-GOSUB-PASS"
    ELSE
        PRINT "ON-GOSUB-FAIL r="; r
    END IF
    GOTO gdone
s1:
    r = r + 1
    RETURN
s2:
    r = r + 2
    RETURN
s3:
    r = r + 3
    RETURN
gdone:

    ' ON GOSUB: out of range falls through
    r = 0
    i = 0
    ON i GOSUB t1, t2
    IF r = 0 THEN
        PRINT "ON-GOSUB-RANGE-PASS"
    ELSE
        PRINT "ON-GOSUB-RANGE-FAIL r="; r
    END IF
    GOTO tdone
t1:
    r = r + 1
    RETURN
t2:
    r = r + 2
    RETURN
tdone:
END FUNCTION
