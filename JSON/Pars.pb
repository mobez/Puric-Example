
;{создание
If CreateJSON(0)
  Person = SetJSONObject(JSONValue(0))
  SetJSONString(AddJSONMember(Person, "FirstName"), "John")
  SetJSONString(AddJSONMember(Person, "LastName"), "Smith")
  SetJSONInteger(AddJSONMember(Person, "Age"), 42)    
  Debug ComposeJSON(0, #PB_JSON_PrettyPrint)
  SaveJSON(0, "LinXP.txt")
EndIf
;}
Debug "        "
Debug "===================="
Debug "        "
;{распарсивание
LoadJSON(1, "LinXP.txt")
ObjectValue = JSONValue(1)
 
If ExamineJSONMembers(ObjectValue)
  While NextJSONMember(ObjectValue)              
    JSONMember.s =  JSONMemberKey(ObjectValue)
    JSONMember1.l =  JSONMemberValue(ObjectValue)      
    If JSONType(JSONMember1) = #PB_JSON_String
      wer.s = GetJSONString(JSONMember1)
    ElseIf JSONType(JSONMember1) = #PB_JSON_Number
      wer= Str(GetJSONInteger(JSONMember1))
    EndIf
    Debug JSONMember+" = "+wer.s  
  Wend
EndIf
;}
; IDE Options = PureBasic 5.31 (Windows - x64)
; Folding = -
; EnableXP