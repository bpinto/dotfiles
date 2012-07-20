function subtitle-extract {
  for x in `ls *.mkv`; do
    FILE=$x
    FILENAME=${FILE%.*}
    TRACK_NUMBER=`mkvinfo $FILE | grep -B 2 subtitles | egrep -o '.*Track number: ([0-9]+)' | sed -E 's/.*([0-9]+)/\1/'`
    if [[ -n $TRACK_NUMBER ]]; then
      mkvextract tracks $FILE $TRACK_NUMBER:$FILENAME.srt
    else
      echo 'No subtitles available.'
    fi
  done
}
