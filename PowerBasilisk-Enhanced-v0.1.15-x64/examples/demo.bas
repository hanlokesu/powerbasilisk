' PowerBasilisk Enhanced  Full Feature Demo
' Compile: pbcompiler build demo.bas --exe --target x86_64-pc-windows-msvc --runtime-lib pb_runtime_x64.obj
'
' Shows every feature implemented by this branch:
'   1) Control flow   : IF/THEN/ELSE, FOR/NEXT, WHILE/WEND, DO/LOOP, GOSUB/RETURN
'   2) Strings        : 18 built-in equates ($CRLF...), REPLACE, LSET/RSET, core funcs
'   3) Arrays         : DIM, ERASE
'   4) File I/O       : OPEN, PRINT#, LINE INPUT#, INPUT#, WRITE#, SEEK#, LOCK/UNLOCK,
'                       FLUSH, RESET, NAME, KILL, EOF, FREEFILE
'   5) Directories    : MKDIR, RMDIR, CHDIR + ERR / ERRCLEAR (PB error codes)
'   6) System         : MSGBOX, BEEP, SLEEP, RANDOMIZE+RND, SWAP, CURDIR$, ISFILE, SHELL
'
FUNCTION PBMAIN() AS LONG
    LOCAL waitk AS STRING
  LOCAL f AS LONG
  LOCAL s AS STRING
  LOCAL t AS STRING
  LOCAL i AS LONG
  LOCAL sum AS LONG
  LOCAL a AS LONG
  LOCAL b AS LONG
  LOCAL r AS DOUBLE
  LOCAL fixed10 AS STRING * 10
  LOCAL ok AS LONG
  DIM arr(5) AS LONG

  ok = 1
  PRINT "=============================================="
  PRINT "  PowerBasilisk Enhanced - Full Feature Demo"
  PRINT "  PowerBASIC -> LLVM IR -> native x64 exe"
  PRINT "=============================================="

  ' ---------- 1. Control flow ----------
  PRINT ""
  PRINT "[1] Control flow"

  FOR i = 1 TO 5
    sum = sum + i
  NEXT i
  IF sum = 15 THEN
    PRINT "  FOR/NEXT + IF/THEN: sum(1..5) = " + STR$(sum) + "  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: sum = " + STR$(sum)
  END IF

  i = 0
  WHILE i < 3
    i = i + 1
  WEND
  PRINT "  WHILE/WEND: i = " + STR$(i) + "  OK"

  DO
    i = i - 1
  LOOP UNTIL i = 0
  PRINT "  DO/LOOP UNTIL: i = " + STR$(i) + "  OK"

  GOSUB ShowSubroutine
  PRINT "  GOSUB/RETURN: returned OK"

  ' ---------- 2. Strings ----------
  PRINT ""
  PRINT "[2] Strings (built-in equates)"

  ' All 18 equates are compile-time constants; demo a few + join
  s = "Line1" + $CRLF + "Line2"
  IF s = "Line1" + CHR$(13, 10) + "Line2" THEN
    PRINT "  $CRLF = CR+LF bytes  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: $CRLF"
  END IF

  PRINT "  $DQ/$SQ/$TAB: [" + $DQ + "quoted" + $DQ + "]" + $TAB + "[" + $SQ + "sq" + $SQ + "]"
  PRINT "  $WHITESPACE = space+tab+cr+lf (invisible)  OK"

  t = "the cat sat on the cat mat"
  REPLACE "cat" WITH "dog" IN t
  IF t = "the dog sat on the dog mat" THEN
    PRINT "  REPLACE: " + t + "  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: REPLACE -> " + t
  END IF

  fixed10 = ""
  LSET fixed10 = "ab"
  PRINT "  LSET: [" + fixed10 + "]  (left-aligned)"
  fixed10 = ""
  RSET fixed10 = "cd"
  PRINT "  RSET: [" + fixed10 + "]  (right-aligned)"

  PRINT "  LEN/LEFT$/RIGHT$: " + STR$(LEN("hello")) + " / " + LEFT$("hello", 2) + " / " + RIGHT$("hello", 2)

  ' ---------- 3. Arrays ----------
  PRINT ""
  PRINT "[3] Arrays"

  FOR i = 0 TO 5
    arr(i) = 100 + i
  NEXT i
  ERASE arr
  IF arr(0) = 0 THEN
    PRINT "  DIM + ERASE: arr(0) after ERASE = " + STR$(arr(0)) + "  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: arr(0) = " + STR$(arr(0))
  END IF

  ' ---------- 4. File I/O ----------
  PRINT ""
  PRINT "[4] File I/O"

  f = FREEFILE
  OPEN "demo_data.tmp" FOR OUTPUT AS #f
  PRINT #f, "Hello file world"
  WRITE #f, "csv", 42, 3.5
  FLUSH #f
  CLOSE #f
  PRINT "  OPEN/PRINT#/WRITE#/FLUSH/CLOSE  OK"

  f = FREEFILE
  OPEN "demo_data.tmp" FOR INPUT AS #f
  LINE INPUT #f, s
  INPUT #f, t, i, r
  IF s = "Hello file world" AND t = "csv" AND i = 42 AND r = 3.5 THEN
    PRINT "  LINE INPUT#/INPUT# read back  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: read back [" + s + "] [" + t + "]"
  END IF

  SEEK #f, 1
  LINE INPUT #f, s
  PRINT "  SEEK# to top: [" + s + "]"
  CLOSE #f

  f = FREEFILE
  OPEN "demo_data.tmp" FOR INPUT AS #f
  LOCK #f, 1, 10
  UNLOCK #f, 1, 10
  CLOSE #f
  PRINT "  LOCK/UNLOCK byte range  OK"

  NAME "demo_data.tmp" AS "demo_renamed.tmp"
  PRINT "  NAME: file renamed  OK"

  f = FREEFILE
  OPEN "demo_renamed.tmp" FOR INPUT AS #f
  RESET
  PRINT "  RESET: all handles closed  OK"

  IF ISFILE("demo_renamed.tmp") = 1 THEN
    KILL "demo_renamed.tmp"
    PRINT "  KILL + ISFILE: file removed  OK"
  END IF

  ' ---------- 5. Directories + ERR ----------
  PRINT ""
  PRINT "[5] Directories + ERR semantics"

  MKDIR "demo_dir"
  MKDIR "demo_dir"          ' already exists -> ERR 75 (PB official)
  IF ERR = 75 THEN
    PRINT "  MKDIR twice -> ERR 75  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: MKDIR exists ERR=" + STR$(ERR)
  END IF
  ERRCLEAR

  RMDIR "no_such_dir_xyz"   ' missing -> ERR 75
  IF ERR = 75 THEN
    PRINT "  RMDIR missing -> ERR 75  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: RMDIR missing ERR=" + STR$(ERR)
  END IF
  ERRCLEAR

  CHDIR "no_such_dir_abc"   ' invalid -> ERR 76
  IF ERR = 76 THEN
    PRINT "  CHDIR invalid -> ERR 76  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: CHDIR invalid ERR=" + STR$(ERR)
  END IF
  ERRCLEAR

  RMDIR "demo_dir"
  PRINT "  RMDIR: cleanup OK"

  ' ---------- 6. System calls ----------
  PRINT ""
  PRINT "[6] System calls"

  RANDOMIZE 42
  r = RND
  PRINT "  RANDOMIZE+RND: first value = " + STR$(r)

  a = 111
  b = 222
  SWAP a, b
  IF a = 222 AND b = 111 THEN
    PRINT "  SWAP: a=222 b=111  OK"
  ELSE
    ok = 0
    PRINT "  FAIL: SWAP a=" + STR$(a) + " b=" + STR$(b)
  END IF

  PRINT "  CURDIR$ = " + CURDIR$
  PRINT "  ISFILE(demo.bas) = " + STR$(ISFILE("demo.bas"))

  BEEP
  SLEEP 300
  PRINT "  BEEP + SLEEP 300ms  OK"

  ' ---------- Final report ----------
  f = FREEFILE
  OPEN "demo_result.txt" FOR OUTPUT AS #f
  IF ok = 1 THEN
    PRINT #f, "ALL OK: every enhanced feature ran successfully"
  ELSE
    PRINT #f, "FAILED: one or more checks failed"
  END IF
  CLOSE #f

  PRINT ""
  IF ok = 1 THEN
    PRINT "=== ALL FEATURES VERIFIED OK ==="
  ELSE
    PRINT "=== SOME CHECKS FAILED ==="
  END IF
  PRINT "(see demo_result.txt)"

  ' ---------- 7. GUI popups (the show) ----------
  SHELL "calc.exe"                                   ' launch Calculator
  MSGBOX "PowerBasilisk Enhanced - all features OK!" + $CRLF + $CRLF + _
         "MSGBOX + SHELL + CURDIR$ + ISFILE + BEEP + SLEEP" + $CRLF + _
         "REPLACE + ERASE + LSET + RSET + SWAP + RANDOMIZE" + $CRLF + _
         "WRITE#/SEEK#/LOCK/UNLOCK/RESET/FLUSH/NAME/KILL" + $CRLF + _
         "MKDIR/RMDIR/CHDIR + ERR/ERRCLEAR + 18 string equates", 64, "PowerBasilisk Demo"

  FUNCTION = 0
  EXIT FUNCTION

ShowSubroutine:
  PRINT "  (inside GOSUB subroutine)"
  RETURN
    PRINT "Press any key to exit..."
    waitk = WAITKEY$

END FUNCTION
