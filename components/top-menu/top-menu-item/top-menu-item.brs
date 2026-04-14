sub init()

    m.tab_label = m.top.findNode("tabLabel")
    m.focus_indicator = m.top.findNode("focusIndicator")

end sub

sub _onContentChange()

    if (m.top.itemContent <> invalid)

        m.tab_label.text = m.top.itemContent.title

    end if

end sub

sub _onFocusPercentChange()

    if (m.top.focusPercent > 0.5)

        m.tab_label.color = "0xFFFFFFFF"
        m.focus_indicator.visible = true

    else

        m.tab_label.color = "0xAAAAAAFF"
        m.focus_indicator.visible = false

    end if

end sub