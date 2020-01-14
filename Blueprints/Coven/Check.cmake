include_guard(GLOBAL)

include(CheckCXXCompilerFlag)
include(CheckCCompilerFlag)

# TODO: Move this to check(SANITIZER) for the check API. It doesn't belong
# in Coven.
function (coven_check_asan)
  #  void(old)
  #  if (DEFINED CMAKE_TRY_COMPILE_TARGET_TYPE)
  #    set(old ${CMAKE_TRY_COMPILE_TARGET_TYPE})
  #  endif()
  #  set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
  #  if (DEFINED CMAKE_C_COMPILER)
  #    check_c_compiler_flag(-fsanitize=address COVEN_C_FLAG_SANITIZE_ADDRESS)
  #  endif()
  #  if (DEFINED CMAKE_CXX_COMPILER)
  #    check_cxx_compiler_flag(-fsanitize=address COVEN_CXX_FLAG_SANITIZE_ADDRESS)
  #  endif()
  #  set(CMAKE_TRY_COMPILE_TARGET_TYPE ${old})
endfunction()

function (coven_check_ubsan)
endfunction()
