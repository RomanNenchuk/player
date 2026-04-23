sub init()

    m.top.ObserveField("visible", "_onBaseVisibilityChanged")
    m.top.ObserveField("requiresTopMenu", "_onMenuRequirementChanged")

end sub

sub _onBaseVisibilityChanged()

    if (m.top.visible = true)

        setTopMenuVisible(m.top.requiresTopMenu)

    end if

end sub

sub _onMenuRequirementChanged()

    if (m.top.visible = true)

        setTopMenuVisible(m.top.requiresTopMenu)

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
