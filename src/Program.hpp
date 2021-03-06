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
#include <ostream>
#include "common.hpp"
#include "Instruction.hpp"

class Pcg32;

namespace RandomX {

	class Program {
	public:
		Instruction& operator()(uint64_t pc) {
			return programBuffer[pc];
		}
		void initialize(Pcg32& gen);
		friend std::ostream& operator<<(std::ostream& os, const Program& p) {
			p.print(os);
			return os;
		}
	private:
		void print(std::ostream&) const;
		Instruction programBuffer[ProgramLength];
	};
}
