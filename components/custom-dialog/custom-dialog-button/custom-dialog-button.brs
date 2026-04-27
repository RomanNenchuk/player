sub init()
    
    m.button_background = m.top.findNode("buttonBackground")
    m.button_text = m.top.findNode("buttonText")
    
end sub

sub onContentChange()
    
    if (m.top.itemContent <> invalid)
        
        m.button_text.text = m.top.itemContent.title
        
    end if
    
end sub

sub onFocusChange()
    
    if (m.top.focusPercent > 0.5)
        
        m.button_background.color = "0xFFFFFFFF"
        m.button_text.color = "0x000000FF"
        
    else
        
        m.button_background.color = "0x00000000"
        m.button_text.color = "0xFFFFFFFF"
        
    end if
    
end sub
