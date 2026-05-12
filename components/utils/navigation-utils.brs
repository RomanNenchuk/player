function GetScreenManager() as Object

    screen_manager = m.top.getScene().findNode("screenManager")

    if (screen_manager = invalid)

        print "WARNING: 'screenManager' node not found in scene. Falling back to dummy node."
        return createObject("roSGNode", "Node")

    end if

    return screen_manager

end function

function GoToPreviousScreen() as Boolean

    handled = GetScreenManager().callFunc("GoBack")

    if (handled = invalid)

        return false

    end if

    return handled

end function

sub navigateTo(payload as Object)

    GetScreenManager().callFunc("navigateToScreen", payload)

end sub
