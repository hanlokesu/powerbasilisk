FUNCTION PBMAIN() AS LONG
    LOCAL h AS QUAD
    MSGBOX "Batch 128: Tests WINDOW statement - creates a native Win32 window.", 0, "Test: WINDOW"
    WINDOW "Window Test", 100, 100, 400, 300 TO h
    MSGBOX "Window created (hwnd=" + STR$(h) + "). Close this message to end.", 0, "WINDOW OK"
END FUNCTION
