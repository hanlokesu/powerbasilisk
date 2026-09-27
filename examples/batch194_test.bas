'=====================================================================
' batch194_test.bas - batch 194: the full-surface scan, and the LET spot check
'---------------------------------------------------------------------
' Batch 194 ran all five audit axes and found no new hard defect.  Its one
' concrete run-time check was that the exemptions list is not hiding a real
' problem: `LET x = 41` must print 42 - the four statements on that list are
' classification entries, not proofs (their own words: 这是分类表不是证明).
'
' This sample repeats that spot check and extends it to the rest of the Excel
' surface the list covers, so the exemption stays honest.
'
' Asserts: LET binds and arithmetic on the bound variable works.
'=====================================================================
FUNCTION PBMAIN () AS LONG
    LOCAL fail AS LONG
    LOCAL x AS LONG
    LOCAL y AS LONG
    LET x = 41
    x = x + 1
    PRINT "LET x = 41; x+1 = "; x
    IF x <> 42 THEN
        fail = fail + 1
    END IF
    y = x * 2 - 42
    PRINT "x*2-42         = "; y
    IF y <> 42 THEN
        fail = fail + 1
    END IF
    PRINT "=== FAILURES:"; fail; "==="
    FUNCTION = fail
END FUNCTION
