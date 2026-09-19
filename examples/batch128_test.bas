FUNCTION PBMAIN() AS LONG
    LOCAL h AS QUAD
    WINDOW "Window Test", 100, 100, 400, 300 TO h
    MSGBOX "Window created (hwnd=" + STR$(h) + ")", 0, "WINDOW NEW OK"
END FUNCTION
