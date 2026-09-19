' Tier-3 DDT: CONTROL ADD FRAME + OPTION
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hDlg AS QUAD
GLOBAL hFrame AS QUAD
GLOBAL hOptA AS QUAD
GLOBAL hOptB AS QUAD
GLOBAL hOptC AS QUAD
GLOBAL hBtn AS QUAD

FUNCTION PBMAIN() AS LONG
    DIALOG NEW 0, "Batch 146: FRAME + OPTION", 100, 100, 400, 300 TO g_hDlg
    
    CONTROL ADD GROUPBOX, g_hDlg, 101, "Options", 100, 20, 300, 200 TO hFrame
    
    CONTROL ADD RADIOBUTTON, g_hDlg, 102, "Choice A", 200, 40, 150, 20 TO hOptA
    CONTROL ADD RADIOBUTTON, g_hDlg, 103, "Choice B", 200, 70, 150, 20 TO hOptB
    CONTROL ADD RADIOBUTTON, g_hDlg, 104, "Choice C", 200, 100, 150, 20 TO hOptC
    
    CONTROL ADD BUTTON, g_hDlg, 105, "&OK", 150, 240, 80, 30 TO hBtn
    
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
