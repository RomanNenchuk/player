sub _setupUi()

    m.voice_prompt_group = m.top.findNode("voicePromptGroup")
    m.search_header_bg = m.top.findNode("searchHeaderBg")
    m.search_header_label = m.top.findNode("searchHeaderLabel")
    m.search_results_grid = m.top.findNode("searchResultsGrid")
    m.search_timer = m.top.findNode("searchDebounceTimer")
    m.no_results_label = m.top.findNode("noResultsLabel")

    m.spinner = m.top.findNode("loadingSpinner")
    m.spinner.poster.uri = "pkg:/images/spinner.png"
    m.spinner.poster.width = 80
    m.spinner.poster.height = 80

    _toggleLoadingSpinner(true)

    m.keyboard = m.top.findNode("keyboard")
    m.keyboard.showTextEditBox = true
    m.keyboard_edit_box = m.keyboard.textEditBox
    m.keyboard_grid = m.keyboard.keyGrid

    if (m.keyboard_edit_box <> invalid)

        m.keyboard_edit_box.visible = true
        m.keyboard_edit_box.voiceEnabled = true
        m.keyboard_edit_box.focusable = false

    end if

    keyboard_children = m.keyboard.getChildren(-1, 0)

    for each child in keyboard_children

        if (child <> invalid and child.subtype() = "VoiceTextEditBox")

            m.voice_edit_box = child
            m.voice_edit_box.scale = [0.001, 0.001]
            m.voice_edit_box.focusable = false
            exit for

        end if

    end for

    m.last_focused_section = m.keyboard_grid
    m.keyboard_grid.setFocus(true)

end sub

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
    m.search_header_label.translation = [horizontal_padding / 2, (bg_height - current_label_bounds.height) / 2]

end sub

sub _toggleLoadingSpinner(show as Boolean)

    m.spinner.visible = show

    if (show)

        m.spinner.control = "start"

    else

        m.spinner.control = "stop"

    end if

end sub

sub _checkVoiceSupport()

    mic = CreateObject("roMicrophone")
    has_voice_support = (mic <> invalid)
    m.voice_prompt_group.visible = has_voice_support

end sub
