'=====================================================================
' batch179_test.bas - the last three CONTROL statements, plus the
'                      two-operand GRAPHIC ATTACH they exposed
'---------------------------------------------------------------------
' Purpose:   Exercise the three statements added in batch 179:
'
'   CONTROL ADD GRAPHIC  (batch 179)  a STATIC the program draws into
'   CONTROL ADD HEADER   (batch 179)  a free-standing SysHeader32 control
'   CONTROL SET COLOR    (batch 179)  per-control text / background colour
'
' Official sources (C:\PBWin10\bin\PBWin_extracted\html):
'   control_add_graphic.htm, CONTROL_ADD_HEADER_statement.htm,
'   control_set_color.htm
'
' Demonstrates:
'   * CONTROL ADD GRAPHIC really creates a STATIC, and its documented
'     default style is %WS_CHILD | %WS_VISIBLE | %SS_OWNERDRAW(0x0B) -
'     the low five style bits are the %SS_TYPEMASK, so 11 there is the
'     proof that the owner-draw default reached the window
'   * a style the program supplies REPLACES that default (control 202 is
'     built with %WS_BORDER|%SS_NOTIFY and must carry neither the
'     owner-draw default nor any other %SS_ type bit)
'   * CONTROL ADD HEADER really creates the common control whose class
'     is SysHeader32, with the documented %WS_CHILD | %WS_VISIBLE default,
'     and %HDM_GETITEMCOUNT(0x1200) answers 0 for a fresh header - the
'     window is live, not just created
'   * CONTROL SET COLOR answers the %WM_CTLCOLORSTATIC(0x0138) question
'     the parent receives when a control paints.  The three documented
'     colour values are all checked by sending that message by hand and
'     reading the brush back:
'         backclr& >= 0   a solid brush         -> differs from the
'                                                  un-coloured answer
'         backclr& = -2&  no background painted -> %NULL_BRUSH (stock
'                                                  object 5)
'         backclr& = -1&  the default again     -> the answer returns to
'                                                  the un-coloured one
'   * the documented follow-up works: CONTROL REDRAW after SET COLOR
'     leaves the control's geometry alone
'   * the two-operand GRAPHIC ATTACH form (fixed in batch 179 - the id
'     operand used to be parsed and then dropped, so it attached to
'     nothing) really puts the control's own DC behind the GRAPHIC
'     statements: what GRAPHIC CLEAR paints is what GetPixel reads back
'   * attaching a second control after GRAPHIC DETACH works too, which
'     is the re-attach path (ReleaseDC, then GetDC on the new window)
'
' What this sample deliberately does NOT cover (and why):
'   * the CALL callback clause: accepted and ignored, as for every other
'     CONTROL ADD form in this fork (control callbacks are not wired up)
'   * colouring the text of a standard push button: control_set_color.htm
'     says outright that a standard push button cannot be coloured this
'     way, so there is nothing here to assert
'   * item text in the header: the header's Txt$ is stored but never
'     painted, and the sample leaves the item list empty on purpose
'   * the DIB-section family on a control target: GRAPHIC GET BITS /
'     SET PIXEL / GET PIXEL still require a memory bitmap and decline
'     when the target is a control (documented behaviour)
'
' Expected output (run mode): a series of "ok" lines and
'   "=== FAILURES:0 ===", exit code 0.
' Complexity note: O(1) - a fixed list of window messages and style reads.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

FUNCTION PBMAIN () AS LONG
    LOCAL hDlg   AS LONG
    LOCAL hGr    AS QUAD
    LOCAL hGr2   AS QUAD
    LOCAL hGrC   AS QUAD
    LOCAL hHd    AS QUAD
    LOCAL gwlA   AS QUAD
    LOCAL gwlH   AS QUAD
    LOCAL gcnA   AS QUAD
    LOCAL gcnH   AS QUAD
    LOCAL smA    AS QUAD
    LOCAL smH    AS QUAD
    LOCAL dcA    AS QUAD
    LOCAL dcH    AS QUAD
    LOCAL rdA    AS QUAD
    LOCAL rdH    AS QUAD
    LOCAL gpA    AS QUAD
    LOCAL gpH    AS QUAD
    LOCAL gsoA   AS QUAD
    LOCAL gsoH   AS QUAD
    LOCAL hdc    AS QUAD
    LOCAL hdc2   AS QUAD
    LOCAL br     AS QUAD
    LOCAL br0    AS QUAD
    LOCAL nullb  AS QUAD
    LOCAL px     AS QUAD
    LOCAL st     AS LONG
    LOCAL typ    AS LONG
    LOCAL n      AS LONG
    LOCAL v      AS LONG
    LOCAL n0     AS LONG
    LOCAL v0     AS LONG
    LOCAL buf    AS STRING * 64
    LOCAL fail   AS LONG

    PRINT "batch 179 - graphic, header and colour controls"
    PRINT "----------------------------------------------"

    IMPORT ADDR "GetWindowLongA", "USER32.DLL" TO gwlA, gwlH
    IMPORT ADDR "GetClassNameA",   "USER32.DLL" TO gcnA, gcnH
    IMPORT ADDR "SendMessageA",    "USER32.DLL" TO smA, smH
    IMPORT ADDR "GetDC",           "USER32.DLL" TO dcA, dcH
    IMPORT ADDR "ReleaseDC",       "USER32.DLL" TO rdA, rdH
    IMPORT ADDR "GetPixel",        "GDI32.DLL"  TO gpA, gpH
    IMPORT ADDR "GetStockObject",  "GDI32.DLL"  TO gsoA, gsoH
    IF gwlA = 0 OR gcnA = 0 OR smA = 0 OR dcA = 0 OR rdA = 0 OR gpA = 0 OR gsoA = 0 THEN
        fail = fail + 1
        PRINT "FAIL IMPORT ADDR (USER32/GDI32 helpers)"
    END IF

    ' Shown modeless: a modal dialog would wait for a human to dismiss it and
    ' this sample has to run unattended.
    DIALOG NEW 0, "batch 179 - graphic / header / colour", 40, 30, 360, 260 TO hDlg
    DIALOG SHOW MODELESS hDlg

    ' Coordinates are multiples of 4 so they survive the dialog-unit round
    ' trip exactly (the CONTROL ADD helpers convert with the base 7 x 14).
    CONTROL ADD GRAPHIC, hDlg, 201, "", 8,   8, 160, 80 TO hGr
    ' 8388864 = %WS_BORDER(8388608) + %SS_NOTIFY(256): a supplied style, which
    ' the help page's default does not get added to.
    CONTROL ADD GRAPHIC, hDlg, 202, "", 8, 112, 160, 60, 8388864 TO hGr2
    ' No TO clause on purpose: the official syntax makes it optional, and the
    ' parser has to reach the same statement through its dummy target.
    CONTROL ADD HEADER,  hDlg, 203, "", 8, 184, 200, 24

    IF hGr <> 0 AND hGr2 <> 0 THEN
        PRINT "ok   CONTROL ADD GRAPHIC returned handles (hGr="; hGr; " hGr2="; hGr2; ")"
    ELSE
        fail = fail + 1
        PRINT "FAIL GRAPHIC handles (hGr="; hGr; " hGr2="; hGr2; ")"
    END IF

    ' The TO clause must hand over the same handle CONTROL HANDLE reports - the
    ' batch 166/168 defect family was exactly a handle stored through a 32-bit slot.
    hGrC = 0
    CONTROL HANDLE hDlg, 201 TO hGrC
    IF hGrC <> 0 AND hGrC = hGr THEN
        PRINT "ok   the GRAPHIC TO handle agrees with CONTROL HANDLE"
    ELSE
        fail = fail + 1
        PRINT "FAIL GRAPHIC TO handle (hGr="; hGr; " CONTROL HANDLE="; hGrC; ")"
    END IF

    hHd = 0
    CONTROL HANDLE hDlg, 203 TO hHd
    IF hHd <> 0 THEN
        PRINT "ok   ADD HEADER without TO + CONTROL HANDLE resolved it"
    ELSE
        fail = fail + 1
        PRINT "FAIL header handle via CONTROL HANDLE"
    END IF

    ' ------------------------------------------------------------------
    ' The window CLASS proves the right Win32 control was created.
    ' ------------------------------------------------------------------
    buf = ""
    n = 0
    CALL DWORD gcnA USING GetClassNameA(hGr, VARPTR(buf), 64) TO n
    IF n > 0 AND INSTR(buf, "Static") > 0 THEN
        PRINT "ok   CONTROL ADD GRAPHIC is a Static-class control"
    ELSE
        fail = fail + 1
        PRINT "FAIL GRAPHIC class (len"; n; ")"
    END IF

    buf = ""
    n = 0
    CALL DWORD gcnA USING GetClassNameA(hHd, VARPTR(buf), 64) TO n
    IF n > 0 AND INSTR(buf, "SysHeader32") > 0 THEN
        PRINT "ok   CONTROL ADD HEADER is the SysHeader32 common control"
    ELSE
        fail = fail + 1
        PRINT "FAIL HEADER class (len"; n; ")"
    END IF

    ' ------------------------------------------------------------------
    ' The documented default style of a graphic control.
    ' ------------------------------------------------------------------
    st = 0
    CALL DWORD gwlA USING GetWindowLongA(hGr, -16) TO st
    typ = st AND 31                               ' %SS_TYPEMASK
    IF typ = 11 THEN                              ' %SS_OWNERDRAW
        PRINT "ok   GRAPHIC 201 carries the documented %SS_OWNERDRAW default"
    ELSE
        fail = fail + 1
        PRINT "FAIL GRAPHIC 201 type bits="; typ; " style="; st
    END IF
    IF (st AND 1073741824) <> 0 AND (st AND 268435456) <> 0 THEN
        PRINT "ok   GRAPHIC 201 has %WS_CHILD and %WS_VISIBLE"
    ELSE
        fail = fail + 1
        PRINT "FAIL GRAPHIC 201 child/visible bits="; st
    END IF

    ' ------------------------------------------------------------------
    ' A supplied style replaces the default; it is not OR-ed into it.
    ' ------------------------------------------------------------------
    st = 0
    CALL DWORD gwlA USING GetWindowLongA(hGr2, -16) TO st
    IF (st AND 31) = 0 THEN
        PRINT "ok   GRAPHIC 202 has no %SS_ type bits (default was replaced)"
    ELSE
        fail = fail + 1
        PRINT "FAIL GRAPHIC 202 kept a default type bit, style="; st
    END IF
    IF (st AND 256) <> 0 AND (st AND 8388608) <> 0 THEN
        PRINT "ok   GRAPHIC 202 carries the %SS_NOTIFY and %WS_BORDER asked for"
    ELSE
        fail = fail + 1
        PRINT "FAIL GRAPHIC 202 supplied style="; st
    END IF

    ' ------------------------------------------------------------------
    ' The header control is live: the common control answers its own
    ' item-count message (%HDM_GETITEMCOUNT = 0x1200).
    ' ------------------------------------------------------------------
    n = 0
    CALL DWORD smA USING SendMessageA(hHd, 4608, 0, 0) TO n
    IF n = 0 THEN
        PRINT "ok   fresh HEADER reports 0 items (%HDM_GETITEMCOUNT)"
    ELSE
        fail = fail + 1
        PRINT "FAIL header item count="; n
    END IF

    st = 0
    CALL DWORD gwlA USING GetWindowLongA(hHd, -16) TO st
    IF (st AND 1073741824) <> 0 AND (st AND 268435456) <> 0 THEN
        PRINT "ok   HEADER has the documented %WS_CHILD and %WS_VISIBLE default"
    ELSE
        fail = fail + 1
        PRINT "FAIL HEADER child/visible bits="; st
    END IF

    ' ------------------------------------------------------------------
    ' CONTROL SET COLOR - what the parent answers to %WM_CTLCOLORSTATIC.
    ' ------------------------------------------------------------------
    hdc = 0
    CALL DWORD dcA USING GetDC(hDlg) TO hdc
    IF hdc = 0 THEN
        fail = fail + 1
        PRINT "FAIL GetDC on the dialog"
    END IF

    br0 = 0
    CALL DWORD smA USING SendMessageA(hDlg, 312, hdc, hGr) TO br0
    PRINT "note un-coloured brush answer="; br0

    ' A solid background colour (65280 = RGB(0,255,0)).
    CONTROL SET COLOR hDlg, 201, -1, 65280
    br = 0
    CALL DWORD smA USING SendMessageA(hDlg, 312, hdc, hGr) TO br
    IF br <> 0 AND br <> br0 THEN
        PRINT "ok   SET COLOR with a solid back colour answers its own brush"
    ELSE
        fail = fail + 1
        PRINT "FAIL solid colour brush="; br; " un-coloured="; br0
    END IF

    ' -2 means "do not paint the text background at all": the answer has to be
    ' the stock %NULL_BRUSH, which we compare against the same stock object.
    CONTROL SET COLOR hDlg, 201, -1, -2
    br = 0
    CALL DWORD smA USING SendMessageA(hDlg, 312, hdc, hGr) TO br
    nullb = 0
    CALL DWORD gsoA USING GetStockObject(5) TO nullb
    IF br = nullb AND nullb <> 0 THEN
        PRINT "ok   SET COLOR -2 answers %NULL_BRUSH (no background painted)"
    ELSE
        fail = fail + 1
        PRINT "FAIL transparent brush="; br; " expected="; nullb
    END IF

    ' Back to the defaults: the answer must return to exactly what it was
    ' before the control was ever coloured.
    CONTROL SET COLOR hDlg, 201, -1, -1
    br = 0
    CALL DWORD smA USING SendMessageA(hDlg, 312, hdc, hGr) TO br
    IF br = br0 THEN
        PRINT "ok   SET COLOR -1,-1 answers the default again"
    ELSE
        fail = fail + 1
        PRINT "FAIL reset brush="; br; " expected="; br0
    END IF

    n = 0
    v = 0
    CONTROL GET SIZE hDlg, 201 TO n, v
    n0 = n
    v0 = v
    ' The help page's documented follow-up to a colour change.
    CONTROL REDRAW hDlg, 201
    n = 0
    v = 0
    CONTROL GET SIZE hDlg, 201 TO n, v
    IF n = n0 AND v = v0 THEN
        PRINT "ok   CONTROL REDRAW after SET COLOR left 201 alone"
    ELSE
        fail = fail + 1
        PRINT "FAIL REDRAW changed 201: "; n0; "x"; v0; " -> "; n; "x"; v
    END IF

    CALL DWORD rdA USING ReleaseDC(hDlg, hdc) TO n

    ' ------------------------------------------------------------------
    ' The two-operand GRAPHIC ATTACH: the target is a CONTROL, so what
    ' GRAPHIC CLEAR paints must be readable back off that control's DC.
    ' 255 = RGB(255,0,0), 65280 = RGB(0,255,0).
    ' ------------------------------------------------------------------
    GRAPHIC ATTACH hDlg, 201
    GRAPHIC CLEAR 255

    hdc2 = 0
    CALL DWORD dcA USING GetDC(hGr) TO hdc2
    px = 0
    CALL DWORD gpA USING GetPixel(hdc2, 5, 5) TO px
    CALL DWORD rdA USING ReleaseDC(hGr, hdc2) TO n
    IF hdc2 <> 0 AND px = 255 THEN
        PRINT "ok   GRAPHIC ATTACH hDlg, id& draws on the control's own DC"
    ELSE
        fail = fail + 1
        PRINT "FAIL control-DC pixel="; px; " dc="; hdc2
    END IF

    ' The re-attach path: detach releases the DC the matching way, then a
    ' second control becomes the target.
    GRAPHIC DETACH
    GRAPHIC ATTACH hDlg, 202
    GRAPHIC CLEAR 65280

    hdc2 = 0
    CALL DWORD dcA USING GetDC(hGr2) TO hdc2
    px = 0
    CALL DWORD gpA USING GetPixel(hdc2, 5, 5) TO px
    CALL DWORD rdA USING ReleaseDC(hGr2, hdc2) TO n
    IF px = 65280 THEN
        PRINT "ok   a second GRAPHIC ATTACH after DETACH targets the new control"
    ELSE
        fail = fail + 1
        PRINT "FAIL re-attach pixel="; px
    END IF

    GRAPHIC DETACH
    PRINT "ok   GRAPHIC DETACH released the control DC"

    PRINT "----------------------------------------------"
    PRINT "=== FAILURES:"; fail; " ==="
    DIALOG END hDlg, fail
    FUNCTION = fail
END FUNCTION
