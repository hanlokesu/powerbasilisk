TYPE Point
    x AS LONG
    y AS LONG
END TYPE
FUNCTION PBMAIN () AS LONG
    LOCAL p AS Point
    p.x = 3
    p.y = 4
    PRINT "point:"; p.x; ","; p.y
    FUNCTION = 0
END FUNCTION
