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

sub setTopMenuVisible(isVisible as Boolean)

    scene = m.top.getScene()
    
    if scene <> invalid and scene.hasField("isTopMenuVisible")
    
        scene.isTopMenuVisible = isVisible
    
    end if

end sub
