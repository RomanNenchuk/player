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

    m.top.contentOutput = ParseRss(response_string)

  end if

end sub
