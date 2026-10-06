' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
FUNCTION PBMAIN() AS LONG
    LOCAL h AS LONG
    WINDOW "Test Window", 200, 200, 500, 400 TO h
    MSGBOX "hWnd=" + STR$(h) + " - click OK, window should be behind this box", 0, "Test"
END FUNCTION