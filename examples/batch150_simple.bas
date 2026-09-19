' Tier-3 DDT: CONTROL GET TEXT simple test
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL g_hEdit AS QUAD
GLOBAL hBtn AS QUAD
GLOBAL s AS STRING

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Test", 100, 100, 350, 250 TO g_hDlg
    CONTROL ADD EDITBOX, g_hDlg, 301, "Hello", 50, 50, 200, 25 TO g_hEdit
    CONTROL ADD BUTTON, g_hDlg, 302, "Read", 50, 100, 100, 30 TO hBtn
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
