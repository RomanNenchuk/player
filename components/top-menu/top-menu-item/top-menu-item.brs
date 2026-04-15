sub init()

    m.tab_label = m.top.findNode("tabLabel")
    m.focus_indicator = m.top.findNode("focusIndicator")

end sub

sub _onContentChange()

    if (m.top.itemContent <> invalid)

        m.tab_label.text = m.top.itemContent.title
        _updateVisualState()

    end if

end sub

sub _updateVisualState()

    is_active_page = false

    if (m.top.itemContent <> invalid and m.top.itemContent.HasField("isActive"))

        is_active_page = m.top.itemContent.isActive

    end if

    is_focused = m.top.itemHasFocus

    if (is_focused or is_active_page)

        m.tab_label.color = "0xFFFFFFFF"
        m.tab_label.font = "font:SmallBoldSystemFont"

    else

        m.tab_label.color = "0x888888FF"
        m.tab_label.font = "font:SmallSystemFont"

    end if

    m.focus_indicator.visible = is_focused

end sub
