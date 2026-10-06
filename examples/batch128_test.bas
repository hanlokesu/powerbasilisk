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
' Tier-3 DDT: WINDOW NEW - basic window creation
' Auto-generated: PowerBasilisk fork batch test

FUNCTION PBMAIN() AS LONG
    LOCAL h AS QUAD
    MSGBOX "Batch 128: Tests WINDOW statement - creates a native Win32 window.", 0, "Test: WINDOW"
    WINDOW "Window Test", 100, 100, 400, 300 TO h
    MSGBOX "Window created (hwnd=" + STR$(h) + "). Close this message to end.", 0, "WINDOW OK"
END FUNCTION
