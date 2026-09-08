' tiny_check.bas — 无弹窗自动验证版：练习新语句
' 目标语句：BEEP, SWAP, SLEEP, MKDIR, RMDIR, RANDOMIZE
' 结果写入 tiny_result.txt，程序自动退出（无 MSGBOX）

FUNCTION PBMAIN() AS LONG
    LOCAL a AS LONG
    LOCAL b AS LONG
    LOCAL p AS STRING
    LOCAL f AS LONG
    LOCAL ok AS LONG

    ok = 1

    ' 1. RANDOMIZE — 设随机种子
    RANDOMIZE 42

    ' 2. MKDIR — 建目录
    p = "tiny_demo_dir"
    MKDIR p
    IF ISFILE(p) = 0 THEN ok = 0

    ' 3. SWAP — 交换两个变量
    a = 111
    b = 222
    SWAP a, b
    IF a <> 222 OR b <> 111 THEN ok = 0

    ' 4. BEEP — 响一声
    BEEP

    ' 5. SLEEP — 停 300ms
    SLEEP 300

    ' 6. RMDIR — 删目录
    RMDIR p
    IF ISFILE(p) <> 0 THEN ok = 0

    ' 写结果文件
    f = FREEFILE
    OPEN "tiny_result.txt" FOR OUTPUT AS #f
    IF ok = 1 THEN
        PRINT #f, "ALL OK: swap=" + STR$(a) + "," + STR$(b) + " rand+mkdir+beep+sleep+rmdir ran"
    ELSE
        PRINT #f, "FAILED: a=" + STR$(a) + " b=" + STR$(b)
    END IF
    CLOSE #f

    FUNCTION = 0
END FUNCTION
