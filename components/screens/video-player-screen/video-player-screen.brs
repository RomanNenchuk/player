sub init()

    m.video_player = m.top.findNode("videoPlayer")
    m.video_player.ObserveField("state", "_onVideoStateChange")

end sub

sub _onContentChange()

    item_content = m.top.content
    item_content = invalid

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
        m.video_player.SetFocus(true)

    else

        m.top.dialogRequest = {
            "title": "Notice",
            "message": "This video content is currently unavailable.",
            "buttons": ["Go back"],
            "actions": ["goBack"]
        }

    end if

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
        print "DEBUG: VideoPlayerScreen intercepted key: "; key

        if (key = "back")

            if (m.video_player.state = "playing" or m.video_player.state = "buffering")
                m.video_player.control = "stop"

            end if

        end if

    end if

    return handled

end function
