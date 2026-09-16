' PowerBasilisk Enhanced - batch 29: Inline ASM (! and ASM statements)
' 32-bit and 64-bit targets. Each ! line becomes an LLVM inline-asm block.
#COMPILE EXE
#DIM ALL

FUNCTION PBMAIN() AS LONG
    LOCAL x AS LONG
    LOCAL y AS LONG
    LOCAL w AS WORD
    LOCAL b AS BYTE
    LOCAL q AS QUAD
    LOCAL pass AS LONG
    LOCAL fail AS LONG
    LOCAL waitk AS STRING

    pass = 0
    fail = 0

    ' 1. write a LONG via ASM shortcut
    x = 5
    ! MOV x, 123
    IF x = 123 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 1: x="; x

    ' 2. copy variable to variable
    ! MOV y, x
    IF y = 123 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 2: y="; y

    ' 3. add immediate
    ! ADD x, 10
    IF x = 133 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 3: x="; x

    ' 4. ASM keyword form with % suffix
    ASM MOV x%, 7
    IF x = 7 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 4: x="; x

    ' 5. BYTE width
    ! MOV b, 100
    IF b = 100 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 5: b="; b

    ' 6. WORD width
    ! MOV w, 30000
    IF w = 30000 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 6: w="; w

    ' 7. QUAD width (qword ptr)
    ! MOV q, 123456789012345
    IF q = 123456789012345 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 7: q="; q

    ' 8. register-only instructions (no PB operands)
    ! MOV EAX, 1
    ! ADD EAX, 2
    ! NOP
    pass = pass + 1

    ' 9. register state preserved across consecutive ASM lines
    ! MOV EAX, [x]
    ! MOV y, EAX
    IF y = 7 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 9: y="; y

    ' 10. x87 floating-point: FLD1 then FSTP to a DOUBLE variable
    LOCAL d AS DOUBLE
    ! FLD1
    ! FSTP d
    IF d > 0.9 AND d < 1.1 THEN pass = pass + 1 ELSE fail = fail + 1 : PRINT "FAIL 10: d="; d

    ' 11. MMX + SSE instructions accepted (compile-time proof)
    ! PXOR MM0, MM0
    ! EMMS
    ! XORPS XMM0, XMM0
    pass = pass + 1

    PRINT "batch29 ASM: pass="; pass; " fail="; fail
    IF fail = 0 THEN PRINT "ALL PASS" ELSE PRINT "SOME FAILED"

    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
