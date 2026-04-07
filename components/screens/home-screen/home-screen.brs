sub init()

    m.content_row_list = m.top.findNode("contentRowList")
    m.content_row_list.ObserveField("rowItemSelected", "onRowItemSelected")
    
    m.top.ObserveField("focusedChild", "onFocusChange")

    initDataLoader()

end sub

sub onRowItemSelected()

  row_index = m.content_row_list.rowItemSelected[0]
  col_index = m.content_row_list.rowItemSelected[1]
  
  selected_content = m.content_row_list.content.GetChild(row_index).GetChild(col_index)

  m.top.navigateTo = {
    screenName: "DetailsScreen",
    contentData: selected_content
  }

end sub

sub onFocusChange()

    if (m.top.hasFocus())

        m.content_row_list.SetFocus(true)
    end if

end sub
