' Tier-3 DDT: MENU NEW BAR/POPUP/ADD STRING
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL g_hMenu AS QUAD

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 145: MENU + DIALOG", 100, 100, 400, 300 TO g_hDlg
    
    MENU NEW BAR TO g_hMenu
    MENU ADD STRING g_hMenu, "File", 100, 0
    MENU ADD STRING g_hMenu, "Edit", 101, 0
    MENU ADD STRING g_hMenu, "Help", 102, 0
    
    CONTROL ADD BUTTON g_hDlg, "&Click Me", 200, 50, 100, 30, 101
    
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 101 THEN
                MSGBOX "Button clicked!"
            END IF
    END SELECT
END FUNCTION
