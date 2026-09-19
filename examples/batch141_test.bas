' Tier-3 DDT: SCROLLBAR - vertical/horizontal scrollbar
' Auto-generated: PowerBasilisk fork batch test

#CONSOLE OFF
#COMPILE EXE

FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hScroll AS QUAD
    LOCAL pos AS LONG

    WINDOW "Batch 141: SCROLLBAR", 100, 100, 300, 300 TO hWnd

    CONTROL ADD SCROLLBAR, hWnd, 301, 250, 30, 25, 200 TO hScroll

    ' Set position to 50
    CONTROL SET POS hScroll, 50
    CONTROL GET POS hScroll TO pos
    MSGBOX "Scrollbar position set to 50, read back = " + STR$(pos), 0, "Batch 141"

    ' Set to 100
    CONTROL SET POS hScroll, 100
    CONTROL GET POS hScroll TO pos
    MSGBOX "Position now = " + STR$(pos), 0, "Batch 141"

    MSGBOX "Done!", 0, "Batch 141"
END FUNCTION
