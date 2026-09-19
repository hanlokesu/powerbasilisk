' Tier-3 DDT: CONTROL ADD COMBOBOX - dropdown list
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hCbo AS QUAD
    MSGBOX "Batch 133: Tests CONTROL ADD COMBOBOX - a dropdown list. Click the arrow to open it.", 0, "Test: COMBOBOX"
    WINDOW "Batch 133: ComboBox", 100, 100, 400, 250 TO hWnd
    CONTROL ADD COMBOBOX, hWnd, 101, 20, 20, 200, 150 TO hCbo
    CONTROL SET TEXT hCbo, "Item 1"
    pb_message_loop
END FUNCTION
