If InitNetwork() = 0
  MessageRequester("Error", "Can't initialize the network !", 0)
  End
EndIf
Global Port = 81
Global buf.s
Global Dim hc.d(2)
Declare send_tcp(tcp_txt.S)
Procedure server(*x)
  sen.s=""
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
          SendNetworkString(ClientID, "200 Ok!"+#CRLF$+"hc595 "+Str(hc(0))+","+Str(hc(1))+","+"0,0,0,0,/")
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
        
      ElseIf CountString(buf, "GET")
        Position = FindString(buf, "/", 1)
        buf=Mid(buf, Position+1)
        Position = FindString(buf, " ", 1)
        buf=Mid(buf, 1, Position-1)
        Select buf
          Case "60"
           hc(0)=0:hc(1)=0 
         Case "61"
           hc(0)=0:hc(1)=0
         Case "3"
           hc(0)=0:hc(1)=0
         Case "4"
           hc(0)=255:hc(1)=255
         Case "2041"
           li=hc(0)
           li=li | 16
           hc(0)=li
         Case "2040"
           li=hc(0)
           li=li & 16
           hc(0)=li
           
            EndSelect
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
          send_tcp("hc595 "+Str(hc(0))+","+Str(hc(1))+","+"0,0,0,0,/")
          EndIf
      EndSelect
   
   
    EndIf
     ForEver
    CloseNetworkServer(0)
Else
  MessageRequester("Error", "Can't create the server (port in use ?).", 0)
EndIf

EndProcedure

Procedure send_tcp(tcp_txt.S)  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection("127.0.0.1", 6666)
  If ConnectionID 
 *Buffer4 = AllocateMemory(65536)
  SendNetworkString(ConnectionID, tcp_txt, #PB_UTF8)
  ReceiveNetworkData(ConnectionID, *Buffer4, 65536)
  bufs.s=PeekS(*Buffer4, -1, #PB_UTF8)
  CloseNetworkConnection(ConnectionID)
  Dats.s="Get resive  has send a packet ! "+#CRLF$+"String: "+bufs+#CRLF$
  Dats + "----------------------------------------------------------"+#CRLF$
  AddGadgetItem(1, 2, "Resive "+ tims+" : "+Dats) 
FreeMemory(*Buffer4)
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
; CursorPosition = 98
; FirstLine = 81
; Folding = -
; EnableXP
; Executable = ..\..\Users\Admin\Desktop\exe–°‚Ç¨–†–Ö–†—ë–†—î–†—ë\Tcp\Server_test_81.exe