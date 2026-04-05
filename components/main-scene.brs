sub init()
  
  m.welcome_label = m.top.FindNode("welcome_label")
  m.content_row_list = m.top.findNode("content_row_list")
  m.content_row_list.SetFocus(true)
  
  _initDataLoader()
  
end sub
