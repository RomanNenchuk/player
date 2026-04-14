sub init()

    m.screen_stack = m.top.findNode("screenStack")
    m.screens = []
    m.top.ObserveField("focusedChild", "_onManagerFocusChange")

end sub

sub _onManagerFocusChange()

    if (m.top.hasFocus())

        if (m.screens <> invalid and m.screens.Count() > 0)

            m.screens.Peek().SetFocus(true)

        end if

    end if

end sub

sub navigateToScreen(payload as Object)

    if (payload <> invalid and payload.DoesExist("screenName"))

        new_screen = CreateObject("roSGNode", payload.screenName)

        if (new_screen <> invalid)

            if (payload.DoesExist("contentData"))

                new_screen.content = payload.contentData

            end if

            if (m.screens.Count() > 0)

                m.screens.Peek().visible = false

            end if

            m.screen_stack.AppendChild(new_screen)
            m.screens.Push(new_screen)

            new_screen.SetFocus(true)

            m.top.activeScreen = payload.screenName

        else

            print "Navigation Error: Failed to create screen - "; payload.screenName

            focus_target = m.top
            if (payload.DoesExist("errorFocusTarget") and payload.errorFocusTarget <> invalid)

                focus_target = payload.errorFocusTarget

            end if

            ShowModal({
                "title": "Navigation Error",
                "message": "Requested page unavailable. Please try again.",
                "buttons": ["OK"],
                "focusTarget": focus_target
            })

        end if

    else

        print "Navigation Error: Payload is invalid or missing 'screenName'"

        ShowModal({
            "title": "Invalid Request",
            "message": "The navigation request was invalid. Please try again.",
            "buttons": ["OK"],
            "focusTarget": m.top
        })

    end if

end sub

function GoBack() as Boolean

    handled = false

    if (m.screens.Count() > 1)

        current_screen = m.screens.Pop()
        m.screen_stack.RemoveChild(current_screen)

        prev_screen = m.screens.Peek()
        prev_screen.visible = true
        prev_screen.SetFocus(true)
        
        ' subtype returns the name of prev_screen's component, 
        ' specified in its xml file, e.g. name="HomeScreen"
        m.top.activeScreen = prev_screen.subtype()

        handled = true

    end if

    return handled

end function
