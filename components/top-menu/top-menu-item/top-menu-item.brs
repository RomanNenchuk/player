sub init()

    m.tab_label = m.top.findNode("tabLabel")
    m.tab_label_bold = m.top.findNode("tabLabelBold")
    m.focus_indicator = m.top.findNode("focusIndicator")
    m.tab_icon = m.top.findNode("tabIcon")

    m.top.ObserveField("focusedChild", "_onFocusChange")

end sub

sub _onFocusChange()

    _updateVisualState()

end sub

sub _onContentChange()

    content = m.top.itemContent

    if (content <> invalid)
        
        if (content.HDPosterUrl <> "")
            
            m.tab_icon.uri = content.HDPosterUrl
            m.tab_icon.visible = true
            
            m.tab_label.visible = false
            m.tab_label_bold.visible = false
            m.focus_indicator.width = 60
            m.focus_indicator.translation = [70, 46]
            
        else
            
            m.tab_label.text = content.title
            m.tab_label_bold.text = content.title
            m.tab_icon.visible = false

            text_rect = m.tab_label_bold.boundingRect()
            text_width = text_rect.width
            
            print text_width
            
            offset_x = (200 - text_width) / 2
            m.tab_label.translation = [offset_x, 0]
            m.tab_label_bold.translation = [offset_x, 0]

            m.focus_indicator.width = text_width
            m.focus_indicator.translation = [offset_x, 46]
            
        end if
        
        _updateVisualState()
        
    end if
    
end sub

sub _updateVisualState()

    is_active_page = false
    content = m.top.itemContent

    if (content <> invalid and content.hasField("isActive"))
        
        is_active_page = content.isActive
        
    end if
    
    is_focused = m.top.hasFocus()

    if (is_focused or is_active_page)
        
        m.tab_label.visible = false
        m.tab_label_bold.visible = true
        
        if (m.tab_icon <> invalid)
            
            m.tab_icon.blendColor = "0xFFFFFFFF"
            
        end if
        
    else
        
        m.tab_label.visible = true
        m.tab_label_bold.visible = false
        
        if (m.tab_icon <> invalid)
            
            m.tab_icon.blendColor = "0x888888FF"
            
        end if
        
    end if
    
    m.focus_indicator.visible = is_focused

end sub
