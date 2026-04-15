sub init()

    hideTopMenu()

    m.hero = m.top.findNode("hero")
    m.error_label = m.top.findNode("errorLabel")
    m.close_timer = m.top.findNode("closeTimer")
    m.screen_manager = m.top.getScene().findNode("screenManager")

    m.top.ObserveField("focusedChild", "_onFocusChange")

    if (m.close_timer <> invalid)

        m.close_timer.ObserveField("fire", "_onTimerComplete")

    end if

end sub

sub onContentChange()

    item_content = m.top.content
    
    if (item_content <> invalid)

        m.hero.content = item_content
        
        m.hero.visible = true
        m.error_label.visible = false
        
        m.hero.SetFocus(true)

    else

        m.hero.visible = false
        m.error_label.visible = true
        m.top.SetFocus(true)

        if (m.close_timer <> invalid)

            m.close_timer.control = "start"

        end if

    end if

end sub

sub _onFocusChange()

    if (m.top.hasFocus())

        if (m.hero.visible)

            m.hero.SetFocus(true)

        end if

    end if

end sub

sub _onTimerComplete()

    if (m.screen_manager <> invalid)

        m.screen_manager.callFunc("GoBack")

    end if

end sub
