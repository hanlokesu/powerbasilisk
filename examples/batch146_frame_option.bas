#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 146: FRAME + OPTION", 100, 100, 400, 300 TO g_hDlg
    
    CONTROL ADD FRAME g_hDlg, "Options", 100, 20, 300, 200, 101
    
    CONTROL ADD OPTION g_hDlg, "Choice A", 200, 40, 150, 20, 102
    CONTROL ADD OPTION g_hDlg, "Choice B", 200, 70, 150, 20, 103
    CONTROL ADD OPTION g_hDlg, "Choice C", 200, 100, 150, 20, 104
    
    CONTROL ADD BUTTON g_hDlg, "&OK", 150, 240, 80, 30, 105
    
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 105 THEN
                MSGBOX "OK clicked!"
            END IF
    END SELECT
END FUNCTION
