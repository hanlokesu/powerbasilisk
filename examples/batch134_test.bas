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
' Tier-3 DDT: CONTROL ADD LISTBOX - list selection
' Auto-generated: PowerBasilisk fork batch test
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)
FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hLb AS QUAD
    MSGBOX "Batch 134: Tests CONTROL ADD LISTBOX - a list box control.", 0, "Test: LISTBOX"
    WINDOW "Batch 134: ListBox", 100, 100, 400, 300 TO hWnd
    CONTROL ADD LISTBOX, hWnd, 101, 20, 20, 200, 200 TO hLb
    pb_message_loop
END FUNCTION
