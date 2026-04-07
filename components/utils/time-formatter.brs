function GetTimeAgo(date_string as String) as String

  regex = CreateObject("roRegex", "(\d{1,2})\s+([a-zA-Z]{3})\s+(\d{4})\s+(\d{2}:\d{2}:\d{2})", "")
  match = regex.Match(date_string)

  pub_seconds = 0

  if (match.Count() = 5)

    day = match[1]

    if (day.Len() = 1)

      day = "0" + day

    end if

    month_str = match[2]
    year = match[3]
    time_str = match[4]

    months = {
      "Jan": "01",
      "Feb": "02",
      "Mar": "03",
      "Apr": "04",
      "May": "05",
      "Jun": "06",
      "Jul": "07",
      "Aug": "08",
      "Sep": "09",
      "Oct": "10",
      "Nov": "11",
      "Dec": "12"
    }

    month = months[month_str]

    if (month = invalid)

      month = "01"

    end if

    iso_string = year + "-" + month + "-" + day + "T" + time_str + "Z"

    date_obj = CreateObject("roDateTime")
    date_obj.FromISO8601String(iso_string)
    pub_seconds = date_obj.AsSeconds()

  end if

  if (pub_seconds = 0)

    return ""

  end if

  now_obj = CreateObject("roDateTime")
  now_seconds = now_obj.AsSeconds()
  diff = now_seconds - pub_seconds

  if (diff < 0)

    return "Just now"

  end if

  if (diff < 60)

    return "Just now"

  end if

  if (diff < 3600)

    return _GetPluralString(diff \ 60, "min")

  else if (diff < 86400)

    return _GetPluralString(diff \ 3600, "hour")

  else if (diff < 2592000)

    return _GetPluralString(diff \ 86400, "day")

  else if (diff < 31536000)

    return _GetPluralString(diff \ 2592000, "month")

  else

    return _GetPluralString(diff \ 31536000, "year")

  end if

end function

function _GetPluralString(count as Integer, unit as String) as String

  if (count = 1)

    return "1 " + unit + " ago"

  else

    return count.ToStr() + " " + unit + "s ago"
    
  end if

end function
