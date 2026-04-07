sub init()

    m.thumbnail = m.top.FindNode("thumbnail")
    m.title = m.top.FindNode("title")
    m.description = m.top.FindNode("description")
    m.play_button = m.top.FindNode("playButton")

end sub

sub onContentChange()

    item_content = m.top.content
    
    if item_content <> invalid

        m.thumbnail.uri = item_content.HDPosterUrl
        m.title.text = item_content.title
        m.description.text = item_content.description
        
        m.play_button.SetFocus(true)
    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false
    if press then
        
        ' Future logic: handle "OK" press on the play_button to launch the Video node
    end if
    
    return handled

end function
