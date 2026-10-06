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
' Tier-3 DDT: CONTROL ADD CHECKBOX - toggle checkbox
' Auto-generated: PowerBasilisk fork batch test
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
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
