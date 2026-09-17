cmake_minimum_required(VERSION 3.22.1)

project(whisper.cpp LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)

set(WHISPER_DIR ${CMAKE_SOURCE_DIR}/whisper)

set(SOURCE_FILES
    ${WHISPER_DIR}/src/whisper.cpp
    ${CMAKE_SOURCE_DIR}/jni.c
    ${WHISPER_DIR}/ggml/src/ggml.c
    ${WHISPER_DIR}/ggml/src/ggml-aarch64.c
    ${WHISPER_DIR}/ggml/src/ggml-alloc.c
    ${WHISPER_DIR}/ggml/src/ggml-backend.cpp
    ${WHISPER_DIR}/ggml/src/ggml-quants.c
)

find_library(LOG_LIB log)
find_library(ANDROID_LIB android)

function(build_library target_name)
    add_library(
        ${target_name}
        SHARED
        ${SOURCE_FILES}
    )

    if (${target_name} STREQUAL "whisper_v8fp16_va")
        target_compile_options(${target_name} PRIVATE -march=armv8.2-a+fp16)
    elseif (${target_name} STREQUAL "whisper_vfpv4")
        target_compile_options(${target_name} PRIVATE -mfpu=neon-vfpv4)
    endif ()

    if (NOT ${CMAKE_BUILD_TYPE} STREQUAL "Debug")
        target_compile_options(${target_name} PRIVATE -O3)
        target_compile_options(${target_name} PRIVATE -fvisibility=hidden -fvisibility-inlines-hidden)
        target_compile_options(${target_name} PRIVATE -ffunction-sections -fdata-sections)

        target_link_options(${target_name} PRIVATE -Wl,--gc-sections)
        target_link_options(${target_name} PRIVATE -Wl,--exclude-libs,ALL)
        target_link_options(${target_name} PRIVATE -flto)
    endif ()

    target_include_directories(${target_name} PRIVATE
        ${WHISPER_DIR}
        ${WHISPER_DIR}/src
        ${WHISPER_DIR}/include
        ${WHISPER_DIR}/ggml/include
        ${WHISPER_DIR}/ggml/src
    )

    target_link_libraries(${target_name} PRIVATE ${LOG_LIB} ${ANDROID_LIB})
endfunction()

if (${ANDROID_ABI} STREQUAL "arm64-v8a")
    build_library("whisper_v8fp16_va")
elseif (${ANDROID_ABI} STREQUAL "armeabi-v7a")
    build_library("whisper_vfpv4")
endif ()

build_library("whisper")
