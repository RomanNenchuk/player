sub init()

	m.search_results_title = m.top.findNode("search_results_title")
	m.empty_state_label = m.top.findNode("empty_state_label")
	m.voice_prompt_group = m.top.findNode("voice_prompt_group")
	m.mic_button_large = m.top.findNode("mic_button_large")
	m.mic_bg = m.top.findNode("mic_bg")
	m.keyboard = m.top.findNode("keyboard")

	m.mic_button_large.ObserveField("focusedChild", "_onMicFocusChange")
	m.top.ObserveField("focusedChild", "_onScreenFocusChange")
	m.keyboard.ObserveField("searchQuery", "_onSearchQueryChanged")
	m.keyboard.ObserveField("exitDirection", "_onKeyboardExit")

	_checkVoiceSupport()

end sub

sub _checkVoiceSupport()

	has_voice_support = true
	m.voice_prompt_group.visible = has_voice_support

end sub

sub _onMicFocusChange()

	print "Microphone focused"

	if (m.mic_button_large.hasFocus() = true)

		m.mic_bg.blendColor = "0xDF46C1FF"

	else

		m.mic_bg.blendColor = "0xFFFFFFFF"

	end if

end sub

sub _onScreenFocusChange()

	if (m.top.hasFocus() = true)

		m.keyboard.setFocus(true)

	end if

end sub

sub _onSearchQueryChanged()

	query = m.keyboard.searchQuery
	m.search_results_title.text = query

	if (query = "")

		m.search_results_title.visible = false
		m.empty_state_label.visible = true

	else

		m.search_results_title.visible = true
		m.empty_state_label.visible = false

	end if

end sub

sub _onKeyboardExit()

    direction = m.keyboard.exitDirection

    if (direction = "up" )

        if (m.voice_prompt_group.visible = true)

            m.mic_button_large.setFocus(true)

        end if

    end if

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

	if (press = false)

		return false

	end if

	if (m.mic_button_large.hasFocus() = true)

		if (key = "down")

			m.keyboard.setFocus(true)

			return true

		else if (key = "OK")

			print "Mic button clicked! Start voice search..."

			return true

		end if

	end if

	return false

end function
