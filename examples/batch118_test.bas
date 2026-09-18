' PowerBasilisk Enhanced - batch118_test.bas
' Batch 118: wire up previously half-finished statements.
'   GRAPHIC PRINT ........ real GDI text on the attached bitmap (pb_graphic_print_str)
'   XPRINT COLOR ......... 1/2/3-arg printer text color (pb_xprint_set_color / _rgb)
'   RESOURCE SAVE FILE ... real embedded-resource extraction (pb_resource_save_file)
'   DISPLAY OPENFILE/SAVEFILE/BROWSE/COLOR/FONT ... real Win32 common dialogs
'   PLAY SOUND freq,ms ... Beep() tone (pb_play_sound)
'   FONT END ............. parser fix (Token::End in peek_plain_upper)
'
' Dialog / printer / embedded-resource statements need an interactive desktop,
' a printer, or a compiled-in resource, so they are guarded by showDialogs=0
' (they still compile to real Win32 calls; flip the flag to try them).
FUNCTION PBMAIN() AS LONG
    LOCAL hbmp AS QUAD
    LOCAL waitk AS STRING
    LOCAL fails AS LONG
    LOCAL showDialogs AS LONG
    LOCAL f AS STRING
    LOCAL c AS LONG

    showDialogs = 0

    PRINT "=== Batch 118: half-finished wiring completion ==="

    ' --- GRAPHIC PRINT: draw text onto an offscreen bitmap, save it ----------
    GRAPHIC BITMAP NEW 240, 80 TO hbmp
    IF hbmp = 0 THEN
        PRINT "FAIL: GRAPHIC BITMAP NEW returned zero"
        INCR fails
    ELSE
        GRAPHIC ATTACH hbmp
        GRAPHIC CLEAR
        GRAPHIC COLOR 0, 16777215          ' black text on white background
        GRAPHIC PRINT "Hello PowerBasilisk"
        KILL "batch118_out.bmp"
        GRAPHIC SAVE "batch118_out.bmp"
        GRAPHIC DETACH
        GRAPHIC BITMAP END
        IF ISFILE("batch118_out.bmp") THEN
            PRINT "OK: GRAPHIC PRINT rendered and saved batch118_out.bmp"
        ELSE
            PRINT "FAIL: GRAPHIC SAVE did not produce batch118_out.bmp"
            INCR fails
        END IF
    END IF

    ' --- PLAY SOUND: a short 440 Hz beep (pb_play_sound -> Beep) -------------
    PLAY SOUND 440, 120
    PRINT "OK: PLAY SOUND 440,120 issued"

    ' --- Interactive common dialogs / printer / resource (compile-verified) -
    IF showDialogs THEN
        DISPLAY OPENFILE "Open a file", "Text files", "" TO f
        DISPLAY SAVEFILE "Save a file", "Text files", "" TO f
        DISPLAY BROWSE "Pick a folder", "" TO f
        DISPLAY COLOR TO c
        DISPLAY FONT TO f
        XPRINT ATTACH "default"
        XPRINT COLOR 0, 0, 255
        XPRINT PRINT "blue text"
        XPRINT CLOSE
        RESOURCE SAVE FILE "MYRES", "res_out.bin"
    END IF

    IF fails = 0 THEN
        PRINT "=== Batch 118: ALL PASS ==="
    ELSE
        PRINT "=== Batch 118: FAILURES="; fails; " ==="
    END IF

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
