sub init()

    m.constants = KeyboardConstants()

    m.background_rect = m.top.findNode("background_rect")
    m.letter_label = m.top.findNode("letter_label")
    m.icon_poster = m.top.findNode("icon_poster")

    m.top.ObserveField("focusedChild", "_onFocusChange")

end sub

sub _onKeyDataChange()

    constants = m.constants

    key_id = m.top.keyId
    key_title = m.top.keyTitle
    key_width = m.top.keyWidth

    if (key_width = 0)

        key_width = constants.KEY_SIZE

    end if

    key_height = m.top.keyHeight

    if (key_height = 0)

        key_height = constants.KEY_HEIGHT

    end if

    m.background_rect.width = key_width
    m.background_rect.height = key_height
    m.letter_label.width = key_width
    m.letter_label.height = key_height

    is_special = (key_id = constants.KEY_ID_CLEAR or key_id = constants.KEY_ID_SPACE or key_id = constants.KEY_ID_BACKSPACE)

    if (is_special)

        m.letter_label.visible = false
        m.icon_poster.visible = true

        center_x = Int((key_width - constants.ICON_SIZE_WIDE) / 2)

        if (key_id = constants.KEY_ID_CLEAR)

            _setIcon(constants.ICON_CLEAR, constants.ICON_SIZE_STANDARD, 
                constants.ICON_SIZE_STANDARD, center_x + 7, constants.ICON_Y)

        else if (key_id = constants.KEY_ID_SPACE)

            _setIcon(constants.ICON_SPACE, constants.ICON_SIZE_WIDE, 
                constants.ICON_SIZE_STANDARD, center_x, constants.ICON_Y)

        else if (key_id = constants.KEY_ID_BACKSPACE)

            _setIcon(constants.ICON_BACKSPACE, constants.ICON_SIZE_STANDARD, 
                constants.ICON_SIZE_STANDARD, center_x + 7, constants.ICON_Y)

        end if

    else

        m.icon_poster.visible = false
        m.letter_label.visible = true
        m.letter_label.text = key_title

    end if

    _updateFocusVisual()

end sub

sub _setIcon(uri as String, w as Integer, h as Integer, tx as Integer, ty as Integer)

    m.icon_poster.uri = uri
    m.icon_poster.width = w
    m.icon_poster.height = h
    m.icon_poster.translation = [tx, ty]

end sub

sub _onFocusChange()

    _updateFocusVisual()

end sub

sub _updateFocusVisual()

    constants = m.constants

    color_focused = m.top.colorFocused

    if (color_focused = "")

        color_focused = constants.COLOR_BG_FOCUSED

    end if

    color_default = m.top.colorDefault

    if (color_default = "")

        color_default = constants.COLOR_BG_DEFAULT

    end if

    if (m.top.hasFocus() = true)

        m.background_rect.color = color_focused
        m.letter_label.color = constants.COLOR_TEXT_FOCUSED

    else

        m.background_rect.color = color_default
        m.letter_label.color = constants.COLOR_TEXT_DEFAULT

    end if

end sub
