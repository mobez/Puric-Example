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

 
 If OpenWindow(0, 0, 0, 222, 200, "Wifi switch", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
    ButtonGadget(1, 10, 10, 200, 20, "Led on")
    ButtonGadget(2, 10, 40, 200, 20, "Led off") 
    
    Repeat
    Event=WaitWindowEvent()
   
  If Event=#PB_Event_Gadget
    
    Gadget= EventGadget()        
      If gadget= 1
       
        DisableGadget(2,0)
        DisableGadget(1,1)
        GetHTTPHeader("http://192.168.1.33/gpio/0")
        
     ElseIf gadget= 2
        
     DisableGadget(1,0) 
     DisableGadget(2,1) 
     ;Get("http://192.168.1.37/gpio/1")
     GetHTTPHeader("http://192.168.1.33/gpio/1")
     
  EndIf
EndIf

  Until WaitWindowEvent() = #PB_Event_CloseWindow  
   
 EndIf    
 End
 
; IDE Options = PureBasic 5.11 (Windows - x86)
; CursorPosition = 30
; FirstLine = 3
; EnableXP