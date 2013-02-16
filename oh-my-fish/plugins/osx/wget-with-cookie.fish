function wget-with-cookie
  wget --cookies=on --keep-session-cookies --save-cookies=cookie.txt "$argv[1]"
  wget -c --referer="$argv[1]" --cookies=on --load-cookies=cookie.txt --keep-session-cookies --save-cookies=cookie.txt "$argv[2]"
end
