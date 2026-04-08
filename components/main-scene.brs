sub init()
    
    m.top.createChild("TrackerTask")
    
    m.screen_manager = m.top.findNode("screenManager")
    
    navigateTo({ screenName: "HomeScreen" })
    
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    
    handled = false
    
    if (press)
        
        if (key = "back")
            
            handled = goToPreviousScreen()
            
        end if
        
    end if
    
    return handled
    
end function
