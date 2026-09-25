'=====================================================================
' PowerBasilisk example - batch 187 test
'---------------------------------------------------------------------
' What this tests: a trailing `;` (or `,`) on PRINT suppresses the newline.
'
' PowerBASIC's rule, quoted from the manual and repeated in the official corpus:
' a semicolon at the end of a PRINT statement leaves the cursor where it is, so
' the next PRINT continues the same line.  Until batch 187 this compiler printed
' the newline anyway:
'
'     PRINT "6 * 7 = "        <- no separator: its own line
'     PRINT 6 * 7
'
' produced
'
'     6 * 7 =
'     42
'
' where PowerBASIC produces `6 * 7 = 42`.
'
' The separator is now carried on the statement (PrintStmt::trailing) instead of
' being dropped by the parser, and the code generator emits the newline only when
' there was none.
'
' Known divergence, stated rather than hidden: a trailing COMMA suppresses the
' newline exactly like a semicolon here, but PowerBASIC also advances the cursor
' to the next print zone (14 columns).  Zone advance needs the current column, so
' it is not implemented yet.
'
' Expected output (run mode) - four lines, the first two joined by the `;`:
'   6 * 7 = 42
'   left/right
'   one
'   two
' Exit code: 0
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL answer AS LONG
    answer = 6 * 7
    PRINT "6 * 7 = ";
    PRINT answer
    PRINT "left"; "/"; "right"
    PRINT "one"
    PRINT "two"
    FUNCTION = 0
END FUNCTION
