' err_demo.bas — D-轻量方案验证：失败时设 ERR 系统变量（官方 PB 默认行为）
' 验证：MKDIR 已存在→75 / RMDIR 不存在→75 / CHDIR 无效→76 / KILL 不存在→53
FUNCTION PBMAIN() AS LONG
    LOCAL f AS LONG
    LOCAL ok AS LONG
    LOCAL msg AS STRING

    ok = 1

    ' 1. MKDIR 已存在目录 → ERR 应为 75
    MKDIR "err_dir"
    MKDIR "err_dir"   ' 第二次：目录已存在
    IF ERR <> 75 THEN
        msg = msg + "FAIL1: MKDIR exists ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    ERRCLEAR

    ' 2. RMDIR 不存在的目录 → ERR 应为 75
    RMDIR "no_such_dir_abc"
    IF ERR <> 75 THEN
        msg = msg + "FAIL2: RMDIR missing ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    ERRCLEAR

    ' 3. CHDIR 无效路径 → ERR 应为 76
    CHDIR "no_such_dir_def"
    IF ERR <> 76 THEN
        msg = msg + "FAIL3: CHDIR invalid ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    ERRCLEAR

    ' 4. KILL 不存在的文件 → ERR 应为 53
    KILL "no_such_file.txt"
    IF ERR <> 53 THEN
        msg = msg + "FAIL4: KILL missing ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    ERRCLEAR

    ' 5. 成功操作后 ERR 应为 0
    MKDIR "err_dir_new"
    IF ERR <> 0 THEN
        msg = msg + "FAIL5: MKDIR success ERR=" + STR$(ERR) + CHR$(13) + CHR$(10)
        ok = 0
    END IF
    RMDIR "err_dir_new"   ' 清理新目录（此时 ERR 会被设 75，但已不再检查）

    ' 写结果
    f = FREEFILE
    OPEN "err_result.txt" FOR OUTPUT AS #f
    IF ok = 1 THEN
        PRINT #f, "ALL OK: ERR semantics match official PB (75/75/76/53/0)"
    ELSE
        PRINT #f, "FAILED:" + msg
    END IF
    CLOSE #f

    ' 清理
    RMDIR "err_dir"

    FUNCTION = 0
END FUNCTION
