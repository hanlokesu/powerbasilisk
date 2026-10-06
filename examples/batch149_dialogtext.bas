#IF (%PB_REVISION AND &H0FF00) = &H1000
    ' Compiling with PB/Win 10.x
    %MY_PBVER = 10
#ELSEIF (%PB_REVISION AND &H0FF00) = &H0900
    ' Compiling with PB/Win 9.x
    %MY_PBVER = 9
#ELSE
    ' Not PBWin (this fork, or other)
    %MY_PBVER = 0
#ENDIF
#COMPILE EXE
' Tier-3 DDT: DIALOG SET TEXT - change window title at runtime
' #CONSOLE OFF (commented: PBWin10 rejects #CONSOLE; fork ignores it)


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
