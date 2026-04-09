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

  if (m.content_row_list <> invalid)

    m.content_row_list.content = content_node

  else
  
    print "[Scene] Warning: m.content_row_list is invalid"
  
  end if

end sub
