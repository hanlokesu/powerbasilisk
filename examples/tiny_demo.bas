' tiny_demo.bas — 迷你验证程序：练习新语句
' 目标语句：BEEP, SWAP, SLEEP, MKDIR, RMDIR, RANDOMIZE
' 编译: pbcompiler build tiny_demo.bas --exe --target x86_64-pc-windows-msvc --runtime-lib pb_runtime_x64.obj

FUNCTION PBMAIN() AS LONG
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL p AS STRING

    ' 1. RANDOMIZE — 设随机种子
    RANDOMIZE 42

    ' 2. MKDIR — 建目录
    p = "tiny_demo_dir"
    MKDIR p

    ' 3. SWAP — 交换两个变量（重点：未实现）
    a = 111
    b = 222
    SWAP a, b
    IF a <> 222 OR b <> 111 THEN
        MSGBOX "SWAP FAILED: a=" + STR$(a) + " b=" + STR$(b)
    END IF

    ' 4. BEEP — 响一声（重点：未实现）
    BEEP

    ' 5. SLEEP — 停 300ms
    SLEEP 300

    ' 6. RMDIR — 删目录
    RMDIR p

    MSGBOX "tiny_demo OK: SWAP + BEEP + SLEEP + MKDIR/RMDIR + RANDOMIZE all ran."
    FUNCTION = 0
END FUNCTION
