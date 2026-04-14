sub _promptAppExit()

    focus_target = m.screen_manager

    if (m.top_menu.isInFocusChain())

        focus_target = m.top_menu

    end if

    ShowModal({
        "title": "Confirmation",
        "message": "Are you sure you want to exit?",
        "buttons": [
            "OK",
            "Cancel"
        ],
        "focusTarget": focus_target,
        "callbacks": [
            {
                "func": _onExitAppClicked
            },
            invalid
        ]
    })

end sub

sub _onExitAppClicked()

    m.top.exitApp = true

end sub
