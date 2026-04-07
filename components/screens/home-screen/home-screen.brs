sub init()

    m.content_row_list = m.top.findNode("contentRowList")
    m.content_row_list.ObserveField("rowItemSelected", "onRowItemSelected")
    m.content_row_list.SetFocus(true)
    
    initDataLoader()

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

  handled = false

  if (press)

    if (key = "up" or key = "down" or key = "left" or key = "right")

      if (not m.content_row_list.hasFocus())

        m.content_row_list.SetFocus(true)
        handled = true
      end if

    end if

  end if

  return handled

end function

sub onRowItemSelected()

  row_index = m.content_row_list.rowItemSelected[0]
  col_index = m.content_row_list.rowItemSelected[1]
  
  selected_content = m.content_row_list.content.GetChild(row_index).GetChild(col_index)

  m.top.navigateTo = {
    screenName: "DetailsScreen",
    contentData: selected_content
  }

end sub

