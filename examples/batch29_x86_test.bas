' PowerBasilisk Enhanced - batch 29 x86 (32-bit) verification
' Uses exit code (no PRINT, avoiding the 32-bit printf symbol issue):
' 0 = all pass, 1/2/3 = specific failure.
#COMPILE EXE
#DIM ALL

FUNCTION PBMAIN() AS LONG
    LOCAL x AS LONG
    LOCAL y AS LONG

    x = 5
    ! MOV x, 42
    IF x <> 42 THEN FUNCTION = 1

    ! MOV y, x
    IF y <> 42 THEN FUNCTION = 2

    ! ADD x, 8
    IF x <> 50 THEN FUNCTION = 3

    ' register state preserved across consecutive ASM lines
    x = 7
    ! MOV EAX, [x]
    ! MOV y, EAX
    IF y <> 7 THEN FUNCTION = 4

    ' qword wide-immediate store (lo/hi dword split)
    LOCAL q AS QUAD
    ! MOV q, 123456789012345
    IF q <> 123456789012345 THEN FUNCTION = 5

    FUNCTION = 0
END FUNCTION
