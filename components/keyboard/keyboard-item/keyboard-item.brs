sub init()

    m.background_rect = m.top.findNode("background_rect")
    m.letter_label = m.top.findNode("letter_label")
    m.icon_poster = m.top.findNode("icon_poster")

end sub

sub _onItemContentChange()

    if (m.top.itemContent = invalid) return

    key_id = m.top.itemContent.id

    if (key_id = "empty")

        m.background_rect.visible = false
        m.letter_label.visible = false
        m.icon_poster.visible = false
        
    else if (key_id = "clear" or key_id = "space" or key_id = "backspace")
        
        m.background_rect.visible = true
        ' 90 (first cell) + 3 (itemSpacing) + 90 (second cell) = 183
        m.background_rect.width = 183
        
        m.letter_label.visible = false
        m.icon_poster.visible = true

        if (key_id = "clear")

            m.icon_poster.uri = "pkg:/images/icon_trash.png"
            m.icon_poster.width = 25
            m.icon_poster.height = 25
            m.icon_poster.translation = [79, 32]
        
        else if (key_id = "space")
        
            m.icon_poster.uri = "pkg:/images/icon_space.png"
            m.icon_poster.width = 40
            m.icon_poster.height = 25
            m.icon_poster.translation = [71, 32]
        
        else if (key_id = "backspace")
        
            m.icon_poster.uri = "pkg:/images/icon_backspace.png"
            m.icon_poster.width = 25
            m.icon_poster.height = 25
            m.icon_poster.translation = [79, 32]
        
        end if
        
    else

        m.background_rect.visible = true
        m.background_rect.width = 90
        
        m.icon_poster.visible = false
        m.letter_label.visible = true
        m.letter_label.width = 90
        
        if (m.top.itemContent.title <> invalid)

            m.letter_label.text = m.top.itemContent.title

        else

            m.letter_label.text = ""

        end if

    end if

    _updateFocusState()

end sub

sub _onFocusChange()

    _updateFocusState()

end sub

sub _updateFocusState()

    if (m.top.itemContent = invalid or m.top.itemContent.id = "empty") 
    
        return
    
    end if
    
    if (m.top.itemHasFocus = true)

        m.background_rect.color = "0xDF46C1FF" 
        m.letter_label.color = "0x000000FF"

    else

        m.background_rect.color = "0x222222FF" 
        m.letter_label.color = "0xFFFFFFFF"

    end if

end sub
