
this tool aimed to sync diaspora stream to hugo powered blog.

you need to be a podmin in order to use it.

prerequisites
=============

currently it works only with postgre database.
you can add mysql support. (:

installation
============
get the source: 
```
git clone https://github.com/norayr/diaspora2hugo
cd diaspora2hugo
git submodule update --init
```
last line syncs submodule dependencies of the project.

to compile it you need to use [vishap oberon compiler](https://github.com/vishaps/voc).

once you have it, make sure that ```voc``` executable is in your path, you are in the diaspora2hugo directory and type ```make```.

using
=====

first time you probably need to get all the public diaspora posts as hugo ready markdown files.
for that run

```
d2h <username>
```

for instance, I change to hugo posts directory 'post' and run ```../build/d2h norayr``` because that's my username.

the files you get have the naming like ```2018-12-24_3407245_spyurk.md```.
i. e. ```year-month-day_post_id_spyurk.md```.

spyurk means 'diaspora' in armenian, also it is the name of my pod. i use the special suffix because i have other posts in my hugo blog. the word 'spyurk' is hardcoded, i did not want to introduce more commandline arguments or a need for a config file.

if you'd like you can easily rename all *spyurk files with commandline utility ```rename```.

in all consequent runs you'd like to extract as markdown only latest posts.

for that the usage is

```d2h <username> <post_id>``` and then markdown files for all posts starting from mentioned post id will be generated.

If you want to make sync automatically, then you can use a cron job, which calls [this](https://github.com/norayr/diaspora2hugo/blob/master/src/cron/sync_diaspora_to_matean.sh) script.

it can be simplified down to
```
posts_path="/home/m/matean/content/post"
hugo_path="/home/m/matean"
d2h="/home/inky/diaspora2hugo/build/d2h"
  cd $posts_path
  last_post=`ls $posts_path/*spyurk.md | tail -n 1 | awk -F "_" {'print $2'}`
  $d2h norayr $last_post
```

i use something like this ```23 5 * * * root /root/sync_diaspora_to_matean.sh```

that's all folks!
