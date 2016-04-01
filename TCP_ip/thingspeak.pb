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

If InitNetwork()
EndIf
Global send_data2
Global api_key.s
Global command_string.s
Global command_string_up.s
Global ip_addr.s="api.thingspeak.com"
Global Port=80
Global TalkBack_ID=4378
Global Position=0
Global Command_ID.s
Global addr.s
Global post_txt.s
;Global port1.s  
;Global port2.s

;Global ConnectionID
;Global getData$
;Global dat.s
;Global q
Structure txt_in_get
  get_txt2$
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
    StatusBarText(12, 0,Time)                   ; Выводим его на строку состояния
    Delay(1000)
  ForEver
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
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Send "+*dats_txt\ipcon$+":"+*dats_txt\portcon$+" "+tims+" : "+getData$)
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(11, 3, "Resive "+ tims+" : "+PeekS(*Buffer1, -1, #PB_Ascii))
    AddGadgetItem(11,3, "------------------------------------------------------------")
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
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
  ConnectionID = OpenNetworkConnection(ip_addr, Port)
  If ConnectionID 
    *Buffer2 = AllocateMemory(65536)
    getData$ = "GET /"+*get_txt\get_txt2$+" HTTP/1.1"+#CRLF$
    getData$ + "Host:"+ip_addr+#CRLF$
    getData$ + #CRLF$
    SendNetworkString(ConnectionID, getData$, #PB_UTF8)
    ReceiveNetworkData(ConnectionID, *Buffer2, 65536)
    CloseNetworkConnection(ConnectionID)
    AddGadgetItem(1, 0, "Send: "+ip_addr+":"+Port+" "+tims+" : "+getData$)
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Send "+ip_addr+":"+Port+" "+tims+" : "+getData$)
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 3, "------------------------------------------------------------")
    AddGadgetItem(1, 3, "Resive: "+ tims+" : "+PeekS(*Buffer2, -1, #PB_UTF8 ))
    
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer2, -1, #PB_UTF8 ))
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 3, "------------------------------------------------------------") 
    FreeMemory(*Buffer2)
  EndIf
  
EndProcedure

Procedure send_post(*post_txt.txt_in_post)
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(ip_addr, Port)
  If ConnectionID 
    *Buffer3 = AllocateMemory(65536)
    SednDat$="api_key="+api_key
    SednDat$+"&command_string="+command_string+"&position="+Position
    len_body=Len(SednDat$)    
    postData$ = "POST /"+*post_txt\post_txt2$+" HTTP/1.1"+#CRLF$
    postData$ + "Host: "+ip_addr+#CRLF$
    postData$ + "Connection: close"+#CRLF$
    postData$ + "X-THINGSPEAKAPIKEY: FEGCEDL7QET8W1AJ"+#CRLF$
    postData$ +"Content-Length:"+Str(len_body)+ #CRLF$ +#CRLF$
    postData$ +SednDat$+#CRLF$
    SendNetworkString(ConnectionID, postData$, #PB_UTF8)
    ReceiveNetworkData(ConnectionID, *Buffer3, 65536)
    CloseNetworkConnection(ConnectionID)
    AddGadgetItem(1, 0, "Send: "+ip_addr+":"+Port+" "+tims+" : "+postData$)
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Send "+ip_addr+":"+Port+" "+tims+" : "+postData$)
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 8, "------------------------------------------------------------")
    AddGadgetItem(1, 8, "Resive: "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
    
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 8, "------------------------------------------------------------") 
    FreeMemory(*Buffer3)
  EndIf
  
EndProcedure

Procedure send_put(*x)
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(ip_addr, Port)
  If ConnectionID 
    *Buffer3 = AllocateMemory(65536)
    SednDat$="api_key="+api_key
    SednDat$+"&command_string="+command_string_up+"&position="+Position
    len_body=Len(SednDat$)    
    postData$ = "PUT /talkbacks/"+addr+"/commands/"+Command_ID+".json"+" HTTP/1.1"+#CRLF$
    postData$ + "Host: "+ip_addr+#CRLF$
    postData$ + "Connection: close"+#CRLF$
    postData$ + "X-THINGSPEAKAPIKEY: FEGCEDL7QET8W1AJ"+#CRLF$
    postData$ +"Content-Length:"+Str(len_body)+ #CRLF$ +#CRLF$
    postData$ +SednDat$+#CRLF$+#CRLF$
    SendNetworkString(ConnectionID, postData$, #PB_UTF8)
    ReceiveNetworkData(ConnectionID, *Buffer3, 65536)
    CloseNetworkConnection(ConnectionID)
    AddGadgetItem(1, 0, "Send: "+ip_addr+":"+Port+" "+tims+" : "+postData$)
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Send "+ip_addr+":"+Port+" "+tims+" : "+postData$)
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 8, "------------------------------------------------------------")
    AddGadgetItem(1, 8, "Resive: "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
    
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 8, "------------------------------------------------------------") 
    FreeMemory(*Buffer3)
  EndIf
  
EndProcedure

Procedure send_delete_all(*x)
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(ip_addr, Port)
  If ConnectionID 
    *Buffer3 = AllocateMemory(65536)
    SednDat$="api_key="+api_key
    len_body=Len(SednDat$)    
    postData$ = "DELETE /talkbacks/"+addr+"/commands HTTP/1.1"+#CRLF$
    postData$ + "Host: "+ip_addr+#CRLF$
    postData$ + "Connection: close"+#CRLF$
    postData$ + "X-THINGSPEAKAPIKEY: FEGCEDL7QET8W1AJ"+#CRLF$
    postData$ +"Content-Length:"+Str(len_body)+ #CRLF$ +#CRLF$
    postData$ +SednDat$+#CRLF$
    SendNetworkString(ConnectionID, postData$, #PB_UTF8)
    ReceiveNetworkData(ConnectionID, *Buffer3, 65536)
    CloseNetworkConnection(ConnectionID)
    AddGadgetItem(1, 0, "Send: "+ip_addr+":"+Port+" "+tims+" : "+postData$)
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Send "+ip_addr+":"+Port+" "+tims+" : "+postData$)
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 8, "------------------------------------------------------------")
    AddGadgetItem(1, 8, "Resive: "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
    
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 8, "------------------------------------------------------------") 
    FreeMemory(*Buffer3)
  EndIf
  
EndProcedure

Procedure send_delete(*x)
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(ip_addr, Port)
  If ConnectionID 
    *Buffer3 = AllocateMemory(65536)
    SednDat$="api_key="+api_key
    len_body=Len(SednDat$)    
    postData$ = "DELETE /talkbacks/"+addr+"/commands/"+Command_ID+" HTTP/1.1"+#CRLF$
    postData$ + "Host: "+ip_addr+#CRLF$
    postData$ + "Connection: close"+#CRLF$
    postData$ + "X-THINGSPEAKAPIKEY: FEGCEDL7QET8W1AJ"+#CRLF$
    postData$ +"Content-Length:"+Str(len_body)+ #CRLF$ +#CRLF$
    postData$ +SednDat$+#CRLF$
    SendNetworkString(ConnectionID, postData$, #PB_UTF8)
    ReceiveNetworkData(ConnectionID, *Buffer3, 65536)
    CloseNetworkConnection(ConnectionID)
    AddGadgetItem(1, 0, "Send: "+ip_addr+":"+Port+" "+tims+" : "+postData$)
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Send "+ip_addr+":"+Port+" "+tims+" : "+postData$)
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 8, "------------------------------------------------------------")
    AddGadgetItem(1, 8, "Resive: "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
    
    If OpenFile(0, "log_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                   ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer3, -1, #PB_Ascii))
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    AddGadgetItem(1, 8, "------------------------------------------------------------") 
    FreeMemory(*Buffer3)
  EndIf
  
EndProcedure

If OpenWindow(0, 0, 0, 850, 500, "Wifi switch", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CreateStatusBar(12, WindowID(0))
  AddStatusBarField(80)
  AddStatusBarField(120)
  top=10 : is=200
  EditorGadget(1,220,10,610,460,#PB_String_ReadOnly)
  top=10 : is=10    
  StringGadget(2,top,is,200,20,""):  is+30   ; Строка GET запроса
  ButtonGadget(3,top,is,200,20, "Отправить GET"):  is+30
  StringGadget(4,top,is,140,20,"api_keyName"):top+150:StringGadget(5,top,is,50,20,"Позиция") :  is+30:top=10 ; Общий Api для POST, PUT, DELET
  StringGadget(6,top,is,200,20,"Данные"):  is+30
  StringGadget(7,top,is,200,20,"Адрес для запроса"):  is+30
  ButtonGadget(8,top,is,200,20, "Отправить POST"):  is+30
  StringGadget(9,top,is,140,20,"Command_ID"):top+150:StringGadget(11,top,is,50,20,"Позиция") :  is+30:top=10
  StringGadget(12,top,is,200,20,"Данные"):  is+30
  StringGadget(10,top,is,200,20,"Поток"):  is+30
  ButtonGadget(13,top,is,200,20, "Отправить PUT"):  is+30
  ButtonGadget(14,top,is,200,20, "Отправить DELETE"):  is+30
  ButtonGadget(15,top,is,200,20, "DELETE ALL")
  
  CreateThread( @DateStatusBar(),0) ; Запуск процедуры в отдельном потоке
  
  Define pass.s = GetTemporaryDirectory() +"configp_talk.cfg"   
  If FileSize(pass) <= 0
    If CreatePreferences(pass)
      PreferenceGroup("Global")
      WritePreferenceString("Api_key", "FEGCEDL7QET8W1AJ")
      WritePreferenceString("TalkBack_ID", "4378")
      WritePreferenceString("Post", "talkbacks/4378/commands")
      WritePreferenceString("get", "talkbacks/4378/commands?api_key=FEGCEDL7QET8W1AJ")
      ClosePreferences()
    EndIf
  EndIf
  If OpenPreferences(pass)
    PreferenceGroup("Global")
    api_key= ReadPreferenceString("Api_key", "")
    addr= ReadPreferenceString("TalkBack_ID", "")
    post_txt=ReadPreferenceString("Post", "")
    Get_txt.s=ReadPreferenceString("get", "")
    ClosePreferences()
  EndIf
  SetGadgetText(4,api_key):SetGadgetText(10,addr):SetGadgetText(7,post_txt):SetGadgetText(2,Get_txt)
  Repeat
    Event=WaitWindowEvent()  
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()  
          Case 2
            Get_txt.s =GetGadgetText(2)
            If OpenPreferences(pass)
              PreferenceGroup("Global")
              WritePreferenceString("Post", Get_txt)
              ClosePreferences()
            EndIf
          Case 7
            post_txt =GetGadgetText(7)
            If CreatePreferences(pass)
              PreferenceGroup("Global")
              WritePreferenceString("Post", post_txt)
              ClosePreferences()
            EndIf
          Case 10
            addr =GetGadgetText(10)
            If CreatePreferences(pass)
              PreferenceGroup("Global")
              WritePreferenceString("TalkBack_ID", addr)
              ClosePreferences()
            EndIf
          Case 4
            api_key =GetGadgetText(4)
            If CreatePreferences(pass)
              PreferenceGroup("Global")
              WritePreferenceString("Api_key", api_key)
              ClosePreferences()
            EndIf
          Case 6 
            command_string =GetGadgetText(6)
          Case 12 
            command_string_up =GetGadgetText(12)            
          Case 5
            Position =Val(GetGadgetText(5)) : SetGadgetText(11,GetGadgetText(5))
          Case 11
            Position =Val(GetGadgetText(11)) : SetGadgetText(5,GetGadgetText(11))
          Case 9 
            Command_ID =GetGadgetText(9)            
          Case 3
            *get_txt\get_txt2$=Get_txt            
            CreateThread(@send_get(),*get_txt)
          Case 8
            *post_txt\send_post_body$=command_string
            *post_txt\send_post$=api_key
            *post_txt\post_txt2$=post_txt
            CreateThread(@send_post(),*post_txt)
          Case 13            
            CreateThread(@send_put(),0)
          Case 15           
            CreateThread(@send_delete_all(),0)
          Case 14          
            CreateThread(@send_delete(),0)
        EndSelect
        
        
        
        ;If ReceiveNetworkData(ConnectionID, *Buffer, 1000)
        ;MessageRequester("Info", "String: "+PeekS(*Buffer, -1, #PB_Ascii), 0)
        ; EndIf
        
    EndSelect
    
    
  Until Event = #PB_Event_CloseWindow   
EndIf    
End
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 216
; FirstLine = 200
; Folding = --
; EnableUnicode
; EnableXP
; UseIcon = D:\fixiki\Basic\TCP_ip\icon_app\ico\TalkBack.ico
; Executable = Tcp\Talk Back.exe