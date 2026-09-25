' =====================================================================
' Regression guard for the 32-bit PRINT link defect (fixed in batch 186)
' ---------------------------------------------------------------------
' Purpose: keep a PRINT-using source inside `pbcompiler/tests/`, which is the
'   set `scripts/link_smoke_32.py` links for BOTH targets.  Until batch 186 the
'   32-bit link of any program that printed failed with
'
'     lld-link: error: undefined symbol: _printf
'
'   while the very same source linked fine for x64.  The cause is not the
'   Windows SDK: `printf`/`scanf` moved into the UCRT and the legacy names are
'   supplied by `legacy_stdio_definitions.lib`, which MSVC's own link line adds
'   and clang's does not.
'
' Why this file has to exist
'   The defect was invisible to every local gate: the runtime still compiled for
'   i686 (undefined symbols are a link-time matter), cargo only builds Rust, and
'   the example runner only ever linked x64.  A source in this folder is the one
'   thing the 32-bit link gate actually sees.
'
' Note: nothing runs this program during the gate - it is linked only - so there
'   is no keyboard input and nothing to block on.  It prints three lines and
'   returns 0, and it exercises both the plain-string and the
'   string-then-number forms of PRINT.
' =====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL answer AS LONG
    PRINT "print link regression guard"
    answer = 6 * 7
    PRINT "The answer is:"; answer
    PRINT "done"
    FUNCTION = 0
END FUNCTION
