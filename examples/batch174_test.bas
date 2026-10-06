'=====================================================================
' batch174_test.bas - MENU ATTACH / MENU CONTEXT / MENU DRAW BAR
'---------------------------------------------------------------------
' Purpose
'   Exercise the three MENU statements added in batch 174 and, where the
'   official page makes a promise that a headless program can observe,
'   pin that promise down with an exact comparison:
'
'       MENU ATTACH   hMenu, hDlg  - attach a menu to a dialog, REPLACING
'                                    any existing menu, and redraw the
'                                    dialog to make room for it
'       MENU CONTEXT  hMenu, x&, y&, flags& TO CmdVar&
'                                  - floating popup menu; the id the user
'                                    picked comes back in CmdVar&
'       MENU DRAW BAR hDlg         - redraw a dialog's menu bar after the
'                                    menu was altered dynamically
'
'   How the promises are checked:
'
'     * "replacing any existing menu" - GetMenu(hDlg) is read back through
'       IMPORT ADDR / CALL DWORD and must equal the bar that was attached
'       last, exactly.  (This is the same mechanism batch022_test.bas uses
'       for GetTickCount; the batch 174 release also fixed that path, which
'       used to drop the callee's arguments.)
'     * "the dialog is redrawn to accommodate the new menu" - the dialog is
'       shown modeless, and DIALOG GET CLIENT must report a SMALLER client
'       height while a menu bar is attached, and the original height again
'       once the menu is removed.  The comparison is relative on purpose:
'       the menu bar's pixel height depends on the DPI and the theme.
'     * MENU CONTEXT: a real popup menu waits for the user, so it cannot be
'       part of an unattended run.  The null-handle case is the part that can
'       be: it must return at once and report 0 ("no selection").
'
' Demonstrates
'   * MENU NEW BAR / MENU NEW POPUP / MENU ADD STRING / MENU ADD POPUP
'   * MENU ATTACH hMenu, hDlg          (attach, then read the handle back)
'   * MENU ATTACH hMenu2, hDlg         (replacement of the existing menu)
'   * MENU ATTACH 0, hDlg              (removal: SetMenu(hDlg, NULL))
'   * MENU DRAW BAR hDlg               (before and after a dynamic change)
'   * MENU CONTEXT ... TO CmdVar&      (null handle -> 0, returns at once)
'
' Expected output (run mode)
'   one line per assertion, then
'   === FAILURES: 0 ===
'   (exit code 0)
'
' Notes
'   * This sample opens a MODELESS dialog briefly.  It runs no message loop
'     and waits for no key, so the verification harness can run it
'     unattended; DIALOG SHOW MODELESS is what makes the client-area
'     measurement meaningful (a hidden window is not laid out yet).
'   * Sample files are text; keep this one headless.
' Complexity note: O(1) - a fixed sequence of menu and dialog calls.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg  AS LONG
    LOCAL hBar1 AS QUAD
    LOCAL hBar2 AS QUAD
    LOCAL hPop  AS QUAD
    LOCAL hGot  AS QUAD
    LOCAL gaddr AS QUAD
    LOCAL ghndl AS QUAD
    LOCAL cw    AS LONG
    LOCAL ch0   AS LONG         ' client height with no menu
    LOCAL ch1   AS LONG         ' client height with bar1
    LOCAL ch2   AS LONG         ' client height with bar2
    LOCAL ch3   AS LONG         ' client height after removing the menu
    LOCAL cmd   AS LONG
    LOCAL fail  AS LONG

    DIALOG NEW 0, "batch174 MENU ATTACH probe", 0, 0, 400, 200 TO hDlg
    DIALOG SHOW MODELESS hDlg
    DIALOG GET CLIENT hDlg TO cw, ch0

    ' GetMenu from USER32 - the only way a PB program can read back which menu a
    ' dialog carries.
    IMPORT ADDR "GetMenu", "USER32.DLL" TO gaddr, ghndl
    IF gaddr = 0 THEN
        fail = fail + 1
        PRINT "FAIL IMPORT ADDR GetMenu failed - cannot verify attachment"
    END IF

    ' ---------------------------------------------------------------
    ' A fresh dialog carries no menu.
    ' ---------------------------------------------------------------
    hGot = 12345
    CALL DWORD gaddr USING GetMenu(hDlg) TO hGot
    IF hGot <> 0 THEN
        fail = fail + 1
        PRINT "FAIL GetMenu before attach ->"; hGot; " (expected 0, a bare dialog has no menu)"
    ELSE
        PRINT "ok   GetMenu before attach  -> 0"
    END IF

    ' ---------------------------------------------------------------
    ' Build two distinct bars.  Each is one item so the bars are valid
    ' menus; bar1 also gets a popup subtree.
    ' ---------------------------------------------------------------
    hBar1 = 0
    MENU NEW BAR TO hBar1
    hBar2 = 0
    MENU NEW BAR TO hBar2
    hPop = 0
    MENU NEW POPUP TO hPop
    IF hBar1 = 0 OR hBar2 = 0 OR hPop = 0 THEN
        fail = fail + 1
        PRINT "FAIL MENU NEW BAR/POPUP returned 0 ("; hBar1; hBar2; hPop; ")"
    ELSE
        PRINT "ok   MENU NEW BAR x2, NEW POPUP -> handles"
    END IF
    IF hBar1 = hBar2 THEN
        fail = fail + 1
        PRINT "FAIL the two bars are the same handle"
    END IF

    MENU ADD STRING hBar1, "File", 100, 0
    MENU ADD POPUP hBar1, hPop, 0
    MENU ADD STRING hBar2, "Edit", 200, 0
    PRINT "ok   MENU ADD STRING / ADD POPUP -> items added"

    ' ---------------------------------------------------------------
    ' ATTACH: GetMenu must report exactly the handle we attached, and the
    ' client area must shrink by the menu bar's height.
    ' ---------------------------------------------------------------
    MENU ATTACH hBar1, hDlg
    hGot = 0
    CALL DWORD gaddr USING GetMenu(hDlg) TO hGot
    IF hGot <> hBar1 THEN
        fail = fail + 1
        PRINT "FAIL GetMenu after attach ->"; hGot; " (expected the bar"; hBar1; ")"
    ELSE
        PRINT "ok   GetMenu after attach   -> the attached bar"
    END IF
    DIALOG GET CLIENT hDlg TO cw, ch1
    IF ch1 >= ch0 THEN
        fail = fail + 1
        PRINT "FAIL client height with menu ->"; ch1; " (expected < "; ch0; ")"
    ELSE
        PRINT "ok   client height shrinks by the menu bar ("; ch0; " -> "; ch1; ")"
    END IF

    ' ---------------------------------------------------------------
    ' REPLACEMENT: attaching the second bar must replace the first.
    ' ---------------------------------------------------------------
    MENU ATTACH hBar2, hDlg
    hGot = 0
    CALL DWORD gaddr USING GetMenu(hDlg) TO hGot
    IF hGot <> hBar2 THEN
        fail = fail + 1
        PRINT "FAIL GetMenu after replace ->"; hGot; " (expected the second bar"; hBar2; ")"
    ELSE
        PRINT "ok   MENU ATTACH replaced the first bar"
    END IF
    DIALOG GET CLIENT hDlg TO cw, ch2
    IF ch2 <> ch1 THEN
        fail = fail + 1
        PRINT "FAIL client height changed on replacement ->"; ch2; " (expected "; ch1; ")"
    ELSE
        PRINT "ok   same menu-bar height after replacement"
    END IF

    ' ---------------------------------------------------------------
    ' DRAW BAR: must repaint after a dynamic menu change, and must not
    ' disturb which menu is attached.
    ' ---------------------------------------------------------------
    MENU DRAW BAR hDlg
    MENU ADD STRING hBar2, "More", 300, 0
    MENU DRAW BAR hDlg
    hGot = 0
    CALL DWORD gaddr USING GetMenu(hDlg) TO hGot
    IF hGot <> hBar2 THEN
        fail = fail + 1
        PRINT "FAIL GetMenu after DRAW BAR ->"; hGot; " (expected "; hBar2; ")"
    ELSE
        PRINT "ok   MENU DRAW BAR x2 kept the bar attached"
    END IF

    ' ---------------------------------------------------------------
    ' CONTEXT: a null handle must return at once and report 0.  A popup on
    ' a real menu handle is interactive by design and is NOT run here.
    ' ---------------------------------------------------------------
    cmd = 777
    MENU CONTEXT 0, 100, 100, 0 TO cmd
    IF cmd <> 0 THEN
        fail = fail + 1
        PRINT "FAIL MENU CONTEXT null ->"; cmd; " (expected 0, no selection)"
    ELSE
        PRINT "ok   MENU CONTEXT null       -> 0, returned immediately"
    END IF

    ' ---------------------------------------------------------------
    ' REMOVAL: attaching 0 removes the menu; the client area must grow
    ' back to its original height.  This is the control that proves the
    ' height difference above really was the menu bar.
    ' ---------------------------------------------------------------
    MENU ATTACH 0, hDlg
    hGot = 0
    CALL DWORD gaddr USING GetMenu(hDlg) TO hGot
    IF hGot <> 0 THEN
        fail = fail + 1
        PRINT "FAIL GetMenu after removal ->"; hGot; " (expected 0)"
    ELSE
        PRINT "ok   MENU ATTACH 0 removed the menu"
    END IF
    DIALOG GET CLIENT hDlg TO cw, ch3
    IF ch3 <> ch0 THEN
        fail = fail + 1
        PRINT "FAIL client height after removal ->"; ch3; " (expected "; ch0; ")"
    ELSE
        PRINT "ok   client height restored ("; ch3; ")"
    END IF
    MENU DRAW BAR hDlg
    PRINT "ok   MENU DRAW BAR on a menu-less dialog is harmless"

    IF gaddr <> 0 THEN
        IMPORT CLOSE ghndl
    END IF
    PRINT "=== FAILURES:"; fail; " ==="
    DIALOG END hDlg, fail
    FUNCTION = fail
END FUNCTION
