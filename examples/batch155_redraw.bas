' Tier-3 DDT: CONTROL REDRAW + DIALOG UPDATE
' Click to redraw controls

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL hBtn AS QUAD

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 155: REDRAW", 100, 100, 300, 180 TO g_hDlg
    DIALOG CENTER g_hDlg
    CONTROL ADD LABEL, g_hDlg, 101, "Click the button below:", 80, 30, 150, 12 TO 0
    CONTROL ADD BUTTON, g_hDlg, 102, "Redraw", 100, 80, 100, 30 TO hBtn
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 102 THEN
                MSGBOX "Button works!"
            END IF
    END SELECT
END FUNCTION
