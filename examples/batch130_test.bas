#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hBtn AS QUAD
    MSGBOX "Batch 130: Tests CONTROL ADD BUTTON - creates a push button on the window.", 0, "Test: BUTTON"
    WINDOW "Batch 130: Button", 100, 100, 400, 300 TO hWnd
    CONTROL ADD BUTTON, hWnd, 100, "Click Me!", 20, 20, 100, 30 TO hBtn
    MSGBOX "Window + Button created. hBtn=" + STR$(hBtn), 0, "BUTTON OK"
    pb_message_loop
END FUNCTION
