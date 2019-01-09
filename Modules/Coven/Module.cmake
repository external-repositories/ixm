include_guard(GLOBAL)

#[[

This is for generating unity builds on a per-directory (aka, a "legacy
module") basis. This is ONLY for directories that are:
 * Not located at 'src/bin'
 * Do not have a src/**/main.{ext} file
 * Still relying on headers
]]
 
macro(ixm_coven_module_vars path)
  file(RELATIVE_PATH path "${PROJECT_SOURCE_DIR}/src" "${path}")
  string(REPLACE "/" "::" alias ${PROJECT_NAME}::${path})
  string(REPLACE "/" "-" target ${PROJECT_NAME}-${path})
  string(REPLACE "/" "_" flag ${PROJECT_NAME}_BUILD_MODULE_${name})
  string(TOUPPER "${flag}" flag)
  set(ixm "${PROJECT_BINARY_DIR}/IXM")
  set(hdr "${PROJECT_SOURCE_DIR}/src/${path}/module") # NAME_WE
  set(src "${ixm}/${path}.cxx")
  set(rsp "${ixm}/${path}.rsp")
  set(pch "${ixm}/${path}.gch")
endmacro()

macro (ixm_coven_module_rsp path)
  set(COMPILE_DEFINITIONS "$<TARGET_PROPERTY:${target},COMPILE_DEFINITIONS>")
  set(COMPILE_DEFINITIONS "$<$<BOOL:${COMPILE_DEFINITIONS}>:-D$<JOIN:${COMPILE_DEFINITIONS},\n-D\n>>")
  set(INCLUDE_DIRECTORIES "$<TARGET_PROPERTY:${target},INCLUDE_DIRECTORIES>")
  set(INCLUDE_DIRECTORIES "$<$<BOOL:${INCLUDE_DEFINITIONS}>:-D$<JOIN:${INCLUDE_DEFINITIONS},\n-I\n>>")
  set(COMPILE_OPTIONS "$<$<BOOL:${COMPILE_OPTIONS}>:$<JOIN:${COMPILE_OPTIONS},\n>>")
  set(COMPILE_FLAGS "$<$<BOOL:${COMPILE_FLAGS}>:$<JOIN:${COMPILE_FLAGS},\n>>"
  file(GENERATE
    OUTPUT ${rsp}
    CONTENT ${COMPILE_DEFINITIONS}${INCLUDE_DIRECTORIES}${COMPILE_OPTIONS}${COMPILE_FLAGS})
endmacro()

function (ixm_coven_generate_module path)
  ixm_coven_module_vars(${path})
  option(flag "Build ${alias} as a unity build" ON)
  add_library(${target} OBJECT)
  add_library(${alias} ALIAS ${target})
  target_include_directories(${target} PRIVATE "${ixm}/${path}")
endfunction()

function (ixm_coven_generate_unity path)
  ixm_coven_module_vars(${path})
  set(COMMENT "/* Generated by IXM::Coven. DO NOT EDIT. */")
  # TODO: Need to get ALL *proper* file extensions :)
  file(GLOB sources
    LIST_DIRECTORIES OFF
    RELATIVE ${PROJECT_SOURCE_DIR}
    CONFIGURE_DEPENDS "${path}/*.*")
  file(RELATIVE_PATH path "${PROJECT_SOURCE_DIR}/src" "${path}")
  file(GENERATE
    OUTPUT ${src}
    CONTENT "${COMMENT}\n#include <$<JOIN:${sources},$<ANGLE-R>\n@include <>>>"
    CONDITION $<BOOL:${flag}>)
  target_sources(${target}
    PRIVATE
      $<IF:$<BOOL:${flag}>,${src},${sources}>)
endfunction()

function (ixm_coven_generate_pch path)
  ixm_coven_module_vars(${path})
  # Here, we look for a file named "${path}/module.hpp". If no such file
  # exists, we return, as PCH are optional.
  # If there IS a module.{header-ext} and a module.{ext}, then we know we have
  # a pair of files for precompiling our headers.
  ixm_coven_module_rsp(${path})
  add_custom_command(
    OUTPUT ${pch}
    DEPENDS ${hdr} ${rsp}
    COMMAND "${CMAKE_CXX_COMPILER}"
      "-x" "c++-header"
      "-o" "${pch}"
      "${hdr}" "@${rsp}" 
    COMMENT Generating "PCH for C++ legacy module '${alias}'")
  target_compile_options(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:GNU>:-Winvalid-pch>
      $<$<CXX_COMPILER_ID:GNU>:-include ${hdr}>)
  target_sources(${target}
    PRIVATE
      $<$<BOOL:${flag}>,${rsp}>)
  set_property(SOURCE ${src} APPEND PROPERTY OBJECT_DEPENDS ${rsp} ${pch})
endfunction()
