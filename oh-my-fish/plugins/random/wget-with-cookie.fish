function wget-with-cookie
  set -l cookie_filename 'wget_cookie.txt'
  set -l temp_filename 'wget_temp.html'

  set -l cookie_url $argv[1]
  set -l download_url $argv[2]

  wget --cookies=on --keep-session-cookies --save-cookies=$cookie_filename -O $temp_filename "$cookie_url"

  if test (echo $argv | wc -w) -eq 3
    set -l download_filename $argv[3]

    wget -c --referer="$argv[1]" --cookies=on --load-cookies=$cookie_filename --keep-session-cookies --save-cookies=$cookie_filename -O "$download_filename" "$download_url"
  else
    wget -c --referer="$argv[1]" --cookies=on --load-cookies=$cookie_filename --keep-session-cookies --save-cookies=$cookie_filename "$download_url"
  end

  rm $cookie_filename
  rm $temp_filename
end
