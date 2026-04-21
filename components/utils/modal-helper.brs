function ShowModal(config as Object) as Object

    modal = CreateObject("roSGNode", "Modal")

    if (modal <> invalid)

        modal.title = config.title
        modal.message = config.message
        modal.buttons = config.buttons
        
        m.current_modal_config = config
        m.current_modal = modal
        
        if (config.DoesExist("focusTarget") and config.focusTarget <> invalid)

            m.modal_focus_target = config.focusTarget

        else if (m.screens <> invalid and m.screens.Count() > 0)

            m.modal_focus_target = m.screens.Peek()

        else

            m.modal_focus_target = m.top

        end if
        
        modal.ObserveField("itemSelected", "_onModalItemSelected")
        
        m.top.AppendChild(modal)
        modal.SetFocus(true)

    end if

    return modal

end function

sub _onModalItemSelected(event as Object)

    selected_index = event.GetData()
    
    func_to_call = invalid
    data_to_pass = invalid

    if (m.current_modal_config <> invalid and m.current_modal_config.DoesExist("callbacks"))

        callbacks = m.current_modal_config.callbacks

        if (selected_index >= 0 and selected_index < callbacks.Count())

            callback_info = callbacks[selected_index]

            if (callback_info <> invalid and callback_info.DoesExist("func"))

                func_to_call = callback_info.func
                data_to_pass = callback_info.data

            end if

        end if

    end if

    ' close modal first
    dismissModal()

    ' execute callback
    if (func_to_call <> invalid)

        if (GetInterface(func_to_call, "ifFunction") <> invalid)

            func_to_call(data_to_pass)

        end if

    end if

end sub

sub dismissModal()

    if (m.current_modal <> invalid)

        m.current_modal.UnobserveField("itemSelected")
        m.top.RemoveChild(m.current_modal)
        m.current_modal = invalid
        m.current_modal_config = invalid

        if (m.modal_focus_target <> invalid)

            m.modal_focus_target.SetFocus(true)
            m.modal_focus_target = invalid

        end if

    end if

end sub
