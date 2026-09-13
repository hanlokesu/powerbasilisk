TYPE MyType
    n AS LONG
    d AS DOUBLE
    s AS STRING * 12
END TYPE

#COMPILE EXE
FUNCTION PBMAIN() AS LONG
    LOCAL t1, t2 AS MyType
    LOCAL f AS LONG
    LOCAL s, d1, d2, d3 AS STRING
    LOCAL waitk AS STRING
    ' GET$ / PUT$ round-trip on a binary file
    OPEN "batch24_bin.dat" FOR BINARY AS #1
    PUT$ #1, "HelloBinary123"
    SEEK #1, 1
    GET$ #1, 13, s
    CLOSE #1
    PRINT "GET$ ="; s
    ' LET whole-TYPE assignment
    t1.n = 42
    t1.d = 3.14
    t1.s = "hello"
    t2 = t1
    PRINT "t2.n ="; t2.n; " t2.s ="; TRIM$(t2.s)
    ' DIR$ function + DIR statement family
    OPEN "batch24_dir_a.tmp" FOR OUTPUT AS #2
    CLOSE #2
    OPEN "batch24_dir_b.tmp" FOR OUTPUT AS #3
    CLOSE #3
    d1 = DIR$("batch24_dir_*.tmp")
    PRINT "DIR$ first ="; d1
    d2 = DIR$(NEXT)
    PRINT "DIR$ next  ="; d2
    DIR "batch24_dir_*.tmp" TO s
    PRINT "DIR stmt    ="; s
    DIR NEXT TO s
    PRINT "DIR NEXT    ="; s
    DIR CLOSE
    KILL "batch24_dir_a.tmp"
    KILL "batch24_dir_b.tmp"
    KILL "batch24_bin.dat"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
