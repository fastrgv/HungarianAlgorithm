
export PATH=$HOME/opt/GNAT/2018/bin:$PATH

gnatmake $1 \
-O3 -gnat12 -I. --subdirs=./obj

mv obj/$1 .

