sub init()
    
    m.top.createChild("TrackerTask")
    
    m.screen_manager = m.top.findNode("screenManager")
    
    m.screen_manager.callFunc("NavigateToScreen", { screenName: "HomeScreen" })
    
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    
    handled = false
    
    if (press)
        
        if (key = "back")
            
            handled = m.screen_manager.callFunc("GoBack")
            
        end if
        
    end if
    
    return handled
    
end function
