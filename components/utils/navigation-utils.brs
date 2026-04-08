function GetScreenManager() as Object

    return m.top.getScene().findNode("screenManager")

end function

sub goToPreviousScreen() as Boolean

    handled = false
    screen_manager = GetScreenManager()

    if (screen_manager <> invalid)

        handled = screen_manager.callFunc("GoBack")

    end if

    return handled

end sub

sub navigateTo(payload as Object)

    screen_manager = GetScreenManager()

    if (screen_manager <> invalid)

        screen_manager.callFunc("navigateToScreen", payload)

    end if

end sub
