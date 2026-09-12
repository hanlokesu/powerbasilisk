FUNCTION PBMAIN() AS LONG
    LOCAL ok AS LONG
    LOCAL s AS STRING
    LOCAL w AS LONG
    LOCAL h AS LONG
    LOCAL x AS LONG
    LOCAL y AS LONG
    ok = 0

    ' --- MKx family: length + first byte (little-endian) ---
    s = MKI$(1000)
    IF LEN(s) <> 2 THEN ok = ok + 1
    IF ASC(s) <> 232 THEN ok = ok + 10          ' 0xE8 = low byte of 1000

    s = MKWRD$(1000)
    IF LEN(s) <> 2 THEN ok = ok + 100
    IF ASC(s) <> 232 THEN ok = ok + 1000

    s = MKL$(1000)
    IF LEN(s) <> 4 THEN ok = ok + 10000
    IF ASC(s) <> 232 THEN ok = ok + 100000

    s = MKDWD$(1000)
    IF LEN(s) <> 4 THEN ok = ok + 1000000
    IF ASC(s) <> 232 THEN ok = ok + 10000000

    s = MKQ$(1000)
    IF LEN(s) <> 8 THEN ok = ok + 100000000
    IF ASC(s) <> 232 THEN ok = ok + 1000000000

    s = MKCUR$(1000)
    IF LEN(s) <> 8 THEN ok = ok + 1

    s = MKCUX$(1000)
    IF LEN(s) <> 8 THEN ok = ok + 10

    s = MKS$(1000)
    IF LEN(s) <> 4 THEN ok = ok + 100

    s = MKD$(1000)
    IF LEN(s) <> 8 THEN ok = ok + 1000

    ' --- DESKTOP GET CLIENT / LOC / PPI ---
    DESKTOP GET CLIENT TO w, h
    IF w <= 0 OR h <= 0 THEN ok = ok + 10000

    DESKTOP GET LOC TO x, y
    IF x < 0 OR y < 0 THEN ok = ok + 100000

    DESKTOP GET PPI TO x, y
    IF x <= 0 OR y <= 0 THEN ok = ok + 1000000

    IF ok = 0 THEN
        PRINT "BATCH16 ALL PASS"
        FUNCTION = 0
    ELSE
        PRINT "FAIL code="; ok
        FUNCTION = 1
    END IF
END FUNCTION
