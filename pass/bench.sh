clang $1.ll -o ./$1
clang $2.ll -o ./$2
hyperfine ./$1 ./$2
