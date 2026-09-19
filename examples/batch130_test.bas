# Batch 130: CONTROL ADD BUTTON (Tier-3 DDT GUI #2)
#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS LONG
    LOCAL hBtn AS LONG
    WINDOW "Batch 130: Button", 100, 100, 400, 300 TO hWnd
    CONTROL ADD BUTTON, hWnd, 100, "Click Me!", 20, 20, 100, 30 TO hBtn
    MSGBOX "Window + Button created. hBtn=" + STR$(hBtn)
    pb_message_loop
END FUNCTION
