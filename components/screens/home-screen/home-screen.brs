sub init()

    hideTopMenu()

    m.hero = m.top.findNode("hero")
    m.content_row_list = m.top.findNode("contentRowList")
    
    m.hide_hero_anim = m.top.findNode("hideHeroAnim")
    m.show_hero_anim = m.top.findNode("showHeroAnim")
    m.custom_splash_screen = m.top.findNode("customSplashScreen")

    m.content_row_list.ObserveField("rowItemSelected", "_onRowItemSelected")
    m.content_row_list.ObserveField("content", "_onContentLoad")
    m.top.ObserveField("focusedChild", "_onFocusChange")

    m.last_focused_element = m.hero
    
    initDataLoader()

end sub

sub _onFeedDataReceived()

    if (m.top.feedData <> invalid)

        m.content_row_list.content = m.top.feedData

    end if

end sub

sub _onContentLoad()

    if (m.content_row_list.content <> invalid and m.content_row_list.content.getChildCount() > 0)

        first_row = m.content_row_list.content.getChild(0)
        
        if (first_row <> invalid and first_row.getChildCount() > 0)

            m.hero.content = first_row.getChild(0)

        end if

        m.hero.visible = true
        m.content_row_list.visible = true

        if (m.custom_splash_screen <> invalid)
            
            m.custom_splash_screen.visible = false
        
        end if

        showTopMenu()

    end if

end sub

sub _onRowItemSelected()

    row_index = m.content_row_list.rowItemSelected[0]
    col_index = m.content_row_list.rowItemSelected[1]
    
    selected_content = m.content_row_list.content.GetChild(row_index).GetChild(col_index)
    m.last_focused_element = m.content_row_list
    
    payload = {
        "screenName": "DetailsScreen",
        "contentData": selected_content
    }

    navigateTo(payload)

end sub

sub _onFocusChange()

    if (m.top.hasFocus())

        if (m.last_focused_element <> invalid)

            m.last_focused_element.SetFocus(true)

        end if

    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false

    if (press)

        if (m.hero.isInFocusChain())

            if (key = "down")

                m.content_row_list.SetFocus(true)
                m.last_focused_element = m.content_row_list
                m.hide_hero_anim.control = "start"
                handled = true

            end if

        else if (m.content_row_list.isInFocusChain())

            current_row = m.content_row_list.rowItemFocused[0]
            total_rows = m.content_row_list.content.getChildCount()

            if (key = "up" and current_row = 0)

                m.hero.SetFocus(true)
                m.last_focused_element = m.hero
                m.show_hero_anim.control = "start"
                handled = true

            else if (key = "down" and current_row = total_rows - 1)

                m.content_row_list.jumpToRowItem = [0, 0]
                m.hero.SetFocus(true)
                m.last_focused_element = m.hero
                m.show_hero_anim.control = "start"
                handled = true

            end if

        end if

    end if

    return handled

end function
