# 1. Define module
igl_add_library(igl_png)

# 2. Include headers
include(GNUInstallDirs)
target_include_directories(igl_png ${IGL_SCOPE}
    $<BUILD_INTERFACE:${libigl_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# 3. Target sources
igl_glob_sources("${libigl_SOURCE_DIR}/include/igl/png/" SRC_FILES)
igl_target_sources(igl_png "${SRC_FILES}")

# 4. Install target & headers
igl_install(igl_png "${SRC_FILES}")

# 5. Dependencies
include(stb)
igl_include(opengl)
target_link_libraries(igl_png ${IGL_SCOPE}
    igl::core
    igl::opengl
    stb::stb
)
