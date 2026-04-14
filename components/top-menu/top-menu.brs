sub init()

    m.menu_grid = m.top.findNode("menuGrid")
    
    m.menu_grid.ObserveField("itemSelected", "_onItemSelected")

    _setupMenu()

end sub

sub _setupMenu()

    tabs = [
        { title: "Home", screen: "HomeScreen" },
        { title: "Shows", screen: "ShowsScreen" },
        { title: "Movies", screen: "MoviesScreen" },
        { title: "On Now", screen: "OnNowScreen" },
        { title: "Settings", screen: "SettingsScreen" }
    ]

    content = CreateObject("roSGNode", "ContentNode")

    for each menu_tab in tabs

        item = content.CreateChild("ContentNode")
        item.title = menu_tab.title
        item.id = menu_tab.screen

    end for

    m.menu_grid.content = content

end sub

sub _onItemSelected()

    selected_index = m.menu_grid.itemSelected
    selected_item = m.menu_grid.content.getChild(selected_index)

    m.top.itemSelected = { screenName: selected_item.id }

end sub
