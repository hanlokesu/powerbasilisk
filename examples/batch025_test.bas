FUNCTION PBMAIN() AS LONG
    LOCAL x AS LONG
    LOCAL errcode AS LONG
    LOCAL waitk AS STRING

    ' --- REGISTER is accepted as an optimization hint (LOCAL semantics) ---
    REGISTER counter AS LONG
    REGISTER regname AS STRING
    counter = 5
    regname = "reg"
    PRINT "REGISTER counter="; counter; " regname="; regname

    ' --- Test 1: ON ERROR GOTO traps a run-time error, RESUME NEXT skips it ---
    ON ERROR GOTO handler1
    MKDIR "Z:\no_such_dir_xyz\sub"
    PRINT "t1: resumed after MKDIR (OK)"
    GOTO after1
handler1:
    errcode = ERR
    PRINT "handler1 caught ERR="; errcode
    RESUME NEXT
after1:
    PRINT "t1 done, errcode="; errcode

    ' --- Test 2: RESUME re-executes the failing statement after fixing it ---
    MKDIR "batch25_dir"
    ERRCLEAR
    ON ERROR GOTO handler2
    MKDIR "batch25_dir"
    PRINT "t2: retried MKDIR succeeded"
    GOTO skip2
handler2:
    errcode = ERR
    PRINT "handler2 caught ERR="; errcode
    RMDIR "batch25_dir"
    RESUME
skip2:
    PRINT "t2 done (mkdir retried OK)"

    ' --- Test 3: RESUME label jumps to a specific label ---
    ON ERROR GOTO handler3
    MKDIR "Z:\no_such_dir_xyz\sub"
    PRINT "t3: should NOT print"
    GOTO after3
handler3:
    errcode = ERR
    PRINT "handler3 caught ERR="; errcode
    RESUME cont3
cont3:
    PRINT "t3 resumed at label"
after3:

    ' --- Test 4: ON ERROR GOTO 0 disables trapping ---
    ON ERROR GOTO 0
    MKDIR "Z:\no_such_dir_xyz\sub"
    PRINT "t4 not trapped (ERR="; ERR; ")"

    ' --- Test 5: RESUME FLUSH continues after the RESUME ---
    ON ERROR GOTO handler5
    MKDIR "Z:\no_such_dir_xyz\sub"
    PRINT "t5: should NOT print"
    GOTO after5
handler5:
    errcode = ERR
    PRINT "handler5 caught ERR="; errcode
    RESUME FLUSH
    PRINT "t5 after RESUME FLUSH (same line continues)"
after5:

    ' --- Test 6: no error -> handler never fires ---
    ON ERROR GOTO handler6
    MKDIR "batch25_dir2"
    PRINT "t6 no error trapped (OK)"
    GOTO after6
handler6:
    PRINT "t6: should NOT print"
    RESUME NEXT
after6:
    RMDIR "batch25_dir2"
    ERRCLEAR

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
