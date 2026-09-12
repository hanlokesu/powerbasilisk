' tiny_demo.bas  
' BEEP, SWAP, SLEEP, MKDIR, RMDIR, RANDOMIZE
' : pbcompiler build tiny_demo.bas --exe --target x86_64-pc-windows-msvc --runtime-lib pb_runtime_x64.obj

FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL p AS STRING

    ' 1. RANDOMIZE  
    RANDOMIZE 42

    ' 2. MKDIR  
    p = "tiny_demo_dir"
    MKDIR p

    ' 3. SWAP  
    a = 111
    b = 222
    SWAP a, b
    IF a <> 222 OR b <> 111 THEN
        MSGBOX "SWAP FAILED: a=" + STR$(a) + " b=" + STR$(b)
    END IF

    ' 4. BEEP  
    BEEP

    ' 5. SLEEP   300ms
    SLEEP 300

    ' 6. RMDIR  
    RMDIR p

    MSGBOX "tiny_demo OK: SWAP + BEEP + SLEEP + MKDIR/RMDIR + RANDOMIZE all ran."
    FUNCTION = 0
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
