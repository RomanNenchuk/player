sub init()

    m.top.createChild("TrackerTask")
    m.screen_manager = m.top.findNode("screenManager")
    m.screen_manager.ObserveField("currentScreen", "_onScreenChanged")
    m.dialog_manager = m.top.findNode("dialogManager")
    m.top_menu = m.top.findNode("topMenu")
    m.top_menu.ObserveField("itemSelected", "_onMenuItemSelected")

    m.top.ObserveField("isTopMenuVisible", "_onMenuVisibilityChanged")

    navigateTo({
        "screenName": "HomeScreen"
    })

end sub

sub _onMenuVisibilityChanged(event as Object)

    is_visible = event.getData()

    if (m.top_menu <> invalid)

        m.top_menu.visible = is_visible

    end if

end sub

sub _onScreenChanged(event as Object)

    active_screen_name = event.getData()
    m.top_menu.activeTab = active_screen_name.subtype()

end sub

sub _onMenuItemSelected(event as Object)

    payload = event.getData()
    payload.errorFocusTarget = m.top_menu
    navigateTo(payload)

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    if (not press)

        return false

    end if

    if (key = "back")

        return _HandleBackKey()

    end if

    if (key = "up")

        return _HandleUpKey()

    end if

    if (key = "down")

        return _HandleDownKey()

    end if

    return false

end function

function _HandleBackKey() as Boolean

    print "_HandleBackKey"

    if (GoToPreviousScreen())

        return true

    end if

    if (not m.top_menu.isInFocusChain() and m.top_menu.visible)

        m.top_menu.SetFocus(true)

        return true

    end if

    print "_promptAppExit()"
    _promptAppExit()

    return true

end function

function _HandleUpKey() as Boolean

    if (not m.top_menu.isInFocusChain() and m.top_menu.visible)

        m.top_menu.SetFocus(true)

        return true

    end if

    return false

end function

function _HandleDownKey() as Boolean

    if (m.top_menu.isInFocusChain())

        m.screen_manager.currentScreen.SetFocus(true)

        return true

    end if

    return false

end function

sub _promptAppExit()

    focus_target = m.screen_manager.currentScreen

    if (m.top_menu.isInFocusChain())

        focus_target = m.top_menu

    end if

    m.dialog_manager.showDialog = {
        "title": "Confirmation",
        "message": "Are you sure you want to exit?",
        "buttons": ["OK", "Cancel"],
        "actions": ["exitApp", "dismiss"],
        "focusTarget": focus_target
    }

end sub

sub _onExitAppClicked()

    m.top.exitApp = true

end sub
