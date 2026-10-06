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
' Tier-3 DDT: CHECKBOX + GROUPBOX - grouped checkboxes
' Auto-generated: PowerBasilisk fork batch test
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hG AS QUAD
    LOCAL hChk AS QUAD
    MSGBOX "Batch 137: Tests CONTROL ADD GROUPBOX - a group box frame with 3 checkboxes inside.", 0, "Test: GROUPBOX"
    WINDOW "Batch 137: GroupBox", 200, 200, 500, 400 TO hWnd
    CONTROL ADD GROUPBOX, hWnd, 201, "Options", 20, 20, 440, 200 TO hG
    CONTROL ADD CHECKBOX, hWnd, 101, "Option A", 50, 60, 380, 30 TO hChk
    CONTROL ADD CHECKBOX, hWnd, 102, "Option B", 50, 100, 380, 30 TO hChk
    CONTROL ADD CHECKBOX, hWnd, 103, "Option C", 50, 140, 380, 30 TO hChk
    pb_message_loop
END FUNCTION
