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
' Tier-3 DDT: CONTROL ADD RADIOBUTTON - radio selection
' Auto-generated: PowerBasilisk fork batch test
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
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
