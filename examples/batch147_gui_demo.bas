' Tier-3 DDT: GUI demo - full dialog with controls
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL g_hEdit AS QUAD
GLOBAL h1 AS QUAD
GLOBAL h2 AS QUAD
GLOBAL h3 AS QUAD
GLOBAL h4 AS QUAD
GLOBAL h5 AS QUAD
GLOBAL h6 AS QUAD

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 147: Full GUI Demo", 100, 100, 500, 400 TO g_hDlg
    
    CONTROL ADD FRAME, g_hDlg, 101, "Controls", 20, 20, 460, 300 TO h1
    
    CONTROL ADD OPTION, g_hDlg, 102, "Option A", 120, 40, 120, 20 TO h2
    CONTROL ADD OPTION, g_hDlg, 103, "Option B", 120, 70, 120, 20 TO h3
    
    CONTROL ADD CHECKBOX, g_hDlg, 104, "Check Me", 260, 40, 120, 20 TO h4
    
    CONTROL ADD EDITBOX, g_hDlg, 105, "Edit here", 120, 110, 200, 25 TO g_hEdit
    
    CONTROL ADD BUTTON, g_hDlg, 106, "&Show Text", 120, 160, 100, 30 TO h5
    CONTROL ADD BUTTON, g_hDlg, 107, "&Clear", 240, 160, 100, 30 TO h6
    CONTROL ADD BUTTON, g_hDlg, 108, "&Close", 360, 160, 100, 30 TO h1
    
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 106 THEN
                MSGBOX "Show Text clicked!"
            ELSEIF CB.CTL = 107 THEN
                MSGBOX "Clear clicked!"
            ELSEIF CB.CTL = 108 THEN
                DIALOG END g_hDlg, 1
            END IF
    END SELECT
END FUNCTION
