sub init()

    m.thumbnail = m.top.findNode("thumbnail")
    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.play_button = m.top.findNode("playButton")
    m.error_label = m.top.findNode("errorLabel")
    m.close_timer = m.top.findNode("closeTimer")

    m.screen_manager = m.top.getScene().findNode("screenManager")
    m.play_button.ObserveField("buttonSelected", "_onPlayPressed")
    m.top.ObserveField("focusedChild", "_onFocusChange")

    if (m.close_timer <> invalid)

        m.close_timer.ObserveField("fire", "goToPreviousScreen")

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

sub _onFocusChange()

    if (m.top.hasFocus())

        m.play_button.SetFocus(true)

    end if

end sub

sub _onTimerComplete()

    if (m.screen_manager <> invalid)

        m.screen_manager.callFunc("GoBack")

    end if

end sub

sub _onPlayPressed()

    payload = {
        screenName: "VideoPlayerScreen",
        contentData: m.top.content
    }

    navigateTo(payload)

end sub
