sub init()

    m.content_row_list = m.top.findNode("contentRowList")
    m.content_row_list.ObserveField("rowItemSelected", "onRowItemSelected")
    m.top.ObserveField("focusedChild", "onFocusChange")
    
    m.screen_manager = m.top.getScene().findNode("screenManager")

    initDataLoader()

end sub

sub onRowItemSelected()

  row_index = m.content_row_list.rowItemSelected[0]
  col_index = m.content_row_list.rowItemSelected[1]
  
  selected_content = m.content_row_list.content.GetChild(row_index).GetChild(col_index)
  
  payload = {
    screenName: "DetailsScreen",
    contentData: selected_content
  }

  m.screen_manager.callFunc("NavigateToScreen", payload)

end sub

sub onFocusChange()

    if (m.top.hasFocus())

        m.content_row_list.SetFocus(true)
        
    end if

end sub
