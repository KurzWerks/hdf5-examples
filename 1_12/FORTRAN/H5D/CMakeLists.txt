cmake_minimum_required (VERSION 3.12)
PROJECT (HDF5Examples_FORTRAN_H5D C CXX Fortran)

# --------------------------------------------------------------------
# Notes: When creating examples they should be prefixed
# with "f90_". This allows for easier filtering of the examples.
# --------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Setup include Directories
#-----------------------------------------------------------------------------
INCLUDE_DIRECTORIES (
    ${CMAKE_Fortran_MODULE_DIRECTORY}
    ${PROJECT_BINARY_DIR}
    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
)

#-----------------------------------------------------------------------------
# Define Sources
#-----------------------------------------------------------------------------
include (Fortran_sourcefiles.cmake)

foreach (example ${examples})
  get_filename_component (example_name ${example} NAME_WE)
  add_executable (f90_${example_name} ${PROJECT_SOURCE_DIR}/${example})
  if (H5_HAVE_PARALLEL)
    target_include_directories (f90_${example_name} PUBLIC ${MPI_Fortran_INCLUDE_DIRS})
  endif ()
  target_link_libraries (f90_${example_name} ${LINK_Fortran_LIBS})
  set_target_properties (f90_${example_name} PROPERTIES LINKER_LANGUAGE Fortran)
endforeach ()

if (BUILD_TESTING)
  macro (ADD_H5_TEST testname)
    add_test (
        NAME f90_${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove
            ${testname}.h5
    )
    add_test (
        NAME f90_${testname}
        COMMAND "${CMAKE_COMMAND}"
            -D "TEST_PROGRAM=$<TARGET_FILE:f90_${testname}>"
            -D "TEST_ARGS:STRING="
            -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
            -D "TEST_EXPECT=0"
            -D "TEST_OUTPUT=${testname}.out"
            -D "TEST_REFERENCE=${testname}.tst"
            -D "TEST_LIBRARY_DIRECTORY=${CMAKE_TEST_LIB_DIRECTORY}"
            -P "${HDF5EX_RESOURCES_DIR}/runTest.cmake"
    )
    set_tests_properties (f90_${testname} PROPERTIES DEPENDS f90_${testname}-clearall)
    if (HDF5_BUILD_TOOLS)
      add_test (
          NAME H5DUMP-f90_${testname}
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=${HDF5_DUMP_EXECUTABLE}"
              -D "TEST_ARGS:STRING=${ARGN};${testname}.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}.ddl.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}.ddl"
              -D "TEST_LIBRARY_DIRECTORY=${CMAKE_TEST_LIB_DIRECTORY}"
              -P "${HDF5EX_RESOURCES_DIR}/runTest.cmake"
      )
      set_tests_properties (H5DUMP-f90_${testname} PROPERTIES DEPENDS f90_${testname})
    endif ()
  endmacro ()

  foreach (example ${examples})
    get_filename_component (example_name ${example} NAME_WE)
    set (testdest "${PROJECT_BINARY_DIR}/${example_name}")
    #message (STATUS " Copying ${example_name}.test")
    add_custom_command (
        TARGET     f90_${example_name}
        POST_BUILD
        COMMAND    ${CMAKE_COMMAND}
        ARGS       -E copy_if_different ${PROJECT_SOURCE_DIR}/testfiles/${example_name}.tst ${testdest}.tst
    )
    if (HDF5_BUILD_TOOLS)
      add_custom_command (
          TARGET     f90_${example_name}
          POST_BUILD
          COMMAND    ${CMAKE_COMMAND}
          ARGS       -E copy_if_different ${PROJECT_SOURCE_DIR}/testfiles/${example_name}.ddl ${testdest}.ddl
      )
    endif ()

    if (${example_name} STREQUAL "h5ex_d_transform")
      ADD_H5_TEST (${example_name} -n)
    else ()
      ADD_H5_TEST (${example_name})
    endif ()
  endforeach ()
endif ()
