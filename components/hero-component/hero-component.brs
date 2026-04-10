sub init()

    m.thumbnail = m.top.findNode("thumbnail")
    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.play_button = m.top.findNode("playButton")
    
    m.play_button.ObserveField("buttonSelected", "_onPlayPressed")
    m.top.ObserveField("focusedChild", "_onFocusChange")

end sub

sub onContentChange()

    item_content = m.top.content
    
    if (item_content <> invalid)

        m.thumbnail.uri = item_content.HDPosterUrl
        m.title.text = item_content.title
        m.description.text = item_content.description

    end if

end sub

sub _onFocusChange()

    if (m.top.hasFocus())

        m.play_button.SetFocus(true)

    end if

end sub

sub _onPlayPressed()

    print "Start playing video"
    print m.top.content
    
    payload = {
        "screenName": "VideoPlayerScreen",
        "contentData": m.top.content
    }

    navigateTo(payload)

end sub

sub onCompactModeChange()
    if (m.top.compactMode = true)

        m.title.numLines = 2
        m.description.numLines = 5

    else

        m.title.numLines = 0
        m.description.numLines = 0

    end if

end sub
