;
; ------------------------------------------------------------
;
;   PureBasic - Network (Client) example file
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;

InitNetwork()

  ;*Buffer = AllocateMemory(1024)
  For g=1 To 100
    For i=1 To 6
      ConnectionID = OpenNetworkConnection("192.168.1.33", 80)
        If ConnectionID  
     getData$ = "GET /h595/1"+Str(i)+"1"+" HTTP/1.1"+#CRLF$
  getData$ + "Host:192.168.1.33"+#CRLF$
  getData$ + #CRLF$
  SendNetworkString(ConnectionID, getData$)   
CloseNetworkConnection(ConnectionID)
EndIf
Delay(50)
 Next i
 For o=1 To 6
   ConnectionID = OpenNetworkConnection("192.168.1.33", 80)
        If ConnectionID  
     getData$ = "GET /h595/1"+Str(o)+"0"+" HTTP/1.1"+#CRLF$
  getData$ + "Host:192.168.1.33"+#CRLF$
  getData$ + #CRLF$
  SendNetworkString(ConnectionID, getData$)   
CloseNetworkConnection(ConnectionID)
EndIf
Delay(50)
 Next o
Next g


For g=1 To 100
    For i=6 To 1 Step -1
      ConnectionID = OpenNetworkConnection("192.168.1.33", 80)
        If ConnectionID  
     getData$ = "GET /h595/1"+Str(i)+"1"+" HTTP/1.1"+#CRLF$
  getData$ + "Host:192.168.1.33"+#CRLF$
  getData$ + #CRLF$
  SendNetworkString(ConnectionID, getData$)   
CloseNetworkConnection(ConnectionID)
EndIf
Delay(50)
 Next i
 For o=6 To 1 Step -1
   ConnectionID = OpenNetworkConnection("192.168.1.33", 80)
        If ConnectionID  
     getData$ = "GET /h595/1"+Str(o)+"0"+" HTTP/1.1"+#CRLF$
  getData$ + "Host:192.168.1.33"+#CRLF$
  getData$ + #CRLF$
  SendNetworkString(ConnectionID, getData$)   
CloseNetworkConnection(ConnectionID)
EndIf
Delay(50)
 Next o
Next g
End
; IDE Options = PureBasic 5.11 (Windows - x86)
; CursorPosition = 39
; FirstLine = 8
; EnableXP
; Executable = MinGW Installer.lnk.exe