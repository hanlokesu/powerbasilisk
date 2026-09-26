' Negative probe - MUST FAIL TO COMPILE.  Not part of the runnable corpus.
' Checked by the skill script check_negative_probes.py.
' Expected: non-zero exit, a diagnostic naming an unrecognised statement, no .exe produced.
FUNCTION PBMAIN () AS LONG
    FLY ME TO THE MOON
    FUNCTION = 0
END FUNCTION
