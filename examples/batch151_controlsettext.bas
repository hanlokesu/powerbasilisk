' Tier-3 DDT: CONTROL SET TEXT
' Click button to change its own caption

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL hBtn AS QUAD
GLOBAL g_clicks AS LONG

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 151: CONTROL SET TEXT", 100, 100, 300, 180 TO g_hDlg
    DIALOG CENTER g_hDlg
    CONTROL ADD BUTTON, g_hDlg, 101, "Click Me", 90, 60, 120, 30 TO hBtn
    DIALOG SHOW MODAL g_hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc()
    SELECT CASE CB.MSG
        CASE 2
            DIALOG END g_hDlg, 1
        CASE 273
            IF CB.CTL = 101 THEN
                g_clicks = g_clicks + 1
                CONTROL SET TEXT hBtn, "Clicked: " + STR$(g_clicks)
            END IF
    END SELECT
END FUNCTION
