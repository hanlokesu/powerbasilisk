' PowerBasilisk Enhanced - Batch 30: ASMDATA / END ASMDATA read-only data blocks
' Verifies: DB/DW/DD/DQ byte layout, ANSI + WIDE string literals, CODEPTR() address,
' packed unaligned offsets, read-back via PEEK.
ASMDATA ABC
    DB 5, 2, 3
    DB 7, 8, 9
    DW 2, 3
    DD &H12345678
    DQ 1234567890
    DB "Hi", 0
    DW "AB"
END ASMDATA

FUNCTION PBMAIN() AS LONG
    LOCAL p AS QUAD
    LOCAL pass AS LONG
    LOCAL waitk AS STRING
    pass = 1

    p = CODEPTR(ABC)

    ' DB 5,2,3 at offsets 0..2
    IF PEEK(BYTE, p) <> 5 THEN pass = 0
    IF PEEK(BYTE, p + 1) <> 2 THEN pass = 0
    IF PEEK(BYTE, p + 2) <> 3 THEN pass = 0
    ' DB 7,8,9 at offsets 3..5
    IF PEEK(BYTE, p + 3) <> 7 THEN pass = 0
    IF PEEK(BYTE, p + 4) <> 8 THEN pass = 0
    IF PEEK(BYTE, p + 5) <> 9 THEN pass = 0
    ' DW 2,3 at offsets 6..9 (LE)
    IF PEEK(WORD, p + 6) <> 2 THEN pass = 0
    IF PEEK(WORD, p + 8) <> 3 THEN pass = 0
    ' DD &H12345678 at offsets 10..13 (LE)
    IF PEEK(DWORD, p + 10) <> &H12345678 THEN pass = 0
    ' DQ 1234567890 at offsets 14..21 (LE)
    IF PEEK(QUAD, p + 14) <> 1234567890 THEN pass = 0
    ' DB "Hi", 0 at offsets 22..24
    IF PEEK(BYTE, p + 22) <> 72 THEN pass = 0
    IF PEEK(BYTE, p + 23) <> 105 THEN pass = 0
    IF PEEK(BYTE, p + 24) <> 0 THEN pass = 0
    ' DW "AB" (WIDE, UTF-16LE) at offsets 25..28
    IF PEEK(WORD, p + 25) <> 65 THEN pass = 0
    IF PEEK(WORD, p + 27) <> 66 THEN pass = 0

    IF pass = 1 THEN
        PRINT "Batch 30 ASMDATA: ALL PASS (14/14)"
    ELSE
        PRINT "Batch 30 ASMDATA: FAIL"
    END IF
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
