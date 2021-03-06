/*
Copyright (c) 2018 tevador

This file is part of RandomX.

RandomX is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

RandomX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with RandomX.  If not, see<http://www.gnu.org/licenses/>.
*/

#pragma once

#include <cstdint>
#include <array>
#include "intrinPortable.h"
#include "common.hpp"
#include "softAes.h"

namespace RandomX {

	using KeysContainer = std::array<__m128i, 10>;

	template<bool soft, bool enc>
	void initBlock(const uint8_t* in, uint8_t* out, uint32_t blockNumber, const KeysContainer& keys);

	template<bool softAes>
	void initBlock(const uint8_t* cache, uint8_t* block, uint32_t blockNumber, const KeysContainer& keys);

	void datasetAlloc(dataset_t& ds);

	template<bool softAes>
	void datasetInit(Cache* cache, dataset_t ds, uint32_t startBlock, uint32_t blockCount);

	convertible_t datasetRead(addr_t addr, MemoryRegisters& memory);

	template<bool softAes>
	void datasetInitCache(const void* seed, dataset_t& dataset);

	template<bool softAes>
	convertible_t datasetReadLight(addr_t addr, MemoryRegisters& memory);
}

