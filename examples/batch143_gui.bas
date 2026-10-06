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
#COMPILE EXE
' Tier-3 DDT: LABEL + PROGRESSBAR
' Auto-generated: PowerBasilisk fork batch test
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)


GLOBAL g_hLabel AS QUAD
GLOBAL g_hProg AS QUAD

FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD

    WINDOW "Label + Progress", 100, 100, 500, 300 TO hWnd

    CONTROL ADD LABEL, hWnd, 201, "Progress:", 30, 30, 100, 20 TO g_hLabel
    CONTROL ADD PROGRESSBAR, hWnd, 202, 30, 80, 400, 30 TO g_hProg

    MESSAGE LOOP
END FUNCTION
