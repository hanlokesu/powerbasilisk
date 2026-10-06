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
#COMPILE EXE
' Tier-3 DDT: DIALOG NEW + DIALOG SHOW MODAL
' Auto-generated: PowerBasilisk fork batch test
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)


GLOBAL g_hDlg AS QUAD
GLOBAL g_hBtn AS QUAD

CALLBACK FUNCTION DlgProc()
    DIALOG END 0, 1
END FUNCTION

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Test", 100, 100, 300, 200 TO g_hDlg
    CONTROL ADD BUTTON, g_hDlg, 100, "OK", 100, 60, 80, 30 TO g_hBtn
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION
