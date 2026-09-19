' Tier-3 DDT: CONTROL GET TEXT by ID
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL g_hEdit AS QUAD
GLOBAL s AS STRING

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 150", 100, 100, 350, 250 TO g_hDlg
    CONTROL ADD EDITBOX, g_hDlg, 301, "Hello", 50, 50, 200, 25 TO g_hEdit
    CONTROL ADD BUTTON, g_hDlg, 302, "Read", 50, 100, 100, 30
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 302 THEN
                CONTROL GET TEXT g_hDlg, 301 TO s
                MSGBOX s
            END IF
    END SELECT
END FUNCTION
