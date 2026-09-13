' hello.bas - PowerBasilisk Enhanced v0.1.15 smoke demo
#COMPILE EXE
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    PRINT "Hello from PowerBasilisk Enhanced v0.1.15!"
    PRINT "CURDIR$ = "; CURDIR$
    PRINT "ISFILE(examples\hello.bas) = "; STR$(ISFILE("examples\hello.bas"))
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
