function ShowModal(config as Object) as Object

    if (m.current_modal <> invalid)

        dismissModal()

    end if

    modal = CreateObject("roSGNode", "Modal")

    if (modal = invalid)

        return invalid

    end if

    modal.title = config.title
    modal.message = config.message
    modal.buttons = config.buttons

    m.current_modal = modal
    m.current_modal_config = config

    modal.ObserveField("itemSelected", "_onModalItemSelected")

    m.top.AppendChild(modal)
    modal.SetFocus(true)

    return modal

end function

sub _onModalItemSelected(event as Object)

    selected_index = event.GetData()
    
    func_to_call = invalid
    data_to_pass = invalid
    has_data = false

    if (m.current_modal_config <> invalid and m.current_modal_config.DoesExist("callbacks"))

        callbacks = m.current_modal_config.callbacks

        if (selected_index >= 0 and selected_index < callbacks.Count())

            callback_info = callbacks[selected_index]

            if (callback_info <> invalid and callback_info.DoesExist("func"))

                func_to_call = callback_info.func
                
                if (callback_info.DoesExist("data"))

                    data_to_pass = callback_info.data
                    has_data = true

                end if

            end if

        end if

    end if

    ' close modal first
    dismissModal()

    ' execute callback
    if (func_to_call <> invalid and GetInterface(func_to_call, "ifFunction") <> invalid)

        if (has_data)

            func_to_call(data_to_pass)

        else

            func_to_call()

        end if

    end if

end sub

sub dismissModal()

    if (m.current_modal = invalid)

        return

    end if

    m.current_modal.UnobserveField("itemSelected")
    m.top.RemoveChild(m.current_modal)

    m.current_modal = invalid
    m.current_modal_config = invalid

    if (m.current_modal_focus_target <> invalid)

        m.current_modal_focus_target.SetFocus(true)
        m.current_modal_focus_target = invalid

    else if (m.screen_manager <> invalid)

        m.screen_manager.SetFocus(true)

    else

        m.top.SetFocus(true)

    end if

end sub
