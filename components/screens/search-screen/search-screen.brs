sub init()

    m.keyboard_grid = m.top.findNode("keyboard_grid")
    m.results_grid = m.top.findNode("results_grid")
    m.debounce_timer = m.top.findNode("debounce_timer")
    m.empty_state_label = m.top.findNode("empty_state_label")
    m.search_results_title = m.top.findNode("search_results_title")
    m.voice_prompt_group = m.top.findNode("voice_prompt_group")

    m.search_query = ""

    m.debounce_timer.ObserveField("fire", "_onDebounceTimerFired")
    m.keyboard_grid.ObserveField("itemSelected", "_onKeyboardItemSelected")

    _checkVoiceSupport()
    _setupKeyboard()

end sub

sub _checkVoiceSupport()

    device_info = CreateObject("roDeviceInfo")
    has_voice_support = device_info.HasFeature("audio_in")
    
    ' Remove this in production
    has_voice_support = true

    if (has_voice_support = true)

        m.voice_prompt_group.visible = true

    else

        m.voice_prompt_group.visible = false

    end if

end sub

sub _setupKeyboard()

    keyboard_content = CreateObject("roSGNode", "ContentNode")
    
    keys = [
        "a", "b", "c", "d", "e", "f", 
        "g", "h", "i", "j", "k", "l", 
        "m", "n", "o", "p", "q", "r", 
        "s", "t", "u", "v", "w", "x", 
        "y", "z", "1", "2", "3", "4", 
        "5", "6", "7", "8", "9", "0",
        "clear", "empty", "space", "empty", "backspace", "empty"
    ]
    
    current_index = 0
    total_keys = keys.count()
    
    while (current_index < total_keys)

        key_id = keys[current_index]
        key_node = keyboard_content.createChild("ContentNode")
        
        key_node.id = key_id
        
        if (key_id <> "empty" and key_id <> "clear" and key_id <> "space" and key_id <> "backspace")

            key_node.title = key_id

        end if
        
        current_index = current_index + 1

    end while
    
    m.keyboard_grid.content = keyboard_content

end sub

sub _onKeyboardItemSelected(event as Object)

    selected_index = event.getData()
    selected_item = m.keyboard_grid.content.getChild(selected_index)
    
    key_id = selected_item.id

    if (key_id = "empty")

        return

    else if (key_id = "clear")

        m.search_query = ""

    else if (key_id = "backspace")

        if (Len(m.search_query) > 0)

            m.search_query = Left(m.search_query, Len(m.search_query) - 1)

        end if

    else if (key_id = "space")

        m.search_query = m.search_query + " "

    else

        m.search_query = m.search_query + selected_item.title

    end if

    _updateUiState()

end sub

sub _updateUiState()

    if (m.search_query = "")

        m.empty_state_label.visible = true
        m.results_grid.visible = false
        m.search_results_title.visible = false
        m.debounce_timer.control = "stop"

    else

        m.empty_state_label.visible = false
        m.search_results_title.text = "Search results for " + Chr(34) + m.search_query + Chr(34)
        m.search_results_title.visible = true
        m.debounce_timer.control = "start"

    end if

end sub

sub _onDebounceTimerFired()

    _filterLocalVideos()

end sub

sub _filterLocalVideos()

    MAX_RESULTS_LIMIT = 50

    filtered_results_node = CreateObject("roSGNode", "ContentNode")

    if (m.global <> invalid and m.global.video_catalog <> invalid)

        total_videos = m.global.video_catalog.getChildCount()
        current_index = 0
        added_count = 0

        while (current_index < total_videos)

            video_node = m.global.video_catalog.getChild(current_index)
            title = video_node.title
            
            match_position = Instr(1, title, m.search_query)

            if (match_position > 0)

                cloned_video = video_node.clone(true)
                filtered_results_node.appendChild(cloned_video)
                added_count = added_count + 1

            end if

            if (added_count >= MAX_RESULTS_LIMIT)

                exit while

            end if

            current_index = current_index + 1

        end while

    end if

    m.results_grid.content = filtered_results_node
    m.results_grid.visible = true

end sub
