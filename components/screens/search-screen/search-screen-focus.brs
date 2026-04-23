function OnKeyEvent(key as String, press as Boolean) as Boolean

    handled = false

    if (press)

        if (m.voice_prompt_group.hasFocus())

            if (key = "down")

                handled = _SetFocusTarget(m.keyboard_grid)

            else if (key = "OK")

                handled = true

            end if

        else if (m.search_results_grid.hasFocus())

            if (key = "left")

                handled = _SetFocusTarget(m.keyboard_grid)

            end if

        else if (m.keyboard_grid.hasFocus())

            if (key = "right")

                if (m.search_results_grid.visible)

                    _SetFocusTarget(m.search_results_grid)

                end if

                handled = true 

            else if (key = "up" and m.voice_prompt_group.visible)

                handled = _SetFocusTarget(m.voice_prompt_group)

            end if

        end if

    end if

    if (not handled)

        handled = HandleBaseKeyEvents(key, press)

    end if

    return handled

end function

function _SetFocusTarget(node as Object) as Boolean

    if (node <> invalid)

        node.setFocus(true)
        m.last_focused_section = node

        return true

    end if

    return false

end function

sub _onScreenFocusChange()

    if (m.top.hasFocus())

        m.last_focused_section.setFocus(true)

    end if

end sub

sub _onKeyboardFocusChanged()

    if (m.voice_edit_box <> invalid and m.voice_edit_box.hasFocus())

        m.keyboard_grid.setFocus(true)
        m.last_focused_section = m.keyboard_grid

    end if

end sub
