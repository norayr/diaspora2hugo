log="/tmp/sync_matean.log"
posts_path="/home/m/matean/content/post"
hugo_path="/home/m/matean"
d2h="/root/diaspora2hugo/build/d2h"
  cd $posts_path
  last_post=`ls $posts_path/*spyurk.md | tail -n 1 | awk -F "_" {'print $2'}`
  tmpdir="$(mktemp -d /tmp/matean.XXXXXX)"
  cd $tmpdir
  $d2h norayr $last_post
  lst=`ls $tmpdir/`
  if [[ -n "$lst" ]]
  then
    count=`echo $lst | wc -w`
    echo "number of posts found $count" >> $log
    if [ "$count" -gt "1" ]
    then
      echo "new posts to publish: $lst" >> $log
      cp $tmpdir/*.md $posts_path/
      cd $hugo_path
      make
    else
      echo "nothing to publish" >> $log
    fi
  else
    echo "no new posts" >> $log
  fi

