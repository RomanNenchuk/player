sub init()

    m.top.createChild("TrackerTask")

    m.screen_manager = m.top.findNode("screenManager")
    m.dialog_manager = m.top.findNode("dialogManager")

    navigateTo({ "screenName": "HomeScreen" })

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false

    if (press and key = "back")

        handled = goToPreviousScreen()

        if (not handled)

            m.dialog_manager.showDialog = {
                "title": "Confirmation",
                "message": "Are you sure you want to exit?",
                "buttons": ["OK", "Cancel"],
                "actions": ["exitApp", "dismiss"],
                "focusTarget": m.screen_manager.currentScreen
            }

            handled = true

        end if

    end if

    return handled

end function

sub _onExitAppClicked()

    m.top.exitApp = true

end sub
