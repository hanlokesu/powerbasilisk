' Tier-3 DDT: CONTROL ADD EDITBOX - text input
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hEd AS QUAD
    LOCAL hBtn AS QUAD
    LOCAL s AS STRING
    MSGBOX "Batch 132: Tests CONTROL GET/SET TEXT - reads and writes editbox text.", 0, "Test: GET/SET TEXT"
    WINDOW "Batch 132: GET/SET TEXT", 100, 100, 400, 200 TO hWnd
    CONTROL ADD EDITBOX, hWnd, 101, "Hello", 20, 20, 200, 25 TO hEd
    CONTROL GET TEXT hEd TO s
    MSGBOX "Initial text: " + s, 0, "GET TEXT"
    CONTROL SET TEXT hEd, "Changed!"
    CONTROL GET TEXT hEd TO s
    MSGBOX "After SET: " + s, 0, "SET TEXT"
    pb_message_loop
END FUNCTION
