FUNCTION PBMAIN () AS LONG
    LOCAL hDlg AS QUAD
    LOCAL hCbo AS QUAD

    DIALOG NEW 0, "Test Combo+Center", 100, 100, 260, 200 TO hDlg
    DIALOG CENTER hDlg
    CONTROL ADD COMBOBOX, hDlg, 1001, 20, 20, 200, 120 TO hCbo
    CONTROL ADDSTRING hCbo, "Apple"
    CONTROL ADDSTRING hCbo, "Banana"
    CONTROL ADDSTRING hCbo, "Cherry"
    CONTROL ADD BUTTON, hDlg, 1002, "Show Selection", 20, 120, 100, 25
    DIALOG SHOW MODAL hDlg CALL DlgProc

    FUNCTION = 0
END FUNCTION

CALLBACK FUNCTION DlgProc
    SELECT CASE CB.MSG
        CASE 273
            IF CB.CTL = 1002 THEN
                LOCAL s AS STRING
                CONTROL GET TEXT CB.HNDL, 1001 TO s
                MSGBOX "You picked: " + s
            END IF
    END SELECT
END FUNCTION