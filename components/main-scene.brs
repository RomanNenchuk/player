sub init()

    m.top.createChild("TrackerTask")

    m.screen_manager = m.top.findNode("screenManager")
    m.screen_manager.ObserveField("activeScreen", "_onScreenChanged")
    m.top_menu = m.top.findNode("topMenu")
    m.top_menu.ObserveField("itemSelected", "_onMenuItemSelected")
    
    m.main_screens = {
        "HomeScreen": true,
        "ShowsScreen": true,
        "MoviesScreen": true,
        "OnNowScreen": true,
        "SettingsScreen": true,
        "SearchScreen": true
    }

    navigateTo({ "screenName": "HomeScreen" })

end sub

sub _onScreenChanged(event as Object)

    active_screen_name = event.getData()
    m.top_menu.activeTab = active_screen_name
    m.top_menu.visible = m.main_screens.DoesExist(active_screen_name)

end sub

sub _onMenuItemSelected(event as Object)

    payload = event.getData()
    payload.errorFocusTarget = m.top_menu
    
    navigateTo(payload)

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false

    if (press)

        if (key = "back")

            handled = goToPreviousScreen()

            if (not handled)

                if (not m.top_menu.isInFocusChain() and m.top_menu.visible)

                    m.top_menu.SetFocus(true)
                    handled = true

                else

                    focus_target = m.screen_manager

                    if (m.top_menu.isInFocusChain())

                        focus_target = m.top_menu

                    end if

                    ShowModal({
                        "title": "Confirmation",
                        "message": "Are you sure you want to exit?",
                        "buttons": ["OK", "Cancel"],
                        "focusTarget": focus_target,
                        "callbacks": [
                            { "func": _onExitAppClicked },
                            invalid
                        ]
                    })

                    handled = true

                end if

            end if

        else if (key = "up")

            if (not m.top_menu.isInFocusChain() and m.top_menu.visible)

                m.top_menu.SetFocus(true)
                handled = true

            end if

        else if (key = "down")

            if (m.top_menu.isInFocusChain())

                m.screen_manager.SetFocus(true)
                handled = true

            end if

        end if

    end if

    return handled

end function

sub _onExitAppClicked()

    m.top.exitApp = true

end sub
