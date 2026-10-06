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
' === console emulation for dual-compiler compatibility ===
' (PBWin10 has no PRINT/#CONSOLE; this wrapper uses only official Win32 API)
DECLARE FUNCTION AllocConsole LIB "KERNEL32.DLL" ALIAS "AllocConsole" () AS LONG
DECLARE FUNCTION GetStdHandle LIB "KERNEL32.DLL" ALIAS "GetStdHandle" (BYVAL nStdHandle AS DWORD) AS LONG
DECLARE FUNCTION WriteFile LIB "KERNEL32.DLL" ALIAS "WriteFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToWrite AS DWORD, lpBytesWritten AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
DECLARE FUNCTION ReadFile LIB "KERNEL32.DLL" ALIAS "ReadFile" (BYVAL hFile AS LONG, lpBuffer AS ANY, BYVAL nBytesToRead AS DWORD, lpBytesRead AS DWORD, BYVAL lpOverlapped AS LONG) AS LONG
SUB ConPrint(BYVAL s AS STRING)
    LOCAL h AS LONG
    LOCAL n AS DWORD
    h = GetStdHandle(-11)
    IF h = 0 THEN
        AllocConsole
        h = GetStdHandle(-11)
    END IF
    IF h <> 0 THEN
        WriteFile h, BYVAL STRPTR(s), LEN(s), n, 0
    END IF
END SUB
SUB ConWaitKey()
    LOCAL h AS LONG
    LOCAL c AS STRING * 1
    LOCAL n AS DWORD
    h = GetStdHandle(-10)
    IF h <> 0 THEN
        ReadFile h, c, 1, n, 0
    END IF
END SUB

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
        ConPrint "t2: NOT REACHED"
    CATCH
        errcode = ERR
        ConPrint "t2 caught ERR=" & STR$(errcode)
    END TRY
    ConPrint "t2 done"

    ' ===== 3. TRY without error: CATCH skipped =====
    TRY
        ConPrint "t3 body ran"
    CATCH
        ConPrint "t3: CATCH SHOULD NOT RUN"
    END TRY
    ConPrint "t3 done"

    ' ===== 4. TRY + FINALLY: CATCH on error, FINALLY always runs =====
    TRY
        MKDIR "."
        ConPrint "t4: NOT REACHED"
    CATCH
        errcode = ERR
        ConPrint "t4 caught ERR=" & STR$(errcode)
    FINALLY
        ConPrint "t4 finally ran"
    END TRY
    ConPrint "t4 done"

    ' ===== 5. TRY + FINALLY without error: FINALLY still runs =====
    TRY
        ConPrint "t5 body ran"
    CATCH
        ConPrint "t5: CATCH SHOULD NOT RUN"
    FINALLY
        ConPrint "t5 finally ran"
    END TRY
    ConPrint "t5 done"

    ' ===== 6. EXIT TRY skips rest of body and CATCH =====
    TRY
        ConPrint "t6 before EXIT TRY"
        EXIT TRY
        ConPrint "t6: NOT REACHED"
    CATCH
        ConPrint "t6: CATCH NOT REACHED"
    END TRY
    ConPrint "t6 done"

    ' ===== 7. nested TRY: inner catches, outer CATCH must not run =====
    TRY
        TRY
            MKDIR "."
            ConPrint "t7: inner NOT REACHED"
        CATCH
            errcode = ERR
            ConPrint "t7 inner caught ERR=" & STR$(errcode)
        END TRY
        ConPrint "t7 inner try completed"
    CATCH
        ConPrint "t7: OUTER CATCH SHOULD NOT RUN"
    END TRY
    ConPrint "t7 done"

    ConPrint "Press any key to exit..."
    ConWaitKey
END FUNCTION

