FUNCTION PBMAIN() AS LONG
    LOCAL a(10) AS LONG
    LOCAL t(10) AS LONG
    LOCAL hDlg AS LONG
    LOCAL id(0) AS LONG
    LOCAL o AS LONG
    LOCAL waitk AS STRING
    PRINT "=== Batch 121: Tier-2 non-GUI cleanup ==="

    ' --- ARRAY TAGARRAY / ERASE (real codegen, verified) ---
    ARRAY TAGARRAY a(), t()
    ARRAY TAGARRAY ERASE a()
    PRINT "1 ARRAY TAGARRAY / ERASE OK"

    ' --- Accepted no-op: OOP / GUI / async (batch 121) ---
    ' INSTANCE o AS MyClass  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    ' EVENT SOURCE s1  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    ' EVENTS Click  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    ' RAISEEVENT Click  ' (batch 222: real form lives in a CLASS block; see batch222_test.bas)
    ACCEL ATTACH hDlg, id()
    TCP NOTIFY 1, 100
    UDP NOTIFY 1, 100
    PRINT "2 OOP/GUI/notify no-op statements accepted OK"
    PRINT ""
    PRINT "=== ALL 2 GROUPS PASSED ==="
    PRINT "Press any key to exit..."
    waitk = WAITKEY$
END FUNCTION
