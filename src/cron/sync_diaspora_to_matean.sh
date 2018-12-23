log="/tmp/sync_matean.log"
echo "run" >> $log
echo "`date`" >> $log
mounted=`mount | grep amp`
posts_path="/home/m/matean/content/post"
hugo_path="/home/m/matean"
d2h="/amp/nil/github/postgre/diaspora2hugo/src/build/d2h"
user="norayr"
set -x
echo "check if mounted" >> $log
if [[ -n "${mounted/[ ]*\n/}" ]]
then
  #execute if the the variable is not empty and contains non space characters
  echo "mounted, continuing" >> $log
  cd $posts_path
  last_post=`ls $posts_path/*spyurk.md | tail -n 1 | awk -F "_" {'print $2'}`
  echo "last post $last_post" >> $log
  tmpdir="$(mktemp -d /tmp/matean.XXXXXX)"
  echo "tmpdir $tmpdir" >> $log
  cd $tmpdir
  echo "running d2h" >> $log
  $d2h $user $last_post 
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


else
  #execute if the variable is empty or contains only spaces
  echo "not mounted, exiting" >> $log
fi


