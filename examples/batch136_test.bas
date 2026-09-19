' Tier-3 DDT: CONTROL ADD RADIOBUTTON - radio selection
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hR AS QUAD
    MSGBOX "Batch 136: Tests CONTROL ADD RADIOBUTTON - 3 radio buttons (select one).", 0, "Test: RADIOBUTTON"
    WINDOW "Batch 136: RadioButton", 200, 200, 500, 400 TO hWnd
    CONTROL ADD RADIOBUTTON, hWnd, 101, "Option A", 20, 20, 400, 30 TO hR
    CONTROL ADD RADIOBUTTON, hWnd, 102, "Option B", 20, 60, 400, 30 TO hR
    CONTROL ADD RADIOBUTTON, hWnd, 103, "Option C", 20, 100, 400, 30 TO hR
    pb_message_loop
END FUNCTION
