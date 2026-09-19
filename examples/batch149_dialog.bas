' Tier-3 DDT: DIALOG CENTER + DIALOG SET TEXT
' Shows how to center dialog and change title at runtime

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL hBtn AS QUAD

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 149: BEFORE", 100, 100, 300, 180 TO g_hDlg
    DIALOG CENTER g_hDlg
    CONTROL ADD BUTTON, g_hDlg, 101, "Change Title", 90, 60, 120, 30 TO hBtn
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 101 THEN
                DIALOG SET TEXT g_hDlg, "AFTER: Title Changed!"
            END IF
    END SELECT
END FUNCTION
