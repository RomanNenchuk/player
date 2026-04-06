sub _initDataLoader()
    
  m.data_task = CreateObject("roSGNode", "VideoLoaderTask")
  m.data_task.ObserveField("content_output", "_onDataLoaded")
  m.data_task.control = "RUN"
    
end sub

sub _onDataLoaded()

  content_node = m.data_task.content_output
  
  if (content_node = invalid)
      print "[Scene] content_output is invalid"
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
