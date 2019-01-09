include_guard(GLOBAL)

include(CTest)

function (ixm_coven_generate_tests)
  file(GLOB items LIST_DIRECTORIES ON "${PROJECT_SOURCE_DIR}/tests/*")
  foreach (item IN LISTS items)
    get_filename_component(name ${item} NAME_WE)
    set(target ${PROJECT_NAME}-test-${name})
    set(alias ${PROJECT_NAME}::test::${name})
    if (IS_DIRECTORY ${item}) # Glob all contents, then add as test
      file(GLOB files LIST_DIRECTORIES OFF CONFIGURE_DEPENDS "${item}/*")
    else()
      list(APPEND files ${item})
    endif()
    add_executable(${target})
    add_executable(${alias} ALIAS ${target})
    add_test(test-${name} ${target})
  endforeach()
endfunction()
