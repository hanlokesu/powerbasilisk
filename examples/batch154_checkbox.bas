' Tier-3 DDT: CHECKBOX GET/SET CHECK
' Check a box, click button to show its state

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL hChk AS QUAD
GLOBAL hBtn AS QUAD

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 154: CHECKBOX STATE", 100, 100, 320, 180 TO g_hDlg
    DIALOG CENTER g_hDlg
    CONTROL ADD CHECKBOX, g_hDlg, 101, "I agree", 50, 40, 150, 20 TO hChk
    CONTROL ADD BUTTON, g_hDlg, 102, "Check State", 110, 90, 100, 30 TO hBtn
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 102 THEN
                LOCAL state AS LONG
                CONTROL GET CHECK hChk TO state
                IF state = 1 THEN
                    MSGBOX "Checked!"
                ELSE
                    MSGBOX "Not checked"
                END IF
            END IF
    END SELECT
END FUNCTION
