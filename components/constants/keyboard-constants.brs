function KeyboardConstants() as Object

    return {
        "KEY_SIZE": 100,
        "KEY_SIZE_WIDE": 203,
        "KEY_HEIGHT": 100,
        "ROW_SPACING": 3,
        "COL_SPACING": 3,
        "ICON_SIZE_STANDARD": 25,
        "ICON_SIZE_WIDE": 40,
        "ICON_Y": 37,
        "COLOR_BG_DEFAULT": "0x222222FF",
        "COLOR_BG_FOCUSED": "0x9B111EFF",
        "COLOR_TEXT_DEFAULT": "0xFFFFFFFF",
        "COLOR_TEXT_FOCUSED": "0x000000FF",
        "ICON_CLEAR": "pkg:/images/icon_trash.png",
        "ICON_SPACE": "pkg:/images/icon_space.png",
        "ICON_BACKSPACE": "pkg:/images/icon_backspace.png",
        "KEY_ID_CLEAR": "clear",
        "KEY_ID_SPACE": "space",
        "KEY_ID_BACKSPACE": "backspace",
        "FONT_DEFAULT": "font:MediumSystemFont",
        "FONT_FOCUSED": "font:MediumBoldSystemFont"
    }

end function

function KeyboardLayout() as Object

    constants = KeyboardConstants()

    return [
        ["a", "b", "c", "d", "e", "f"],
        ["g", "h", "i", "j", "k", "l"],
        ["m", "n", "o", "p", "q", "r"],
        ["s", "t", "u", "v", "w", "x"],
        ["y", "z", "1", "2", "3", "4"],
        ["5", "6", "7", "8", "9", "0"],
        [constants.KEY_ID_CLEAR, constants.KEY_ID_SPACE, constants.KEY_ID_BACKSPACE]
    ]

end function
