#CONSOLE OFF
#COMPILE EXE

SUB OnBtn1
    MSGBOX "Button 1 clicked!", 0, "Batch 139"
END SUB

SUB OnBtn2
    MSGBOX "Button 2 clicked!", 0, "Batch 139"
END SUB

SUB OnBtn3
    MSGBOX "Button 3 clicked!", 0, "Batch 139"
END SUB

FUNCTION PBMAIN() AS LONG
    LOCAL hWnd AS QUAD
    LOCAL hBtn1 AS QUAD
    LOCAL hBtn2 AS QUAD
    LOCAL hBtn3 AS QUAD

    WINDOW "Batch 139: CONTROL CMD", 100, 100, 350, 200 TO hWnd

    CONTROL ADD BUTTON, hWnd, 101, "Click Me 1",  30, 30, 120, 35 TO hBtn1
    CONTROL ADD BUTTON, hWnd, 102, "Click Me 2",  30, 80, 120, 35 TO hBtn2
    CONTROL ADD BUTTON, hWnd, 103, "Click Me 3",  30, 130, 120, 35 TO hBtn3

    CONTROL CMD hBtn1, OnBtn1
    CONTROL CMD hBtn2, OnBtn2
    CONTROL CMD hBtn3, OnBtn3

    MESSAGE LOOP
END FUNCTION
