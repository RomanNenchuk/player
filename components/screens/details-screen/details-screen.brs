sub init()

    m.thumbnail = m.top.findNode("thumbnail")
    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.play_button = m.top.findNode("playButton")
    m.error_label = m.top.findNode("errorLabel")
    m.close_timer = m.top.findNode("closeTimer")

    if (m.close_timer <> invalid)

        m.close_timer.ObserveField("fire", "onTimerComplete")

    end if

end sub

sub onContentChange()

    item_content = m.top.content
    
    if (item_content <> invalid)

        m.error_label.visible = false
        m.thumbnail.visible = true
        m.title.visible = true
        m.description.visible = true
        m.play_button.visible = true

        m.thumbnail.uri = item_content.HDPosterUrl
        m.title.text = item_content.title
        m.description.text = item_content.description
        
        m.play_button.SetFocus(true)
        
    else

        m.thumbnail.visible = false
        m.title.visible = false
        m.description.visible = false
        m.play_button.visible = false

        m.error_label.visible = true

        m.top.SetFocus(true)

        if (m.close_timer <> invalid)

            m.close_timer.control = "start"

        end if

    end if

end sub

sub onTimerComplete()

    screen_manager = m.top.getScene().findNode("screenManager")

    if (screen_manager <> invalid)

        screen_manager.callFunc("GoBack")

    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false
    if press then
        
        ' Future logic: handle "OK" press on the play_button to launch the Video node
    end if
    
    return handled

end function
