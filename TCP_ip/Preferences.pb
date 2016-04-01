;
; ------------------------------------------------------------
;
;   PureBasic - Preference example file
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;

;If CreatePreferences(GetTemporaryDirectory()+"Preferences.prefs")
  If OpenPreferences(GetTemporaryDirectory()+"Preferences.prefs")
  PreferenceGroup("Global")
    WritePreferenceString("ApplicationName", "MP3 Player")
    WritePreferenceString("Version", "1.1b")

  PreferenceComment(" This is the Window dimension")
  PreferenceComment("")

  PreferenceGroup("Window")
    WritePreferenceLong ("WindowX", 123)
    WritePreferenceLong ("WindowY", 124)
    WritePreferenceFloat("WindowZ", -125.5)

  ClosePreferences()
EndIf


OpenPreferences(GetTemporaryDirectory()+"Preferences.prefs")

  PreferenceGroup("Window")
    Debug ReadPreferenceLong ("WindowX", 0)
    Debug ReadPreferenceLong ("WindowY", 0)
    Debug ReadPreferenceFloat("WindowZ", 0)
    
  PreferenceGroup("Global")
    Debug ReadPreferenceString("ApplicationName", "")
    Debug ReadPreferenceString("Version", "")
    
    ClosePreferences()
    
    If OpenWindow(0, 0, 0, 440, 380, "Wifi switch", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  top=10 : is=200
    TextGadget(0,10,top,is,15,"Управление комнатой", #PB_Text_Center) :top+30
    ButtonGadget(1, 10, top,is, 20, "Отправить флюрографию") :top+30
    ButtonGadget(2, 10, top,is, 20, "Возвратить флюрографию") :top+50
     ButtonGadget(3, 10, top,is, 20, "Эмуляция таблицы дальтоников") :top+50
     ButtonGadget(4, 10, top,is, 20, "Открыть дверь") :top+30
     ButtonGadget(5, 10, top,is, 20, "Открыть люк") :top+30
     
    top=10 : is=200
    TextGadget(6,230,top,is,15,"Звуковое сопровождение", #PB_Text_Center) :top+30
    ButtonGadget(7, 230, top,is, 20, "Темница") :top+30
    ButtonGadget(8, 230, top,is, 20, "Кабинет врача") :top+30
     ButtonGadget(9, 230, top,is, 20, "Лифт") :top+30
     ButtonGadget(10, 230, top,is, 20, "Коридор") :top+40
     TextGadget(13,230,top,is,15,"Громкость : 100%", #PB_Text_Center) :top+20
     TrackBarGadget  (14,  230, top,is,20, 0, 100):top+30
     TextGadget(16,230,top,is,15,"", #PB_Text_Center) :top+20
     TextGadget(17,230,top,is,15,"", #PB_Text_Center) :top+20
     ProgressBarGadget(15,  230, top,is,10, 0, 1000):top+30
     ButtonGadget(11, 230, top,is, 20, "Стоп") :top+30
     
     
SetGadgetColor(2, #PB_Gadget_BackColor, $00FFFF)
     SetGadgetColor(3, #PB_Gadget_BackColor, $00FF00)
   
   CreateStatusBar(12, WindowID(0))
   AddStatusBarField(80)
   AddStatusBarField(60)
   AddStatusBarField(80)
   
    
  CreateThread( @DateStatusBar(),0) ; Запуск процедуры в отдельном потоке
     CreateThread(@net(),0)
     
   *tcp_txt\portcon$="9999"  
   *tcp_txt\ipcon$="192.168.4.1"
   mp3_file.s="" 
   mp3_txt.s=""
   SetGadgetState(14, 100)
   q=0
     Repeat
       If q=1
       Result.q = MovieStatus(0)
       If result>0 Or result<0
         ;volue_info = MovieInfo(0,0)
    ;SetGadgetText(17, Str(volue_info))
         SetGadgetText(17, Str(result))
         SetGadgetState(15, result)
       Else
        SetGadgetState(15, 0) 
         EndIf
   EndIf
  Event=WaitWindowEvent()  
  Select Event
    Case #PB_Event_Gadget
    Select EventGadget()        
      Case 1
       *tcp_txt\tcp_txt2$="d"
       CreateThread(@send_tcp(),*tcp_txt)
       MessageRequester("Флюрография", "Флюрография отправлена", 0)
       Case 2
       *tcp_txt\tcp_txt2$="u"
       CreateThread(@send_tcp(),*tcp_txt)
       MessageRequester("Флюрография", "Флюрография сейчас будет возвращена", 0)
       Case 3
       *tcp_txt\tcp_txt2$="on"
       CreateThread(@send_tcp(),*tcp_txt)
       MessageRequester("Флюрография", "Таблица сработала", 0)
       Case 4
       *tcp_txt\tcp_txt2$="D"
       CreateThread(@send_tcp(),*tcp_txt)
       MessageRequester("Флюрография", "Дверь открыта", 0)
       Case 5
       *tcp_txt\tcp_txt2$="H"
       CreateThread(@send_tcp(),*tcp_txt)
       MessageRequester("Флюрография", "Люк открыт", 0)
     Case 7
       mp3_name.s="Темница"
       mp3_txt="d:\лифт\temn.mp3" 
       play_mp3(mp3_txt , mp3_name) 
     Case 8
       mp3_name.s="Кабинет врача"
       mp3_txt="d:\лифт\кабинет врача.mp3" 
       play_mp3(mp3_txt , mp3_name) 
     Case 9
       mp3_name.s="Лифт"
       mp3_txt="d:\лифт\лифт.mp3" 
       play_mp3(mp3_txt , mp3_name) 
     Case 10
       mp3_name.s="Коридор"
       mp3_txt="d:\лифт\коридор.mp3" 
       play_mp3(mp3_txt , mp3_name) 
       Case 11
         stop_mp3()
       Case 14         
         volume= GetGadgetState(14) 
         SetGadgetText(13, "Громкость : "+Str(volume)+"%")
         MovieAudio(0, volume, 0)
         
EndSelect



 ;If ReceiveNetworkData(ConnectionID, *Buffer, 1000)
         ;MessageRequester("Info", "String: "+PeekS(*Buffer, -1, #PB_Ascii), 0)
         ; EndIf
         
       EndSelect
       

  Until Event = #PB_Event_CloseWindow  
   
 EndIf    
End

; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 155
; FirstLine = 43
; EnableXP
; Executable = ..\Desktop\exeС€РЅРёРєРё\prefer.exe