sub init()

  m.top.functionName = "_executeTask"
end sub

sub _executeTask()

  feed_url = "https://feeds.feedburner.com/TedtalksHD"
  url_transfer = CreateObject("roUrlTransfer")

  url_transfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
  url_transfer.SetUrl(feed_url)

  response_string = url_transfer.GetToString()

  if (response_string <> "")

    m.top.contentOutput = _ParseRss(response_string)

  end if

end sub

function _ParseRss(xml_string as String) as Object

  root = CreateObject("roSGNode", "ContentNode")
  xml = CreateObject("roXMLElement")

  if (not xml.Parse(xml_string))

    print "[DataLoaderTask] XML parse failed"
    return root

  end if

  if (xml.channel = invalid or xml.channel.item = invalid)

    print "[DataLoaderTask] RSS structure is invalid: missing channel or items"
    return root

  end if

  items = xml.channel.item
  row_titles = ["Live", "Recommended", "Trending"]
  items_per_row = Int(items.Count() / row_titles.Count())
  current_item_index = 0

  for each row_title in row_titles

    row_node = CreateObject("roSGNode", "ContentNode")
    row_node.title = row_title

    print row_title

    end_index = current_item_index + items_per_row - 1

    if (end_index >= items.Count())

      end_index = items.Count() - 1

    end if

    for i = current_item_index to end_index
      row_node.AppendChild(_ParseItem(items[i]))
    end for

    current_item_index = end_index + 1
    root.AppendChild(row_node)
  end for

  print "[DataLoaderTask] Parsed: " ; root.GetChildCount() ; " rows"

  return root

end function

function _ParseItem(item as Object) as Object

    episode = CreateObject("roSGNode", "ContentNode")
    episode.title = item.title.GetText()
    episode.description = item.description.GetText()
    episode.url = item.enclosure@url
    episode.hdposterurl = _ExtractThumbnailUrl(item)
    episode.shortdescriptionline2 = _ExtractDuration(item)
    episode.streamformat = _ExtractStreamFormat(item)
    episode.ReleaseDate = _ExtractPubDate(item)
    return episode

end function

function _ExtractThumbnailUrl(item as Object) as String

  media_nodes = item.GetNamedElements("media:thumbnail")

  if (media_nodes.Count() > 0)

    return media_nodes[0]@url

  end if

  return ""

end function

function _ExtractDuration(item as Object) as String

  duration_nodes = item.GetNamedElements("itunes:duration")

  if (duration_nodes.Count() = 0)

    return ""

  end if

  duration_str = duration_nodes[0].GetText()

  if (duration_str.Left(3) = "00:")

    duration_str = duration_str.Mid(3)

  end if

  if (duration_str.Left(1) = "0" and duration_str.Mid(2, 1) = ":")
    
    duration_str = duration_str.Mid(1)
  
  end if

  return duration_str

end function

function _ExtractStreamFormat(item as Object) as String

  enclosure_type = item.enclosure@type

  if (enclosure_type <> invalid and enclosure_type <> "")

    type_parts = enclosure_type.Split("/")

    if (type_parts.Count() > 1)

      return type_parts[1]
      
    end if

  end if

  return "mp4"

end function

function _ExtractPubDate(item as Object) as String

  if (item.pubDate <> invalid)
    
    return item.pubDate.GetText()

  end if
  
  return ""

end function
