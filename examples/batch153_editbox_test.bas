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
' Tier-3 DDT: EDITBOX basic typing test
' Auto-generated: PowerBasilisk fork batch test
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)


CALLBACK FUNCTION DlgProc()
    FUNCTION = 0
END FUNCTION

FUNCTION PBMAIN() AS LONG
    LOCAL hDlg AS QUAD
    LOCAL hEdit AS QUAD
    DIALOG NEW 0, "Edit Test", , , 200, 100 TO hDlg
    CONTROL ADD EDITBOX, hDlg, 1001, "", 10, 10, 180, 20 TO hEdit
    DIALOG SHOW MODAL hDlg CALL DlgProc
END FUNCTION
