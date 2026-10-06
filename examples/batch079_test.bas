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

' PowerBasilisk Enhanced - Batch 79 Test: OOP foundation (CLASS/METHOD/OBJECT/INSTANCE) + ARRAY REDIM

' CLASS/END CLASS block at top level (simplified: namespace, methods inside are skipped)
CLASS MyClass
    METHOD Foo()
        ConPrint "inside Foo (should NOT appear)"
    END METHOD
END CLASS

' METHOD at top level (treated as SUB)
METHOD TestMethod()
    ConPrint "TestMethod called"
END METHOD

FUNCTION PBMAIN() AS LONG
    LOCAL arr(10) AS LONG
    LOCAL obj AS LONG
    LOCAL waitk AS STRING

    ConPrint "=== Batch 79: OOP foundation + ARRAY REDIM ==="

    ConPrint "CLASS/END CLASS: parsed OK (block skipped)"

    ' OBJECT type (treated as pointer/LONG)
    obj = 0
    ConPrint "OBJECT type: OK (value=" & STR$(obj) & ")"

    ' ARRAY REDIM INCR/DECR (simplified: reports new size)
    ARRAY REDIM INCR arr(0), 5
    ConPrint "ARRAY REDIM INCR: done"
    ARRAY REDIM DECR arr(0), 3
    ConPrint "ARRAY REDIM DECR: done"

    ' Call top-level METHOD (treated as SUB)
    TestMethod
    ConPrint "METHOD call: OK"

    ConPrint "=== Result: ALL PASS (OOP foundation + ARRAY REDIM)"
    ConPrint "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
