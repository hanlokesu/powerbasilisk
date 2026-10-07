#COMPILE EXE
#DIM ALL
#OPTION EXPLICIT
#LINK "kernel32.lib"
#STACK 1048576
#ALIGN 4
#BREAK ON
#DEBUG BOUNDS ON
#DEBUG CODE ON
#DEBUG DISPLAY ON
#DEBUG ERROR ON
#DEBUG NUMERIC ON
#DEBUG ConPrint ON
#REGISTER NONE
#UNIQUE ON
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


#BLOAT NONE
#COM ON
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
#EXPORT
#MESSAGES OFF
#OPTIMIZE SPEED
#PAGE
#PBFORMS
#RESOURCE "x.rc"
#TOOLS OFF
#UTILITY "x"
#IF %DEF(%PB_WIN10)
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
#ELSEIF %DEF(%PB_CC)
    #CONSOLE ON
#ELSE
    #CONSOLE ON
#ENDIF
#INCLUDE "win32api.inc"
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    MSGBOX "META-ALL-ACCEPTED"
    FUNCTION = 0
    MSGBOX "Press OK to exit.", 0, "Done"
END FUNCTION

