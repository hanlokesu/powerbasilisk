FUNCTION PBMAIN () AS LONG
    LOCAL p AS LONG
    IMPORT ADDR "MessageBoxA", "user32.dll" TO p
    PRINT "import addr = "; p
    FUNCTION = 0
END FUNCTION
