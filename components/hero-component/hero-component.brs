sub init()

    m.thumbnail = m.top.findNode("thumbnail")
    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.play_button = m.top.findNode("playButton")

    m.mainLayout = m.top.findNode("mainLayout")
	m.leftColumn = m.top.findNode("leftColumn")
	m.rightColumn = m.top.findNode("rightColumn")

    m.play_button.observeField("buttonSelected", "_onPlayPressed")
    m.top.observeField("focusedChild", "_onFocusChange")

	m.LAYOUT_CONFIG = {
        compact: {
            thumb_size: [596, 335],
            btn_size: [220, 60],
            main_spacing: [60],
            left_spacing: [30],
            text_spacing: 20
        },
        normal: {
            thumb_size: [640, 360],
            btn_size: [220, 70],
            main_spacing: [60],
            left_spacing: [40]
        }
    }

end sub

sub onContentChange()

    item_content = m.top.content

    if (item_content <> invalid)

        m.thumbnail.uri = item_content.HDPosterUrl
        m.title.text = item_content.title
        m.description.text = item_content.description
        updateLayout()

    end if

end sub

sub _onFocusChange()

    if (m.top.hasFocus())

        m.play_button.setFocus(true)

    end if

end sub

sub _onPlayPressed()

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

    m.title.ellipsizeOnBoundary = false
    m.description.ellipsizeOnBoundary = false

    m.title.numLines = 0
    m.title.height = 0

    if (m.top.compactMode = true)

        config = m.LAYOUT_CONFIG.compact

        m.thumbnail.width = config.thumb_size[0]
        m.thumbnail.height = config.thumb_size[1]

        m.play_button.width = config.btn_size[0]
        m.play_button.height = config.btn_size[1]

        m.mainLayout.itemSpacings = config.main_spacing
        m.leftColumn.itemSpacings = config.left_spacing

        title_height = m.title.boundingRect().height
        total_max_height = config.thumb_size[1] + config.left_spacing[0] + config.btn_size[1]
        remaining_height = total_max_height - title_height - config.text_spacing

        if (remaining_height > 0)

            m.description.visible = true
            m.description.numLines = 0
            m.description.height = remaining_height

        else

            m.description.visible = false

        end if

    else

        config = m.LAYOUT_CONFIG.normal

        m.thumbnail.width = config.thumb_size[0]
        m.thumbnail.height = config.thumb_size[1]

        m.play_button.width = config.btn_size[0]
        m.play_button.height = config.btn_size[1]

        m.mainLayout.itemSpacings = config.main_spacing
        m.leftColumn.itemSpacings = config.left_spacing

        m.description.visible = true
        m.description.numLines = 0
        m.description.height = 0

    end if

end sub
