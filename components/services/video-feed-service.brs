sub initDataLoader()

  m.video_task = CreateObject("roSGNode", "VideoFeedTask")
  m.video_task.ObserveField("contentOutput", "_onDataLoaded")
  m.video_task.control = "RUN"

end sub

sub _onDataLoaded()

  content_node = m.video_task.contentOutput

  if (content_node = invalid)

    print "[Scene] contentOutput is invalid"
    return

  end if

  if (m.top.hasField("feedData"))

    m.top.feedData = content_node

  else

    print "[Scene] Warning: Component does not have 'feedData' interface"

  end if

end sub
