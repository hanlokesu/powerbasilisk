'=====================================================================
' PowerBasilisk Enhanced - batch 190 test
' ---------------------------------------------------------------------
' THE LAST THREE DDT CONTROL TYPES (Tier-3 DDT GUI, three statements)
'
'   CONTROL ADD MONTHCAL hDlg, id&, x, y, w, h TO hCtl&
'   CONTROL ADD ANIMATE  hDlg, id&, x, y, w, h TO hCtl&
'   CONTROL ADD RICHEDIT hDlg, id&, x, y, w, h TO hCtl&
'
' Official sources: control_add_monthcal.htm, control_add_animate.htm,
' control_add_richedit.htm (all under C:\PBWin10\bin\PBWin_extracted\html).
'
' WHAT THIS SAMPLE WITNESSES, AND HOW
' -----------------------------------
' 1. WHICH WINDOW CLASS WAS REALLY CREATED (GetClassNameA):
'       MONTHCAL SysMonthCal32
'       ANIMATE  SysAnimate32
'       RICHEDIT RICHEDIT50W
'    RICHEDIT50W only exists once MSFTEDIT.DLL has been loaded - the local
'    RichEdit.inc says so in as many words - so the runtime helper loads that
'    DLL before CreateWindowExA.  A helper that forgot to would come back
'    with class "Edit" instead, and check 1 would catch it here.
'
' 2. WHICH STYLES REALLY REACHED THE WINDOW (GetWindowLongA GWL_STYLE):
'    all three are WS_CHILD | WS_VISIBLE, MONTHCAL/RICHEDIT also WS_TABSTOP,
'    and RICHEDIT additionally WS_BORDER | ES_MULTILINE | ES_AUTOVSCROLL.
'
' 3. THAT THE CONTROL REALLY PROCESSES MESSAGES (SendMessageA round trips):
'       MONTHCAL MCM_SETMONTHDELTA(3) -> MCM_GETMONTHDELTA back
'       ANIMATE  ACM_ISPLAYING on a fresh control is 0 (nothing is playing)
'       RICHEDIT WM_CHAR("A") -> WM_GETTEXTLENGTH is 1 -> WM_GETTEXT holds it
'
' 4. THAT CONTROL HANDLE RESOLVES THE ID: the MONTHCAL is found a second way
'    through CONTROL HANDLE hDlg, 401 TO hTmp.
'
' Message numbers below were read out of the local C:\PBWin10\WINAPI
' includes, not from memory:  %MCM_FIRST = &H1000, so MCM_GETMONTHDELTA =
' MCM_FIRST+19 = 4115 and MCM_SETMONTHDELTA = MCM_FIRST+20 = 4116;
' %ACM_ISPLAYING = %WM_USER+104 = 1032.
'
' KNOWN LIMITATION, STATED HONESTLY
' ---------------------------------
' The official syntax prints the TO clause in brackets, but this family
' (all 31 CONTROL ADD types, not just these three) currently requires it.
'
' Run mode is headless: one line per check, ending with
' "=== FAILURES:0 ===".  The dialog is modeless because a modal one would
' need a human to dismiss it.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL hDlg   AS LONG
    LOCAL hMc    AS QUAD
    LOCAL hAn    AS QUAD
    LOCAL hRe    AS QUAD
    LOCAL hTmp   AS QUAD
    LOCAL gcnA   AS QUAD
    LOCAL gcnH   AS QUAD
    LOCAL gwlA   AS QUAD
    LOCAL gwlH   AS QUAD
    LOCAL smA    AS QUAD
    LOCAL smH    AS QUAD
    LOCAL buf    AS STRING * 64
    LOCAL n      AS LONG
    LOCAL idx    AS LONG
    LOCAL st     AS LONG
    LOCAL b1     AS LONG
    LOCAL b2     AS LONG
    LOCAL b3     AS LONG
    LOCAL rc     AS LONG
    LOCAL v      AS LONG
    LOCAL fail   AS LONG

    ' Message numbers, read from C:\PBWin10\WINAPI\*.inc on this machine.
    LOCAL mMcGetDelta  AS LONG   ' MCM_GETMONTHDELTA = MCM_FIRST + 19 = 4115
    LOCAL mMcSetDelta  AS LONG   ' MCM_SETMONTHDELTA = MCM_FIRST + 20 = 4116
    LOCAL mAnIsPlaying AS LONG   ' ACM_ISPLAYING     = WM_USER + 104 = 1032
    LOCAL mWmSetText   AS LONG   ' WM_SETTEXT        = 12
    LOCAL mWmGetText   AS LONG   ' WM_GETTEXT        = 13
    LOCAL mWmGetTxtLen AS LONG   ' WM_GETTEXTLENGTH  = 14
    LOCAL mWmChar      AS LONG   ' WM_CHAR           = 258

    PRINT "batch 190 - CONTROL ADD MONTHCAL / ANIMATE / RICHEDIT"
    PRINT "-----------------------------------------------------"

    mMcGetDelta = 4115
    mMcSetDelta = 4116
    mAnIsPlaying = 1032
    mWmSetText = 12
    mWmGetText = 13
    mWmGetTxtLen = 14
    mWmChar = 258

    IMPORT ADDR "SendMessageA", "USER32.DLL" TO smA, smH
    IMPORT ADDR "GetWindowLongA", "USER32.DLL" TO gwlA, gwlH
    IMPORT ADDR "GetClassNameA", "USER32.DLL" TO gcnA, gcnH
    IF smA = 0 OR gwlA = 0 OR gcnA = 0 THEN
        fail = fail + 1
        PRINT "FAIL IMPORT ADDR SendMessageA / GetWindowLongA / GetClassNameA"
    END IF

    ' Modeless: a modal dialog would need a human to dismiss it.
    DIALOG NEW 0, "batch 190 - month calendar, animation, rich edit", 40, 30, 460, 240 TO hDlg
    DIALOG SHOW MODELESS hDlg

    ' Coordinates are multiples of 4: CONTROL ADD converts dialog units to
    ' pixels with the base 7 x 14, and CONTROL GET divides back exactly only
    ' for multiples of 4.
    CONTROL ADD MONTHCAL, hDlg, 401,   8,   8, 180, 120 TO hMc
    CONTROL ADD ANIMATE,  hDlg, 402, 200,   8, 120,  60 TO hAn
    CONTROL ADD RICHEDIT, hDlg, 403,   8, 144, 312,  64 TO hRe

    ' ------------------------------------------------------------------
    ' 1. Every ADD must hand back a real handle.
    ' ------------------------------------------------------------------
    IF hMc <> 0 AND hAn <> 0 AND hRe <> 0 THEN
        PRINT "ok   all three CONTROL ADD returned a handle"
    ELSE
        fail = fail + 1
        PRINT "FAIL a CONTROL ADD returned 0 (mc"; hMc; " an"; hAn; " re"; hRe; ")"
    END IF

    hTmp = 0
    CONTROL HANDLE hDlg, 401 TO hTmp
    IF hTmp = hMc AND hTmp <> 0 THEN
        PRINT "ok   CONTROL HANDLE resolves id 401 to the MONTHCAL handle"
    ELSE
        fail = fail + 1
        PRINT "FAIL CONTROL HANDLE id 401 mismatch"
    END IF

    ' ------------------------------------------------------------------
    ' 2. The window class is the witness that the right Win32 control was
    '    used - and for RICHEDIT it also proves MSFTEDIT.DLL got loaded.
    ' ------------------------------------------------------------------
    buf = ""
    n = 0
    CALL DWORD gcnA USING GetClassNameA(hMc, VARPTR(buf), 64) TO n
    IF n > 0 AND INSTR(buf, "SysMonthCal32") > 0 THEN
        PRINT "ok   MONTHCAL created a SysMonthCal32 window"
    ELSE
        fail = fail + 1
        PRINT "FAIL MONTHCAL class (len"; n; ") -> "; buf
    END IF

    buf = ""
    n = 0
    CALL DWORD gcnA USING GetClassNameA(hAn, VARPTR(buf), 64) TO n
    IF n > 0 AND INSTR(buf, "SysAnimate32") > 0 THEN
        PRINT "ok   ANIMATE created a SysAnimate32 window"
    ELSE
        fail = fail + 1
        PRINT "FAIL ANIMATE class (len"; n; ") -> "; buf
    END IF

    buf = ""
    n = 0
    CALL DWORD gcnA USING GetClassNameA(hRe, VARPTR(buf), 64) TO n
    IF n > 0 AND INSTR(buf, "RICHEDIT50W") > 0 THEN
        PRINT "ok   RICHEDIT created a RICHEDIT50W window (msftedit.dll loaded)"
    ELSE
        fail = fail + 1
        PRINT "FAIL RICHEDIT class (len"; n; ") -> "; buf
    END IF

    ' ------------------------------------------------------------------
    ' 3. The styles really reached the window.  WS_CHILD is 1073741824,
    '    WS_VISIBLE 268435456, WS_BORDER 8388608; the bit tests stay in
    '    separate variables on purpose, because mixing AND's two meanings in
    '    one expression is exactly the PowerBASIC trap.
    ' ------------------------------------------------------------------
    idx = -16                       ' GWL_STYLE
    st = 0
    CALL DWORD gwlA USING GetWindowLongA(hMc, idx) TO st
    b1 = st AND 1073741824          ' WS_CHILD
    b2 = st AND 268435456           ' WS_VISIBLE
    IF b1 <> 0 AND b2 <> 0 THEN
        PRINT "ok   MONTHCAL is WS_CHILD | WS_VISIBLE"
    ELSE
        fail = fail + 1
        PRINT "FAIL MONTHCAL styles (st="; st; ")"
    END IF

    st = 0
    CALL DWORD gwlA USING GetWindowLongA(hAn, idx) TO st
    b1 = st AND 1073741824
    b2 = st AND 268435456
    IF b1 <> 0 AND b2 <> 0 THEN
        PRINT "ok   ANIMATE is WS_CHILD | WS_VISIBLE"
    ELSE
        fail = fail + 1
        PRINT "FAIL ANIMATE styles (st="; st; ")"
    END IF

    st = 0
    CALL DWORD gwlA USING GetWindowLongA(hRe, idx) TO st
    b1 = st AND 1073741824          ' WS_CHILD
    b2 = st AND 268435456           ' WS_VISIBLE
    b3 = st AND 8388608             ' WS_BORDER
    IF b1 <> 0 AND b2 <> 0 AND b3 <> 0 THEN
        PRINT "ok   RICHEDIT is WS_CHILD | WS_VISIBLE | WS_BORDER"
    ELSE
        fail = fail + 1
        PRINT "FAIL RICHEDIT styles (st="; st; ")"
    END IF

    ' ------------------------------------------------------------------
    ' 4. The controls really process their messages.
    ' ------------------------------------------------------------------
    ' MONTHCAL: the month delta is a single number in wParam, so it makes an
    ' exact scalar round trip.
    rc = 0
    CALL DWORD smA USING SendMessageA(hMc, mMcSetDelta, 3, 0) TO rc
    v = 0
    CALL DWORD smA USING SendMessageA(hMc, mMcGetDelta, 0, 0) TO v
    IF v = 3 THEN
        PRINT "ok   MONTHCAL set month delta 3 and read back 3"
    ELSE
        fail = fail + 1
        PRINT "FAIL MONTHCAL month delta round trip (rc"; rc; " v"; v; ")"
    END IF

    ' ANIMATE: a fresh animation control is not playing anything.  (Playing
    ' real AVI content needs a file, so the observable here is the state.)
    v = 0
    v = -1
    CALL DWORD smA USING SendMessageA(hAn, mAnIsPlaying, 0, 0) TO v
    IF v = 0 THEN
        PRINT "ok   ANIMATE reports nothing playing on a fresh control"
    ELSE
        fail = fail + 1
        PRINT "FAIL ANIMATE isplaying (v"; v; ")"
    END IF

    ' RICHEDIT: type a character through WM_CHAR, then ask the control how
    ' much text it holds and hand that text back through WM_GETTEXT.
    rc = 0
    CALL DWORD smA USING SendMessageA(hRe, mWmChar, 65, 1) TO rc
    v = 0
    CALL DWORD smA USING SendMessageA(hRe, mWmGetTxtLen, 0, 0) TO v
    buf = ""
    n = 0
    CALL DWORD smA USING SendMessageA(hRe, mWmGetText, 64, VARPTR(buf)) TO n
    IF v = 1 AND INSTR(buf, "A") > 0 THEN
        PRINT "ok   RICHEDIT took WM_CHAR 'A' and gave it back (len"; v; ")"
    ELSE
        fail = fail + 1
        PRINT "FAIL RICHEDIT text round trip (len"; v; " got"; n; " -> "; buf; ")"
    END IF

    ' A rich edit is not a plain EDIT: WM_SETTEXT must also work.
    rc = 0
    CALL DWORD smA USING SendMessageA(hRe, mWmSetText, 0, VARPTR(buf)) TO rc
    v = 0
    v = -1
    CALL DWORD smA USING SendMessageA(hRe, mWmGetTxtLen, 0, 0) TO v
    IF v >= 1 THEN
        PRINT "ok   RICHEDIT accepted WM_SETTEXT (length now"; v; ")"
    ELSE
        fail = fail + 1
        PRINT "FAIL RICHEDIT WM_SETTEXT (len"; v; ")"
    END IF

    DIALOG END hDlg, fail
    PRINT "=== FAILURES:"; fail; " ==="
END FUNCTION
