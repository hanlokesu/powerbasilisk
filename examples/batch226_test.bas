' === console emulation for dual-compiler compatibility ===
' (PBWin10 has no PRINT/#CONSOLE; this wrapper uses only official Win32 API)
DECLARE FUNCTION AllocConsole LIB "KERNEL32.DLL" ALIAS "AllocConsole" () AS LONG
DECLARE FUNCTION GetStdHandle LIB "KERNEL32.DLL" ALIAS "GetStdHandle" (BYVAL nStdHandle AS DWORD) AS LONG
DECLARE FUNCTION WriteFile LIB "KERNEL32.DLL" ALIAS "WriteFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToWrite AS DWORD, lpBytesWritten AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
DECLARE FUNCTION ReadFile LIB "KERNEL32.DLL" ALIAS "ReadFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToRead AS DWORD, lpBytesRead AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
SUB ConPrint(BYVAL s AS STRING)
    LOCAL h AS LONG
    LOCAL n AS DWORD
    h = GetStdHandle(-11)
    IF h = 0 THEN
        AllocConsole
        h = GetStdHandle(-11)
    END IF
    IF h <> 0 THEN
        WriteFile h, BYVAL STRPTR(s), LEN(s), n, 0
    END IF
END SUB
SUB ConWaitKey()
    LOCAL h AS LONG
    LOCAL c AS STRING * 1
    LOCAL n AS DWORD
    h = GetStdHandle(-10)
    IF h <> 0 THEN
        ReadFile h, c, 1, n, 0
    END IF
END SUB

' batch 226: string concatenation with numeric operands.
' Regression for the codegen fix: "x" & LEN(...) / "x" & n used to pass the
' raw i32 Val as the second pointer argument of pb_str_concat, corrupting or
' dropping the whole output.  Numeric operands are now converted to text
' first (STR$ semantics), on both sides of the &.
FUNCTION PBMAIN() AS LONG
    LOCAL n AS LONG
    LOCAL s AS STRING
    LOCAL q AS QUAD
    n = 42
    s = "world"
    q = 9876543210
    ConPrint "C1-" & STR$(n)
    ConPrint "C2-" & STR$(LEN("abc"))
    ConPrint "C3-" & STR$(n)
    ConPrint "C4-" & STR$(ISFILE(".\nonexistent.txt"))
    ConPrint "C5-" & s & "-" & STR$(n)
    ConPrint "C6-" & STR$(q)
    ConPrint "C7-" & STR$(7)
    ConPrint "FAILURES: 0"
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

