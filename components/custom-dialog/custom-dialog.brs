sub init()
    
    m.background_overlay = m.top.findNode("backgroundOverlay")
    m.dialog_container = m.top.findNode("dialogContainer")
    m.title_label = m.top.findNode("titleLabel")
    m.message_label = m.top.findNode("messageLabel")
    m.button_list = m.top.findNode("buttonList")
    
    m.button_list.ObserveField("itemSelected", "_onButtonSelected")
    
    m.top.ObserveField("focusedChild", "_onFocusChange")
    
end sub

sub onTitleChange()
    
    m.title_label.text = m.top.title
    
end sub

sub onMessageChange()
    
    m.message_label.text = m.top.message
    
end sub

sub onButtonsChange()
    
    content = CreateObject("roSGNode", "ContentNode")
    
    for each btn_text in m.top.buttons
        
        item = content.CreateChild("ContentNode")
        item.title = btn_text
        
    end for
    
    m.button_list.content = content
    
end sub

sub _onFocusChange()

    if (m.top.hasFocus())
        
        m.button_list.SetFocus(true)
        
    end if
    
end sub

sub _onButtonSelected(event as Object)
    
    m.top.itemSelected = event.GetData()
    
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    
    handled = false
    
    if (press)
        
        if (key = "back")
            
            m.top.itemSelected = -1
            handled = true
            
        end if
        
    end if
    
    return handled
    
end function
