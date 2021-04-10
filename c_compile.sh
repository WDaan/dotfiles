################### C/C++ compile functions ###########################
gcc_comp() {
  gcc -o "${1%.*}" "$1"
}

g++_comp() {
  g++ -o "${1%.*}" "$1"
}

#usage bv: gcc_run test.c
gcc_run() {
  gcc -o "${1%.*}" "$1"
  ./"${1%.*}"
}

g++_run() {
  g++ -o "${1%.*}" "$1"
  ./"${1%.*}".exe
}

#usage bv : gcc_mtp util.h util.c main.c -o test
gcc_mtp() {
  array=("$@")
  files=()
  for var in "${@:1:$(($# - 1))}"; do
    files+=("$var")
  done
  gcc "${files[@]}" -o "${array[-1]}"
  ./"${array[-1]}"
}

g++_mtp() {
  array=("$@")
  files=()
  for var in "${@:1:$(($# - 1))}"; do
    files+=("$var")
  done
  g++ "${files[@]}" -o "${array[-1]}"
  ./"${array[-1]}".exe
}
