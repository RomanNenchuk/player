sub init()

    m.screen_stack = m.top.findNode("screenStack")
    m.screens = []

end sub

sub navigateToScreen(payload as Object)

    if (payload = invalid or not payload.DoesExist("screenName"))

        print "Navigation Error: Payload is invalid or missing 'screenName'"

        _requestDialog({
            "title": "Invalid Request",
            "message": "The navigation request was invalid. Please try again.",
            "buttons": ["OK"],
            "actions": ["dismiss"],
            "focusTarget": m.screens.Peek()
        })

        return

    end if

    new_screen = CreateObject("roSGNode", payload.screenName)

    if (new_screen = invalid)

        print "Navigation Error: Failed to create screen - "; payload.screenName

        _requestDialog({
            "title": "Navigation Error",
            "message": "Requested page unavailable. Please try again.",
            "buttons": ["OK"],
            "actions": ["dismiss"]
            "focusTarget": m.screens.Peek()
        })

        return

    end if

    new_screen.ObserveField("dialogRequest", "_onScreenDialogRequest")

    if (payload.DoesExist("contentData"))

        new_screen.content = payload.contentData

    end if

    if (m.screens.Count() > 0)

        prev_screen = m.screens.Peek()
        prev_screen.visible = false

    end if

    m.screen_stack.AppendChild(new_screen)
    m.screens.Push(new_screen)

    dialog_manager = m.top.GetScene().findNode("dialogManager")

    if (dialog_manager = invalid or not dialog_manager.isDialogVisible)

        new_screen.SetFocus(true)

    end if


end sub

function GoBack() as Boolean

    handled = false

    if (m.screens.Count() > 1)

        current_screen = m.screens.Pop()
        current_screen.UnobserveField("dialogRequest")
        m.screen_stack.RemoveChild(current_screen)

        prev_screen = m.screens.Peek()
        prev_screen.visible = true

        prev_screen.SetFocus(true)
        handled = true

    end if

    return handled

end function

sub _onScreenDialogRequest(event as Object)

    config = event.GetData()
    _requestDialog(config)

end sub

sub _requestDialog(config as Object)

    dialog_manager = m.top.GetScene().findNode("dialogManager")

    if (dialog_manager = invalid)

        print "ScreenManager Error: dialogManager node not found"
        return

    end if

    dialog_manager.showDialog = config

end sub
