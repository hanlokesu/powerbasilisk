#COMPILE EXE
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

'-------------------------------------------------------------------------------
'
'  HELLO.BAS example for PowerBASIC for Windows
'  Copyright (c) 1997-2011 PowerBASIC, Inc.
'  All Rights Reserved.
'
'-------------------------------------------------------------------------------

#COMPILER PBWIN 10


' The resource gives the EXE program the "hello" icon in Explorer,
' and provides it with Windows version information.
#RESOURCE ICON, 100, "Hello.ico"
#RESOURCE VERSIONINFO
#RESOURCE FILEVERSION 10, 0, 0, 0
#RESOURCE PRODUCTVERSION 10, 0, 0, 0
#RESOURCE STRINGINFO "0409", "04B0"
#RESOURCE VERSION$ "Comments",         "Hello, World Example"
#RESOURCE VERSION$ "CompanyName",      "PowerBASIC, Inc."
#RESOURCE VERSION$ "FileDescription",  "Simple MSGBOX Application for Windows"
#RESOURCE VERSION$ "FileVersion",      "10.0"
#RESOURCE VERSION$ "InternalName",     "Hello"
#RESOURCE VERSION$ "LegalCopyright",   "Copyright © 1996-2011 PowerBASIC, Inc."
#RESOURCE VERSION$ "LegalTrademarks",  "PowerBASIC is a trademark of PowerBASIC, Inc."
#RESOURCE VERSION$ "OriginalFilename", "HELLO.EXE"
#RESOURCE VERSION$ "ProductName",      "PowerBASIC Compiler for Windows"
#RESOURCE VERSION$ "ProductVersion",   "10.0"
'
FUNCTION PBMAIN () AS LONG
    LOCAL waitk AS STRING

    MSGBOX "Hello, World!"
    ConPrint "Press any key to exit..."
    ConWaitKey

END FUNCTION

