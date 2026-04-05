sub init()

    m.poster = m.top.findNode("poster")
    m.title_label = m.top.findNode("title_label")
    m.duration_label = m.top.findNode("duration_label")
    m.duration_bg = m.top.findNode("duration_bg")
    
end sub

sub _onContentChange()

    item_data = m.top.itemContent
    
    if (item_data <> invalid)
        m.poster.uri = item_data.hdposterurl
        m.title_label.text = item_data.title
        
        if (item_data.shortdescriptionline2 <> "")
            m.duration_label.text = item_data.shortdescriptionline2
            m.duration_bg.visible = true
        else
            m.duration_bg.visible = false
        end if
        
    end if
    
end sub