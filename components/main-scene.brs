sub init()

  m.top.createChild("TrackerTask")
  m.screen_stack = m.top.findNode("screenStack")
  m.screens = []

  ShowScreen("HomeScreen")

end sub

function ShowScreen(screen_name as String) as Object

  new_screen = CreateObject("roSGNode", screen_name)

  if (new_screen <> invalid)

    new_screen.ObserveField("navigateTo", "onNavigateRequest")

    if (m.screens.Count() > 0)

      prev_screen = m.screens.Peek()
      prev_screen.visible = false
    end if

    m.screen_stack.AppendChild(new_screen)
    m.screens.Push(new_screen)

    new_screen.SetFocus(true)
  end if
  
  return new_screen 

end function

sub closeScreen()

  if (m.screens.Count() > 1)

    current_screen = m.screens.Pop()
    m.screen_stack.RemoveChild(current_screen)

    prev_screen = m.screens.Peek()
    prev_screen.visible = true

    prev_screen.SetFocus(true)
  end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

  handled = false

  if (press)

    if (key = "back")

      if (m.screens.Count() > 1)

        closeScreen()
        handled = true
      end if

    end if

  end if

  return handled

end function

sub onNavigateRequest(event as Object)
  
    nav_info = event.GetData()
    
    if nav_info <> invalid and nav_info.DoesExist("screenName")

      new_screen = ShowScreen(nav_info.screenName)

      if new_screen <> invalid and nav_info.DoesExist("contentData")

          new_screen.content = nav_info.contentData
        end if
    end if
end sub
