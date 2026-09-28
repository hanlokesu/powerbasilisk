#COMPILE EXE
CLASS C
    INSTANCE v AS LONG
    METHOD GetIt() AS LONG
        FUNCTION = v
    END METHOD
    METHOD SetIt(n AS LONG) AS LONG
        v = n
        FUNCTION = v
    END METHOD
END CLASS

FUNCTION PBMAIN() AS LONG
    LOCAL o AS C
    LOCAL got AS LONG
    o.v = 7
    got = o.GetIt()
    PRINT "get ="; got
    got = o.SetIt(44)
    PRINT "set ="; got; " v ="; o.v
    FUNCTION = 0
END FUNCTION
