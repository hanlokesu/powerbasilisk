#CONSOLE OFF
#COMPILE EXE

GLOBAL g_hEdit AS QUAD
GLOBAL g_hChk AS QUAD
GLOBAL g_hRadio AS QUAD
GLOBAL g_hVSB AS QUAD
GLOBAL g_hHSB AS QUAD

FUNCTION OnShowState
    LOCAL s AS STRING
    LOCAL chk AS LONG
    LOCAL vpos AS LONG
    LOCAL hpos AS LONG

    CONTROL GET TEXT g_hEdit TO s$
    CONTROL GET CHECK g_hChk TO chk

    CONTROL GET POS g_hVSB TO vpos
    CONTROL GET POS g_hHSB TO hpos

    MSGBOX "Edit box text: [" + s$ + "]" + $CRLF + _
           "Checkbox checked: " + STR$(chk) + $CRLF + _
           "Vert scroll pos: " + STR$(vpos) + $CRLF + _
           "Horz scroll pos: " + STR$(hpos), 0, "Control State"
END FUNCTION

FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hBtn AS QUAD

    WINDOW "PowerBasilisk GUI Demo", 100, 100, 600, 500 TO hWnd

    CONTROL ADD BUTTON, hWnd, 101, "Show State", 30, 20, 150, 35 TO hBtn
    CONTROL CMD hBtn, OnShowState

    CONTROL ADD EDITBOX, hWnd, 102, "Type text here...", 30, 70, 250, 28 TO g_hEdit
    CONTROL ADD CHECKBOX, hWnd, 103, "Option A (click to toggle)", 30, 115, 250, 28 TO g_hChk
    CONTROL ADD RADIOBUTTON, hWnd, 104, "Choice B (click to select)", 30, 155, 250, 28 TO g_hRadio
    CONTROL ADD GROUPBOX, hWnd, 105, "GroupBox frame", 30, 195, 250, 100 TO 0
    CONTROL ADD SCROLLBAR, hWnd, 106, "", 500, 20, 30, 400 TO g_hVSB
    CONTROL ADD HSCROLLBAR, hWnd, 107, "", 30, 420, 400, 30 TO g_hHSB

    CONTROL CHECK g_hChk

    MSGBOX "GUI Demo ready!" + $CRLF + _
           "1. Type in edit box" + $CRLF + _
           "2. Check/uncheck the checkbox" + $CRLF + _
           "3. Click scrollbar arrows" + $CRLF + _
           "4. Click 'Show State' button", 0, "GUI Demo"

    MESSAGE LOOP
END FUNCTION
