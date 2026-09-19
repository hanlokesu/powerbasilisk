# Batch 135: CheckBox
#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS LONG
    LOCAL hChk AS LONG
    WINDOW "Batch 135: CheckBox", 100, 100, 400, 300 TO hWnd
    CONTROL ADD CHECKBOX, hWnd, 101, "Option A", 20, 20, 300, 30 TO hChk
    CONTROL ADD CHECKBOX, hWnd, 102, "Option B", 20, 60, 300, 30 TO hChk
    CONTROL ADD CHECKBOX, hWnd, 103, "Option C", 20, 100, 300, 30 TO hChk
    MSGBOX "Click OK to see the window behind"
    pb_message_loop
END FUNCTION