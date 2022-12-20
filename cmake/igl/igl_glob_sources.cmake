macro(igl_glob_sources directory out_sources)
    file(GLOB _h_inc_files "${directory}/*.h")
    file(GLOB _hpp_inc_files "${directory}/*.hpp")
    file(GLOB _src_files "${directory}/*.cpp")

    set(${out_sources} "${_h_inc_files}" "${_hpp_inc_files}" "${_src_files}")
    unset(_h_inc_files)
    unset(_hpp_inc_files)
    unset(_src_files)
endmacro()