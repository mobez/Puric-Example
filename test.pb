Global Button_0
EnableExplicit
 
UseSQLiteDatabase()
 
#AdressDB = 0
#frm_Main = 0
 
Enumeration ; Gadgets
  #gad_Panel
  #gad_ListAnschrift
  #gad_Container
  #gad_strName
  #gad_strVorname
  #gad_strStrasse
  #gad_strPLZ
  #gad_strOrt
  #gad_strTelefon
  #gad_btnHinzufuegen
  #gad_btnAendern
  #gad_btnLoeschen
  #gad_btnSortieren
  #Button_0
  #Button_1
  #Window_1
EndEnumeration
Declare CreateFormMain()
Declare DatenSatzHinzufuegen()
Declare DatenSatzAendern()
Declare DatenSatzLoeschen()
Declare ListFuellen()
 
Define db_name.s = GetTemporaryDirectory() + "Adr.db"
Define SQL.s
 
; �� ��������� , ���������� �� ���DB , ���� ���,����� DB ������ .
If FileSize(db_name) <= 0
  If CreateFile(0, db_name)
    CloseFile(0)
    If OpenDatabase(#AdressDB, db_name, "", "")
      ; �� ������� ������ ������� , ������������ SQL :
      ; " CREATE TABLE table_name ( ��� ���� [��� ] ���_���� [ TYPE] , ...) " ��������
      ; ��� ���� , ��� �������, ������������� �� SQLite, ��� ��� �� , ��� �������, �������� ��� ����.
      ; ����������� �� ����� ������� ������������������ ������������� �BLOB. ��� ������ ���� INTEGER, ��� BLOB
      ; ��������� ��� ���� ID : ���_���� INTEGER PRIMARY KEY AUTOINCREMENT
      ; �������������, �������������� SQL ��������� �� ��������� �����.
      SQL = "CREATE TABLE adressen (id INTEGER PRIMARY KEY AUTOINCREMENT,"
      SQL + " name, vorname, strasse, plz, ort, telefon, notizen, fotodata BLOB, fotosize INTEGER)"
      
      ; ���� �� ����� ��������� , �� ����������: ���������� ���� ������ (ID , SQL ���������)
      ; � ��������� ������ ������� ���� ������ ( ID , SQL ��������� ), ������� �� ������ �����.
      If DatabaseUpdate(#AdressDB, SQL) = #False
        Debug DatabaseError()
        End
      EndIf
    Else
      Debug DatabaseError()
      End
    EndIf
  Else
    Debug db_name + " �� ����� ���� ������."
    End
  EndIf
Else ; ���� ������ ��� ���������� � ������.
  If OpenDatabase(#AdressDB, db_name, "", "") = #False
    Debug DatabaseError()
    End
  EndIf
EndIf
 
; ����� ���� ��� �� ������� ���� ���� ������ (���� �� ������ ��� ��� � ���������� )
; �� ������� ������ ������� ����
 
CreateFormMain()
 
Define i
 
; ������ ���� ListIconGadget ����������� �������
ListFuellen()
 
; ��� � ���������� ���� MainLoop .
Repeat
  Select WaitWindowEvent()
  
    Case #PB_Event_CloseWindow
      CloseDatabase(#AdressDB)
      Break
      
    Case #PB_Event_Gadget
      Select EventGadget()
 
        Case #gad_ListAnschrift
          Select EventType()
            Case #PB_EventType_Change
              i = GetGadgetState(#gad_ListAnschrift)
              If i > -1
                SetGadgetText(#gad_strName, GetGadgetItemText(#gad_ListAnschrift, i, 1))
                SetGadgetText(#gad_strVorname, GetGadgetItemText(#gad_ListAnschrift, i, 2))
                SetGadgetText(#gad_strStrasse, GetGadgetItemText(#gad_ListAnschrift, i, 3))
                SetGadgetText(#gad_strPLZ, GetGadgetItemText(#gad_ListAnschrift, i, 4))
                SetGadgetText(#gad_strOrt, GetGadgetItemText(#gad_ListAnschrift, i, 5))
                SetGadgetText(#gad_strTelefon, GetGadgetItemText(#gad_ListAnschrift, i, 6))
              Else
                SetGadgetText(#gad_strName, "")
                SetGadgetText(#gad_strVorname, "")
                SetGadgetText(#gad_strStrasse, "")
                SetGadgetText(#gad_strPLZ, "")
                SetGadgetText(#gad_strOrt, "")
                SetGadgetText(#gad_strTelefon, "")                
              EndIf
          EndSelect
        Case #gad_btnHinzufuegen ; �������� ������
          DatenSatzHinzufuegen()
        
        Case #gad_btnAendern
          If GetGadgetState(#gad_ListAnschrift)  > -1
            DatenSatzAendern()
          Else
            MessageRequester("SQLite �������", "����������, ��������  ������ ��� ���������� !")
          EndIf
          
        Case #gad_btnLoeschen
          If GetGadgetState(#gad_ListAnschrift)  > -1
            DatenSatzLoeschen()
          Else
            MessageRequester("SQLite �������", "����������, ��������  ������ ��� �������� !")
          EndIf 
          
        Case #gad_btnSortieren
          ListFuellen()
      EndSelect
  EndSelect
ForEver
End
 
Procedure ListFuellen()
  ; ������ ��� ListIconGadget ����������� �������
  ; ��� ���� ������������� SQL SELECT ����� ���������������. * ������������� ���� � ����� �� ����������� �������
  ; ORDER BY ��� ���� ������������ ���������� !
  Protected itemtext.s, i
  
  ClearGadgetItems(#gad_ListAnschrift)
  
  If DatabaseQuery(#AdressDB, "SELECT * FROM adressen ORDER BY name")
    While NextDatabaseRow(#AdressDB)
      itemtext = GetDatabaseString(#AdressDB, 0) ; ��� ������� ���������� �������������,
      For i = 1 To 6 ; ��� � ������� !
        itemtext + #LF$ + GetDatabaseString(#AdressDB, i)
      Next
      AddGadgetItem(#gad_ListAnschrift, -1, itemtext)
    Wend
    FinishDatabaseQuery(#AdressDB); ��� ������� ������ ����������� ��� ������� !
  Else
    Debug DatabaseError()
  EndIf
EndProcedure
 
Procedure DatenSatzHinzufuegen()
  Protected.s SQL, id, name, vorname, strasse, plz, ort, telefon, itemtext
  
  name = GetGadgetText(#gad_strName)
  vorname = GetGadgetText(#gad_strVorname)
  strasse = GetGadgetText(#gad_strStrasse)
  plz = GetGadgetText(#gad_strPLZ)
  ort = GetGadgetText(#gad_strOrt)
  telefon = GetGadgetText(#gad_strTelefon)
  
  ; ������������ SQL : " INSERT INTO ... " �������� !
  SQL = "INSERT INTO adressen (name, vorname, strasse, plz, ort, telefon) "
  SQL + "VALUES ('"
  SQL + name + "','"
  SQL + vorname + "','"
  SQL + strasse + "','"
  SQL + plz + "','"
  SQL + ort + "','"
  SQL + telefon + "')"
  
  If DatabaseUpdate(#AdressDB, SQL) ; ������� � �� .
    ; ������ ��� ����� ������������� ��������� ������������� , ����� ������ ��� � ����� ������
    If DatabaseQuery(#AdressDB, "SELECT last_insert_rowid()")
      NextDatabaseRow(#AdressDB)
      id = GetDatabaseString(#AdressDB, 0)
      FinishDatabaseQuery(#AdressDB)
      
      itemtext = id + #LF$ + name + #LF$ + vorname + #LF$ + strasse + #LF$ + plz + #LF$ + ort + #LF$ + telefon
      AddGadgetItem(#gad_ListAnschrift, -1, itemtext)
    EndIf
  Else
    Debug DatabaseError()
  EndIf
EndProcedure
 
Procedure DatenSatzAendern()
  Protected.s SQL, id, name, vorname, strasse, plz, ort, telefon, itemtext
  Protected item
  
  name = GetGadgetText(#gad_strName)
  vorname = GetGadgetText(#gad_strVorname)
  strasse = GetGadgetText(#gad_strStrasse)
  plz = GetGadgetText(#gad_strPLZ)
  ort = GetGadgetText(#gad_strOrt)
  telefon = GetGadgetText(#gad_strTelefon)
  
  ; ���������� ID ��������� ������
  item = GetGadgetState(#gad_ListAnschrift)
  id = GetGadgetItemText(#gad_ListAnschrift, item, 0)
 
  ; ����� �������� , �� ���������� SQL ���������: " UPDATE table_name SET "
  SQL = "UPDATE adressen SET "
  SQL + "name = '" + name + "',"
  SQL + "vorname = '" + vorname + "',"
  SQL + "strasse = '" + strasse + "',"
  SQL + "plz = '" + plz + "',"
  SQL + "ort = '" + ort + "',"
  SQL + "telefon = '" + telefon + "' "
  SQL + "WHERE id = " + id
 
  If DatabaseUpdate(#AdressDB, SQL) = #False
    Debug DatabaseError()
  Else
    SetGadgetItemText(#gad_ListAnschrift, item, name, 1)
    SetGadgetItemText(#gad_ListAnschrift, item, vorname, 2)
    SetGadgetItemText(#gad_ListAnschrift, item, strasse, 3)
    SetGadgetItemText(#gad_ListAnschrift, item, plz, 4)
    SetGadgetItemText(#gad_ListAnschrift, item, ort, 5)
    SetGadgetItemText(#gad_ListAnschrift, item, telefon, 6)
  EndIf
EndProcedure
 
Procedure DatenSatzLoeschen()
  Protected.s SQL, id
  Protected item
  
  item = GetGadgetState(#gad_ListAnschrift)
  id = GetGadgetItemText(#gad_ListAnschrift, item, 0)
  SQL = "DELETE FROM adressen WHERE id = " + id
  
  If DatabaseUpdate(#AdressDB, SQL) = #False
    Debug DatabaseError()
  Else
    RemoveGadgetItem(#gad_ListAnschrift, item)
  EndIf
EndProcedure
 
Procedure CreateFormMain()
  Protected ListIconFlags = #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    ListIconFlags | #PB_ListIcon_AlwaysShowSelection
  CompilerEndIf
  OpenWindow(0,200,305,640,416,"����",#PB_Window_SystemMenu| #PB_Window_MinimizeGadget| #PB_Window_MaximizeGadget) 
  SetWindowColor(0, RGB(37,162,254))
  PanelGadget(#gad_Panel, 0, 0, 640, 415)
  AddGadgetItem(#gad_Panel, -1, "��������")
  
 
      ListIconGadget(#gad_ListAnschrift, 5, 5, GetGadgetAttribute(#gad_Panel, #PB_Panel_ItemWidth) - 10, GetGadgetAttribute(#gad_Panel, #PB_Panel_ItemHeight) - 10, "id", 1, ListIconFlags)
      ; ������ ������� ��������� ���������� ������������� � �� ����� !
      AddGadgetColumn(#gad_ListAnschrift, 1, "���", 95)
      AddGadgetColumn(#gad_ListAnschrift, 2, "�������", 95)
      AddGadgetColumn(#gad_ListAnschrift, 3, "�����", 160)
      AddGadgetColumn(#gad_ListAnschrift, 4, "���", 45)
      AddGadgetColumn(#gad_ListAnschrift, 5, "�����", 125)
      AddGadgetColumn(#gad_ListAnschrift, 6, "�������", 90)
      CloseGadgetList()
      ;***************************************************************************
      
      OpenWindow(1,200,200,640,80,"Dialogfenster",#PB_Window_SystemMenu| #PB_Window_MinimizeGadget| #PB_Window_MaximizeGadget) 
     
  ContainerGadget(#gad_Container, 5, 20, 630, 60)
  StringGadget(#gad_strName, 5, 0, 95, 25, "")
  SetGadgetColor(#gad_strName, #PB_Gadget_FrontColor,RGB(0,0,255))
  SetGadgetColor(#gad_strName, #PB_Gadget_BackColor,RGB(242,252,186))
 
  StringGadget(#gad_strVorname, 100, 0, 95, 25, "")
  StringGadget(#gad_strStrasse, 195, 0, 160, 25, "")
  StringGadget(#gad_strPLZ, 355, 0, 45, 25, "")
  StringGadget(#gad_strOrt, 400, 0, 125, 25, "")
  StringGadget(#gad_strTelefon, 525, 0, 95, 25, "")
  ButtonGadget(#gad_btnHinzufuegen, 5, 30, 100, 25, "��������")
  ButtonGadget(#gad_btnAendern, 115, 30, 80, 25, "��������")
  ButtonGadget(#gad_btnLoeschen, 205, 30, 80, 25, "�������")
  ButtonGadget(#gad_btnSortieren, 540, 30, 80, 25, "�����������")
  CloseGadgetList()
 
EndProcedure
End
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 285
; FirstLine = 251
; Folding = -
; EnableXP