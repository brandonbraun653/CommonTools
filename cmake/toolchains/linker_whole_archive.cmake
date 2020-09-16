# ====================================================
# Manually overrides the linker command such that it will automatically wrap libraries
# with the whole-archive flags. This forces symbols to not get thrown out by the linker.
#
# See:
# https://stackoverflow.com/questions/53071878/using-whole-archive-linker-option-with-cmake-and-libraries-with-other-library/63911370#63911370
# ====================================================
set(CMAKE_CXX_LINK_EXECUTABLE
"<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> -Wl,--start-group -Wl,--whole-archive <LINK_LIBRARIES> -Wl,--no-whole-archive -Wl,--end-group")


