' PowerBasilisk Enhanced — 功能演示 Demo
' 编译: pbcompiler build demo.bas --exe --target x86_64-pc-windows-msvc --runtime-lib pb_runtime_x64.obj
'
' 展示增强版全部功能：
'   1) Win32 内建: MSGBOX / SHELL / CURDIR$ / ISFILE
'   2) 第二档语句: REPLACE / ERASE / LSET / RSET
'   3) 文件语句:   WRITE# / SEEK# / LOCK / UNLOCK / RESET / FLUSH / NAME
'
FUNCTION PBMAIN() AS LONG
  LOCAL f AS LONG
  LOCAL s AS STRING
  LOCAL t AS STRING
  LOCAL n AS LONG
  LOCAL fixed10 AS STRING * 10
  DIM arr(5) AS LONG

  PRINT "=== PowerBasilisk Enhanced Demo ==="
  PRINT "PowerBASIC -> LLVM IR -> native x64 exe"
  PRINT ""

  ' ---------- 1. Win32 built-ins ----------
  PRINT "[1] Win32 built-ins"

  ' CURDIR$ -> GetCurrentDirectoryA
  PRINT "CURDIR$  = "; CURDIR$

  ' ISFILE -> _access
  PRINT "ISFILE(pbcompiler.exe) = "; ISFILE("pbcompiler.exe")
  PRINT "ISFILE(not_exist.txt)  = "; ISFILE("not_exist.txt")

  ' SHELL -> ShellExecuteA (launches Calculator; SW_SHOWNORMAL)
  SHELL "calc.exe"
  PRINT "SHELL -> launched calc.exe via ShellExecuteA"

  ' ---------- 2. Tier-2 statements ----------
  PRINT ""
  PRINT "[2] Tier-2 statements"

  ' REPLACE
  t = "the cat sat on the cat mat"
  REPLACE "cat" WITH "dog" IN t
  PRINT "REPLACE: "; t

  ' ERASE
  FOR n = 0 TO 5
    arr(n) = 100 + n
  NEXT n
  ERASE arr
  PRINT "ERASE arr(5) -> arr(0) = "; arr(0)

  ' LSET / RSET on a fixed-length string
  fixed10 = ""
  LSET fixed10 = "ab"
  PRINT "LSET: ["; fixed10; "]"
  fixed10 = ""
  RSET fixed10 = "cd"
  PRINT "RSET: ["; fixed10; "]"

  ' ---------- 3. File statements ----------
  PRINT ""
  PRINT "[3] File statements"

  ' WRITE # (CSV-style) + FLUSH
  f = FREEFILE
  OPEN "demo_data.tmp" FOR OUTPUT AS #f
  WRITE #f, "hello", 42, 3.5
  WRITE #f, "world", 7
  FLUSH #f
  CLOSE #f

  ' Read back with LINE INPUT
  f = FREEFILE
  OPEN "demo_data.tmp" FOR INPUT AS #f
  LINE INPUT #f, s
  PRINT "WRITE# row1: ["; s; "]"
  LINE INPUT #f, s
  PRINT "WRITE# row2: ["; s; "]"
  CLOSE #f

  ' SEEK: reposition to byte 1, re-read first record
  f = FREEFILE
  OPEN "demo_data.tmp" FOR INPUT AS #f
  SEEK #f, 1
  LINE INPUT #f, s
  PRINT "SEEK  -> re-read: ["; s; "]"
  CLOSE #f

  ' LOCK / UNLOCK byte range
  f = FREEFILE
  OPEN "demo_data.tmp" FOR INPUT AS #f
  LOCK #f, 1, 10
  PRINT "LOCK #f,1,10 OK"
  UNLOCK #f, 1, 10
  PRINT "UNLOCK #f,1,10 OK"
  CLOSE #f

  ' NAME: rename file
  NAME "demo_data.tmp" AS "demo_renamed.tmp"
  PRINT "NAME -> demo_renamed.tmp"

  ' RESET: open a file, then close ALL handles
  f = FREEFILE
  OPEN "demo_renamed.tmp" FOR INPUT AS #f
  RESET
  PRINT "RESET: all files closed"

  ' Cleanup
  KILL "demo_renamed.tmp"

  PRINT ""
  PRINT "All enhanced features demonstrated OK."

  ' ---------- 4. MSGBOX last (modal, blocks) ----------
  MSGBOX "Hello from PowerBasilisk 64-bit!" + CHR$(13, 10) + "All Tier-2 statements + Win32 built-ins verified.", 0, "PowerBasilisk Demo"

  FUNCTION = 0
END FUNCTION
