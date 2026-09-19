# Batch 135: CheckBox
#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS LONG
    LOCAL hChk AS LONG
    WINDOW "Batch 135: CheckBox", 100, 100, 400, 200 TO hWnd
    CONTROL ADD CHECKBOX, hWnd, 101, "Option A", 20, 20, 200, 20 TO hChk
    CONTROL ADD CHECKBOX, hWnd, 102, "Option B", 20, 50, 200, 20 TO hChk
    MSGBOX "Checkboxes created - click to toggle"
    pb_message_loop
END FUNCTION