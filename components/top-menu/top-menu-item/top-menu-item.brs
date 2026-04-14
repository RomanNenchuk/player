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

    ' Це поле автоматично true, тільки якщо курсор лежить прямо на цій кнопці
    is_focused = m.top.itemHasFocus

    ' БІЛИЙ ТЕКСТ: якщо ми пультом на кнопці АБО це наша поточна сторінка
    if (is_focused or is_active_page)

        m.tab_label.color = "0xFFFFFFFF"

    else

        m.tab_label.color = "0xAAAAAAFF"

    end if

    ' ЧЕРВОНА ЛІНІЯ: світиться тільки коли елемент має реальний фокус
    m.focus_indicator.visible = is_focused

end sub