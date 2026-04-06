function ParseRssFeed(xml_string as String) as Object

    root = CreateObject("roSGNode", "ContentNode")
    xml = CreateObject("roXMLElement")
    
    if (not xml.Parse(xml_string))
        print "[RssParser] XML parse failed"
        return root
    end if

    if (xml.channel = invalid or xml.channel.item = invalid)
        print "[RssParser] RSS structure is invalid: missing channel or items"
        return root
    end if
    
    items = xml.channel.item
    row_titles = ["Live", "Recommended", "Trending"]
    items_per_row = Int(items.Count() / row_titles.Count())
    current_item_index = 0
    
    for each row_title in row_titles
        row_node = CreateObject("roSGNode", "ContentNode")
        row_node.title = row_title
        
        end_index = current_item_index + items_per_row - 1
        if (end_index >= items.Count()) 
            end_index = items.Count() - 1
        end if
        
        for i = current_item_index to end_index
            row_node.AppendChild(_BuildEpisodeNode(items[i]))
        end for
        
        current_item_index = end_index + 1
        root.AppendChild(row_node)
    end for
    
    print "[RssParser] Parsed: " ; root.GetChildCount() ; " rows"
    return root

end function

function _BuildEpisodeNode(item as Object) as Object

    episode = CreateObject("roSGNode", "ContentNode")
    episode.title = item.title.GetText()
    episode.description = item.description.GetText()
    episode.url = item.enclosure@url
    episode.hdposterurl = _ExtractThumbnailUrl(item)
    episode.shortdescriptionline2 = _ExtractDuration(item)
    episode.streamformat = _ExtractStreamFormat(item)
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
        return duration_str.Mid(4)
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
