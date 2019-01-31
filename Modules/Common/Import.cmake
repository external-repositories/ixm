include_guard(GLOBAL)

#[[
Originally had more complex syntax. I gave up and decided to make it simple :v
import(${root}::Submodule) -> ${root}_MODULE_ROOT/Submodule.cmake
import(${root}::*) -> ${root}_MODULE_ROOT/*.cmake
]]

function (ixm_import_find var name)
  string(REPLACE "::" ";" paths ${name})
  list(LENGTH paths length)
  if (length LESS 2)
    error("Imports must have a path larger than just the module root!")
  endif()
  list(GET paths 0 root)
  if (NOT DEFINED ${root}_MODULE_ROOT)
    error("${root}_MODULE_ROOT is not defined.")
  endif()
  if (NOT IS_DIRECTORY "${${root}_MODULE_ROOT}")
    error("${root}_MODULE_ROOT must be a directory")
  endif()
  if (NOT IS_ABSOLUTE "${${root}_MODULE_ROOT}")
    error("${root}_MODULE_ROOT must be an absolute path")
  endif()
  list(REMOVE_AT paths 0)
  string(JOIN "/" paths ${paths})
  file(GLOB files LIST_DIRECTORIES OFF
    "${${root}_MODULE_ROOT}/${paths}.cmake")
  set(${var} ${files} PARENT_SCOPE)
endfunction()

macro (import name)
  ixm_import_find(@import-files ${name})
  foreach (file IN LISTS @import-files)
    include(${file})
  endforeach()
  unset(@import-files)
endmacro()

#[[
This is just a simple wrapper to let a user declare a module, *and* set it's
${name}_MODULE_ROOT all in one go.
]]
macro(module name)
  include_guard(GLOBAL)
  internal(${name}_MODULE_ROOT
    ${CMAKE_CURRENT_LIST_DIR}
    "Module Root for '${name}'")
endmacro()