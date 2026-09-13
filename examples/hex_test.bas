#COMPILE EXE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL l AS LONG
    LOCAL q AS QUAD
    l = -1
    q = -1
    PRINT "hex(-1)="; HEX$(-1)
    PRINT "hex(255)="; HEX$(255)
    PRINT "hex(255,4)="; HEX$(255, 4)
    PRINT "hex(l)="; HEX$(l)
    PRINT "hex(q)="; HEX$(q)
    PRINT "hex(16)="; HEX$(16)
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
