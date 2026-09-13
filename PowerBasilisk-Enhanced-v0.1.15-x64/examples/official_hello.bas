'-------------------------------------------------------------------------------
'
'  HELLO.BAS example for PowerBASIC for Windows
'  Copyright (c) 1997-2011 PowerBASIC, Inc.
'  All Rights Reserved.
'
'-------------------------------------------------------------------------------

#COMPILER PBWIN 10
#COMPILE EXE

' The resource gives the EXE program the "hello" icon in Explorer,
' and provides it with Windows version information.
#RESOURCE ICON, 100, "Hello.ico"
#RESOURCE VERSIONINFO
#RESOURCE FILEVERSION 10, 0, 0, 0
#RESOURCE PRODUCTVERSION 10, 0, 0, 0
#RESOURCE STRINGINFO "0409", "04B0"
#RESOURCE VERSION$ "Comments",         "Hello, World Example"
#RESOURCE VERSION$ "CompanyName",      "PowerBASIC, Inc."
#RESOURCE VERSION$ "FileDescription",  "Simple MSGBOX Application for Windows"
#RESOURCE VERSION$ "FileVersion",      "10.0"
#RESOURCE VERSION$ "InternalName",     "Hello"
#RESOURCE VERSION$ "LegalCopyright",   "Copyright © 1996-2011 PowerBASIC, Inc."
#RESOURCE VERSION$ "LegalTrademarks",  "PowerBASIC is a trademark of PowerBASIC, Inc."
#RESOURCE VERSION$ "OriginalFilename", "HELLO.EXE"
#RESOURCE VERSION$ "ProductName",      "PowerBASIC Compiler for Windows"
#RESOURCE VERSION$ "ProductVersion",   "10.0"
'
FUNCTION PBMAIN () AS LONG
    LOCAL waitk AS STRING

    MSGBOX "Hello, World!"
    PRINT "Press any key to exit..."
    waitk = WAITKEY$

END FUNCTION
