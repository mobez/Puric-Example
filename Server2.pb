If InitNetwork() = 0
  MessageRequester("Error", "Can't initialize the network !", 0)
  End
EndIf
Global Port = 80
Global buf.s
Procedure server(*x)
  If CreateNetworkServer(0, Port)
AddGadgetItem(1,0, "Server created (Port "+Str(Port)+").")

Repeat
SEvent = NetworkServerEvent()
If SEvent 
      ClientID = EventClient()
  
      Select SEvent
      
        Case #PB_NetworkEvent_Connect
          
          
          ;AddGadgetItem(1, 1, "A new client has connected !")
          ip_client.s = IPString(GetClientIP(ClientID)  , #PB_Network_IPv4)           
        Case #PB_NetworkEvent_Data
          *Buffer2 = AllocateMemory(2056)
          coun=0
          ReceiveNetworkData(ClientID, *Buffer2, 2056)
          buf=PeekS(*Buffer2, -1, #PB_UTF8)
          ;RTrim(buf, #CRLF$)
          ;AddGadgetItem(1, 2, "edit= "+buf)
          Dats.s="Client "+ip_client+"  has send a packet ! "+#CRLF$+"String: "+buf+#CRLF$
          SendNetworkString(ClientID, "200 Ok!"+#CRLF$+#CRLF$)
          If CountString(buf, "hc165")
            Position = FindString(buf, " ", 1)
          Position2 = FindString(buf, "/", 1)
          buf=Mid(buf, Position, Position2-Position)
          cont= CountString(buf, ",")          
          Position3 = FindString(buf, ",", 1)
           Dats + "¡‡ÈÚπ1= "+Mid(buf, 1, Position3-1)+#CRLF$
          For k = 2 To cont 
          buf=Mid(buf, Position3+1, (Position2-Position3))
          Position3 = FindString(buf, ",", 1)
          Dats + "¡‡ÈÚπ"+k+"= "+Mid(buf, 1, Position3-1)+#CRLF$
          Next
          
          ElseIf CountString(buf, "hc595")
           Position = FindString(buf, " ", 1)
          Position2 = FindString(buf, "/", 1)
          buf=Mid(buf, Position, Position2-Position)
          cont= CountString(buf, ",")          
          Position3 = FindString(buf, ",", 1)
           Dats + "¡‡ÈÚπ1= "+Mid(buf, 1, Position3-1)+#CRLF$
          For k = 2 To cont 
          buf=Mid(buf, Position3+1, (Position2-Position3))
          Position3 = FindString(buf, ",", 1)
          Dats + "¡‡ÈÚπ"+k+"= "+Mid(buf, 1, Position3-1)+#CRLF$
          Next
          EndIf
          
        Case #PB_NetworkEvent_Disconnect
          ;FreeMemory(*Buffer)
          

          
          If coun=0
            Dats + "Client "+ip_client+"  has closed the connection..."+#CRLF$
          ;CloseNetworkServer(0)
          Dats + "----------------------------------------------------------"+#CRLF$
          coun=coun+1
          AddGadgetItem(1, 2, Dats)
          FreeMemory(*Buffer2)
          EndIf
      EndSelect
   
   
    EndIf
     ForEver
    CloseNetworkServer(0)
Else
  MessageRequester("Error", "Can't create the server (port in use ?).", 0)
EndIf

  EndProcedure

If OpenWindow(0, 0, 0, 850, 500, "Wifi switch", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  EditorGadget(1,10,10,830,480,#PB_String_ReadOnly)
  CreateThread(@server(),0)
Repeat
    
    
  Until WaitWindowEvent() = #PB_Event_CloseWindow  
  
  CloseNetworkServer(0)

 EndIf 
End   

; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 30
; FirstLine = 26
; Folding = -
; EnableXP
; Executable = ..\..\Users\Admin\Desktop\exe–°‚Ç¨–†–Ö–†—ë–†—î–†—ë\TCP_server.exe