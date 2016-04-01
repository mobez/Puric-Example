;
; ------------------------------------------------------------
;
;   PureBasic - Network (Client) example file
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;
 
If InitNetwork() = 0
  MessageRequester("Error", "Can't initialize the network !", 0)
  End
EndIf
 
Port = 80
 
ConnectionID = OpenNetworkConnection("192.168.1.37", Port)
If ConnectionID
  MessageRequester("PureBasic - Client", "Client connected to server...", 0)
  
  SendNetworkString(ConnectionID, "GET /gpio/1 HTTP\1.1", #PB_Ascii)
    
  MessageRequester("PureBasic - Client", "A string has been sent to the server, please check it before quit...", 0)
  
  CloseNetworkConnection(ConnectionID)
Else
  MessageRequester("PureBasic - Client", "Can't find the server (Is it launched ?).", 0)
EndIf


 
End
; IDE Options = PureBasic 5.11 (Windows - x86)
; CursorPosition = 9
; EnableXP