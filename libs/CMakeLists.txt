

#=================== SDL2 ===================

cmake_policy(SET CMP0077 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)


if(RASPBIAN)
    set(VIDEO_RPI ON)
endif()

if(USE_PREBUILT_SDL_LIB)

    set(CMAKE_FIND_DEBUG_MODE TRUE)
    set(PREBUILT_PATH ${PROJECT_SOURCE_DIR}/libs/prebuilt/libs/)

    if(WIN32)

        if(ARCH STREQUAL "x64")
            set(LIB_PATH "win32/x64")
        elseif(ARCH STREQUAL "x86")
            set(LIB_PATH "win32/x86")
        else()
            MESSAGE(STATUS "Invalid architecture parameters found... ${ARCH}")
            return()
        endif()



        find_library(SDL_LIB
                NAMES
                SDL2d
                PATHS ${PREBUILT_PATH}/${LIB_PATH}
                REQUIRED
                )

        if (SDL_LIB)

            message(STATUS "SDL LIBRARY FOUND: ${SDL_LIB}")
            add_library(SDL2 SHARED IMPORTED GLOBAL)
            set_target_properties(SDL2
                    PROPERTIES
                    IMPORTED_IMPLIB "${SDL_LIB}"
                    IMPORTED_LOCATION "${PREBUILT_PATH}/${LIB_PATH}/SDL2d.dll"
                    )

        endif ()

        if (NOT TARGET SDL2)
            message(STATUS "SDL2: library not found..")
            return()
        else ()
            message(STATUS "SDL2: library for WIN32 ${ARCH} found...")
        endif ()

        find_library(SDL2_MAIN_LIB
                NAMES
                SDL2maind
                PATHS ${PREBUILT_PATH}/${LIB_PATH}
                REQUIRED
                )

        add_library(SDL2main SHARED IMPORTED GLOBAL)
        set_target_properties(SDL2main
                PROPERTIES
                IMPORTED_IMPLIB "${SDL2_MAIN_LIB}"
                )

        if (NOT SDL2main)
            message(STATUS "SDL2main: library not found..")
            return()
        else ()
            message(STATUS "SDL2main: library for WIN32 ${ARCH} found...")
        endif ()

    endif()

    set(SDL2_DIR ${PROJECT_SOURCE_DIR}/libs/prebuilt)

else()

    set(SDL2_DIR ${CMAKE_CURRENT_SOURCE_DIR}/SDL)
    add_subdirectory(${SDL2_DIR})
endif()

#=================== IMGUI ===================

set(IMGUI_DIR ${CMAKE_CURRENT_SOURCE_DIR}/imgui)
add_library(IMGUI STATIC)

target_sources( IMGUI
                PRIVATE
                    ${IMGUI_DIR}/imgui_demo.cpp
                    ${IMGUI_DIR}/imgui_draw.cpp
                    ${IMGUI_DIR}/imgui_tables.cpp
                    ${IMGUI_DIR}/imgui_widgets.cpp
                    ${IMGUI_DIR}/imgui.cpp

                PRIVATE
                    ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
                    ${IMGUI_DIR}/backends/imgui_impl_sdl.cpp
                )

target_include_directories( IMGUI
                            PUBLIC ${IMGUI_DIR}
                            PUBLIC ${IMGUI_DIR}/backends
                            PUBLIC ${SDL2_DIR}/include
                            )


if(RASPBIAN)
    #Not actually needed, just there for convenience
    target_compile_definitions(IMGUI PUBLIC -D__RASPBIAN__)

    # Do not search for OpenGL on raspbian. Use GLES instead.
    set(USE_GLES ON) 
endif()


if(USE_GLES)
    target_compile_definitions(IMGUI PUBLIC -DIMGUI_IMPL_OPENGL_ES2)

    if(RASPBIAN AND USE_BROADCOM_DRIVER)
        target_link_directories(IMGUI PUBLIC /opt/vc/lib)
        target_link_libraries(IMGUI PUBLIC brcmGLESv2 brcmEGL)
    else()
        target_link_libraries(IMGUI PUBLIC GLESv2)
    endif()
else()
    find_package(OpenGL REQUIRED)
    target_link_libraries(IMGUI PUBLIC ${OPENGL_LIBRARIES})
endif()

target_link_libraries(IMGUI PUBLIC SDL2main SDL2 ${CMAKE_DL_LIBS})


#=================== EXAMPLE ===================

if(BUILD_EXAMPLES)
    add_executable(example_sdl_opengl3)
    target_sources(example_sdl_opengl3 PUBLIC ${IMGUI_DIR}/examples/example_sdl_opengl3/main.cpp)
    target_link_libraries(example_sdl_opengl3 IMGUI)
    set_target_properties(example_sdl_opengl3 PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
endif()
