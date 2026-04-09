sub init()

    m.video_player = m.top.findNode("videoPlayer")
    m.video_player.ObserveField("state", "_onVideoStateChange")

end sub

sub _onContentChange()

    item_content = m.top.content

    if (item_content <> invalid)

        video_content = CreateObject("roSGNode", "ContentNode")
        video_content.url = item_content.url
        video_content.title = item_content.title

        stream_format = item_content.streamformat

        if (stream_format = invalid or stream_format = "")

            stream_format = "mp4"

        end if

        video_content.streamFormat = stream_format
        
        m.video_player.content = video_content
        m.video_player.control = "play"
        m.video_player.setFocus(true)

    else

        modal_config = {
            "title": "Notice",
            "message": "This video content is currently unavailable.",
            "buttons": ["Go back"]
        }
        modal = ShowModal(modal_config)
        
        if (modal <> invalid)
            
            modal.ObserveField("itemSelected", "_onVideoModalDismissed")

        end if

    end if

end sub

sub _onVideoModalDismissed(event as Object)

    dismissModal(event)
    goToPreviousScreen()

end sub

sub _onVideoStateChange()

    state = m.video_player.state
    
    if (state = "finished" or state = "error")

        m.video_player.control = "stop"
        goToPreviousScreen()

    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false
    
    if (press)
    
        if (key = "back")
    
            if (m.video_player.state = "playing" or m.video_player.state = "buffering")
    
                m.video_player.control = "stop"
    
            end if
    
        end if
    
    end if
    
    return handled

end function

sub _onModalDismissed(event as Object)

    print "_onModalDismissed in VideoPlayer!!!!"

    scene = m.top.getScene()

    if (m.current_modal <> invalid and scene <> invalid)
        scene.RemoveChild(m.current_modal)
        m.current_modal = invalid
    end if

    goToPreviousScreen()

end sub
