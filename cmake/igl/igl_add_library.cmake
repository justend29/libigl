# Creates a CMake target for a given libigl module. This convenience function also defines common
# compilation flags, as well as installation rules for the target. Target sources and dependencies
# need to be added separately.
function(igl_add_library module_name)
  # Check if category is `copyleft` or `restricted`
  if(${module_name} MATCHES "^igl_copyleft")
    set(suffix "_copyleft")
  elseif(${module_name} MATCHES "^igl_restricted")
    set(suffix "_restricted")
  else()
    set(suffix "")
  endif()

  # Check module name
  if(NOT ${module_name} MATCHES "^igl_")
    message(FATAL_ERROR "Libigl module name should start with 'igl_'")
  endif()
  string(REPLACE "igl${suffix}_" "" module_shortname ${module_name})

  # Define target
  if(LIBIGL_USE_STATIC_LIBRARY)
    add_library(${module_name} STATIC)
  else()
    add_library(${module_name} INTERFACE)
  endif()

  # Alias target name
  message(STATUS "Creating target: igl${suffix}::${module_shortname} (${module_name})")
  add_library(igl${suffix}::${module_shortname} ALIAS ${module_name})
  set_property(TARGET ${module_name} PROPERTY EXPORT_NAME ${module_shortname})


  # Compile definitions
  if(LIBIGL_USE_STATIC_LIBRARY)
    target_compile_definitions(${module_name} ${IGL_SCOPE} -DIGL_STATIC_LIBRARY)
  endif()

  # C++11 features
  target_compile_features(${module_name} ${IGL_SCOPE} cxx_std_11)

  # Other compilation flags
  if(MSVC)
    # Enable parallel compilation for Visual Studio
    target_compile_options(${module_name} ${IGL_SCOPE} $<$<COMPILE_LANGUAGE:CXX>:/MP> $<$<COMPILE_LANGUAGE:CXX>:/bigobj>)
    target_compile_definitions(${module_name} ${IGL_SCOPE} -DNOMINMAX)

    # Silencing some compilation warnings
    if(LIBIGL_USE_STATIC_LIBRARY)
      target_compile_options(${module_name} PRIVATE
        # Type conversion warnings. These can be fixed with some effort and possibly more verbose code.
        /wd4267 # conversion from 'size_t' to 'type', possible loss of data
        /wd4244 # conversion from 'type1' to 'type2', possible loss of data
        /wd4018 # signed/unsigned mismatch
        /wd4305 # truncation from 'double' to 'float'
        # This one is from template instantiations generated by autoexplicit.sh:
        /wd4667 # no function template defined that matches forced instantiation ()
        # This one is easy to fix, just need to switch to safe version of C functions
        /wd4996 # this function or variable may be unsafe
        # This one is when using bools in adjacency matrices
        /wd4804 #'+=': unsafe use of type 'bool' in operation
        )
    endif()
  endif()

  # Generate position independent code
  if(LIBIGL_POSITION_INDEPENDENT_CODE)
    set_target_properties(${module_name} PROPERTIES INTERFACE_POSITION_INDEPENDENT_CODE ON)
    if(LIBIGL_USE_STATIC_LIBRARY)
      set_target_properties(${module_name} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()
  endif()

  # Folder for IDE
  if(LIBIGL_USE_STATIC_LIBRARY OR CMAKE_VERSION VERSION_GREATER_EQUAL 3.19.0)
    set_target_properties(${module_name} PROPERTIES FOLDER "Libigl")
  endif()
endfunction()
