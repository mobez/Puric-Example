Procedure md5()
  *Buffer = AllocateMemory(500)    
  If *Buffer
    ;PokeS(*Buffer, "The quick brown fox jumps over the lazy dog.")
    PokeS(*Buffer, GetGadgetText(1))
    MD5$ = MD5Fingerprint(*Buffer, MemorySize(*Buffer))
    SetGadgetText(2,MD5$)
    FreeMemory(*Buffer)  ; would also be done automatically at the end of the program
  EndIf
EndProcedure



If OpenWindow(0, 0, 0, 410, 60, "MD5 генератор", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
StringGadget(1, 5,  10, 400, 20, "Введите пароль")

StringGadget(2, 5,  30, 400, 20, "MD5", #PB_String_ReadOnly)

  
  Repeat
       

   
  Event=WaitWindowEvent()  
  Select Event
    Case #PB_Event_Gadget
    Select EventGadget() 
      Case 1
        md5()
  
  
  EndSelect



 ;If ReceiveNetworkData(ConnectionID, *Buffer, 1000)
         ;MessageRequester("Info", "String: "+PeekS(*Buffer, -1, #PB_Ascii), 0)
         ; EndIf
         
       EndSelect
 Until Event = #PB_Event_CloseWindow  
   
 EndIf    
End
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 13
; Folding = -
; EnableXP
; Executable = ..\..\Users\Admin\Desktop\exeС€РЅРёРєРё\MD5 РіРµРЅРµСЂР°С‚РѕСЂ.exe