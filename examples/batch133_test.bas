#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS LONG
    LOCAL hCbo AS LONG
    WINDOW "Batch 133: ComboBox", 100, 100, 400, 200 TO hWnd
    CONTROL ADD COMBOBOX, hWnd, 101, 20, 20, 200, 100 TO hCbo
    MSGBOX "ComboBox created. hCbo=" + STR$(hCbo)
    pb_message_loop
END FUNCTION
