add_library(domains list_of_cosets.cc multiplicative_group.cc)
target_link_libraries(domains third_party)

add_executable(multiplicative_group_test multiplicative_group_test.cc)
target_link_libraries(multiplicative_group_test algebra starkware_gtest)
add_test(multiplicative_group_test multiplicative_group_test)

add_executable(list_of_cosets_test list_of_cosets_test.cc)
target_link_libraries(list_of_cosets_test algebra starkware_gtest)
add_test(list_of_cosets_test list_of_cosets_test)
