sub init()
  
  m.welcomeLabel = m.top.FindNode("welcomeLabel")
  m.content_row_list = m.top.findNode("content_row_list")
  m.content_row_list.SetFocus(true)
  
  _initDataLoader()
  
end sub
