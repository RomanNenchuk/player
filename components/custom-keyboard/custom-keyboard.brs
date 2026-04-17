sub init()

	m.keyboard_layout_group = m.top.findNode("keyboard_layout_group")
	m.key_nodes = []
	m.key_grid = []
	m.search_query = ""
	m.last_focused_node = invalid

	m.top.ObserveField("focusedChild", "_onInternalFocusChange")

	_setupKeyboard()

end sub

sub _onInternalFocusChange()

    if (m.top.hasFocus() = true and m.key_nodes.count() > 0)

		if m.last_focused_node <> invalid

			m.last_focused_node.setFocus(true)

		else

			m.key_nodes[0]["node"].setFocus(true)
            m.last_focused_node = m.key_nodes[0]["node"]

		end if

	end if

end sub

sub _setupKeyboard()

	key_rows = [
		["a", "b", "c", "d", "e", "f"],
		["g", "h", "i", "j", "k", "l"],
		["m", "n", "o", "p", "q", "r"],
		["s", "t", "u", "v", "w", "x"],
		["y", "z", "1", "2", "3", "4"],
		["5", "6", "7", "8", "9", "0"],
		["clear", "space", "backspace"]
	]

	row_index = 0

	for each row in key_rows

		row_group = CreateObject("roSGNode", "LayoutGroup")
		row_group.layoutDirection = "horiz"
		row_group.itemSpacings = [3]

		col_index = 0

		for each key_id in row

			key_node = CreateObject("roSGNode", "KeyboardKey")
			key_node.id = "key_" + key_id
			key_node.keyId = key_id
			key_node.keyTitle = key_id

			if (key_id = "clear" or key_id = "space" or key_id = "backspace")

				key_node.keyWidth = 203

			else

				key_node.keyWidth = 100

			end if

			row_group.appendChild(key_node)

			entry = {
				"node": key_node,
				"row": row_index,
				"col": col_index,
				"key_id": key_id
			}

			m.key_nodes.push(entry)
			col_index = col_index + 1

		end for

		m.keyboard_layout_group.appendChild(row_group)
		row_index = row_index + 1

	end for

	_buildKeyGrid()
	_wireKeyboardFocus()

end sub

sub _buildKeyGrid()

	m.key_grid = []

	for each entry in m.key_nodes

		row = entry["row"]

		if (row >= m.key_grid.count())

			m.key_grid.push([])

		end if

		m.key_grid[row].push(entry["node"])

	end for

end sub

sub _wireKeyboardFocus()

	m.focus_map = {}
	num_rows = m.key_grid.count()

	for row = 0 to num_rows - 1

		row_keys = m.key_grid[row]
		num_cols = row_keys.count()
		last_col = num_cols - 1

		for col = 0 to last_col

			node = row_keys[col]
			mapping = {}

			if (col > 0)

				mapping["left"] = row_keys[col - 1]

			end if

			if (col < last_col)

				mapping["right"] = row_keys[col + 1]

			end if

			if (row > 0)

				prev_row = m.key_grid[row - 1]
				target_col = col

				if (target_col >= prev_row.count())

					target_col = prev_row.count() - 1

				end if

				mapping["up"] = prev_row[target_col]

			end if

			if (row < num_rows - 1)

				next_row = m.key_grid[row + 1]
				target_col = col

				if (target_col >= next_row.count())

					target_col = next_row.count() - 1

				end if

				mapping["down"] = next_row[target_col]

			end if

			m.focus_map[node.id] = mapping

		end for

	end for

end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean

    if (press = false)

        return false

    end if

    focused_id = _GetFocusedKeyId()

	if (focused_id = "")

        if ( m.key_nodes.count() > 0 )
        
            if m.last_focused_node <> invalid

				m.last_focused_node.setFocus(true)

			else

				m.key_nodes[0]["node"].setFocus(true)
                m.last_focused_node = m.key_nodes[0]["node"]

			end if

		end if

		return true

	end if

    if (m.focus_map.DoesExist(focused_id))

        mapping = m.focus_map[focused_id]

        if (mapping.DoesExist(key))

            mapping[key].setFocus(true)
			m.last_focused_node = mapping[key]

            return true

        else if (key = "up" or key = "down" or key = "left" or key = "right")

            m.top.exitDirection = key

            return true

        else if (key = "OK")

            for each entry in m.key_nodes

                if (entry["node"].id = focused_id)

                    _handleKeyPress(entry["key_id"])

                    return true

                end if

            end for

            return true

        end if

    end if

    return false

end function

function _getFocusedKeyId() as String

	for each entry in m.key_nodes

		if (entry["node"].hasFocus() = true)

			return entry["node"].id

		end if

	end for

	return ""

end function

sub _handleKeyPress(key_id as String)

	if (key_id = "clear")

		m.search_query = ""

	else if (key_id = "backspace")

		if (Len(m.search_query) > 0)

			m.search_query = Left(m.search_query, Len(m.search_query) - 1)

		end if

	else if (key_id = "space")

		m.search_query = m.search_query + " "

	else

		m.search_query = m.search_query + LCase(key_id)

	end if

	m.top.searchQuery = m.search_query

end sub
