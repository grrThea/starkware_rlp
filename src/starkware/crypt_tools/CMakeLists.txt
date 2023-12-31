add_subdirectory(hash_context)

add_library(crypto_utils INTERFACE)
target_link_libraries(crypto_utils INTERFACE blake2s Keccak1600F pedersen_hash_context)

add_library(crypto_test_utils test_utils.cc)

add_executable(utils_test utils_test.cc)
target_link_libraries(utils_test starkware_gtest)
add_test(utils_test utils_test)

add_executable(keccak_256_test keccak_256_test.cc)
target_link_libraries(keccak_256_test starkware_gtest crypto_test_utils)
add_test(keccak_256_test keccak_256_test)

add_executable(masked_hash_test masked_hash_test.cc)
target_link_libraries(masked_hash_test starkware_gtest)
add_test(masked_hash_test masked_hash_test)

add_executable(blake2s_test blake2s_test.cc)
target_link_libraries(blake2s_test blake2s starkware_gtest)
add_test(blake2s_test blake2s_test)

add_executable(pedersen_test pedersen_test.cc)
target_link_libraries(pedersen_test algebra pedersen_hash_context starkware_gtest crypto_test_utils)
add_test(pedersen_test pedersen_test)
