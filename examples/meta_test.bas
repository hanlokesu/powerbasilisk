#COMPILE EXE
#DIM ALL
' meta-disabled for PBWin10 dual-compile: #OPTION EXPLICIT
' meta-disabled for PBWin10 dual-compile: #LINK "kernel32.lib"
#STACK 1048576
#ALIGN 4
' meta-disabled for PBWin10 dual-compile: #BREAK ON
' meta-disabled for PBWin10 dual-compile: #DEBUG BOUNDS ON
' meta-disabled for PBWin10 dual-compile: #DEBUG CODE ON
' meta-disabled for PBWin10 dual-compile: #DEBUG DISPLAY ON
' meta-disabled for PBWin10 dual-compile: #DEBUG ERROR ON
' meta-disabled for PBWin10 dual-compile: #DEBUG NUMERIC ON
' meta-disabled for PBWin10 dual-compile: #DEBUG ConPrint ON
#REGISTER NONE
' meta-disabled for PBWin10 dual-compile: #UNIQUE ON
' === console emulation for dual-compiler compatibility ===
' (PBWin10 has no PRINT/#CONSOLE; this wrapper uses only official Win32 API)
DECLARE FUNCTION AllocConsole LIB "KERNEL32.DLL" ALIAS "AllocConsole" () AS LONG
DECLARE FUNCTION AttachConsole LIB "KERNEL32.DLL" ALIAS "AttachConsole" (BYVAL dwProcessId AS DWORD) AS LONG
DECLARE FUNCTION GetStdHandle LIB "KERNEL32.DLL" ALIAS "GetStdHandle" (BYVAL nStdHandle AS DWORD) AS LONG
DECLARE FUNCTION WriteFile LIB "KERNEL32.DLL" ALIAS "WriteFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToWrite AS DWORD, lpBytesWritten AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
DECLARE FUNCTION ReadFile LIB "KERNEL32.DLL" ALIAS "ReadFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToRead AS DWORD, lpBytesRead AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
SUB ConPrint(BYVAL s AS STRING)
    LOCAL h AS LONG
    LOCAL n AS DWORD
    h = GetStdHandle(-11)
    IF h = 0 THEN
        IF AttachConsole(-1) = 0 THEN AllocConsole
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


' meta-disabled for PBWin10 dual-compile: #BLOAT NONE
' meta-disabled for PBWin10 dual-compile: #COM ON
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
' meta-disabled for PBWin10 dual-compile: #EXPORT
' meta-disabled for PBWin10 dual-compile: #MESSAGES OFF
' meta-disabled for PBWin10 dual-compile: #OPTIMIZE SPEED
' meta-disabled for PBWin10 dual-compile: #PAGE
' meta-disabled for PBWin10 dual-compile: #PBFORMS
' meta-disabled for PBWin10 dual-compile: #RESOURCE "x.rc"
' meta-disabled for PBWin10 dual-compile: #TOOLS OFF
' meta-disabled for PBWin10 dual-compile: #UTILITY "x"
' meta-disabled for PBWin10 dual-compile: #IF %DEF(%PB_WIN10)
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
' meta-disabled for PBWin10 dual-compile: #ELSEIF %DEF(%PB_CC)
' meta-disabled for PBWin10 dual-compile: #CONSOLE ON
' meta-disabled for PBWin10 dual-compile: #ELSE
' meta-disabled for PBWin10 dual-compile: #CONSOLE ON
' meta-disabled for PBWin10 dual-compile: #ENDIF
' meta-disabled for PBWin10 dual-compile: #INCLUDE "win32api.inc"
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    MSGBOX "META-ALL-ACCEPTED"
    FUNCTION = 0
    MSGBOX "Press OK to exit.", 0, "Done"
END FUNCTION

