sub init()

  m.top.createChild("TrackerTask")
  m.screen_stack = m.top.findNode("screenStack")
  m.screens = []

  showScreen("HomeScreen")

end sub

sub showScreen(screen_name as String)

  new_screen = CreateObject("roSGNode", screen_name)

  if (new_screen <> invalid)

    if (m.screens.Count() > 1)

      prev_screen = m.screens.Peek()
      prev_screen.visible = false

    end if

    m.screen_stack.AppendChild(new_screen)
    m.screens.Push(new_screen)

    new_screen.SetFocus(true)

  end if

end sub

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
