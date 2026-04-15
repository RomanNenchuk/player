sub init()

    m.normal_bg = m.top.findNode("normalBg")
    m.focus_bg = m.top.findNode("focusBg")
    m.button_label = m.top.findNode("buttonLabel")

    m.top.observeField("focusedChild", "_onFocusChange")

    _applySize()
    _applyUnfocusedStyle()

end sub

sub onSizeChange()

    _applySize()

end sub

sub _applySize()

    btn_width = m.top.width
    btn_height = m.top.height

    m.normal_bg.width = btn_width
    m.normal_bg.height = btn_height

    m.focus_bg.width = btn_width
    m.focus_bg.height = btn_height

    m.button_label.width = btn_width
    m.button_label.height = btn_height

end sub

sub _onFocusChange()

    if(m.top.hasFocus() or m.top.isInFocusChain())
       
       _applyFocusedStyle()
    
    else
    
        _applyUnfocusedStyle()
    
    end if

end sub

sub _applyFocusedStyle()

    m.focus_bg.visible = true
    m.normal_bg.visible = false
    m.button_label.color = "0x000000FF"

end sub

sub _applyUnfocusedStyle()

    m.focus_bg.visible = false
    m.normal_bg.visible = true
    m.button_label.color = "0xFFFFFFCC"

end sub

function onKeyEvent(key as string, press as boolean) as boolean

    if( press and key = "OK" )

        m.top.buttonSelected = not m.top.buttonSelected
        return true
    
    end if

    return false

end function
