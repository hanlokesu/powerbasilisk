#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hLb AS QUAD
    MSGBOX "Batch 134: Tests CONTROL ADD LISTBOX - a list box control.", 0, "Test: LISTBOX"
    WINDOW "Batch 134: ListBox", 100, 100, 400, 300 TO hWnd
    CONTROL ADD LISTBOX, hWnd, 101, 20, 20, 200, 200 TO hLb
    pb_message_loop
END FUNCTION
