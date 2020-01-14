include_guard(GLOBAL)

function (coven_common_check_main out-var directory)
  get_property(extensions GLOBAL PROPERTY ixm::extensions::source)
  foreach (extension IN LISTS extensions)
    if (EXISTS "${directory}/main.${extension}")
      set(${out-var} ON PARENT_SCOPE)
      return()
    endif()
  endforeach()
endfunction()

function (coven_common_project_name out-var)
  string(MAKE_C_IDENTIFIER "${PROJECT_NAME}" project)
  string(TOUPPER "${project}" project)
  set(${out-var} ${project} PARENT_SCOPE)
endfunction()
