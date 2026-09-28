'=====================================================================
' batch 218 negative probe - a malformed GLOBALMEM statement must be LOUD.
'---------------------------------------------------------------------
' The official syntax always carries the destination:
'     GLOBALMEM ALLOC count TO vHndl
'     GLOBALMEM FREE  mHndl TO vHndl
' (see GLOBALMEM_statement.htm).  Without the `TO <var>` there is nowhere to
' put the handle / the result.
'
' Before batch 218 that spelling compiled cleanly and did absolutely nothing:
' the FREE below was silently dropped and the block leaked - a silent no-op on
' malformed input, the exact shape the project forbids.
' After batch 218 the codegen arm reports it and the build stops.
'
' Expected: rc != 0, with
'   Error: GLOBALMEM FREE requires its destination: GLOBALMEM FREE mHndl TO vHndl
'=====================================================================
#COMPILE EXE

FUNCTION PBMAIN() AS LONG
    LOCAL h AS LONG
    LOCAL sz AS LONG

    GLOBALMEM ALLOC 64 TO h
    GLOBALMEM SIZE h TO sz
    PRINT "handle ="; h; " size ="; sz

    ' MALFORMED: the official form is `GLOBALMEM FREE h TO result`
    GLOBALMEM FREE h

    PRINT "still holding handle ="; h
    FUNCTION = 0
END FUNCTION
