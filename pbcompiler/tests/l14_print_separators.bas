'=====================================================================
' l14_print_separators.bas - PRINT's trailing separator suppresses the newline
'---------------------------------------------------------------------
' PowerBASIC documents `PRINT a;` and `PRINT a,` as leaving the cursor on the
' same line, so the next PRINT continues it.  Before batch 187 the compiler
' printed a newline unconditionally, and the parser threw the trailing
' separator away, so `PRINT "6 * 7 = ";` followed by `PRINT answer` produced
' two lines.
'
' This file doubles as a link-guard input: scripts/link_smoke_32.py links every
' pbcompiler/tests/*.bas for both targets, so it also keeps PRINT on the 32-bit
' link path covered (see l13_print_link.bas).
'
' Expected output (run mode) - four lines, the first two joined by the `;`:
'   6 * 7 = 42
'   left/right
'   one
'   two
' Exit code: 0
'=====================================================================
FUNCTION PBMAIN () AS LONG
    PRINT "6 * 7 = ";
    PRINT 6 * 7
    PRINT "left"; "/"; "right"
    PRINT "one"
    PRINT "two"
    FUNCTION = 0
END FUNCTION
