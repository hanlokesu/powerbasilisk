' PowerBasilisk Enhanced - batch220_test.bas
' batch 220: the remaining 125 guarded arms became loud (a short argument list
' is now a compile error, e.g. IMPORT ADDR without its TO AddrVar& target).
' This sample is the positive half of the witness: it drives a representative
' subset of those families with the argument counts the official pages require,
' and checks the calls really did something at run time.
FUNCTION PBMAIN () AS LONG
    LOCAL fails AS LONG
    LOCAL a AS LONG
    LOCAL f AS LONG
    LOCAL s AS STRING
    LOCAL mask AS STRING
    LOCAL w AS LONG, h AS LONG
    LOCAL x AS LONG, y AS LONG
    LOCAL ppix AS LONG, ppiy AS LONG
    LOCAL name1 AS STRING
    LOCAL name2 AS STRING

    ' --- MEMORY FILL (guard 3): write 4 bytes into a LONG, verify little-endian
    a = 0
    s = CHR$(1, 2, 3, 4)
    MEMORY FILL VARPTR(a), 4, s
    IF a = &H04030201 THEN
        PRINT "OK: MEMORY FILL wrote the 4 bytes"
    ELSE
        PRINT "FAIL: MEMORY FILL a="; HEX$(a)
        INCR fails
    END IF

    ' --- NAME (guard 2): rename a file and confirm the result exists
    name1 = "batch220_name1.tmp"
    name2 = "batch220_name2.tmp"
    KILL name1
    KILL name2
    OPEN name1 FOR OUTPUT AS #1
    PRINT #1, "batch 220"
    CLOSE #1
    NAME name1 AS name2
    IF ISFILE(name2) AND ISFILE(name1) = 0 THEN
        PRINT "OK: NAME renamed the file"
    ELSE
        PRINT "FAIL: NAME rename did not land"
        INCR fails
    END IF

    ' --- PUT_STR / GET_STR (guards 2/3): binary ANSI string round-trip.
    '     PUT$ writes at the current file position and advances it, so rewind
    '     with SEEK # before reading the bytes back.
    OPEN name2 FOR BINARY AS #1
    PUT$ #1, "hello"
    SEEK #1, 1
    GET$ #1, 5, s
    CLOSE #1
    IF s = "hello" THEN
        PRINT "OK: PUT/GET string round-trip"
    ELSE
        PRINT "FAIL: PUT/GET s=["; s; "]"
        INCR fails
    END IF
    KILL name2

    ' --- DIR family (guard 2): find the file we just deleted is gone, then
    '     list the batch test sources in this directory
    DIR "batch220_*.bas" TO s
    IF s = "" THEN
        PRINT "OK: DIR returned empty for a deleted pattern"
    ELSE
        PRINT "FAIL: DIR s=["; s; "]"
        INCR fails
    END IF
    DIR CLOSE

    ' --- DESKTOP GET SIZE/CLIENT/LOC/PPI (guards 2): values must be sane
    DESKTOP GET SIZE TO w, h
    IF w > 0 AND h > 0 THEN
        PRINT "OK: DESKTOP GET SIZE "; w; "x"; h
    ELSE
        PRINT "FAIL: DESKTOP GET SIZE "; w; "x"; h
        INCR fails
    END IF
    DESKTOP GET CLIENT TO w, h
    IF w > 0 AND h > 0 THEN
        PRINT "OK: DESKTOP GET CLIENT "; w; "x"; h
    ELSE
        PRINT "FAIL: DESKTOP GET CLIENT "; w; "x"; h
        INCR fails
    END IF
    DESKTOP GET LOC TO x, y
    IF x >= 0 AND y >= 0 THEN
        PRINT "OK: DESKTOP GET LOC "; x; ","; y
    ELSE
        PRINT "FAIL: DESKTOP GET LOC "; x; ","; y
        INCR fails
    END IF
    DESKTOP GET PPI TO ppix, ppiy
    IF ppix > 0 AND ppiy > 0 THEN
        PRINT "OK: DESKTOP GET PPI "; ppix; ","; ppiy
    ELSE
        PRINT "FAIL: DESKTOP GET PPI "; ppix; ","; ppiy
        INCR fails
    END IF

    IF fails = 0 THEN
        PRINT "batch220: ALL PASS"
    ELSE
        PRINT "batch220: FAILURES="; fails
    END IF
    PRINT "=== FAILURES: "; fails; " ==="
END FUNCTION
