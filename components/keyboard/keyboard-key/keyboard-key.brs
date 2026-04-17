sub init()

  m.background_rect = m.top.findNode("background_rect")
  m.letter_label = m.top.findNode("letter_label")
  m.icon_poster = m.top.findNode("icon_poster")

  m.top.ObserveField("focusedChild", "_onFocusChange")

end sub

sub _onKeyDataChange()

  key_id = m.top.keyId
  key_title = m.top.keyTitle
  key_width = m.top.keyWidth

  if (key_width = 0)

    key_width = 100

  end if

  m.background_rect.width = key_width
  m.letter_label.width = key_width

  if (key_id = "clear" or key_id = "space" or key_id = "backspace")

    m.letter_label.visible = false
    m.icon_poster.visible = true

    center_x = Int((key_width - 40) / 2)

    if (key_id = "clear")

      m.icon_poster.uri = "pkg:/images/icon_trash.png"
      m.icon_poster.width = 25
      m.icon_poster.height = 25
      m.icon_poster.translation = [center_x + 7, 37]

    else if (key_id = "space")

      m.icon_poster.uri = "pkg:/images/icon_space.png"
      m.icon_poster.width = 40
      m.icon_poster.height = 25
      m.icon_poster.translation = [center_x, 37]

    else if (key_id = "backspace")

      m.icon_poster.uri = "pkg:/images/icon_backspace.png"
      m.icon_poster.width = 25
      m.icon_poster.height = 25
      m.icon_poster.translation = [center_x + 7, 37]

    end if

  else

    m.icon_poster.visible = false
    m.letter_label.visible = true
    m.letter_label.text = key_title

  end if

  _updateFocusVisual()

end sub

sub _onFocusChange()

  _updateFocusVisual()

end sub

sub _updateFocusVisual()

  if (m.top.hasFocus() = true)

    m.background_rect.color = "0xDF46C1FF"
    m.letter_label.color = "0x000000FF"

  else

    m.background_rect.color = "0x222222FF"
    m.letter_label.color = "0xFFFFFFFF"

  end if

end sub
