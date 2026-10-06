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

' PowerBasilisk Enhanced - batch 41: BUILD$ / CLIP$ / WRAP$ / UNWRAP$ / SHRINK$
GLOBAL failures AS LONG

SUB Check(cond AS LONG, msg AS STRING)
    IF cond = 0 THEN
        ConPrint "FAIL: " & msg
        failures = failures + 1
    END IF
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL x AS STRING
    failures = 0

    x = BUILD$("a", "b", "c")
    Check(x = "abc", "build")
    x = CLIP$(LEFT "abcdef", 2)
    Check(x = "cdef", "clip left")
    x = CLIP$(RIGHT "abcdef", 2)
    Check(x = "abcd", "clip right")
    x = CLIP$(MID "abcdef", 3, 2)
    Check(x = "abef", "clip mid")
    x = WRAP$("MyWord", "<", ">")
    Check(x = "<MyWord>", "wrap")
    x = UNWRAP$("<MyWord>", "<", ">")
    Check(x = "MyWord", "unwrap")
    x = SHRINK$("  a   b  c ")
    Check(x = "a b c", "shrink")

    IF failures = 0 THEN
        ConPrint "batch41: ALL PASS"
    ELSE
        ConPrint "batch41: FAILURES=" & STR$(failures)
    END IF
    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

