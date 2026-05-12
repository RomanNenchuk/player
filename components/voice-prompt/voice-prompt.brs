sub init()

    m.MIC_CONFIG = {
        "color_focused": "0xDF46C1FF",
        "color_unfocused": "0xFFFFFFFF"
    }

    m.mic_bg = m.top.findNode("micBg")
    m.top.focusable = true    

    m.top.ObserveField("focusedChild", "_onFocusChange")

end sub

sub _onFocusChange()

    if (m.top.hasFocus())

        m.mic_bg.blendColor = m.MIC_CONFIG.color_focused

    else

        m.mic_bg.blendColor = m.MIC_CONFIG.color_unfocused

    end if

end sub
