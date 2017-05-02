function caffeinate
  echo 'Drinking coffee for 1 month...'
  systemd-inhibit --what=handle-lid-switch sleep 2592000
end
