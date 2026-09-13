' equate_demo.bas   PB  string equates 18 
'  equate  equate_result.txt
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL f AS LONG

    f = FREEFILE
    OPEN "equate_result.txt" FOR OUTPUT AS #f

    PRINT #f, "NUL=" + $NUL
    PRINT #f, "BEL=" + $BEL
    PRINT #f, "BS=" + $BS
    PRINT #f, "TAB=" + $TAB
    PRINT #f, "LF=" + $LF
    PRINT #f, "VT=" + $VT
    PRINT #f, "FF=" + $FF
    PRINT #f, "CR=" + $CR
    PRINT #f, "CRLF=" + $CRLF
    PRINT #f, "EOF=" + $EOF
    PRINT #f, "ESC=" + $ESC
    PRINT #f, "SPC=" + $SPC
    PRINT #f, "DQ=" + $DQ
    PRINT #f, "DQ2=" + $DQ2
    PRINT #f, "SQ=" + $SQ
    PRINT #f, "SQ2=" + $SQ2
    PRINT #f, "QCQ=" + $QCQ
    PRINT #f, "WHITESPACE=" + $WHITESPACE

    ' $CRLF 
    PRINT #f, "LINE1" + $CRLF + "LINE2"

    CLOSE #f

    FUNCTION = 0
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
