sub initDataLoader()

  m.video_task = CreateObject("roSGNode", "VideoFeedTask")
  m.content_row_list.ObserveField("rowItemSelected", "onRowItemSelected")
  m.video_task.ObserveField("contentOutput", "_onDataLoaded")
  m.video_task.control = "RUN"

end sub

sub _onDataLoaded()

  content_node = m.video_task.contentOutput

  if (content_node = invalid)

    print "[Scene] contentOutput is invalid"
    return
  end if

  m.content_row_list.content = content_node

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
  
  ' 1. Ask the main scene stack to create and show the DetailsScreen
  ' callFunc returns the newly created screen node
  details_screen = m.top.GetScene().callFunc("ShowScreen", "DetailsScreen")
  
  ' 2. Pass the data to the screen (this triggers OnContentChange in details-screen.brs)
  if details_screen <> invalid
      details_screen.content = selected_content
  end if

end sub
