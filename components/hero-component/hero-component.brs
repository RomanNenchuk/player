sub init()

    m.thumbnail = m.top.findNode("thumbnail")
    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.play_button = m.top.findNode("playButton")

    m.play_button.observeField("buttonSelected", "_onPlayPressed")
    m.top.observeField("focusedChild", "_onFocusChange")

end sub

sub onContentChange()

    item_content = m.top.content

    if(item_content <> invalid)

        m.thumbnail.uri = item_content.HDPosterUrl
        m.title.text = item_content.title
        m.description.text = item_content.description
        updateLayout()

    end if

end sub

sub _onFocusChange()

    if(m.top.hasFocus())
        m.play_button.setFocus(true)
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

    updateLayout()

end sub

sub updateLayout()

    if(m.top.compactMode = true)

        m.title.numLines = 0
        m.title.height = 0

        title_rect = m.title.boundingRect()
        title_height = title_rect.height

        total_max_height = 500
        spacing = 20

        remaining_height = total_max_height - title_height - spacing

        if(remaining_height > 0)

            m.description.visible = true
            m.description.numLines = 0
            m.description.height = remaining_height

        else

            m.description.visible = false

        end if

    else

        m.title.ellipsizeOnBoundary = false
        m.description.ellipsizeOnBoundary = false

        m.title.numLines = 0
        m.title.height = 0

        m.description.visible = true
        m.description.numLines = 0
        m.description.height = 0

    end if
    
end sub
