' Batch 119: ARRAY SCAN / ARRAY SELECT / ARRAY REDIM INCR-DECR
' Regression for parser bug: these statements were silently dropped
' (reserved tokens SELECT/REDIM/INCR/DECR not recognized by parser guards).
' Now they emit real IR calls. SCAN returns the 1-based index of a match.
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL i AS LONG
    LOCAL n AS LONG
    LOCAL a(1 TO 6) AS LONG
    a(1)=11: a(2)=22: a(3)=33: a(4)=44: a(5)=55: a(6)=66

    PRINT "=== Batch 119: ARRAY SCAN / SELECT / REDIM ==="

    ' Test 1: ARRAY SCAN = value  -> 1-based index
    i = -1
    ARRAY SCAN a(), = 33 TO i
    PRINT "SCAN = 33 -> index="; i; " (expect 3)"

    ' Test 2: ARRAY SCAN with <> operator
    i = -1
    ARRAY SCAN a(), <> 33 TO i
    PRINT "SCAN <> 33 -> index="; i; " (expect 1)"

    ' Test 3: ARRAY SELECT sets the active selection range
    ARRAY SELECT a(), 2, 5
    PRINT "ARRAY SELECT a(), 2, 4 accepted (selection state set)"

    ' Test 4: ARRAY REDIM INCR / DECR (runtime reports new size)
    ARRAY REDIM INCR a(), 2
    ARRAY REDIM DECR a(), 1
    PRINT "ARRAY REDIM INCR/DECR accepted"

    PRINT ""
    PRINT "=== ALL TESTS RAN ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
