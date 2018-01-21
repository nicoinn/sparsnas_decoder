cmake_minimum_required(VERSION 3.9)
project(sparsnas)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")

add_executable(sparsnas_decode main.cpp)

