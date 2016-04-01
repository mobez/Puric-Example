;
; ------------------------------------------------------------
;
;   PureBasic - Network (Client) example file
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;

 ;If OpenPreferences(GetTemporaryDirectory()+"Preferences.prefs")
 ; PreferenceGroup("Global")
  ;  WritePreferenceString("ip", "192.168.1.34")
   ; WritePreferenceString("port", "80")

 ; PreferenceComment(" This is the Window dimension")
  
 ; ClosePreferences()
;EndIf


Global send_data2
    ;Global port1.s  
    ;Global port2.s
    
    ;Global ConnectionID
    ;Global getData$
    ;Global dat.s
    ;Global q
    Structure txt_in_get
      get_txt2$
      ipcon$
      portcon$
    EndStructure
    *get_txt.txt_in_get = AllocateMemory(SizeOf(txt_in_get))
    Structure txt_in_post
      post_txt2$
      ipcon$
      portcon$
      send_post$
      send_post_body$
    EndStructure
    *post_txt.txt_in_post = AllocateMemory(SizeOf(txt_in_post))
    Structure txt_in_tcp
      tcp_txt2$
      ipcon$
      portcon$
    EndStructure
    *tcp_txt.txt_in_tcp = AllocateMemory(SizeOf(txt_in_tcp))
    
    Structure txt_in_595
      inf$
      a595.b
      ipcon$
      portcon$
    EndStructure
    *a595_txt.txt_in_595 = AllocateMemory(SizeOf(txt_in_595))
    
     Structure dates
      dats.b
      ipcon$
      portcon$
    EndStructure
    *dats_txt.dates = AllocateMemory(SizeOf(dates))
    Declare AlertThread2(*dats_txt.dates)
    
    Procedure DateStatusBar(*x) 
Repeat
  Time.s = FormatDate("%hh:%ii:%ss", Date() ) ; Узнаём текущее время
  StatusBarText(12, 0,Time) ; Выводим его на строку состояния
  Delay(1000)
ForEver
EndProcedure 
Procedure net(*x)
  InitNetwork()
EndProcedure



 
 
   

Procedure send(*dats_txt.dates)
  Protected send_data
  
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(*dats_txt\ipcon$, Val(*dats_txt\portcon$))
  If ConnectionID 
    *Buffer1 = AllocateMemory(65536)
 getData$ = "GET /gpio/"+Str(*dats_txt\dats)+" HTTP/1.1"+#CRLF$
  getData$ + "Host:"+*dats_txt\ipcon$+#CRLF$
  getData$ + #CRLF$
  SendNetworkString(ConnectionID, getData$, #PB_UTF8)
  
  ReceiveNetworkData(ConnectionID, *Buffer1, 65536)  
  CloseNetworkConnection(ConnectionID)
AddGadgetItem(11, 0, "Send "+*dats_txt\ipcon$+":"+*dats_txt\portcon$+" "+tims+" : "+getData$)
AddGadgetItem(11, 3, "------------------------------------------------------------")
If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Send "+*dats_txt\ipcon$+":"+*dats_txt\portcon$+" "+tims+" : "+getData$)
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
  AddGadgetItem(11, 3, "Resive "+ tims+" : "+PeekS(*Buffer1, -1, #PB_Ascii))
  AddGadgetItem(11,3, "------------------------------------------------------------")
 If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer1, -1, #PB_Ascii))
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf 

send_data2=*dats_txt\dats
If *dats_txt\dats=1
        DisableGadget(2,1)
        DisableGadget(1,0)
      Else
        DisableGadget(2,0)
        DisableGadget(1,1)
      EndIf
      FreeMemory(*Buffer1)
      EndIf
      
EndProcedure  

Procedure send_get(*get_txt.txt_in_get)
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(*get_txt\ipcon$, Val(*get_txt\portcon$))
  If ConnectionID 
    *Buffer2 = AllocateMemory(65536)
 getData$ = "GET /"+*get_txt\get_txt2$+" HTTP/1.1"+#CRLF$
  getData$ + "Host:"+*get_txt\ipcon$+#CRLF$
  getData$ + #CRLF$
  SendNetworkString(ConnectionID, getData$, #PB_UTF8)
  ReceiveNetworkData(ConnectionID, *Buffer2, 65536)
  CloseNetworkConnection(ConnectionID)
  AddGadgetItem(11, 0, "Send: "+*get_txt\ipcon$+":"+*get_txt\portcon$+" "+tims+" : "+getData$)
  If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Send "+*get_txt\ipcon$+":"+*get_txt\portcon$+" "+tims+" : "+getData$)
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
  AddGadgetItem(11, 3, "------------------------------------------------------------")
  AddGadgetItem(11, 3, "Resive: "+ tims+" : "+PeekS(*Buffer2, -1, #PB_UTF8 ))
  
 If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer2, -1, #PB_UTF8 ))
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
AddGadgetItem(11, 3, "------------------------------------------------------------") 
FreeMemory(*Buffer2)
EndIf

EndProcedure

Procedure send_post(*post_txt.txt_in_post)
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(*post_txt\ipcon$, Val(*post_txt\portcon$))
  If ConnectionID 
    *Buffer3 = AllocateMemory(65536)
    SednDat$="api_key="+*post_txt\send_post$
    SednDat$+"&command_string="+*post_txt\send_post_body$+"&position="
    len_body=Len(SednDat$)    
    postData$ = "POST /"+*post_txt\post_txt2$+" HTTP/1.1"+#CRLF$
    postData$ + "Host: "+*post_txt\ipcon$+#CRLF$
    postData$ + "Connection: close"+#CRLF$
    postData$ + "X-THINGSPEAKAPIKEY: FEGCEDL7QET8W1AJ"+#CRLF$
 postData$ +"Content-Length:"+Str(len_body)+ #CRLF$ +#CRLF$
 postData$ +SednDat$+#CRLF$
  SendNetworkString(ConnectionID, postData$, #PB_UTF8)
  ReceiveNetworkData(ConnectionID, *Buffer3, 65536)
  CloseNetworkConnection(ConnectionID)
  AddGadgetItem(11, 0, "Send: "+*post_txt\ipcon$+":"+*post_txt\portcon$+" "+tims+" : "+postData$)
  If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Send "+*post_txt\ipcon$+":"+*post_txt\portcon$+" "+tims+" : "+postData$)
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
  AddGadgetItem(11, 8, "------------------------------------------------------------")
  AddGadgetItem(11, 8, "Resive: "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
  
 If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
AddGadgetItem(11, 8, "------------------------------------------------------------") 
FreeMemory(*Buffer3)
EndIf

EndProcedure

Procedure send_tcp(*tcp_txt.txt_in_tcp)
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(*tcp_txt\ipcon$, Val(*tcp_txt\portcon$))
  If ConnectionID 
 *Buffer4 = AllocateMemory(65536)
  SendNetworkString(ConnectionID, *tcp_txt\tcp_txt2$, #PB_UTF8)
  ReceiveNetworkData(ConnectionID, *Buffer4, 65536)
  CloseNetworkConnection(ConnectionID)
AddGadgetItem(11, 0, "Send "+*tcp_txt\ipcon$+":"+*tcp_txt\portcon$+" "+tims+" : "+*tcp_txt\tcp_txt2$)
AddGadgetItem(11, 3, "------------------------------------------------------------")
If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Send "+*tcp_txt\ipcon$+":"+*tcp_txt\portcon$+" "+tims+" : "+getData$)
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
  AddGadgetItem(11, 3, "Resive "+ tims+" : "+PeekS(*Buffer4, -1, #PB_Ascii))
  AddGadgetItem(11, 3, "------------------------------------------------------------")
 If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer4, -1, #PB_Ascii))
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf 
FreeMemory(*Buffer4)
EndIf

EndProcedure


Procedure send_595(*a595_txt.txt_in_595)
  *Buffer5 = AllocateMemory(65536)
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
        ConnectionID = OpenNetworkConnection(*a595_txt\ipcon$, Val(*a595_txt\portcon$))
   If ConnectionID
     getData$ = "GET /h595/1"+*a595_txt\inf$+Str(*a595_txt\a595)+" HTTP/1.1"+#CRLF$
  getData$ + "Host:"+*a595_txt\ipcon$+#CRLF$
  getData$ + #CRLF$
  SendNetworkString(ConnectionID, getData$, #PB_UTF8)  
  ReceiveNetworkData(ConnectionID, *Buffer5, 65536)
  CloseNetworkConnection(ConnectionID)
AddGadgetItem(11, 0, "Send "+*a595_txt\ipcon$+":"+*a595_txt\portcon$+" "+tims+" : "+getData$)
AddGadgetItem(11, 3, "------------------------------------------------------------")
If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Send "+*a595_txt\ipcon$+":"+*a595_txt\portcon$+" "+tims+" : "+getData$)
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
  AddGadgetItem(11, 3, "Resive "+ tims+" : "+PeekS(*Buffer5, -1, #PB_Ascii))
  AddGadgetItem(11, 3, "------------------------------------------------------------")
 If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer5, -1, #PB_Ascii))
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf 

EndIf
FreeMemory(*Buffer5)
EndProcedure 
     
 If OpenWindow(0, 0, 0, 850, 500, "Wifi switch", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ButtonGadget(1, 10, 10, 200, 20, "Led on")
    ButtonGadget(2, 10, 40, 200, 20, "Led off")
    TextGadget(3,10,70,80,15,"Включить") ; Выводим в окно надпись "Включить".        
     ComboBoxGadget(4, 10, 100, 80, 21, #PB_ComboBox_Editable)        
     For i=0 To 7          
       AddGadgetItem(4,-1,Str(i))          
     Next i 
     SetGadgetState(4,0)
     TextGadget(5,90,70,80,15,"Отключить") ; Выводим в окно надпись "Отключить".        
     ComboBoxGadget(6, 90, 100, 80, 21, #PB_ComboBox_Editable)        
     For i=0 To 7          
       AddGadgetItem(6,-1,Str(i))          
     Next i 
     SetGadgetState(6,0)
     
     
     ButtonGadget(7, 10, 140, 80, 20, "Послать")
     ButtonGadget(8, 90, 140, 80, 20, "Послать")
     
     TextGadget(9,10,170,80,15,"IP адрес") ; Выводим в окно надпись "Отключить".        
     ComboBoxGadget(10, 90, 170, 100, 21, #PB_ComboBox_Editable)        
     For i=1 To 254          
       AddGadgetItem(10,-1,"192.168.1."+Str(i))          
     Next i 
     SetGadgetState(10,33)
     
     
     TextGadget(17,10,200,80,15,"Порт") ; Выводим в окно надпись "Отключить".        
     ComboBoxGadget(18, 90, 200, 100, 21, #PB_ComboBox_Editable)        
     For i=1 To 1000          
       AddGadgetItem(18,-1,Str(i))          
     Next i 
     SetGadgetState(18,79)
     port1.s = GetGadgetText(4) 
     port2.s= GetGadgetText(6)
     
     EditorGadget(11,220,10,610,460,#PB_String_ReadOnly)
     
     CreateStatusBar(12, WindowID(0))
   AddStatusBarField(80)
   AddStatusBarField(120)
    StringGadget(13,10,270,200,20,"")
    ButtonGadget(14,10,300,200,20, "Отправить GET")
    StringGadget(21,10,330,70,20,"api_keyName")
    StringGadget(22,82,330,140,20,"Тело для POST")
    StringGadget(19,10,360,200,20,"")
    ButtonGadget(20,10,390,200,20, "Отправить POST")
    StringGadget(15,10,420,200,20,"")
    ButtonGadget(16,10,450,200,20, "Отправить TCP")
    
  CreateThread( @DateStatusBar(),0) ; Запуск процедуры в отдельном потоке
     CreateThread(@net(),0)
     
     OpenPreferences(GetTemporaryDirectory()+"Preferences.prefs")

 
  PreferenceGroup("Global")
    SetGadgetText(18,  ReadPreferenceString("port", ""))
    SetGadgetText(10,  ReadPreferenceString("ip", ""))
    
    ClosePreferences()

    ip_con.s= GetGadgetText(10)
     *dats_txt\ipcon$=ip_con
  *a595_txt\ipcon$=ip_con
  *get_txt\ipcon$=ip_con
  *post_txt\ipcon$=ip_con
  *tcp_txt\ipcon$=ip_con
    port.s=GetGadgetText(18)
   *dats_txt\portcon$=port
  *a595_txt\portcon$=port
  *get_txt\portcon$=port
  *post_txt\portcon$=port
  *tcp_txt\portcon$=port
     Repeat
       

   
  Event=WaitWindowEvent()  
  Select Event
    Case #PB_Event_Gadget
    Select EventGadget()        
      Case 1
       
        *dats_txt\dats=0
        CreateThread(@send(),*dats_txt)

Case 2
  *dats_txt\dats=1
       CreateThread(@send(),*dats_txt)

     Case 7
       *a595_txt\inf$=port1
    *a595_txt\a595=1
  CreateThread(@send_595(),*a595_txt)    
   
 
  Case 8
    
    *a595_txt\inf$=port2
    *a595_txt\a595=0
  CreateThread(@send_595(),*a595_txt)
   


Case 4
  port1.s = GetGadgetText(4)   
Case 6
  port2.s= GetGadgetText(6)  
Case 10
  ip_con.s= GetGadgetText(10)
  If OpenPreferences(GetTemporaryDirectory()+"Preferences.prefs")
  PreferenceGroup("Global")
    WritePreferenceString("ip", ip_con)
  PreferenceComment(" This is the Window dimension")
  
  ClosePreferences()
EndIf
  *dats_txt\ipcon$=ip_con
  *a595_txt\ipcon$=ip_con
  *get_txt\ipcon$=ip_con
  *tcp_txt\ipcon$=ip_con
  *post_txt\ipcon$=ip_con
Case 13
  Get_txt.s =GetGadgetText(13)
Case 15
  TCP_txt.s= GetGadgetText(15)
  Case 19
    post_txt.s =GetGadgetText(19)
  Case 21
    post_sends.s =GetGadgetText(21)
  Case 22
    post_sends_body.s =GetGadgetText(22)
Case 14
  *get_txt\get_txt2$=Get_txt
  CreateThread(@send_get(),*get_txt)
Case 20
  *post_txt\send_post_body$=post_sends_body
  *post_txt\send_post$=post_sends
  *post_txt\post_txt2$=post_txt
  CreateThread(@send_post(),*post_txt)
Case 16
  *tcp_txt\tcp_txt2$=tcp_txt
  CreateThread(@send_tcp(),*TCP_txt)
Case 18
  port=GetGadgetText(18)
  If OpenPreferences(GetTemporaryDirectory()+"Preferences.prefs")
  PreferenceGroup("Global")
    WritePreferenceString("port", port)
  PreferenceComment(" This is the Window dimension")
  
  ClosePreferences()
EndIf
   *dats_txt\portcon$=port
  *a595_txt\portcon$=port
  *get_txt\portcon$=port
  *tcp_txt\portcon$=port
  *post_txt\portcon$=port
EndSelect



 ;If ReceiveNetworkData(ConnectionID, *Buffer, 1000)
         ;MessageRequester("Info", "String: "+PeekS(*Buffer, -1, #PB_Ascii), 0)
         ; EndIf
         
       EndSelect
       

  Until Event = #PB_Event_CloseWindow  
   
 EndIf    
End
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 172
; FirstLine = 165
; Folding = --
; EnableXP
; UseIcon = D:\fixiki\Basic\TCP_ip\icon_app\ico\main_ico.ico
; Executable = Tcp\tcp_http_v1.3.exe