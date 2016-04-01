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
 
Define db_name.s = GetTemporaryDirectory() +"ar\Adr1.sqlite"
Define SQL.s
 
; �� ��������� , ���������� �� ���DB , ���� ���,����� DB ������ .
If FileSize(db_name) <= 0
  If CreateFile(0, db_name)
    CloseFile(0)
    If OpenDatabase(#AdressDB, db_name, "", "", #PB_Database_SQLite)
      ; �� ������� ������ ������� , ������������ SQL :
      ; " CREATE TABLE table_name ( ��� ���� [��� ] ���_���� [ TYPE] , ...) " ��������
      ; ��� ���� , ��� �������, ������������� �� SQLite, ��� ��� �� , ��� �������, �������� ��� ����.
      ; ����������� �� ����� ������� ������������������ ������������� �BLOB. ��� ������ ���� INTEGER, ��� BLOB
      ; ��������� ��� ���� ID : ���_���� INTEGER PRIMARY KEY AUTOINCREMENT
      ; �������������, �������������� SQL ��������� �� ��������� �����.
      SQL = "CREATE TABLE adressen (id INTEGER PRIMARY KEY AUTOINCREMENT,"
      SQL + " day, nachalo, konech, vrem, notizen, fotodata BLOB, fotosize INTEGER)"
      
      ; ���� �� ����� ��������� , �� ����������: ���������� ���� ������ (ID , SQL ���������)
      ; � ��������� ������ ������� ���� ������ ( ID , SQL ��������� ), ������� �� ������ �����.
      If DatabaseUpdate(#AdressDB, SQL) = #False
        Debug DatabaseError()+"1"
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
  If OpenDatabase(#AdressDB, db_name, "", "",#PB_Database_SQLite) = #False
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
              Else
                SetGadgetText(#gad_strName, "")
                SetGadgetText(#gad_strVorname, "")
                SetGadgetText(#gad_strStrasse, "")
                SetGadgetText(#gad_strPLZ, "")              
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
  
  If DatabaseQuery(#AdressDB, "SELECT * FROM adressen ORDER BY day")
    While NextDatabaseRow(#AdressDB)
      itemtext = GetDatabaseString(#AdressDB, 0) ; ��� ������� ���������� �������������,
      For i = 1 To 4 ; ��� � ������� !
        itemtext + #LF$ + GetDatabaseString(#AdressDB, i)
      Next
      AddGadgetItem(#gad_ListAnschrift, -1, itemtext)
    Wend
    FinishDatabaseQuery(#AdressDB); ��� ������� ������ ����������� ��� ������� !
  Else
    Debug DatabaseError()+"2"
  EndIf
EndProcedure
 
Procedure DatenSatzHinzufuegen()
  Protected.s SQL, id, day, nachalo, konech, vrem, ort, telefon, itemtext
  
  day = GetGadgetText(#gad_strName)
  nachalo = GetGadgetText(#gad_strVorname)
  konech= GetGadgetText(#gad_strStrasse)
  vrem = GetGadgetText(#gad_strPLZ)
  
  ; ������������ SQL : " INSERT INTO ... " �������� !
  SQL = "INSERT INTO adressen (day, nachalo, konech, vrem) "
  SQL + "VALUES ('"
  SQL + day + "','"
  SQL + nachalo + "','"
  SQL + konech + "','"
  SQL + vrem +  "')"
  
  If DatabaseUpdate(#AdressDB, SQL) ; ������� � �� .
    ; ������ ��� ����� ������������� ��������� ������������� , ����� ������ ��� � ����� ������
    If DatabaseQuery(#AdressDB, "SELECT last_insert_rowid()")
      NextDatabaseRow(#AdressDB)
      id = GetDatabaseString(#AdressDB, 0)
      FinishDatabaseQuery(#AdressDB)
      
      itemtext = id + #LF$ + day + #LF$ + nachalo + #LF$ + konech + #LF$ + vrem 
      AddGadgetItem(#gad_ListAnschrift, -1, itemtext)
    EndIf
  Else
    Debug DatabaseError()+" 3"
  EndIf
EndProcedure
 
Procedure DatenSatzAendern()
  Protected.s SQL, id, day, nachalo, konech, vrem, ort, telefon, itemtext
  Protected item
  
  day = GetGadgetText(#gad_strName)
  nachalo = GetGadgetText(#gad_strVorname)
  konech = GetGadgetText(#gad_strStrasse)
  vrem = GetGadgetText(#gad_strPLZ)
  ; ���������� ID ��������� ������
  item = GetGadgetState(#gad_ListAnschrift)
  id = GetGadgetItemText(#gad_ListAnschrift, item, 0)
 
  ; ����� �������� , �� ���������� SQL ���������: " UPDATE table_name SET "
  SQL = "UPDATE adressen SET "
  SQL + "day = '" + day + "',"
  SQL + "nachalo = '" + nachalo + "',"
  SQL + "konech = '" + konech + "',"
  SQL + "vrem = '" + vrem + "'"
  SQL + "WHERE id = " + id
 
  If DatabaseUpdate(#AdressDB, SQL) = #False
    Debug DatabaseError()+ "4"
  Else
    SetGadgetItemText(#gad_ListAnschrift, item, day, 1)
    SetGadgetItemText(#gad_ListAnschrift, item, nachalo, 2)
    SetGadgetItemText(#gad_ListAnschrift, item, konech, 3)
    SetGadgetItemText(#gad_ListAnschrift, item, vrem, 4)
  EndIf
EndProcedure
 
Procedure DatenSatzLoeschen()
  Protected.s SQL, id
  Protected item
  
  item = GetGadgetState(#gad_ListAnschrift)
  id = GetGadgetItemText(#gad_ListAnschrift, item, 0)
  SQL = "DELETE FROM adressen WHERE id = " + id
  
  If DatabaseUpdate(#AdressDB, SQL) = #False
    Debug DatabaseError() + " 5"
  Else
    RemoveGadgetItem(#gad_ListAnschrift, item)
  EndIf
EndProcedure
 
Procedure CreateFormMain()
  Protected ListIconFlags = #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    ListIconFlags | #PB_ListIcon_AlwaysShowSelection
  CompilerEndIf
  OpenWindow(0,200,305,480,416,"����",#PB_Window_SystemMenu| #PB_Window_MinimizeGadget| #PB_Window_MaximizeGadget) 
  SetWindowColor(0, RGB(37,162,254))
  PanelGadget(#gad_Panel, 0, 0, 480, 415)
  AddGadgetItem(#gad_Panel, -1, "��������")
  
 
      ListIconGadget(#gad_ListAnschrift, 5, 5, GetGadgetAttribute(#gad_Panel, #PB_Panel_ItemWidth) - 10, GetGadgetAttribute(#gad_Panel, #PB_Panel_ItemHeight) - 10, "id", 1, ListIconFlags)
      ; ������ ������� ��������� ���������� ������������� � �� ����� !
      AddGadgetColumn(#gad_ListAnschrift, 1, "�����", 150)
      AddGadgetColumn(#gad_ListAnschrift, 2, "������", 95)
      AddGadgetColumn(#gad_ListAnschrift, 3, "�����", 95)
      AddGadgetColumn(#gad_ListAnschrift, 4, "�����������������", 120)
      CloseGadgetList()
      ;***************************************************************************
      
      OpenWindow(1,200,200,490,80,"Dialogfenster",#PB_Window_SystemMenu| #PB_Window_MinimizeGadget| #PB_Window_MaximizeGadget) 
     
  ContainerGadget(#gad_Container, 5, 20, 490, 60)
  StringGadget(#gad_strName, 5, 0, 150, 25, "")
  SetGadgetColor(#gad_strName, #PB_Gadget_FrontColor,RGB(0,0,255))
  SetGadgetColor(#gad_strName, #PB_Gadget_BackColor,RGB(242,252,186))
 
  StringGadget(#gad_strVorname, 165, 0, 95, 25, "")
  StringGadget(#gad_strStrasse, 260, 0, 95, 25, "")
  StringGadget(#gad_strPLZ, 355, 0, 120, 25, "")
  ButtonGadget(#gad_btnHinzufuegen, 5, 30, 100, 25, "��������")
  ButtonGadget(#gad_btnAendern, 115, 30, 80, 25, "��������")
  ButtonGadget(#gad_btnLoeschen, 205, 30, 80, 25, "�������")
  ButtonGadget(#gad_btnSortieren, 290, 30, 80, 25, "�����������")
  CloseGadgetList()
 
EndProcedure
End
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 32
; FirstLine = 234
; Folding = -
; EnableXP
; Executable = ..\..\Users\Admin\Desktop\exeС€РЅРёРєРё\Sql client.exe