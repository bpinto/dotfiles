function subtitle-extract {
  for x in `ls *.mkv`; do
    FILE=$x
    FILENAME=${FILE%.*}
    TRACK_NUMBER=`mkvinfo $FILE | grep -B 2 subtitles | egrep -o '.*Track number: ([0-9]+)' | sed -E 's/.*([0-9]+)/\1/'`
    mkvextract tracks $FILE $TRACK_NUMBER:$FILENAME.srt
  done
}
