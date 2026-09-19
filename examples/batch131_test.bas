#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS LONG
    LOCAL hBtn AS LONG
    LOCAL hEd AS LONG
    WINDOW "Batch 131: EditBox", 100, 100, 400, 300 TO hWnd
    CONTROL ADD EDITBOX, hWnd, 101, "Type here...", 20, 20, 200, 25 TO hEd
    CONTROL ADD BUTTON, hWnd, 102, "OK", 20, 60, 80, 30 TO hBtn
    MSGBOX "Editbox + Button created"
    pb_message_loop
END FUNCTION
