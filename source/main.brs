sub main()

  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.SetMessagePort(m.port)

  scene = screen.CreateScene("MainScene")
  screen.Show()
  
  scene.ObserveField("exitApp", m.port)
  
  while (true)

    msg = Wait(0, m.port)
    msg_type = Type(msg)

    if (msg_type = "roSGScreenEvent")

      if (msg.isScreenClosed())

        return
        
      end if

    else if (msg_type = "roSGNodeEvent")

      if (msg.GetField() = "exitApp" and msg.GetData() = true)
        
        screen.close()
        return

      end if

    end if

  end while

end sub
