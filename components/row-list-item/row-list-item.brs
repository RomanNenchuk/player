sub init()

    m.poster = m.top.findNode("poster")
    m.title_label = m.top.findNode("title_label")
    m.duration_label = m.top.findNode("duration_label")
    m.duration_bg = m.top.findNode("durationBg")
    m.date_label = m.top.findNode("date_label")
    
end sub

sub _onContentChange()

    item_data = m.top.itemContent
    
    if (item_data <> invalid)
        m.poster.uri = item_data.hdposterurl
        m.title_label.text = item_data.title
        
        pubDateStr = item_data.ReleaseDate
        if pubDateStr <> invalid and pubDateStr <> ""
            m.date_label.text = GetTimeAgo(pubDateStr)
        end if

        duration_str = item_data.shortdescriptionline2
        
        if (duration_str <> "")
            m.duration_label.width = 0 
            m.duration_label.text = duration_str
            
            text_rect = m.duration_label.boundingRect()
            text_width = text_rect.width
            
            padding_x = 16
            margin_right = 10
            margin_bottom = 10
            
            bg_width = text_width + padding_x
            
            m.duration_bg.width = bg_width
            m.duration_label.width = bg_width
            
            poster_width = m.poster.width
            poster_height = m.poster.height
            
            bg_x = poster_width - bg_width - margin_right
            bg_y = poster_height - m.duration_bg.height - margin_bottom
            
            m.duration_bg.translation = [bg_x, bg_y]
            m.duration_bg.visible = true
        else
            m.duration_bg.visible = false
        end if
        
    end if
    
end sub
