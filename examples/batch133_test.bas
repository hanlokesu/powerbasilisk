#IF (%PB_REVISION AND &H0FF00) = &H1000
    ' Compiling with PB/Win 10.x
    %MY_PBVER = 10
#ELSEIF (%PB_REVISION AND &H0FF00) = &H0900
    ' Compiling with PB/Win 9.x
    %MY_PBVER = 9
#ELSE
    ' Not PBWin (this fork, or other)
    %MY_PBVER = 0
#ENDIF
' Tier-3 DDT: CONTROL ADD COMBOBOX - dropdown list
' Auto-generated: PowerBasilisk fork batch test
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hCbo AS QUAD
    MSGBOX "Batch 133: Tests CONTROL ADD COMBOBOX - a dropdown list. Click the arrow to open it.", 0, "Test: COMBOBOX"
    WINDOW "Batch 133: ComboBox", 100, 100, 400, 250 TO hWnd
    CONTROL ADD COMBOBOX, hWnd, 101, 20, 20, 200, 150 TO hCbo
    CONTROL SET TEXT hCbo, "Item 1"
    pb_message_loop
END FUNCTION
