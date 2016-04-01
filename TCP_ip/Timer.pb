Procedure AlertThread() 
    Debug "Alert !" 
EndProcedure 
 
OpenWindow(0,0,0,0,0,"",#PB_Window_Invisible)
SetTimer_(WindowID(0),1,1000,@AlertThread() )
 
MessageRequester("Info", "It will display an alert every 3 seconds."+#LF$+"Click To finish the program", 0) 

; IDE Options = PureBasic 5.11 (Windows - x86)
; CursorPosition = 8
; Folding = -
; EnableXP