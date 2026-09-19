# Batch 133: ComboBox with items
#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS LONG
    LOCAL hCbo AS LONG
    WINDOW "Batch 133: ComboBox", 100, 100, 400, 250 TO hWnd
    CONTROL ADD COMBOBOX, hWnd, 101, 20, 20, 200, 150 TO hCbo
    CONTROL SET TEXT hCbo, "Item 1"
    MSGBOX "ComboBox created - click the dropdown arrow"
    pb_message_loop
END FUNCTION