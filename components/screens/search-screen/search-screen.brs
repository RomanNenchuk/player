sub init()

    setTopMenuVisible(true)

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
