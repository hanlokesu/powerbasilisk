#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hEd AS QUAD
    LOCAL hBtn AS QUAD
    LOCAL s AS STRING
    WINDOW "Batch 132: GET/SET TEXT", 100, 100, 400, 200 TO hWnd
    CONTROL ADD EDITBOX, hWnd, 101, "Hello", 20, 20, 200, 25 TO hEd
    CONTROL GET TEXT hEd TO s
    MSGBOX "Initial text: " + s
    CONTROL SET TEXT hEd, "Changed!"
    CONTROL GET TEXT hEd TO s
    MSGBOX "After SET: " + s
    pb_message_loop
END FUNCTION
