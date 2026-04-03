sub init()

  m.top.functionName = "_executeTask"

end sub

sub _executeTask()

  feed_url = "https://feeds.feedburner.com/TedtalksHD"
  
  url_transfer = CreateObject("roUrlTransfer")
  url_transfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
  url_transfer.SetUrl(feed_url)

  response_string = url_transfer.GetToString()

  if response_string <> ""
    m.top.content_output = _ParseRss(response_string)
  end if

end sub

function _ParseRss(xml_string as String) as Object

  root = CreateObject("roSGNode", "ContentNode")
  xml  = CreateObject("roXMLElement")

  if not xml.Parse(xml_string)
    print "[DataLoaderTask] XML parse failed"
    return root
  end if

  for each item in xml.channel.item
    thumbnail_url = ""
    media_nodes = item.GetNamedElements("media:thumbnail")
    if media_nodes.Count() > 0
      thumbnail_url = media_nodes[0]@url
    end if

    duration_str = ""
    duration_nodes = item.GetNamedElements("itunes:duration")
    if duration_nodes.Count() > 0
      duration_str = duration_nodes[0].GetText()
    end if

    episode = CreateObject("roSGNode", "ContentNode")
    episode.title = item.title.GetText()
    episode.description = item.description.GetText()
    episode.streamformat = "mp4"
    episode.url = item.enclosure@url
    episode.hdposterurl = thumbnail_url
    episode.shortdescriptionline2 = duration_str

    root.AppendChild(episode)
  end for

  print "[DataLoaderTask] Parsed: " ; root.GetChildCount() ; " episodes"
  return root

end function
