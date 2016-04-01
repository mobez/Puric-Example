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
Port = 80
*Buffer = AllocateMemory(1024)
 If OpenWindow(0, 0, 0, 222, 200, "Wifi switch", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ButtonGadget(0, 10, 10, 200, 20, "Led on")
    ButtonGadget(1, 10, 40, 200, 20, "Led off") 
    Repeat
   
  Event=WaitWindowEvent()  
  If Event=#PB_Event_Gadget
    
    Select EventGadget()        
      Case 0
        ConnectionID = OpenNetworkConnection("192.168.1.33", Port)
        Delay(10)
    If ConnectionID
        DisableGadget(1,0)
        DisableGadget(0,1)
        SendNetworkString(ConnectionID, "GET /gpio/0/128 HTTP\1.1") 
       
EndIf 
   Case 1 
     ConnectionID = OpenNetworkConnection("192.168.1.33", Port)
     Delay(10)
    If ConnectionID
     DisableGadget(0,0) 
     DisableGadget(1,1)     
     SendNetworkString(ConnectionID, "GET /gpio/1/255 HTTP\1.1")

     EndIf   
  EndSelect 
 ;If ReceiveNetworkData(ConnectionID, *Buffer, 1000)
         ;MessageRequester("Info", "String: "+PeekS(*Buffer, -1), 0)
         ;EndIf
EndIf

  Until WaitWindowEvent() = #PB_Event_CloseWindow  
   
 EndIf    
End
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 33
; FirstLine = 15
; EnableXP
; DisableDebugger
; Compiler = PureBasic 4.51 (Windows - x86)