#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hBtn AS QUAD
    LOCAL hEd AS QUAD
    MSGBOX "Batch 131: Tests CONTROL ADD EDITBOX - a text input field + OK button.", 0, "Test: EDITBOX"
    WINDOW "Batch 131: EditBox", 100, 100, 400, 300 TO hWnd
    CONTROL ADD EDITBOX, hWnd, 101, "Type here...", 20, 20, 200, 25 TO hEd
    CONTROL ADD BUTTON, hWnd, 102, "OK", 20, 60, 80, 30 TO hBtn
    pb_message_loop
END FUNCTION
