// Copyright 2023 StarkWare Industries Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.starkware.co/open-source-license/
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions
// and limitations under the License.

#ifndef STARKWARE_CRYPT_TOOLS_TEST_UTILS_H_
#define STARKWARE_CRYPT_TOOLS_TEST_UTILS_H_

#include <cstddef>
#include <vector>

namespace starkware {

std::vector<std::byte> GenerateTestVector(size_t length);

}  // namespace starkware

#endif  // STARKWARE_CRYPT_TOOLS_TEST_UTILS_H_
