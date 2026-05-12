sub init()

    setTopMenuVisible(true)

    m.SEARCH_CONFIG = {
        "max_chars": 50,
        "max_pill_width": 750,
        "horizontal_padding": 48,
        "spinner_width": 80,
        "spinner_height": 80,
        "spinner_uri": "pkg:/images/spinner.png"
    }

    _setupUi()
    _setupObservers()
    _checkVoiceSupport()
    _updateHeaderSize()

    initDataLoader()

end sub

sub _setupObservers()

    m.search_timer.ObserveField("fire", "_onDebounceTimerFired")
    m.search_results_grid.ObserveField("itemSelected", "_onGridItemSelected")
    m.top.ObserveField("focusedChild", "_onScreenFocusChange")
    m.search_header_label.ObserveField("boundingRect", "_onHeaderBoundsChanged")
    m.keyboard.ObserveField("focusedChild", "_onKeyboardFocusChanged")
    m.keyboard.ObserveField("text", "_onSearchQueryChanged")

end sub

sub _onGridItemSelected()

    selected_index = m.search_results_grid.itemSelected
    selected_content = m.search_results_grid.content.getChild(selected_index)

    if (selected_content <> invalid)

        navigateTo({
            "screenName": "DetailsScreen",
            "contentData": selected_content
        })

    end if

end sub

sub _setupUi()

    m.voice_prompt_group = m.top.findNode("voicePromptGroup")
    m.search_header_bg = m.top.findNode("searchHeaderBg")
    m.search_header_label = m.top.findNode("searchHeaderLabel")
    m.search_results_grid = m.top.findNode("searchResultsGrid")
    m.search_timer = m.top.findNode("searchDebounceTimer")
    m.no_results_label = m.top.findNode("noResultsLabel")

    m.spinner = m.top.findNode("loadingSpinner")
    m.spinner.poster.uri = m.SEARCH_CONFIG.spinner_uri
    m.spinner.poster.width = m.SEARCH_CONFIG.spinner_width
    m.spinner.poster.height = m.SEARCH_CONFIG.spinner_height

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
            m.voice_edit_box.scale = [0.01, 0.01]
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

    target_bg_width = text_bounds.width + m.SEARCH_CONFIG.horizontal_padding

    if (target_bg_width > m.SEARCH_CONFIG.max_pill_width)

        m.search_header_bg.width = m.SEARCH_CONFIG.max_pill_width
        m.search_header_label.width = m.SEARCH_CONFIG.max_pill_width - m.SEARCH_CONFIG.horizontal_padding

    else

        m.search_header_bg.width = target_bg_width
        m.search_header_label.width = 0

    end if

    current_label_bounds = m.search_header_label.boundingRect()

    x_pos = m.SEARCH_CONFIG.horizontal_padding / 2
    y_pos = (bg_height - current_label_bounds.height) / 2

    m.search_header_label.translation = [x_pos, y_pos]

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

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false

    if (press)

        if (m.voice_prompt_group.hasFocus())

            if (key = "down")

                handled = _SetFocusTarget(m.keyboard_grid)

            else if (key = "OK")

                handled = true

            end if

        else if (m.search_results_grid.hasFocus())

            if (key = "left")

                handled = _SetFocusTarget(m.keyboard_grid)

            end if

        else if (m.keyboard_grid.hasFocus())

            if (key = "right")

                if (m.search_results_grid.visible)

                    _SetFocusTarget(m.search_results_grid)

                end if

                handled = true 

            else if (key = "up" and m.voice_prompt_group.visible)

                handled = _SetFocusTarget(m.voice_prompt_group)

            end if

        end if

    end if

    if (not handled)

        handled = HandleBaseKeyEvents(key, press)

    end if

    return handled

end function

function _SetFocusTarget(node as Object) as Boolean

    if (node <> invalid)

        node.setFocus(true)
        m.last_focused_section = node

        return true

    end if

    return false

end function

sub _onScreenFocusChange()

    if (m.top.hasFocus())

        m.last_focused_section.setFocus(true)

    end if

end sub

sub _onKeyboardFocusChanged()

    if (m.voice_edit_box <> invalid and m.voice_edit_box.hasFocus())

        m.keyboard_grid.setFocus(true)
        m.last_focused_section = m.keyboard_grid

    end if

end sub

sub _onSearchQueryChanged()

    m.no_results_label.visible = false
    query = m.keyboard.text

    if (query.len() > m.SEARCH_CONFIG.max_chars)

        query = query.left(m.SEARCH_CONFIG.max_chars)
        m.keyboard.textEditBox.text = query

    end if

    if (query = "")

        m.search_header_label.text = "What are you looking for?"

    else

        m.search_header_label.text = "Search results for """ + query + """"

    end if

    m.search_results_grid.visible = false

    _toggleLoadingSpinner(true)

    m.search_timer.control = "stop"
    m.search_timer.control = "start"

    _updateHeaderSize()

end sub

sub _onDebounceTimerFired()

    _filterAndDisplayResults(m.keyboard.text)

end sub

sub _onFeedDataReceived()

    content_node = m.top.feedData

    if (content_node = invalid)

        return

    end if

    m.all_videos_raw = []

    for each row in content_node.getChildren(-1, 0)

        if (row <> invalid and row.getChildCount() > 0)

            for each video_item in row.getChildren(-1, 0)

                item_data = {
                    "title": video_item.title,
                    "hdposterurl": video_item.hdposterurl,
                    "releaseDate": video_item.releaseDate,
                    "shortdescriptionline2": video_item.shortdescriptionline2,
                    "url": video_item.url,
                    "id": video_item.id,
                    "description": video_item.description
                }

                m.all_videos_raw.push(item_data)

            end for

        end if

    end for

    _filterAndDisplayResults(m.keyboard.text)

end sub

sub _filterAndDisplayResults(query as String)

    if (m.all_videos_raw = invalid)

        return

    end if

    query_lower = LCase(query)
    filtered_content = CreateObject("roSGNode", "ContentNode")

    for each video in m.all_videos_raw

        if (query_lower = "" or (video.title <> invalid and LCase(video.title).inStr(query_lower) >= 0))

            new_item = filtered_content.createChild("ContentNode")

            new_item.update(video, true)

        end if

    end for

    m.search_results_grid.content = filtered_content

    has_results = (filtered_content.getChildCount() > 0)

    m.search_results_grid.visible = has_results
    m.no_results_label.visible = (not has_results)

    _toggleLoadingSpinner(false)

end sub
