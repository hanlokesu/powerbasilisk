FUNCTION PBMAIN() AS LONG
    LOCAL h AS LONG
    WINDOW "PowerBasilisk Tier-3 Test", 100, 100, 400, 300 TO h
    MSGBOX "Window created (hwnd=" + STR$(h) + ")", 0, "WINDOW NEW OK"
END FUNCTION
