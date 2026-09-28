' batch 219 negative probe: FILECOPY with one argument is a malformed statement.
' Official syntax: FILECOPY sourcefile, destfile
' Before batch 219 this compiled and silently did nothing (exit code 0).
FUNCTION PBMAIN () AS LONG
    FILECOPY "a.txt"
    FUNCTION = 0
END FUNCTION
