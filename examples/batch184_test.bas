'=====================================================================
' batch184_test.bas - batch 184: the --batch-note-file path of sync_coverage_docs.py, verified
'---------------------------------------------------------------------
' This batch changed no code at all (tool verification only), so there is no product behaviour of its own
' to pin.  The sample exists for two reasons:
'
'   * the corpus keeps a 1:1 batch <-> examples/batchN_test.bas mapping, so the
'     release gate always has one file it can compile AND run for the batch;
'   * it is the end-to-end smoke test of that mapping: preprocess -> lex ->
'     parse -> codegen -> link -> run, exercising the runtime calls the shipped
'     hello.bas depends on (CURDIR$, ISFILE, PRINT).
'
' Asserts: the working directory string is non-empty.  Nothing here depends on
' the tooling batch's own artefacts, which live in scripts/ and .github/.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL here AS STRING
    here = CURDIR$
    PRINT "batch 184 sample (verification-only batch, no code change)"
    PRINT "CURDIR$     = "; here
    PRINT "ISFILE(exe) = "; ISFILE("batch184_test.exe")
    IF LEN(here) = 0 THEN
        fail = fail + 1
    END IF
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
' Press any key to exit...
WAITKEY$
END FUNCTION
