sub hideTopMenu()

    if (m.top.hasField("requiresTopMenu"))

        m.top.requiresTopMenu = false

    end if

end sub

sub showTopMenu()

    if (m.top.hasField("requiresTopMenu"))

        m.top.requiresTopMenu = true

    end if

end sub
