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
