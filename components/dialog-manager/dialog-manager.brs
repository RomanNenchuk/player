sub init()

    m.current_dialog = invalid
    m.current_dialog_config = invalid
    m.focus_target = invalid

    m.action_handlers = {
        "goBack": sub(focus_target as Object)

            goToPreviousScreen()

        end sub,

        "dismiss": sub(focus_target as Object)

            if (focus_target <> invalid)

                focus_target.SetFocus(true)

            end if

        end sub
    }

end sub

sub _onShowDialog()

    config = m.top.showDialog

    if (config = invalid)

        return

    end if

    _dismissDialog()

    dialog = CreateObject("roSGNode", "CustomDialog")

    if (dialog = invalid)

        print "DialogManager Error: Failed to create CustomDialog node"
        return

    end if

    dialog.title = config.title
    dialog.message = config.message
    dialog.buttons = config.buttons

    m.current_dialog = dialog
    m.current_dialog_config = config

    if (config.DoesExist("focusTarget") and config.focusTarget <> invalid)

        m.focus_target = config.focusTarget

    else

        m.focus_target = m.top

    end if

    dialog.ObserveField("itemSelected", "_onDialogItemSelected")

    m.top.AppendChild(dialog)
    m.top.isDialogVisible = true
    dialog.SetFocus(true)

end sub

sub _onDialogItemSelected(event as Object)

    selected_index = event.GetData()
    config = m.current_dialog_config
    focus_target = m.focus_target

    _dismissDialog()

    if (config = invalid or not config.DoesExist("actions"))

        return

    end if

    actions = config.actions

    if (selected_index < 0 or selected_index >= actions.Count())

        return

    end if

    action = actions[selected_index]

    _handleAction(action, focus_target)

end sub

sub _handleAction(action as String, focus_target as Object)

    handler = m.action_handlers[action]

    if (handler <> invalid)

        handler(focus_target)

    else

        print "DialogManager Warning: Unknown action - "; action

    end if

end sub

sub _dismissDialog()

    if (m.current_dialog = invalid)

        return

    end if

    m.current_dialog.UnobserveField("itemSelected")
    m.top.RemoveChild(m.current_dialog)
    m.top.isDialogVisible = false

    m.current_dialog = invalid
    m.current_dialog_config = invalid

    if (m.focus_target <> invalid)

        m.focus_target.SetFocus(true)
        m.focus_target = invalid

    end if

end sub
