sub init()

    m.top.createChild("TrackerTask")
    m.screen_manager = m.top.findNode("screenManager")
    m.screen_manager.ObserveField("activeScreen", "_onScreenChanged")
    m.top_menu = m.top.findNode("topMenu")
    m.top_menu.ObserveField("itemSelected", "_onMenuItemSelected")

    m.main_screens = {
        "HomeScreen": true,
        "ShowsScreen": true,
        "MoviesScreen": true,
        "OnNowScreen": true,
        "SettingsScreen": true,
        "SearchScreen": true
    }

    navigateTo({
        "screenName": "HomeScreen"
    })

end sub

sub _onScreenChanged(event as Object)

    active_screen_name = event.getData()
    m.top_menu.activeTab = active_screen_name
    m.top_menu.visible = m.main_screens.DoesExist(active_screen_name)

end sub

sub _onMenuItemSelected(event as Object)

    payload = event.getData()
    payload.errorFocusTarget = m.top_menu
    navigateTo(payload)

end sub
