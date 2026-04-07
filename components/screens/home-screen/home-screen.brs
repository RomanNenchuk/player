sub init()

    m.content_row_list = m.top.findNode("contentRowList")
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
