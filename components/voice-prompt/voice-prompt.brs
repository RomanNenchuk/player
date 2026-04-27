sub init()

    m.mic_bg = m.top.findNode("micBg")
    m.top.focusable = true    
    m.top.ObserveField("focusedChild", "_onFocusChange")

end sub

sub _onFocusChange()

    if (m.top.hasFocus())

        m.mic_bg.blendColor = "0xDF46C1FF"

    else

        m.mic_bg.blendColor = "0xFFFFFFFF"

    end if

end sub
