' equate_demo.bas — 验证 PB 内置 string equates（官方 18 个）
' 把每个 equate 的字节序列写入 equate_result.txt，逐一对照官方表
FUNCTION PBMAIN() AS LONG
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

    ' 拼接用例：$CRLF 是最常用的
    PRINT #f, "LINE1" + $CRLF + "LINE2"

    CLOSE #f

    FUNCTION = 0
END FUNCTION
