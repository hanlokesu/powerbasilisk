'=====================================================================
' PBXB64 / PowerBasilisk Enhanced — batch 176 test
' ---------------------------------------------------------------------
' THE CONTROL MESSAGE AND STATE FAMILY (Tier-3 DDT GUI, ten statements)
'
'   CONTROL HANDLE      hDlg, id& TO hCtl&
'   CONTROL SEND        hDlg, id&, Msg&, wParam&, lParam& [TO lResult&]
'   CONTROL POST        hDlg, id&, Msg&, wParam&, lParam&
'   CONTROL REDRAW      hDlg, id&
'   CONTROL SET FOCUS   hDlg, id&
'   CONTROL SET FONT    hDlg, id&, FontHndl&
'   CONTROL SHOW STATE  hDlg, id&, showstate& [TO lResult&]
'   CONTROL NORMALIZE   hDlg, id&
'   CONTROL SET USER    hDlg, id&, index&, usrval&
'   CONTROL GET USER    hDlg, id&, index& TO retvar&
'
' Every one of them addresses the control by (hDlg, id) instead of by a
' handle, which is what makes DDT code readable - but it means the
' implementation has to resolve the handle for you (GetDlgItem), and the
' tests below check that resolution as carefully as they check the effect.
'
' WHAT THIS SAMPLE IS ALLOWED TO DO
' ---------------------------------
' It is written to be run with nobody watching: no MSGBOX, no WAITKEY$, no
' message loop.  The one statement whose whole point is asynchrony -
' CONTROL POST - is therefore proved with a NEGATIVE assertion: right after
' the POST the control must still be in its old state, because the queued
' message cannot have been delivered without a pump.  A positive assertion
' would need DIALOG DOEVENTS, which would make the sample interactive.
'
' WHAT IT NEEDS FROM USER32
' -------------------------
' Two raw API calls act as independent witnesses, because a statement
' reporting its own success is weak evidence:
'     SendMessageA(h, WM_GETFONT, 0, 0)  -> which font does the control really hold?
'     GetFocus()                         -> which window really owns the keyboard focus?
' Both are reached the PowerBASIC way: IMPORT ADDR ... TO addr, then
' CALL DWORD addr USING f(args) TO result.
'
' Raw numbers, because this dialect defines no %WM_* / %BM_* / %SW_* names:
'     WM_GETTEXT 13      WM_GETTEXTLENGTH 14    WM_SETFONT 48    WM_GETFONT 49
'     EM_GETSEL 176      EM_SETSEL 177          BM_GETCHECK 240  BM_SETCHECK 241
'     SW_HIDE 0          SW_SHOW 5
'
' Expected output (run mode): every line starts with "ok" and the last line
' is "=== FAILURES:0 ===".
' Exit code: the number of failed checks (0 on success), so a harness can
' read it straight from ERRORLEVEL.
' Complexity note: O(1) - a fixed list of probes against three controls;
' the interesting part is the address/identity plumbing, not any algorithm.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg   AS LONG
    LOCAL hBtn   AS QUAD
    LOCAL hEd    AS QUAD
    LOCAL hChk   AS QUAD
    LOCAL hTmp   AS QUAD
    LOCAL hFnt   AS QUAD
    LOCAL hGot   AS QUAD
    LOCAL hFoc   AS QUAD
    LOCAL hEd2   AS QUAD
    LOCAL smAddr AS QUAD
    LOCAL smHndl AS QUAD
    LOCAL gfAddr AS QUAD
    LOCAL gfHndl AS QUAD
    LOCAL buf    AS STRING * 32
    LOCAL s1     AS LONG
    LOCAL s2     AS LONG
    LOCAL n      AS LONG
    LOCAL st     AS LONG
    LOCAL prev   AS LONG
    LOCAL v      AS LONG
    LOCAL q      AS QUAD
    LOCAL fail   AS LONG

    PRINT "batch 176 - CONTROL message and state family"
    PRINT "-------------------------------------------"

    IMPORT ADDR "SendMessageA", "USER32.DLL" TO smAddr, smHndl
    IMPORT ADDR "GetFocus", "USER32.DLL" TO gfAddr, gfHndl
    IF smAddr = 0 OR gfAddr = 0 THEN
        fail = fail + 1
        PRINT "FAIL IMPORT ADDR SendMessageA / GetFocus"
    END IF

    ' The dialog is shown modeless: a modal dialog would need a human to
    ' dismiss it, and this sample has to run unattended.
    DIALOG NEW 0, "batch 176 - CONTROL messages and state", 40, 30, 460, 220 TO hDlg
    DIALOG SHOW MODELESS hDlg

    CONTROL ADD BUTTON,   hDlg, 101, "OK",    12, 12,  60, 24 TO hBtn
    CONTROL ADD EDITBOX,  hDlg, 102, "hello", 80, 12, 120, 24 TO hEd
    CONTROL ADD CHECKBOX, hDlg, 103, "check", 12, 48, 100, 20 TO hChk

    ' ------------------------------------------------------------------
    ' CONTROL HANDLE - the window handle behind an id.  The sample keeps
    ' the handle CONTROL ADD handed back, so the two have to agree: if they
    ' did not, the id-based statements and the raw handle would be
    ' addressing different windows.
    ' ------------------------------------------------------------------
    hTmp = 0
    CONTROL HANDLE hDlg, 101 TO hTmp
    IF hTmp = 0 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL HANDLE 101 returned 0"
    ELSE
        IF hTmp = hBtn THEN
            PRINT "ok   CONTROL HANDLE 101 equals the handle CONTROL ADD returned"
        ELSE
            fail = fail + 1
            PRINT "FAIL CONTROL HANDLE 101 ="; hTmp; " but CONTROL ADD returned"; hBtn
        END IF
    END IF

    hTmp = 12345
    CONTROL HANDLE hDlg, 999 TO hTmp
    IF hTmp <> 0 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL HANDLE 999 (never created) ->"; hTmp; " (want 0)"
    ELSE
        PRINT "ok   CONTROL HANDLE for a missing id -> 0"
    END IF

    ' ------------------------------------------------------------------
    ' CONTROL SEND - synchronous, with a return value.
    ' ------------------------------------------------------------------
    n = -1
    CONTROL SEND hDlg, 102, 14, 0, 0 TO n
    IF n <> 5 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL SEND WM_GETTEXTLENGTH ->"; n; " (the editbox holds 'hello')"
    ELSE
        PRINT "ok   CONTROL SEND WM_GETTEXTLENGTH -> 5"
    END IF

    ' A state change made by SEND is visible to the very next statement -
    ' that is what "synchronous" buys you.
    CONTROL SEND hDlg, 103, 241, 1, 0
    st = -1
    CONTROL SEND hDlg, 103, 240, 0, 0 TO st
    IF st <> 1 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL SEND BM_SETCHECK then BM_GETCHECK ->"; st; " (want 1)"
    ELSE
        PRINT "ok   CONTROL SEND is synchronous (BM_SETCHECK was in effect immediately)"
    END IF

    ' The optional TO clause has to work for a QUAD variable as well as for
    ' a LONG, because message results are pointer-width on x64.
    q = 0
    CONTROL SEND hDlg, 102, 14, 0, 0 TO q
    IF q <> 5 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL SEND TO a QUAD ->"; q; " (want 5)"
    ELSE
        PRINT "ok   CONTROL SEND TO a QUAD variable -> 5"
    END IF

    ' ------------------------------------------------------------------
    ' Pointer arguments.  The official help is explicit: SEND passes its
    ' arguments BYVAL, and a message that writes back has to be given
    ' VARPTR addresses:
    '     CONTROL SEND CB.HNDL, %ID_EDIT1, %EM_GETSEL, VARPTR(Sel1&), VARPTR(Sel2&)
    ' EM_GETSEL puts the first address in wParam and the second in lParam,
    ' so a matching pair proves BOTH halves survived as 64-bit values.
    ' (batch 176 fixed exactly this: wParam used to be truncated to 32 bits.)
    ' ------------------------------------------------------------------
    CONTROL SEND hDlg, 102, 177, 1, 4
    s1 = -1 : s2 = -1
    CONTROL SEND hDlg, 102, 176, VARPTR(s1), VARPTR(s2)
    IF s1 <> 1 OR s2 <> 4 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL SEND VARPTR write-back ->"; s1; s2; " (want 1 and 4)"
    ELSE
        PRINT "ok   CONTROL SEND VARPTR write-back through wParam and lParam (1,4)"
    END IF

    ' WM_GETTEXT fills a fixed string buffer.  A non-zero return value
    ' alone would not prove the bytes arrived, so the content is searched.
    n = -1
    CONTROL SEND hDlg, 102, 13, 32, VARPTR(buf) TO n
    IF n <> 5 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL SEND WM_GETTEXT ->"; n; " (want 5)"
    ELSE
        IF INSTR(buf, "hello") > 0 THEN
            PRINT "ok   CONTROL SEND filled a STRING * 32 buffer through VARPTR"
        ELSE
            fail = fail + 1
            PRINT "FAIL CONTROL SEND returned"; n; " but the buffer stayed empty"
        END IF
    END IF

    n = -1
    CONTROL SEND hDlg, 999, 14, 0, 0 TO n
    IF n <> 0 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL SEND to a missing id ->"; n; " (want 0, and no crash)"
    ELSE
        PRINT "ok   CONTROL SEND to a missing id -> 0"
    END IF

    ' ------------------------------------------------------------------
    ' CONTROL POST - asynchronous.  The uncheck is queued, so immediately
    ' afterwards the box is still checked.  Asserting the OLD state is the
    ' whole test: if POST were implemented as SEND, this check would fail.
    ' The queued message stays in this window's queue - harmless, because
    ' the program exits right after the last check.
    ' ------------------------------------------------------------------
    CONTROL POST hDlg, 103, 241, 0, 0
    st = -1
    CONTROL SEND hDlg, 103, 240, 0, 0 TO st
    IF st <> 1 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL POST was already delivered (BM_GETCHECK ->"; st; ")"
    ELSE
        PRINT "ok   CONTROL POST is asynchronous (the uncheck is still queued)"
    END IF

    ' ------------------------------------------------------------------
    ' CONTROL SET USER / GET USER - eight Long slots per control, index 1..8.
    ' ------------------------------------------------------------------
    CONTROL SET USER hDlg, 101, 3, 4242
    v = -1
    CONTROL GET USER hDlg, 101, 3 TO v
    IF v <> 4242 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL GET USER 101,3 ->"; v; " (want 4242)"
    ELSE
        PRINT "ok   CONTROL SET/GET USER 101,3 -> 4242"
    END IF

    CONTROL SET USER hDlg, 102, 3, 99
    v = -1
    CONTROL GET USER hDlg, 101, 3 TO v
    IF v <> 4242 THEN
        fail = fail + 1
        PRINT "FAIL the user slots leak between controls: 101,3 ->"; v
    ELSE
        PRINT "ok   each control owns its own slots (102,3 did not touch 101,3)"
    END IF

    CONTROL SET USER hDlg, 101, 9, 7
    v = -1
    CONTROL GET USER hDlg, 101, 9 TO v
    IF v <> 0 THEN
        fail = fail + 1
        PRINT "FAIL index 9 (outside 1..8) ->"; v; " (want 0, the write is ignored)"
    ELSE
        PRINT "ok   an index outside 1..8 is ignored"
    END IF

    CONTROL SET USER hDlg, 999, 1, 77
    v = -1
    CONTROL GET USER hDlg, 999, 1 TO v
    IF v <> 0 THEN
        fail = fail + 1
        PRINT "FAIL SET USER on a missing id stored"; v
    ELSE
        PRINT "ok   CONTROL SET USER on a missing id stored nothing"
    END IF

    ' ------------------------------------------------------------------
    ' CONTROL SHOW STATE - the optional TO reports the PREVIOUS state:
    ' 0 when the control was hidden, non-zero when it was visible.
    ' ------------------------------------------------------------------
    prev = -1
    CONTROL SHOW STATE hDlg, 101, 0 TO prev
    IF prev = 0 THEN
        fail = fail + 1
        PRINT "FAIL SHOW STATE SW_HIDE reported previous = 0 (the button was visible)"
    ELSE
        PRINT "ok   SHOW STATE SW_HIDE -> previous state was visible"
    END IF

    prev = -1
    CONTROL SHOW STATE hDlg, 101, 5 TO prev
    IF prev <> 0 THEN
        fail = fail + 1
        PRINT "FAIL SHOW STATE SW_SHOW reported previous ="; prev; " (it was hidden)"
    ELSE
        PRINT "ok   SHOW STATE SW_SHOW -> previous state was hidden"
    END IF

    ' ------------------------------------------------------------------
    ' CONTROL NORMALIZE - makes the control visible, whatever it was.
    ' ------------------------------------------------------------------
    CONTROL SHOW STATE hDlg, 101, 0
    CONTROL NORMALIZE hDlg, 101
    prev = -1
    CONTROL SHOW STATE hDlg, 101, 5 TO prev
    IF prev = 0 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL NORMALIZE left the button hidden"
    ELSE
        PRINT "ok   CONTROL NORMALIZE made a hidden control visible"
    END IF

    ' ------------------------------------------------------------------
    ' CONTROL REDRAW - no result to check; it must simply not disturb the
    ' rest of the run.
    ' ------------------------------------------------------------------
    CONTROL REDRAW hDlg, 101
    PRINT "ok   CONTROL REDRAW returned"

    ' ------------------------------------------------------------------
    ' CONTROL SET FOCUS - checked with GetFocus, not with the statement's
    ' own return value (it has none).
    ' ------------------------------------------------------------------
    hEd2 = 0
    CONTROL HANDLE hDlg, 102 TO hEd2
    CONTROL SET FOCUS hDlg, 102
    hFoc = 0
    CALL DWORD gfAddr USING GetFocus() TO hFoc
    IF hFoc <> hEd2 THEN
        fail = fail + 1
        PRINT "FAIL CONTROL SET FOCUS: GetFocus ="; hFoc; " editbox ="; hEd2
    ELSE
        PRINT "ok   CONTROL SET FOCUS -> GetFocus reports the editbox"
    END IF

    ' ------------------------------------------------------------------
    ' CONTROL SET FONT - WM_GETFONT is the witness.  Passing 0 is
    ' documented to restore the font the control was created with, so the
    ' handle read back afterwards must differ from the one just set.
    ' ------------------------------------------------------------------
    hFnt = 0
    FONT NEW "Arial", 14, 0, 0, 0, 0 TO hFnt
    IF hFnt = 0 THEN
        fail = fail + 1
        PRINT "FAIL FONT NEW returned 0 - CONTROL SET FONT cannot be tested"
    ELSE
        CONTROL SET FONT hDlg, 102, hFnt
        hGot = 0
        CALL DWORD smAddr USING SendMessageA(hEd2, 49, 0, 0) TO hGot
        IF hGot <> hFnt THEN
            fail = fail + 1
            PRINT "FAIL after CONTROL SET FONT, WM_GETFONT ->"; hGot; " (want"; hFnt; ")"
        ELSE
            PRINT "ok   CONTROL SET FONT -> WM_GETFONT reports the new font"
        END IF

        CONTROL SET FONT hDlg, 102, 0
        hGot = 0
        CALL DWORD smAddr USING SendMessageA(hEd2, 49, 0, 0) TO hGot
        IF hGot = hFnt THEN
            fail = fail + 1
            PRINT "FAIL CONTROL SET FONT 0 left the new font in place"
        ELSE
            PRINT "ok   CONTROL SET FONT 0 restored the original font"
        END IF
        FONT END hFnt
    END IF

    ' ------------------------------------------------------------------
    ' The negative sweep: every statement in the family against an id that
    ' was never created.  Reaching the final PRINT is the assertion - a
    ' missing control must be ignored, never dereferenced.
    ' ------------------------------------------------------------------
    CONTROL HANDLE     hDlg, 999 TO hTmp
    CONTROL SEND       hDlg, 999, 14, 0, 0 TO n
    CONTROL POST       hDlg, 999, 241, 1, 0
    CONTROL REDRAW     hDlg, 999
    CONTROL SET FOCUS  hDlg, 999
    CONTROL SET FONT   hDlg, 999, 0
    CONTROL SHOW STATE hDlg, 999, 0 TO n
    CONTROL NORMALIZE  hDlg, 999
    CONTROL SET USER   hDlg, 999, 1, 5
    CONTROL GET USER   hDlg, 999, 1 TO v
    PRINT "ok   all ten statements survived an id that does not exist"

    PRINT "=== FAILURES:"; fail; " ==="
    DIALOG END hDlg, fail
    FUNCTION = fail
END FUNCTION
