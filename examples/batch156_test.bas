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
'=====================================================================
' Batch 156 test — #RESOURCE VERSIONINFO + hard-fail diagnostics
'=====================================================================
#COMPILER PBWIN 10


' Version info embedded into the EXE
#RESOURCE VERSIONINFO
#RESOURCE FILEVERSION 10, 0, 0, 0
#RESOURCE PRODUCTVERSION 10, 0, 0, 0
#RESOURCE STRINGINFO "0409", "04B0"
#RESOURCE VERSION$ "FileDescription", "Batch 156 Test"
#RESOURCE VERSION$ "ProductName", "PowerBasilisk Enhanced"

FUNCTION PBMAIN () AS LONG
    MSGBOX "Batch 156: VERSIONINFO + hard-fail diagnostics test", 0, "Batch 156"
    FUNCTION = 0
END FUNCTION
