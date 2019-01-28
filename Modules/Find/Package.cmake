include_guard(GLOBAL)

function (ixm_find_package name)
  parse(${ARGN}
    @FLAGS EXACT QUIET MODULE REQUIRED NO_POLICY_SCOPE
    @ARGS=* COMPONENTS OPTIONAL_COMPONENTS)

  find_package(${name} ${ARGN})
  if (NOT TARGET ixm::find::${name})
    set(${name}::Found ${name}_FOUND PARENT_SCOPE)
    upvar(${name}_FOUND)
    return()
  endif()
  # THIS IS WHERE WE DO ACTUAL CONFIRMATION!!!
  set(${name}::Found OFF PARENT_SCOPE)
  set(${name}_FOUND OFF PARENT_SCOPE)

  if (NOT TARGET ${name}::${name})
    set(${name}::Found ${name}_FOUND PARENT_SCOPE)
    upvar(${name}_FOUND)
    return()
  endif()

  # Handle EXACT here
  if (REMAINDER)
    list(GET ARGN 0 version)
  endif()

  foreach (component IN LISTS COMPONENTS)
    if (NOT TARGET ${name}::${component})
      return() # Error here if REQUIRED
    endif()
  endforeach()

  # Hooray, we've been found! :v
  set(${name}::Found ON PARENT_SCOPE)
  set(${name}_FOUND ON PARENT_SCOPE)
endfunction()
