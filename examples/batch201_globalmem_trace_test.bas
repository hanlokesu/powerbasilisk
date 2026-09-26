'=====================================================================
' batch 201 - GLOBALMEM and TRACE: two silent no-ops made real
'---------------------------------------------------------------------
' Defect 1: `GLOBALMEM ALLOC 64 TO h` parsed to ONE argument, because the parser
'   only consumed TO after a comma.  The codegen arm needs two arguments, so the
'   statement compiled cleanly and then did nothing at all.
' Defect 2: the numeric branch of TRACE PRINT skipped four bytes for a length
'   prefix that is not there.  num_to_string returns a BSTR whose pointer already
'   addresses the characters, so `TRACE PRINT 42` wrote a stray byte from
'   uninitialised heap instead of 42.
'
' Pointer results (GLOBALMEM LOCK, IMPORT ADDR, IMAGELIST NEW) are 64-bit
' addresses: hold them in QUAD.  A LONG truncates them to 0 on this target.
' The trace file this program writes is checked externally by the harness:
' it must contain exactly the two lines "alpha" and "42".
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL h       AS LONG
    LOCAL p       AS QUAD
    LOCAL sz      AS LONG
    LOCAL scratch AS LONG
    LOCAL fails   AS LONG

    fails = 0

    GLOBALMEM ALLOC 64 TO h
    PRINT "alloc handle = "; h
    IF h = 0 THEN fails = fails + 1

    GLOBALMEM SIZE h TO sz
    PRINT "size = "; sz
    IF sz < 64 THEN fails = fails + 1

    GLOBALMEM LOCK h TO p
    PRINT "lock pointer = "; p
    IF p = 0 THEN fails = fails + 1

    GLOBALMEM UNLOCK h TO scratch
    GLOBALMEM FREE h TO scratch
    PRINT "unlock/free returned "; scratch

    TRACE NEW "batch201_trace.txt"
    TRACE ON
    TRACE PRINT "alpha"
    TRACE PRINT 42
    TRACE OFF
    TRACE PRINT "must not be written"
    TRACE CLOSE
    PRINT "wrote batch201_trace.txt"

    PRINT "=== FAILURES: "; fails
    FUNCTION = fails
END FUNCTION
