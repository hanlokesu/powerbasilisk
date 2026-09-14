' PowerBasilisk Enhanced - batch62_test.bas
' MENU GET STATE / SET STATE / GET TEXT / SET TEXT (batch 62)
FUNCTION PBMAIN() AS LONG
    LOCAL hbar AS QUAD
    LOCAL hpop AS QUAD
    LOCAL st AS LONG
    LOCAL txt AS STRING
    LOCAL ok AS LONG
    LOCAL waitk AS STRING

    MENU NEW BAR TO hbar
    MENU NEW POPUP TO hpop
    MENU ADD STRING, hbar, "File", 100, 0
    MENU ADD STRING, hbar, "Edit", 101, 0
    MENU ADD STRING, hpop, "Open", 110, 0
    MENU ADD STRING, hpop, "Save", 111, 0

    ' 1. GET STATE by position (enabled = 0)
    MENU GET STATE hbar, 1 TO st
    IF st = 0 THEN ok = ok + 1 ELSE PRINT "GET STATE POS FAIL"; st

    ' 2. GET STATE by command id
    MENU GET STATE hbar, BYCMD, 100 TO st
    IF st = 0 THEN ok = ok + 1 ELSE PRINT "GET STATE BYCMD FAIL"; st

    ' 3. SET STATE grayed (1) by command id, then read back
    MENU SET STATE hbar, BYCMD, 100, 1
    MENU GET STATE hbar, BYCMD, 100 TO st
    IF st AND 1 THEN ok = ok + 1 ELSE PRINT "SET GRAYED FAIL"; st

    ' 4. SET STATE enabled (0)
    MENU SET STATE hbar, BYCMD, 100, 0
    MENU GET STATE hbar, BYCMD, 100 TO st
    IF (st AND 1) = 0 THEN ok = ok + 1 ELSE PRINT "SET ENABLED FAIL"; st

    ' 5. SET STATE checked (8) on popup item, read back
    MENU SET STATE hpop, BYCMD, 110, 8
    MENU GET STATE hpop, BYCMD, 110 TO st
    IF st AND 8 THEN ok = ok + 1 ELSE PRINT "SET CHECKED FAIL"; st

    ' 6. GET TEXT by command id
    MENU GET TEXT hbar, BYCMD, 100 TO txt
    IF txt = "File" THEN ok = ok + 1 ELSE PRINT "GET TEXT FAIL ["; txt; "]"

    ' 7. SET TEXT by command id, then read back
    MENU SET TEXT hbar, BYCMD, 100, "Filer"
    MENU GET TEXT hbar, BYCMD, 100 TO txt
    IF txt = "Filer" THEN ok = ok + 1 ELSE PRINT "SET TEXT FAIL ["; txt; "]"

    ' 8. GET TEXT by position on popup
    MENU GET TEXT hpop, 2 TO txt
    IF txt = "Save" THEN ok = ok + 1 ELSE PRINT "GET TEXT POS FAIL ["; txt; "]"

    IF ok = 8 THEN
        PRINT "batch62: ALL PASS"
    ELSE
        PRINT "batch62: FAILURES="; 8 - ok
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
