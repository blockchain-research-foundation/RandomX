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
//#define TRACEVM
#include "VirtualMachine.hpp"
#include "JitCompilerX86.hpp"

namespace RandomX {

	class CompiledVirtualMachine : public VirtualMachine {
	public:
		CompiledVirtualMachine(bool softAes);
		void setDataset(dataset_t ds, bool light = false) override;
		void initializeProgram(const void* seed) override;
		virtual void execute() override;
		void* getProgram() {
			return compiler.getCode();
		}
	private:
#ifdef TRACEVM
		convertible_t tracepad[InstructionCount];
#endif
		JitCompilerX86 compiler;
	};
}