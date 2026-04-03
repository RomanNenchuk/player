sub _initDataLoader()
    
  m.data_task = CreateObject("roSGNode", "DataLoaderTask")
  m.data_task.ObserveField("content_output", "_onDataLoaded")
  m.data_task.control = "RUN"

end sub

sub _onDataLoaded()

  content_node = m.data_task.content_output

  if content_node = invalid
    print "[Scene] content_output is invalid"
    return
  end if

  count = content_node.GetChildCount()
  print "[Scene] Total episodes: " ; count

  if count > 0
    first = content_node.GetChild(0)
    print "[Scene] First title: " ; first.title
    print "[Scene] First URL:   " ; first.url
    print "[Scene] Thumbnail:   " ; first.hdposterurl
  end if

end sub
