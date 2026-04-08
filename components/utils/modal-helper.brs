function showModal(config as Object) as Object
    
    scene = m.top.getScene()
    modal = invalid
    
    if (scene <> invalid)
        
        modal = CreateObject("roSGNode", "Modal")
        
        if (modal <> invalid)
            
            modal.title = config.title
            modal.message = config.message
            modal.buttons = config.buttons
            
            modal.ObserveField("itemSelected", "_onModalDismissed")
            
            scene.AppendChild(modal)
            modal.SetFocus(true)
            
            m.current_modal = modal
            
        end if
        
    end if
    
    return modal
    
end function

sub _onModalDismissed(event as Object)
    
    selected_index = event.GetData()
    scene = m.top.getScene()
    
    if (m.current_modal <> invalid and scene <> invalid)
        
        m.current_modal.UnobserveField("itemSelected")
        scene.RemoveChild(m.current_modal)
        m.current_modal = invalid
        
        if (m.screens <> invalid and m.screens.Count() > 0)
            
            m.screens.Peek().SetFocus(true)
            
        end if
        
    end if
    
end sub
