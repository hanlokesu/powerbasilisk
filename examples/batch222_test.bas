' batch222_test.bas — OOP event bus (EVENT SOURCE / EVENTS FROM / RAISEEVENT)
' ============================================================================
' Demonstrates:
'   * EVENT SOURCE Iface inside a CLASS — advertises an event interface
'   * RAISEEVENT Iface.Method(args) inside a method — fires an event
'   * EVENTS FROM obj / EVENTS END obj — subscribe / unsubscribe a client
'
' The event bus (batch 222) matches handlers by METHOD NAME: a subscribing
' class must implement a method with the same name as the raised event.
'
' Expected output (console):
'   got=42
'   (exit code 0)
' ============================================================================
#COMPILE EXE
#DIM ALL

CLASS Publisher
    INSTANCE state AS LONG
    EVENT SOURCE Status
    METHOD SetState (BYVAL v AS LONG)
        state = v
    END METHOD
    METHOD RaiseProgress (BYVAL pct AS LONG)
        RAISEEVENT Status.Progress(pct)
    END METHOD
END CLASS

CLASS Subscriber
    INSTANCE got AS LONG
    METHOD Progress (BYVAL pct AS LONG)
        got = pct
    END METHOD
END CLASS

FUNCTION PBMAIN () AS LONG
    LOCAL p AS Publisher
    LOCAL s AS Subscriber

    EVENTS FROM s
    p.SetState(5)
    p.RaiseProgress(42)
    PRINT "got=" & STR$(s.got)
    WAITKEY$
    EVENTS END s

    FUNCTION = 0
END FUNCTION
