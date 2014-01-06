function download
  set -l guess
  set -l reverse
  set -l url

  # Read arguments
  if test (echo $argv | wc -w) -eq 1
    set url $argv[1]
  else
    set reverse $argv[1] #TODO: check arguments
    set guess $argv[1] #TODO: check arguments
    set url $argv[2]
  end

  # URL argument check
  if test -z $url
    echo "No URL specified"
    return 1
  end

  # Replace URL if reverse is specified
  if test -n $reverse
    set url (echo $url | rev)
  end

  # Extract guessed URL
  if test -n guess
    set url (echo $url | sed "s/=.*//")
  end

  # Call appropriate downloader
  switch $url
    case '*adrive*'
      _adrive_download $url
    case '*'
      echo 'Not found'
  end
end

function _adrive_download
  set -l filename (basename $argv)

  set -l cookie_url (echo $argv | sed "s/www/downloadwww21/" | sed "s/\/$filename/.html/")
  set -l download_url (echo $cookie_url | sed "s/public/public\/view/")

  wget-with-cookie $cookie_url $download_url $filename
end
