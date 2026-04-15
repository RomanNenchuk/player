sub init()

    m.menu_grid = m.top.findNode("menuGrid")
    m.menu_grid.ObserveField("itemSelected", "_onItemSelected")
    m.top.ObserveField("focusedChild", "_onFocusChange")

    _setupMenu()

end sub

sub _onFocusChange()

    if (m.top.hasFocus())

        m.menu_grid.SetFocus(true)

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

    content = CreateObject("roSGNode", "ContentNode")

    for i = 0 to tabs.count() - 1

        menu_tab = tabs[i]
        
        item = content.CreateChild("ContentNode")
        item.title = menu_tab.title
        item.id = menu_tab.screen
        
        if (menu_tab.icon <> invalid)
        
            item.HDPosterUrl = menu_tab.icon
        
        end if
        
        item.addField("isActive", "boolean", false)
        
        if (i = 0)

            item.isActive = true

        end if

    end for

    m.menu_grid.content = content

end sub

sub _onItemSelected()

    selected_index = m.menu_grid.itemSelected
    selected_item = m.menu_grid.content.getChild(selected_index)
    
    m.top.itemSelected = { screenName: selected_item.id }

end sub

sub _onActiveTabChange()

    active_id = m.top.activeTab
    total_items = m.menu_grid.content.getChildCount()

    for i = 0 to total_items - 1

        child = m.menu_grid.content.getChild(i)
        child.isActive = (child.id = active_id)

    end for

end sub
