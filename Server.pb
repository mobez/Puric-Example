If InitNetwork() = 0
  MessageRequester("Error", "Can't initialize the network !", 0)
  End
EndIf
Global *Buffer2 = AllocateMemory(1000)
Global Port = 6666
Procedure server(*x)
  If CreateNetworkServer(0, Port)
AddGadgetItem(1,0, "Server created (Port "+Str(Port)+").")

Repeat
SEvent = NetworkServerEvent()
If SEvent 
      ClientID = EventClient()
  
      Select SEvent
      
        Case #PB_NetworkEvent_Connect
          AddGadgetItem(1, 1, "A new client has connected !")
          ip_client.s = IPString(GetClientIP(ClientID)  , #PB_Network_IPv4)           
        Case #PB_NetworkEvent_Data
          
          ReceiveNetworkData(ClientID, *Buffer2, 1000)
          Dats.s="Client "+ip_client+"  has send a packet ! "+#CRLF$+"String: "+PeekS(*Buffer2, -1, #PB_UTF8)+#CRLF$
          SendNetworkString(ClientID, "200 Ok!"+#CRLF$)
          If CountString(PeekS(*Buffer2, -1, #PB_UTF8), "hc165")
          Position = FindString(PeekS(*Buffer2, -1, #PB_UTF8), " ", 1)
          Position2 = FindString(PeekS(*Buffer2, -1, #PB_UTF8), "/", 1)
          buf.s=Mid(PeekS(*Buffer2, -1, #PB_UTF8), 7, Position2-7)
          cont= CountString(buf, ",")          
          Position3 = FindString(buf, ",", 1)
           Dats + "¡‡ÈÚπ1= "+Mid(buf, 1, Position3-1)+#CRLF$
          For k = 2 To cont 
          buf=Mid(buf, Position3+1, (Position2-Position3))
          Position3 = FindString(buf, ",", 1)
          Dats + "¡‡ÈÚπ"+k+"= "+Mid(buf, 1, Position3-1)+#CRLF$
          Next
          
          ElseIf CountString(PeekS(*Buffer2, -1, #PB_UTF8), "hc595")
          Position = FindString(PeekS(*Buffer2, -1, #PB_UTF8), " ", 1)
          Position2 = FindString(PeekS(*Buffer2, -1, #PB_UTF8), "/", 1)
          buf.s=Mid(PeekS(*Buffer2, -1, #PB_UTF8), 7, Position2-7)
          cont= CountString(buf, ",")          
          Position3 = FindString(buf, ",", 1)
           Dats + "¡‡ÈÚπ1= "+Mid(buf, 1, Position3-1)+#CRLF$
          For k = 2 To cont 
          buf=Mid(buf, Position3+1, (Position2-Position3))
          Position3 = FindString(buf, ",", 1)
          Dats + "¡‡ÈÚπ"+k+"= "+Mid(buf, 1, Position3-1)+#CRLF$
        Next
      Else
        
          EndIf
          
        Case #PB_NetworkEvent_Disconnect
          ;FreeMemory(*Buffer)

          Dats + "Client "+ip_client+"  has closed the connection..."+#CRLF$
          ;CloseNetworkServer(0)
          Dats + "----------------------------------------------------------"+#CRLF$
          AddGadgetItem(1, 2, Dats)
          
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
FreeMemory(*Buffer2)
 EndIf 
End   

; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 22
; Folding = -
; EnableXP
; Executable = ..\..\Users\Admin\Desktop\exe–†–é–≤‚Äö¬¨–†¬†–†‚Ä¶–†¬†–°‚Äò–†¬†–°‚Äù–†¬†–°‚Äò\TCP_server.exe