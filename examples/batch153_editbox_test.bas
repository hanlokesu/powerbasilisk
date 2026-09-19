' Tier-3 DDT: EDITBOX basic typing test
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
#COMPILE EXE

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
