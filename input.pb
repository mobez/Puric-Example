Input$ = InputRequester("Title", "Please make your input:", "I'm the default input.")

  If Input$ > ""
    a$ = "You entered in the requester:" + Chr(10)  ; Chr(10) only needed
    a$ + Input$                                                  ; for line-feed
  Else  
    a$ = "The requester was canceled or there was nothing entered."
  EndIf
  MessageRequester("Information", a$, 0)
Debug CountString("How many 'ow' contains Bow ?", "ow") ; will display 3

; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 10
; EnableXP