echo "usage <1>.so <2>pass <3>.ll file"
opt -S -load-pass-plugin ./$1 -passes=$2 $3 -o output.ll -debug-pass-manager
