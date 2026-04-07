sub init()

    m.thumbnail = m.top.FindNode("thumbnail")
    m.title = m.top.FindNode("title")
    m.description = m.top.FindNode("description")
    m.play_button = m.top.FindNode("playButton")

end sub

' Triggered when the "content" interface field is set
sub OnContentChange()

    item_content = m.top.content
    
    if item_content <> invalid
        ' Populate the UI with data from the parsed RSS feed ContentNode
        m.thumbnail.uri = item_content.HDPosterUrl
        m.title.text = item_content.title
        m.description.text = item_content.description
        
        ' Set focus to the play button so the user can interact immediately
        m.play_button.SetFocus(true)
    end if

end sub

' Ensure the component can handle back presses if needed, 
' though your main-scene screen stack might handle this globally.
function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false
    if press then
        ' Future logic: handle "OK" press on the play_button to launch the Video node
    end if
    return handled

end function