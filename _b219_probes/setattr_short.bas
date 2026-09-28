' batch 219 negative probe: SETATTR with one argument is a malformed statement.
' Official syntax: SETATTR filespec$, attribute
' Second probe so the witness covers more than a single family.
FUNCTION PBMAIN () AS LONG
    SETATTR "a.txt"
    FUNCTION = 0
END FUNCTION
