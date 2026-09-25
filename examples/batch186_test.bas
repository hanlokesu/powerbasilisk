'=====================================================================
' PowerBasilisk example - batch 186 test
'---------------------------------------------------------------------
' What this tests: PRINT on the 32-bit target.
'
' PRINT lowers to the CRT's printf.  UCRT keeps the legacy stdio names in
' legacy_stdio_definitions.lib - a library MSVC's own link line adds and
' clang's does not.  Before batch 186 this file therefore compiled for
' i686 but failed at link time:
'
'     lld-link: error: undefined symbol: _printf
'
' while the very same source linked fine for x64.  The compiler now
' locates that archive and passes it by full path in both link steps.
'
' scripts/link_smoke_32.py links every pbcompiler/tests/*.bas for both
' targets on each change, and pbcompiler/tests/l13_print_link.bas is the
' permanent guard; this example is the same case written for people
' rather than for the gate.
'
' Expected output (run mode):
'   batch 186 - PRINT links on both targets
'   6 * 7 = 42
'   done
' The second line used to arrive as two lines (`6 * 7 = ` then `42`); batch 187
' made the statement's trailing `;` suppress the newline, so this file's header
' was updated with it.
' Exit code: 0
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL answer AS LONG
    answer = 6 * 7
    PRINT "batch 186 - PRINT links on both targets"
    PRINT "6 * 7 = ";
    PRINT answer
    PRINT "done"
    FUNCTION = 0
END FUNCTION
