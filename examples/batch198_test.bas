'=====================================================================
' batch198_test.bas - batch 198: the 197 correction, and the dead-arm finding
'---------------------------------------------------------------------
' Two things happened in batch 198:
'
'   1. Batch 197 had called the v0.2.047 warning a false alarm.  Batch 198
'      corrected that: the witness showed the IMAGELIST handle really was 0, so
'      the warning had been pointing at something.  (两处都报警时，「哪个是真」
'      优先于「哪个数字好看」。)
'   2. Removing IMAGELIST_ from the family early return did not reach the arms
'      at all - the statements fell through to the catch-all hard error, i.e.
'      those arms sit in an unreachable dispatcher.  The experiment was rolled
'      back; the fix moved to a later batch.
'
' This sample pins the state the rollback left behind: the documented call form
' compiles and the handle/count pair behaves as batch 200 then made it behave.
' The *negative* half of the batch (the unreachable arms) cannot live in a
' compiling sample; it is recorded in the batch note in scripts/README.md.
'
' Asserts: non-zero handle, count 0 on a fresh list.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL hil AS QUAD
    LOCAL cnt AS LONG
    IMAGELIST NEW BITMAP 16, 16, 32, 2 TO hil
    PRINT "imagelist handle = "; hil
    IF hil = 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST GET COUNT hil TO cnt
    PRINT "fresh list count = "; cnt
    IF cnt <> 0 THEN
        fail = fail + 1
    END IF
    IMAGELIST KILL hil
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
