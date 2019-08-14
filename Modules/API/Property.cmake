include_guard(GLOBAL)

import(IXM::Property::*)

function (property action)
  if (action STREQUAL "DEFINE")
    ixm_property_define(${ARGN})
  elseif (action STREQUAL "GET")
    ixm_property_get(${ARGN})
  elseif (action STREQUAL "SET")
    ixm_property_set(${ARGN})
  elseif (action STREQUAL "GENEXP")
    ixm_property_genexp(${ARGN})
  else()
    fatal("property(${action}) is not a supported action")
  endif()
endfunction()