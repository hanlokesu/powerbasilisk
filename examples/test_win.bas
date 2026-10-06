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
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
FUNCTION PBMAIN() AS LONG
    LOCAL h AS LONG
    WINDOW "Test Window", 200, 200, 500, 400 TO h
    MSGBOX "hWnd=" + STR$(h) + " - click OK, window should be behind this box", 0, "Test"
END FUNCTION