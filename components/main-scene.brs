sub init()

  m.screenStack = m.top.findNode("screenStack")
  m.screens = []
  showScreen("HomeScreen")

end sub

sub showScreen(screenName as String)
    
  newScreen = CreateObject("roSGNode", screenName)
    
    if (newScreen <> invalid)

      if (m.screens.Count() > 0)
        prevScreen = m.screens.Peek()
        prevScreen.visible = false
      end if
        
        m.screenStack.AppendChild(newScreen)
        m.screens.Push(newScreen)
        
        newScreen.SetFocus(true)
    end if
    
end sub

sub closeScreen()
  
  if (m.screens.Count() > 1)
    currentScreen = m.screens.Pop()
    m.screenStack.RemoveChild(currentScreen)
    
    prevScreen = m.screens.Peek()
    prevScreen.visible = true
    prevScreen.SetFocus(true)
  end if
  
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

  handled = false

  if press
    if key = "back"

      if (m.screens.Count() > 1)
        closeScreen()
        handled = true
      end if

      end if
  end if

  return handled

end function
