sub init()

    m.menu_group = m.top.findNode("menuGroup")
    m.current_focus_index = 0
    m.menu_items = []

    m.top.ObserveField("focusedChild", "_onFocusChange")

    _setupMenu()

end sub

sub _onFocusChange()

    if (m.top.hasFocus() and m.menu_items.count() > 0)

        m.menu_items[m.current_focus_index].SetFocus(true)

    end if

end sub

sub _setupMenu()

    tabs = [
        { title: "", screen: "SearchScreen", icon: "pkg:/images/search_icon.png" },
        { title: "Home", screen: "HomeScreen" },
        { title: "Shows", screen: "ShowsScreen" },
        { title: "Movies", screen: "MoviesScreen" },
        { title: "On Now", screen: "OnNowScreen" },
        { title: "Settings", screen: "SettingsScreen" }
    ]

    for i = 0 to tabs.count() - 1
        
        menu_tab = tabs[i]
        
        content = CreateObject("roSGNode", "ContentNode")
        content.title = menu_tab.title
        content.id = menu_tab.screen
        
        if (menu_tab.icon <> invalid)

            content.HDPosterUrl = menu_tab.icon

        end if
        
        content.addField("isActive", "boolean", false)
        
        if (i = 0)
            
            content.isActive = true
            
        end if
        
        item = m.menu_group.CreateChild("TopMenuItem")
        item.itemContent = content
        
        m.menu_items.push(item)
        
    end for

end sub

sub _onActiveTabChange()

    active_id = m.top.activeTab

    for i = 0 to m.menu_items.count() - 1
        
        child = m.menu_items[i]
        content = child.itemContent
        
        if (content <> invalid)
            
            is_active = (content.id = active_id)
            content.isActive = is_active
            child.itemContent = content

            if (is_active)

                m.current_focus_index = i
            
            end if
            
        end if
        
    end for

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false

    if (press)
        
        if (key = "right")
            
            if (m.current_focus_index < m.menu_items.count() - 1)
                
                m.current_focus_index += 1
                m.menu_items[m.current_focus_index].SetFocus(true)
                handled = true
                
            end if
            
        else if (key = "left")
            
            if (m.current_focus_index > 0)
                
                m.current_focus_index -= 1
                m.menu_items[m.current_focus_index].SetFocus(true)
                handled = true
                
            end if
            
        else if (key = "OK")
            
            selected_item = m.menu_items[m.current_focus_index]
            m.top.itemSelected = { screenName: selected_item.itemContent.id }
            handled = true
            
        end if
        
    end if
    
    return handled

end function
