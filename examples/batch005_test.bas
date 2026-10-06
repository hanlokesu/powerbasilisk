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

' Batch 5: PEEK / POKE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL x AS LONG
    LOCAL addr AS QUAD
    LOCAL b AS LONG

    x = 0
    addr = VARPTR(x)
    POKE LONG, addr, 12345
    IF x = 12345 THEN
        ConPrint "POKE-LONG-PASS"
    ELSE
        ConPrint "POKE-LONG-FAIL x=" & STR$(x)
    END IF

    b = PEEK(LONG, addr)
    IF b = 12345 THEN
        ConPrint "PEEK-LONG-PASS"
    ELSE
        ConPrint "PEEK-LONG-FAIL b=" & STR$(b)
    END IF

    POKE BYTE, addr, 65
    b = PEEK(addr)
    IF b = 65 THEN
        ConPrint "PEEK-BYTE-PASS"
    ELSE
        ConPrint "PEEK-BYTE-FAIL b=" & STR$(b)
    END IF

    POKE BYTE, addr, 7, 8, 9
    b = PEEK(addr)
    IF b = 7 AND PEEK(addr + 2) = 9 THEN
        ConPrint "POKE-MULTI-PASS"
    ELSE
        ConPrint "POKE-MULTI-FAIL b=" & STR$(b)
    END IF
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
