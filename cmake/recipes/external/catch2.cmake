if (LIBIGL_FIND_PACKAGES)
  find_package(Catch2 REQUIRED)
endif ()

if (TARGET Catch2::Catch2)
  return()
endif ()

message(STATUS "Third-party: creating target 'Catch2::Catch2'")

include(FetchContent)
FetchContent_Declare(
  catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG v2.13.8
  GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(catch2)
