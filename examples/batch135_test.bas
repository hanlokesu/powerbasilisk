' Tier-3 DDT: CONTROL ADD CHECKBOX - toggle checkbox
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hChk AS QUAD
    MSGBOX "Batch 135: Tests CONTROL ADD CHECKBOX - 3 checkboxes. Click them to toggle.", 0, "Test: CHECKBOX"
    WINDOW "Batch 135: CheckBox", 200, 200, 500, 400 TO hWnd
    CONTROL ADD CHECKBOX, hWnd, 101, "Option A", 20, 20, 400, 30 TO hChk
    CONTROL ADD CHECKBOX, hWnd, 102, "Option B", 20, 60, 400, 30 TO hChk
    CONTROL ADD CHECKBOX, hWnd, 103, "Option C", 20, 100, 400, 30 TO hChk
    pb_message_loop
END FUNCTION
