' PowerBasilisk Enhanced - batch219_test.bas
' batch 219: the statements whose argument-count guard became loud.
' This sample drives two of them (FILECOPY, SETATTR) with the argument counts
' the official help pages require - the positive half of the batch's witness.
' A short argument list is a compile error now (see _b219_probes/*.bas), so this
' file must keep using the full forms.
FUNCTION PBMAIN () AS LONG
    LOCAL fails AS LONG
    LOCAL src AS STRING
    LOCAL dst AS STRING
    LOCAL e AS LONG

    src = "batch219_src.tmp"
    dst = "batch219_dst.tmp"

    OPEN src FOR OUTPUT AS #1
    PRINT #1, "batch 219"
    CLOSE #1

    FILECOPY src, dst
    e = ERR
    IF e = 0 AND ISFILE(dst) THEN
        PRINT "OK: FILECOPY copied the file"
    ELSE
        PRINT "FAIL: FILECOPY err="; e
        INCR fails
    END IF

    SETATTR dst, 1
    e = ERR
    IF e = 0 AND ISFILE(dst) THEN
        PRINT "OK: SETATTR accepted the attribute"
    ELSE
        PRINT "FAIL: SETATTR err="; e
        INCR fails
    END IF

    SETATTR dst, 0
    IF ERR = 0 THEN PRINT "OK: SETATTR cleared the attribute"

    KILL src
    KILL dst
    IF ISFILE(src) = 0 AND ISFILE(dst) = 0 THEN
        PRINT "OK: temporary files removed"
    ELSE
        PRINT "FAIL: temporary files left behind"
        INCR fails
    END IF

    IF fails = 0 THEN
        PRINT "batch219: ALL PASS"
    ELSE
        PRINT "batch219: FAILURES="; fails
    END IF
    PRINT "=== FAILURES: "; fails; " ==="
END FUNCTION
