/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include "kernel/yosys.h"
#include "kernel/mem.h"

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct MemoryMemxPass : public Pass {
	MemoryMemxPass() : Pass("memory_memx", "emulate vlog sim behavior for mem ports") { }
	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    memory_memx [selection]\n");
		log("\n");
		log("This pass adds additional circuitry that emulates the Verilog simulation\n");
		log("behavior for out-of-bounds memory reads and writes.\n");
		log("\n");
	}

	SigSpec make_addr_check(Mem &mem, SigSpec addr) {
		int start_addr = mem.start_offset;
		int end_addr = mem.start_offset + mem.size;

		addr.extend_u0(32);

		SigSpec res = mem.module->Nex(NEW_ID, mem.module->ReduceXor(NEW_ID, addr), mem.module->ReduceXor(NEW_ID, {addr, State::S1}));
		if (start_addr != 0)
			res = mem.module->LogicAnd(NEW_ID, res, mem.module->Ge(NEW_ID, addr, start_addr));
		res = mem.module->LogicAnd(NEW_ID, res, mem.module->Lt(NEW_ID, addr, end_addr));
		return res;
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override {
		log_header(design, "Executing MEMORY_MEMX pass (converting $mem cells to logic and flip-flops).\n");
		extra_args(args, 1, design);

		for (auto module : design->selected_modules())
		for (auto &mem : Mem::get_selected_memories(module))
		{
			for (auto &port : mem.rd_ports)
			{
				if (port.clk_enable)
					log_error("Memory %s.%s has a synchronous read port.  Synchronous read ports are not supported by memory_memx!\n",
							log_id(module), log_id(mem.memid));

				SigSpec addr_ok = make_addr_check(mem, port.addr);
				Wire *raw_rdata = module->addWire(NEW_ID, GetSize(port.data));
				module->addMux(NEW_ID, SigSpec(State::Sx, GetSize(port.data)), raw_rdata, addr_ok, port.data);
				port.data = raw_rdata;
			}

			for (auto &port : mem.wr_ports) {
				SigSpec addr_ok = make_addr_check(mem, port.addr);
				port.en = module->And(NEW_ID, port.en, addr_ok.repeat(GetSize(port.en)));
			}

			mem.emit();
		}
	}
} MemoryMemxPass;

PRIVATE_NAMESPACE_END
