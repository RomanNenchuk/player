sub init()

    setTopMenuVisible(true)
    
    m.voice_prompt_group = m.top.findNode("voicePromptGroup")
    m.mic_button_large = m.top.findNode("micButtonLarge")
    m.mic_bg = m.top.findNode("micBg")
    m.keyboard = m.top.findNode("keyboard")
    m.search_header_bg = m.top.findNode("searchHeaderBg")
    m.search_header_label = m.top.findNode("searchHeaderLabel")
    m.search_results_grid = m.top.findNode("searchResultsGrid")
    m.last_focused_section = m.keyboard

    m.all_videos_flat = invalid

    m.search_results_grid.ObserveField("itemSelected", "_onGridItemSelected")

    m.mic_button_large.ObserveField("focusedChild", "_onMicFocusChange")
    m.top.ObserveField("focusedChild", "_onScreenFocusChange")
    m.keyboard.ObserveField("searchQuery", "_onSearchQueryChanged")
    m.keyboard.ObserveField("exitDirection", "_onKeyboardExit")
    m.search_header_label.ObserveField("boundingRect", "_onHeaderBoundsChanged")

    _checkVoiceSupport()
    _updateHeaderSize()
    initDataLoader()

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

        m.last_focused_section.setFocus(true)

    end if

end sub

sub _onKeyboardExit()

    direction = m.keyboard.exitDirection

    if (direction = "up")

        if (m.voice_prompt_group.visible = true)

            m.mic_button_large.setFocus(true)
            m.last_focused_section = m.mic_button_large

        end if

    else if (direction = "right")
        
        m.search_results_grid.setFocus(true)
        m.last_focused_section = m.search_results_grid
    
    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    if (press = false)

        return false

    end if

    if (m.mic_button_large.hasFocus() = true)

        if (key = "down")

            m.keyboard.setFocus(true)
            m.last_focused_section = m.keyboard 

            return true

        else if (key = "OK")

            print "Mic button clicked! Start voice search..."

            return true

        end if

    else if (m.search_results_grid.hasFocus() = true)

        if (key = "left")

            m.keyboard.setFocus(true)
            m.last_focused_section = m.keyboard
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

sub _onFeedDataReceived()

    content_node = m.top.feedData

    if (content_node <> invalid)

        m.all_videos_flat = CreateObject("roSGNode", "ContentNode")

        for each row in content_node.getChildren(-1, 0)

            if (row <> invalid and row.getChildCount() > 0)

                for each video_item in row.getChildren(-1, 0)

                    new_item = CreateObject("roSGNode", "ContentNode")
                    
                    new_item.title = video_item.title
                    new_item.hdposterurl = video_item.hdposterurl
                    new_item.ReleaseDate = video_item.ReleaseDate
                    new_item.shortdescriptionline2 = video_item.shortdescriptionline2
                    
                    if (video_item.hasField("url"))

                        new_item.url = video_item.url

                    end if
                    
                    if (video_item.hasField("id"))

                        new_item.id = video_item.id

                    end if

                    if (video_item.hasField("description"))

                        new_item.description = video_item.description

                    end if

                    m.all_videos_flat.appendChild(new_item)

                end for

            end if

        end for

        _filterAndDisplayResults(m.keyboard.searchQuery)

    end if

end sub

sub _filterAndDisplayResults(query as String)

    if (m.all_videos_flat = invalid) 

        return

    end if

    query_lower = LCase(query)
    filtered_content = CreateObject("roSGNode", "ContentNode")

    for each video in m.all_videos_flat.getChildren(-1, 0)

        if (query_lower = "" or (video.title <> invalid and LCase(video.title).inStr(query_lower) >= 0))

            filtered_content.appendChild(video.clone(false))

        end if

    end for

    m.search_results_grid.content = filtered_content
    
    if (filtered_content.getChildCount() > 0)

        m.search_results_grid.visible = true

    else

        m.search_results_grid.visible = false

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
    _filterAndDisplayResults(query)

end sub

sub _onGridItemSelected()

    selected_index = m.search_results_grid.itemSelected
    
    selected_content = m.search_results_grid.content.getChild(selected_index)
    
    if selected_content <> invalid

        payload = {
            "screenName": "DetailsScreen",
            "contentData": selected_content
        }

        navigateTo(payload)

    end if

end sub
