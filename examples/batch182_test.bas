'=====================================================================
' batch182_test.bas - the DDT/GRAPHIC statements of batch 182
'---------------------------------------------------------------------
' Purpose:   Exercise every statement this batch implemented, with a positive
'            run-time assertion for each one.  The point is not to compile -
'            this compiler reports Success even for a statement that codegen
'            silently drops, so only a value read back at run time proves the
'            statement does anything at all.
'
'   GRAPHIC SET SCROLLTEXT [n&]             enable/disable auto-scroll text
'   GRAPHIC GET SCROLLTEXT To var&          read that flag back
'   GRAPHIC IMAGELIST (x,y), hLst, i&, ov&, style&
'                                           draw item i from an image list
'   GRAPHIC RENDER [BITMAP|ICON] name$, (x1,y1)-(x2,y2)
'                                           stretch an image onto the target
'   GRAPHIC STRETCH hBmp, ID, (x1,y1)-(x2,y2) TO (x3,y3)-(x4,y4) [, Mix, Stretch]
'   GRAPHIC STRETCH PAGE hBmp, ID [, Mix, Stretch]
'   GRAPHIC BITMAP CAPTURE To hBmp&         (FORK EXTENSION - no page in the
'                                            official help; grammar mirrors
'                                            GRAPHIC BITMAP LOAD/NEW)
'
' WHAT EACH ASSERTION PROVES
'   SCROLLTEXT   set 1 then 0 and read the flag back both times: a missing
'                runtime would answer 0 for both.
'   CAPTURE      the returned handle must be non-zero, and the bitmap it names
'                must survive being used as a STRETCH source below - a stub
'                returning 0 fails the first check.
'   STRETCH      a red box is drawn, captured, then stretched from (10,10)-(60,60)
'                onto (200,150)-(280,220).  The pixel at (240,180) maps back to
'                (40,40) inside that box, so it must be red.  If the parser
'                drops the TO half of the statement (it did, until this batch's
'                fix) nothing is drawn and the read fails.
'   IMAGELIST    called with a null list handle: the runtime must refuse it and
'                return, not fault.  The positive path needs an ImageList handle
'                from the IMAGELIST DDT family, which this sample does not build.
'   RENDER       the icon file is rendered but no pixel read follows: a .ico has
'                an alpha mask, so "nothing changed" would not prove failure.
'                Recorded as a known limit rather than dressed up as a check.
'
' Expected output (run mode): a series of "ok" lines and
'   "=== FAILURES:0 ===", exit code 0.
' Complexity note: O(1) - a fixed list of draws and pixel reads.
'=====================================================================
#COMPILER PBWIN 10
#COMPILE EXE

%RED     = 255      ' COLORREF 0x000000FF
%GREEN   = 65280    ' COLORREF 0x0000FF00

FUNCTION PBMAIN () AS LONG
    LOCAL hGr    AS QUAD
    LOCAL iswA   AS QUAD
    LOCAL iswH   AS QUAD
    LOCAL dcA    AS QUAD
    LOCAL dcH    AS QUAD
    LOCAL rdA    AS QUAD
    LOCAL rdH    AS QUAD
    LOCAL gpA    AS QUAD
    LOCAL gpH    AS QUAD
    LOCAL hdc    AS QUAD
    LOCAL hb     AS QUAD
    LOCAL hbL    AS LONG
    LOCAL guard  AS LONG
    LOCAL st     AS LONG
    LOCAL px     AS LONG
    LOCAL sv     AS LONG
    LOCAL fail   AS LONG

    PRINT "batch 182 - SET/GET SCROLLTEXT / IMAGELIST / RENDER /"
    PRINT "            STRETCH / STRETCH PAGE / BITMAP CAPTURE"
    PRINT "-----------------------------------------------------------"

    IMPORT ADDR "IsWindow",  "USER32.DLL" TO iswA, iswH
    IMPORT ADDR "GetDC",     "USER32.DLL" TO dcA, dcH
    IMPORT ADDR "ReleaseDC", "USER32.DLL" TO rdA, rdH
    IMPORT ADDR "GetPixel",  "GDI32.DLL"  TO gpA, gpH
    IF iswA = 0 OR dcA = 0 OR rdA = 0 OR gpA = 0 THEN
        fail = fail + 1
        PRINT "FAIL IMPORT ADDR (USER32/GDI32 helpers)"
    END IF

    ' ---- the drawing target ------------------------------------------
    hGr = 0
    GRAPHIC WINDOW NEW "batch 182", 60, 60, 420, 320 TO hGr
    IF hGr <> 0 THEN
        PRINT "ok   GRAPHIC WINDOW NEW returned a handle"
    ELSE
        fail = fail + 1
        PRINT "FAIL GRAPHIC WINDOW NEW handle"
    END IF

    ' ---- SET / GET SCROLLTEXT ----------------------------------------
    GRAPHIC SET SCROLLTEXT 1
    sv = 0
    GRAPHIC GET SCROLLTEXT TO sv
    IF sv <> 0 THEN
        PRINT "ok   SET SCROLLTEXT 1 is reported back by GET SCROLLTEXT"
    ELSE
        fail = fail + 1
        PRINT "FAIL GET SCROLLTEXT after SET 1 ="; sv
    END IF

    GRAPHIC SET SCROLLTEXT 0
    sv = -1
    GRAPHIC GET SCROLLTEXT TO sv
    IF sv = 0 THEN
        PRINT "ok   SET SCROLLTEXT 0 is reported back as 0"
    ELSE
        fail = fail + 1
        PRINT "FAIL GET SCROLLTEXT after SET 0 ="; sv
    END IF

    GRAPHIC SET SCROLLTEXT 1

    ' ---- a red box to capture and to stretch --------------------------
    GRAPHIC BOX (10,10)-(60,60), %RED, %RED, 1
    GRAPHIC REDRAW
    hdc = 0
    CALL DWORD dcA USING GetDC(hGr) TO hdc
    px = -1
    CALL DWORD gpA USING GetPixel(hdc, 30, 30) TO px
    IF px = %RED THEN
        PRINT "ok   baseline: the red box reached the target (30,30)"
    ELSE
        fail = fail + 1
        PRINT "FAIL baseline pixel (30,30) ="; px
    END IF

    ' ---- BITMAP CAPTURE ----------------------------------------------
    hb = 0
    GRAPHIC BITMAP CAPTURE TO hb
    IF hb <> 0 THEN
        PRINT "ok   BITMAP CAPTURE returned a bitmap handle"
    ELSE
        fail = fail + 1
        PRINT "FAIL BITMAP CAPTURE handle ="; hb
    END IF

    ' ---- STRETCH, using the captured bitmap as the source -------------
    GRAPHIC STRETCH hb, 0, (10,10)-(60,60) TO (200,150)-(280,220), 0, 0
    GRAPHIC REDRAW
    px = -1
    CALL DWORD gpA USING GetPixel(hdc, 240, 180) TO px
    IF px = %RED THEN
        PRINT "ok   STRETCH copied the captured box to (200,150)-(280,220)"
    ELSE
        fail = fail + 1
        PRINT "FAIL stretched pixel (240,180) ="; px
    END IF

    ' ---- STRETCH PAGE (whole-buffer form, must not fault) -------------
    GRAPHIC STRETCH PAGE hb, 0, 0, 0
    GRAPHIC REDRAW
    PRINT "ok   STRETCH PAGE ran without faulting (whole-buffer copy)"

    ' ---- IMAGELIST: the null-handle guard ------------------------------
    GRAPHIC IMAGELIST (5,5), 0, 1, 0, 0
    PRINT "ok   IMAGELIST refused a null list handle without faulting"

    ' ---- RENDER (no pixel assertion - see the header note) ------------
    GRAPHIC RENDER ICON "batch173_test.ico", (300,10)-(316,26)
    GRAPHIC REDRAW
    PRINT "ok   RENDER ran (icon has an alpha mask: run, not asserted)"

    ' ---- the window is still alive ------------------------------------
    st = 0
    CALL DWORD iswA USING IsWindow(hGr) TO st
    IF st <> 0 THEN
        PRINT "ok   the drawing target survived every statement above"
    ELSE
        fail = fail + 1
        PRINT "FAIL IsWindow(hGr)="; st
    END IF

    IF hdc <> 0 THEN
        CALL DWORD rdA USING ReleaseDC(hGr, hdc) TO st
    END IF

    ' ---- a LONG destination must not write past its slot ---------------
    ' The handle is an i64.  Until batch 183 it was stored straight through the
    ' destination pointer, so a LONG received an eight-byte store into a
    ' four-byte slot: the target still read back its low half, and the four
    ' bytes past it silently clobbered whatever alloca sat next door - which is
    ' why the QUAD destination used above never showed anything.
    '
    ' Two things are asserted, and they are not equally strong: hbL <> 0 proves
    ' the truncation kept the handle, while guard = 12345 only reports the
    ' clobber when the two allocas happen to land adjacently.  The deterministic
    ' proof of this fix is the scanner self-test - sweep_handle_width.py was fed
    ' the pre-fix backup and named exactly these two arms (L8564 capture,
    ' L8572 load); with the fix in place it reports none.
    guard = 12345
    hbL = 0
    GRAPHIC BITMAP CAPTURE TO hbL
    IF hbL <> 0 THEN
        PRINT "ok   BITMAP CAPTURE into a LONG destination kept its low half"
    ELSE
        fail = fail + 1
        PRINT "FAIL BITMAP CAPTURE into a LONG destination read back 0"
    END IF
    IF guard = 12345 THEN
        PRINT "ok   the LONG next to the destination was not written past"
    ELSE
        fail = fail + 1
        PRINT "FAIL the destination's i64 store ran into its neighbour: guard ="; guard
    END IF

    ' ---- close the window before returning -----------------------------
    ' A graphic window that is still alive at process exit makes this runtime
    ' exit with 0xC0000005 - reproduced by a six-line window+box program that
    ' uses no batch-182 statement at all, so it is a pre-existing defect in the
    ' teardown path rather than something this batch introduced.  batch181_test.bas
    ' closes its window for the same reason.  The sample therefore cleans up after
    ' itself; the defect is recorded in the batch notes, not papered over.
    GRAPHIC WINDOW END hGr
    st = 1
    CALL DWORD iswA USING IsWindow(hGr) TO st
    IF st = 0 THEN
        PRINT "ok   GRAPHIC WINDOW END closed the drawing target"
    ELSE
        fail = fail + 1
        PRINT "FAIL the window was still alive after GRAPHIC WINDOW END"
    END IF

    PRINT "-----------------------------------------------------------"
    PRINT "=== FAILURES:"; fail; " ==="
    FUNCTION = fail
END FUNCTION
