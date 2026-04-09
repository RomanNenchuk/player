function ShowModal(config as Object) as Object
    
    scene = m.top.getScene()
    modal = invalid
    
    if (scene <> invalid)
        
        modal = CreateObject("roSGNode", "Modal")
        
        if (modal <> invalid)

            modal.title = config.title
            modal.message = config.message
            modal.buttons = config.buttons
            scene.AppendChild(modal)
            
            m.current_modal = modal
            
        end if
        
    end if
    
    return modal
    
end function

sub dismissModal(event as Object)
    
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
