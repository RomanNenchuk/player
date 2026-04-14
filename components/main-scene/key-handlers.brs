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

    if (GoToPreviousScreen())

        return true

    end if

    if (not m.top_menu.isInFocusChain() and m.top_menu.visible)

        m.top_menu.SetFocus(true)

        return true

    end if

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

        m.screen_manager.SetFocus(true)

        return true

    end if

    return false

end function
