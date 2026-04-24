sub init()

    m.top.ObserveField("visible", "_updateMenuState")
    m.top.ObserveField("requiresTopMenu", "_updateMenuState")
    m.top.ObserveField("focusedChild", "_updateMenuState")

    m.MENU_OFFSETS = {
        "with_menu": 180,
        "without_menu": 110
    }

end sub

sub _updateMenuState()

    if (m.top.visible = true)

        setTopMenuVisible(m.top.requiresTopMenu)
        applyMenuOffset()

    end if

end sub

sub setTopMenuVisible(is_visible as Boolean)

    scene = m.top.getScene()
    
    if (scene <> invalid and scene.hasField("isTopMenuVisible"))
    
        scene.isTopMenuVisible = is_visible
    
    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    return HandleBaseKeyEvents(key, press)

end function

function HandleBaseKeyEvents(key as String, press as Boolean) as Boolean

    if (not press)

        return false

    else if (key = "back")

        return _HandleBackKey()

    else if (key = "up")

        return _HandleUpKey()

    end if

    return false

end function

function _HandleBackKey() as Boolean

    scene = m.top.getScene()
    top_menu = invalid

    if (scene <> invalid)

        top_menu = scene.findNode("topMenu")

    end if

    if (top_menu <> invalid and not top_menu.isInFocusChain() and top_menu.visible)

        top_menu.SetFocus(true)
        return true

    end if
    
    return GoToPreviousScreen()

end function

function _HandleUpKey() as Boolean

    scene = m.top.getScene()
    top_menu = invalid

    if (scene <> invalid)

        top_menu = scene.findNode("topMenu")

    end if

    if (top_menu <> invalid and not top_menu.isInFocusChain() and top_menu.visible)

        top_menu.SetFocus(true)

        return true

    end if

    return false

end function

sub applyMenuOffset()

    content_group = m.top.findNode("contentGroup")

    if (content_group <> invalid)

        if (m.top.requiresTopMenu)

            content_group.translation = [0, m.MENU_OFFSETS.with_menu]

        else

            content_group.translation = [0, m.MENU_OFFSETS.without_menu]

        end if

    end if

end sub
