# CMakeList.txt : CMake project for TrymeLinux, include source and define
# project specific logic here.
#

# Add source to this project's executable.
add_executable (TrymeLinux "TrymeLinux.cpp" "TrymeLinux.h")

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET TrymeLinux PROPERTY CXX_STANDARD 20)
endif()

# Ensure the linker is the C++ linker and link the C++ standard library explicitly
set_target_properties(TrymeLinux PROPERTIES LINKER_LANGUAGE CXX)
target_link_libraries(TrymeLinux PRIVATE stdc++)

# TODO: Add tests and install targets if needed.
