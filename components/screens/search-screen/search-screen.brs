sub init()

    setTopMenuVisible(true)

    m.voice_prompt_group = m.top.findNode("voicePromptGroup")
    m.search_header_bg = m.top.findNode("searchHeaderBg")
    m.search_header_label = m.top.findNode("searchHeaderLabel")
    m.search_results_grid = m.top.findNode("searchResultsGrid")

    m.search_timer = m.top.findNode("searchDebounceTimer")
    m.search_timer.ObserveField("fire", "_onDebounceTimerFired")

    m.no_results_label = m.top.findNode("noResultsLabel")
    
    m.spinner = m.top.findNode("loadingSpinner")
    m.spinner.visible = true
    m.spinner.control = "start"
    m.spinner.poster.uri = "pkg:/images/spinner.png"
    m.spinner.poster.width = 80
    m.spinner.poster.height = 80

    m.keyboard = m.top.findNode("keyboard")
    m.keyboard.showTextEditBox = true

    m.keyboard_edit_box = m.keyboard.textEditBox

    if (m.keyboard_edit_box <> invalid)

        m.keyboard_edit_box.visible = true
        m.keyboard_edit_box.voiceEnabled = true
        m.keyboard_edit_box.focusable = false

    end if

    m.keyboard_grid = m.keyboard.keyGrid
    m.last_focused_section = m.keyboard_grid

    m.search_results_grid.ObserveField("itemSelected", "_onGridItemSelected")
    m.top.ObserveField("focusedChild", "_onScreenFocusChange")
    m.search_header_label.ObserveField("boundingRect", "_onHeaderBoundsChanged")

    m.keyboard_grid.setFocus(true)

    keyboard_children = m.keyboard.getChildren(-1, 0)

    for each child in keyboard_children

        if (child <> invalid and child.subtype() = "VoiceTextEditBox")

            m.voice_edit_box = child
            m.voice_edit_box.scale = [0.001, 0.001]
            m.voice_edit_box.focusable = false

            exit for

        end if

    end for

    m.keyboard.ObserveField("focusedChild", "_onKeyboardFocusChanged")

    m.keyboard.ObserveField("text", "_onSearchQueryChanged")

    _checkVoiceSupport()
    _updateHeaderSize()
    initDataLoader()

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
    max_chars = 50

    if (query.len() > max_chars)

        query = query.left(max_chars)
        m.keyboard.textEditBox.text = query

    end if

    if (query = "")

        m.search_header_label.text = "What are you looking for?"

    else

        m.search_header_label.text = "Search results for """ + query + """"

    end if

    m.search_results_grid.visible = false

    m.spinner.visible = true
    m.spinner.control = "start"

    m.search_timer.control = "stop"
    m.search_timer.control = "start"

    _updateHeaderSize()

end sub

sub _onDebounceTimerFired()

    _filterAndDisplayResults(m.keyboard.text)

end sub

sub _checkVoiceSupport()

    mic = CreateObject("roMicrophone")
    has_voice_support = (mic <> invalid)
    m.voice_prompt_group.visible = has_voice_support

end sub

sub _onScreenFocusChange()

    if (m.top.hasFocus())

        m.last_focused_section.setFocus(true)

    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    if (not press) 

        return false
        
    end if

    if (m.voice_prompt_group.hasFocus())

        if (key = "down") 

            return _setFocusTarget(m.keyboard_grid)

        end if

        if (key = "OK") 

            return true

        end if

    else if (m.search_results_grid.hasFocus())

        if (key = "left") 

            return _setFocusTarget(m.keyboard_grid)

        end if

    else if (m.keyboard_grid.hasFocus())

        if (key = "right")

            if (m.search_results_grid.visible)

                _setFocusTarget(m.search_results_grid)

            end if
            
            return true 

        else if (key = "up" and m.voice_prompt_group.visible)

            return _setFocusTarget(m.voice_prompt_group)

        end if

    end if

    return false

end function

function _setFocusTarget(node as Object) as Boolean

    node.setFocus(true)
    m.last_focused_section = node
    return true

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
    m.search_header_label.translation = [horizontal_padding / 2, (bg_height - current_label_bounds.height) / 2]

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

    m.spinner.control = "stop"
    m.spinner.visible = false

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
