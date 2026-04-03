sub main()

  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.SetMessagePort(m.port)

  scene = screen.CreateScene("MainScene")
  screen.Show()

  while(true)
    msg = Wait(0, m.port)
    msg_type = Type(msg)

    if(msg_type = "roSGScreenEvent")

      if(msg.isScreenClosed())
        return
      end if

    end if
  end while

end sub