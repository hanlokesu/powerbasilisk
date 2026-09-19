' Tier-3 DDT: DIALOG SET TEXT - change window title at runtime
#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 149: Dialog Before", 100, 100, 350, 200 TO g_hDlg
    CONTROL ADD BUTTON, g_hDlg, 100, "Change Title", 100, 70, 100, 30
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 100 THEN
                DIALOG SET TEXT g_hDlg, "Dialog After"
                CONTROL SET TEXT g_hDlg, 100, "Changed!"
            END IF
    END SELECT
END FUNCTION
