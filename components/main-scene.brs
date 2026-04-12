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
            
            if (not handled)
            
                modal_config = {
                    "title": "Confirmation",
                    "message": "Sure you wanna exit?",
                    "buttons": ["OK", "Cancel"],
                    "callbacks": [
                        {
                            "func": _onExitAppClicked,
                        },
                        invalid
                    ]
                }

                ShowModal(modal_config)
                handled = true

            end if

        end if
        
    end if
    
    return handled
    
end function

sub _onExitAppClicked()

    m.top.exitApp = true

end sub
