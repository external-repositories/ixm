include_guard(GLOBAL)

function (coven_benchmark_init)
  string(MAKE_C_IDENTIFIER "${PROJECT_NAME}" project)
  string(TOUPPER "${project}" project)
  if (NOT ${project}_BUILD_BENCHMARKS)
    return()
  endif()
  glob(items "${PROJECT_SOURCE_DIR}/benches/*")
  foreach (item IN LISTS items)
    if (IS_DIRECTORY "${item}")
      glob(files FILES_ONLY "${item}/*")
      if (NOT files)
        continue()
      else()
        set(files "${item}")
      endif()
      coven_common_create_test(bench "${item}" ${files})
      set_property(TARGET ${target} PROPERTY
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/benches)
    endif()
  endforeach ()
endfunction()
