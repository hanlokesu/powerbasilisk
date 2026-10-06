#IF (%PB_REVISION AND &H0FF00) = &H1000
    ' Compiling with PB/Win 10.x
    %MY_PBVER = 10
#ELSEIF (%PB_REVISION AND &H0FF00) = &H0900
    ' Compiling with PB/Win 9.x
    %MY_PBVER = 9
#ELSE
    ' Not PBWin (this fork, or other)
    %MY_PBVER = 0
#ENDIF
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

' Batch 107: DECLARE / DIM / REDIM
DECLARE SUB MySub()
DECLARE FUNCTION MyFunc(x AS LONG) AS LONG

SUB MySub()
    ConPrint "  MySub called"
END SUB

FUNCTION MyFunc(x AS LONG) AS LONG
    FUNCTION = x * 2
END FUNCTION

FUNCTION PBMAIN() AS LONG
    LOCAL i AS LONG
    LOCAL arr(5) AS LONG
    LOCAL waitk AS STRING
    
    ConPrint "Testing DIM..."
    DIM arr2(10) AS LONG
    ConPrint "  DIM arr2(10) OK"
    
    ConPrint "Testing REDIM..."
    REDIM arr2(20) AS LONG
    ConPrint "  REDIM arr2(20) OK"
    
    ConPrint "Testing DECLARE..."
    CALL MySub
    i = MyFunc(5)
    ConPrint "  MyFunc(5) = " & STR$(i)
    
    ConPrint "DIM / REDIM / DECLARE tests passed!"
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
