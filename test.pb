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
 
; Мы проверяем , существует ли ужеDB , если нет,пусто DB создан .
If FileSize(db_name) <= 0
  If CreateFile(0, db_name)
    CloseFile(0)
    If OpenDatabase(#AdressDB, db_name, "", "")
      ; Мы создаем адреса таблицы , этозаявление SQL :
      ; " CREATE TABLE table_name ( имя поля [Тип ] имя_поля [ TYPE] , ...) " отвечает
      ; Тип поля , как правило, дополнительно на SQLite, так что мы , как правило, опускать это тоже.
      ; Исключением из этого правила являетсяуникальный идентификатор иBLOB. Это всегда типа INTEGER, или BLOB
      ; Синтаксис для поля ID : имя_поля INTEGER PRIMARY KEY AUTOINCREMENT
      ; Рекомендуется, чтобызаявление SQL разделить на несколько строк.
      SQL = "CREATE TABLE adressen (id INTEGER PRIMARY KEY AUTOINCREMENT,"
      SQL + " name, vorname, strasse, plz, ort, telefon, notizen, fotodata BLOB, fotosize INTEGER)"
      
      ; Если мы нужен результат , мы используем: обновление базы данных (ID , SQL заявление)
      ; в противном случае запроса базы данных ( ID , SQL заявление ), который мы увидим позже.
      If DatabaseUpdate(#AdressDB, SQL) = #False
        Debug DatabaseError()
        End
      EndIf
    Else
      Debug DatabaseError()
      End
    EndIf
  Else
    Debug db_name + " не может быть создан."
    End
  EndIf
Else ; База данных уже существует и открыт.
  If OpenDatabase(#AdressDB, db_name, "", "") = #False
    Debug DatabaseError()
    End
  EndIf
EndIf
 
; После того как мы открыли нашу базу данных (будь то пустой или уже с содержимым )
; мы создаем первый главное окно
 
CreateFormMain()
 
Define i
 
; Теперь наша ListIconGadget заполняется данными
ListFuellen()
 
; Вот и начинается наша MainLoop .
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
        Case #gad_btnHinzufuegen ; Добавьте запись
          DatenSatzHinzufuegen()
        
        Case #gad_btnAendern
          If GetGadgetState(#gad_ListAnschrift)  > -1
            DatenSatzAendern()
          Else
            MessageRequester("SQLite Справка", "Пожалуйста, выберите  запись для обновления !")
          EndIf
          
        Case #gad_btnLoeschen
          If GetGadgetState(#gad_ListAnschrift)  > -1
            DatenSatzLoeschen()
          Else
            MessageRequester("SQLite Справка", "Пожалуйста, выделите  запись для удаления !")
          EndIf 
          
        Case #gad_btnSortieren
          ListFuellen()
      EndSelect
  EndSelect
ForEver
End
 
Procedure ListFuellen()
  ; Теперь наш ListIconGadget заполняется данными
  ; Для этой целизаявление SQL SELECT несет ответственность. * Соответствует всем и после из определения таблицы
  ; ORDER BY имя поля обеспечивает сортировку !
  Protected itemtext.s, i
  
  ClearGadgetItems(#gad_ListAnschrift)
  
  If DatabaseQuery(#AdressDB, "SELECT * FROM adressen ORDER BY name")
    While NextDatabaseRow(#AdressDB)
      itemtext = GetDatabaseString(#AdressDB, 0) ; наш скрытый уникальный идентификатор,
      For i = 1 To 6 ; Имя и телефон !
        itemtext + #LF$ + GetDatabaseString(#AdressDB, i)
      Next
      AddGadgetItem(#gad_ListAnschrift, -1, itemtext)
    Wend
    FinishDatabaseQuery(#AdressDB); Эта функция всегда выполняется для запроса !
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
  
  ; Этозаявление SQL : " INSERT INTO ... " отвечает !
  SQL = "INSERT INTO adressen (name, vorname, strasse, plz, ort, telefon) "
  SQL + "VALUES ('"
  SQL + name + "','"
  SQL + vorname + "','"
  SQL + strasse + "','"
  SQL + plz + "','"
  SQL + ort + "','"
  SQL + telefon + "')"
  
  If DatabaseUpdate(#AdressDB, SQL) ; Введите в БД .
    ; Теперь нам нужен автоматически созданный идентификатор , чтобы ввести его в нашем списке
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
  
  ; Определите ID выбранной записи
  item = GetGadgetState(#gad_ListAnschrift)
  id = GetGadgetItemText(#gad_ListAnschrift, item, 0)
 
  ; Чтобы изменить , мы используем SQL заявление: " UPDATE table_name SET "
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
  OpenWindow(0,200,305,640,416,"База",#PB_Window_SystemMenu| #PB_Window_MinimizeGadget| #PB_Window_MaximizeGadget) 
  SetWindowColor(0, RGB(37,162,254))
  PanelGadget(#gad_Panel, 0, 0, 640, 415)
  AddGadgetItem(#gad_Panel, -1, "Выделить")
  
 
      ListIconGadget(#gad_ListAnschrift, 5, 5, GetGadgetAttribute(#gad_Panel, #PB_Panel_ItemWidth) - 10, GetGadgetAttribute(#gad_Panel, #PB_Panel_ItemHeight) - 10, "id", 1, ListIconFlags)
      ; Первый столбец управляет уникальный идентификатор и не видно !
      AddGadgetColumn(#gad_ListAnschrift, 1, "Имя", 95)
      AddGadgetColumn(#gad_ListAnschrift, 2, "Фамилия", 95)
      AddGadgetColumn(#gad_ListAnschrift, 3, "Адрес", 160)
      AddGadgetColumn(#gad_ListAnschrift, 4, "Дом", 45)
      AddGadgetColumn(#gad_ListAnschrift, 5, "место", 125)
      AddGadgetColumn(#gad_ListAnschrift, 6, "Телефон", 90)
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
  ButtonGadget(#gad_btnHinzufuegen, 5, 30, 100, 25, "Добавить")
  ButtonGadget(#gad_btnAendern, 115, 30, 80, 25, "Обновить")
  ButtonGadget(#gad_btnLoeschen, 205, 30, 80, 25, "Удалить")
  ButtonGadget(#gad_btnSortieren, 540, 30, 80, 25, "Сортировать")
  CloseGadgetList()
 
EndProcedure
End
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 285
; FirstLine = 251
; Folding = -
; EnableXP