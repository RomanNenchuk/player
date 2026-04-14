sub init()

    m.top.createChild("TrackerTask")

    m.screen_manager = m.top.findNode("screenManager")
    m.top_menu = m.top.findNode("topMenu")
    m.top_menu.ObserveField("itemSelected", "_onMenuItemSelected")

    navigateTo({ "screenName": "HomeScreen" })

end sub

sub _onMenuVisibilityChange()

    m.top_menu.visible = m.top.isMenuVisible

end sub

sub _onMenuItemSelected(event as Object)

    payload = event.getData()
    
    navigateTo(payload)

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false

    if (press and key = "back")

        handled = goToPreviousScreen()

        if (not handled)

            ShowModal({
                "title": "Confirmation",
                "message": "Are you sure you want to exit?",
                "buttons": ["OK", "Cancel"],
                "focusTarget": m.screen_manager,
                "callbacks": [
                    { "func": _onExitAppClicked },
                    invalid
                ]
            })

            handled = true

        end if

    end if

    return handled

end function

sub _onExitAppClicked()

    m.top.exitApp = true

end sub
