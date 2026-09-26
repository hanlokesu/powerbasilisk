' Negative probe - MUST FAIL TO COMPILE.  Not part of the runnable corpus.
' Checked by the skill script check_negative_probes.py.
' Expected: non-zero exit, a diagnostic naming an unsupported LISTVIEW sub-command, no .exe produced.
FUNCTION PBMAIN () AS LONG
    LOCAL h AS LONG
    DIALOG NEW 0, "p", 0, 0, 200, 120 TO h
    LISTVIEW FIT h, 9999
    FUNCTION = 0
END FUNCTION
