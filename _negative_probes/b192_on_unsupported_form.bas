' Negative probe - MUST FAIL TO COMPILE.  Not part of the runnable corpus.
' Checked by the skill script check_negative_probes.py.
' Expected: non-zero exit, a diagnostic naming an unsupported ON form, no .exe produced.
FUNCTION PBMAIN () AS LONG
    ON NOSUCHTHING GOTO 100
    FUNCTION = 0
END FUNCTION
