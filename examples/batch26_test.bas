FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL errcode AS LONG

    ' ===== 1. PREFIX: prepend "PRINT " to each following line =====
    PREFIX "PRINT "
        "Hello from PREFIX #1"
        "Hello from PREFIX #2"
    END PREFIX

    ' ===== 2. TRY/CATCH traps a run-time error (MKDIR existing dir -> ERR 75) =====
    TRY
        MKDIR "."
        PRINT "t2: NOT REACHED"
    CATCH
        errcode = ERR
        PRINT "t2 caught ERR="; errcode
    END TRY
    PRINT "t2 done"

    ' ===== 3. TRY without error: CATCH skipped =====
    TRY
        PRINT "t3 body ran"
    CATCH
        PRINT "t3: CATCH SHOULD NOT RUN"
    END TRY
    PRINT "t3 done"

    ' ===== 4. TRY + FINALLY: CATCH on error, FINALLY always runs =====
    TRY
        MKDIR "."
        PRINT "t4: NOT REACHED"
    CATCH
        errcode = ERR
        PRINT "t4 caught ERR="; errcode
    FINALLY
        PRINT "t4 finally ran"
    END TRY
    PRINT "t4 done"

    ' ===== 5. TRY + FINALLY without error: FINALLY still runs =====
    TRY
        PRINT "t5 body ran"
    CATCH
        PRINT "t5: CATCH SHOULD NOT RUN"
    FINALLY
        PRINT "t5 finally ran"
    END TRY
    PRINT "t5 done"

    ' ===== 6. EXIT TRY skips rest of body and CATCH =====
    TRY
        PRINT "t6 before EXIT TRY"
        EXIT TRY
        PRINT "t6: NOT REACHED"
    CATCH
        PRINT "t6: CATCH NOT REACHED"
    END TRY
    PRINT "t6 done"

    ' ===== 7. nested TRY: inner catches, outer CATCH must not run =====
    TRY
        TRY
            MKDIR "."
            PRINT "t7: inner NOT REACHED"
        CATCH
            errcode = ERR
            PRINT "t7 inner caught ERR="; errcode
        END TRY
        PRINT "t7 inner try completed"
    CATCH
        PRINT "t7: OUTER CATCH SHOULD NOT RUN"
    END TRY
    PRINT "t7 done"

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
