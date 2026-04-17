sub init()

    setTopMenuVisible(true)
    
    m.voice_prompt_group = m.top.findNode("voice_prompt_group")
    m.mic_button_large = m.top.findNode("mic_button_large")
    m.mic_bg = m.top.findNode("mic_bg")
    m.keyboard = m.top.findNode("keyboard")
    m.search_header_bg = m.top.findNode("search_header_bg")
    m.search_header_label = m.top.findNode("search_header_label")

    m.mic_button_large.ObserveField("focusedChild", "_onMicFocusChange")
    m.top.ObserveField("focusedChild", "_onScreenFocusChange")
    m.keyboard.ObserveField("searchQuery", "_onSearchQueryChanged")
    m.keyboard.ObserveField("exitDirection", "_onKeyboardExit")
    m.search_header_label.ObserveField("boundingRect", "_onHeaderBoundsChanged")

    _checkVoiceSupport()
    _updateHeaderSize()

end sub

sub _checkVoiceSupport()

	has_voice_support = true
	m.voice_prompt_group.visible = has_voice_support

end sub

sub _onMicFocusChange()

    if (m.mic_button_large.hasFocus() = true)

        m.mic_bg.blendColor = "0xDF46C1FF"

    else

        m.mic_bg.blendColor = "0xFFFFFFFF"

    end if

end sub

sub _onScreenFocusChange()

    if (m.top.hasFocus() = true)

        m.keyboard.setFocus(true)

    end if

end sub

sub _onSearchQueryChanged()

    query = m.keyboard.searchQuery
    max_chars = 50

    if (query.len() > max_chars)

        query = query.left(max_chars)
        m.keyboard.searchQuery = query

    end if

    if (query = "")

        m.search_header_label.text = "What are you looking for?"

    else

        m.search_header_label.text = "Search results for """ + query + """"

    end if

    _updateHeaderSize()

end sub

sub _onKeyboardExit()

    direction = m.keyboard.exitDirection

    if (direction = "up")

        if (m.voice_prompt_group.visible = true)

            m.mic_button_large.setFocus(true)

        end if

    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    if (press = false)

        return false

    end if

    if (m.mic_button_large.hasFocus() = true)

        if (key = "down")

            m.keyboard.setFocus(true)

            return true

        else if (key = "OK")

            print "Mic button clicked! Start voice search..."

            return true

        end if

    end if

    return false

end function

sub _updateHeaderSize()

    m.search_header_label.width = 0

    text_bounds = m.search_header_label.boundingRect()
    bg_height = m.search_header_bg.height

    max_pill_width = 750
    horizontal_padding = 48
    
    target_bg_width = text_bounds.width + horizontal_padding

    if (target_bg_width > max_pill_width)

        m.search_header_bg.width = max_pill_width
        m.search_header_label.width = max_pill_width - horizontal_padding

    else

        m.search_header_bg.width = target_bg_width
        m.search_header_label.width = 0

    end if

    current_label_bounds = m.search_header_label.boundingRect()
    
    x_pos = horizontal_padding / 2
    y_pos = (bg_height - current_label_bounds.height) / 2

    m.search_header_label.translation = [x_pos, y_pos]

end sub
