	.arch armv8-a
	.file	"md5.cpp"
// GNU C++14 (GCC) version 10.3.1 (aarch64-linux-gnu)
//	compiled by GNU C version 10.3.1, GMP version 6.2.1, MPFR version 4.1.0-p9, MPC version 1.2.0, isl version none
// GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
// options passed:  -D_GNU_SOURCE md5.cpp -mlittle-endian -mabi=lp64
// -auxbase-strip md5_scalar_O2.s -O2 -fverbose-asm
// options enabled:  -faggressive-loop-optimizations -falign-functions
// -falign-jumps -falign-labels -falign-loops -fallocation-dce
// -fasynchronous-unwind-tables -fauto-inc-dec -fbranch-count-reg
// -fcaller-saves -fcode-hoisting -fcombine-stack-adjustments
// -fcompare-elim -fcprop-registers -fcrossjumping -fcse-follow-jumps
// -fdefer-pop -fdelete-null-pointer-checks -fdevirtualize
// -fdevirtualize-speculatively -fdwarf2-cfi-asm -fearly-inlining
// -feliminate-unused-debug-symbols -feliminate-unused-debug-types
// -fexceptions -fexpensive-optimizations -ffinite-loops
// -fforward-propagate -ffp-int-builtin-inexact -ffunction-cse -fgcse
// -fgcse-lm -fgnu-unique -fguess-branch-probability -fhoist-adjacent-loads
// -fident -fif-conversion -fif-conversion2 -findirect-inlining -finline
// -finline-atomics -finline-functions -finline-functions-called-once
// -finline-small-functions -fipa-bit-cp -fipa-cp -fipa-icf
// -fipa-icf-functions -fipa-icf-variables -fipa-profile -fipa-pure-const
// -fipa-ra -fipa-reference -fipa-reference-addressable -fipa-sra
// -fipa-stack-alignment -fipa-vrp -fira-hoist-pressure
// -fira-share-save-slots -fira-share-spill-slots
// -fisolate-erroneous-paths-dereference -fivopts -fkeep-static-consts
// -fleading-underscore -flifetime-dse -flra-remat -fmath-errno
// -fmerge-constants -fmerge-debug-strings -fmove-loop-invariants
// -fomit-frame-pointer -foptimize-sibling-calls -foptimize-strlen
// -fpartial-inlining -fpeephole -fpeephole2 -fplt -fprefetch-loop-arrays
// -free -freg-struct-return -freorder-blocks -freorder-functions
// -frerun-cse-after-loop -fsched-critical-path-heuristic
// -fsched-dep-count-heuristic -fsched-group-heuristic -fsched-interblock
// -fsched-last-insn-heuristic -fsched-pressure -fsched-rank-heuristic
// -fsched-spec -fsched-spec-insn-heuristic -fsched-stalled-insns-dep
// -fschedule-fusion -fschedule-insns -fschedule-insns2 -fsection-anchors
// -fsemantic-interposition -fshow-column -fshrink-wrap
// -fshrink-wrap-separate -fsigned-zeros -fsplit-ivs-in-unroller
// -fsplit-wide-types -fssa-backprop -fssa-phiopt -fstdarg-opt
// -fstore-merging -fstrict-aliasing -fstrict-volatile-bitfields
// -fsync-libcalls -fthread-jumps -ftoplevel-reorder -ftrapping-math
// -ftree-bit-ccp -ftree-builtin-call-dce -ftree-ccp -ftree-ch
// -ftree-coalesce-vars -ftree-copy-prop -ftree-cselim -ftree-dce
// -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre
// -ftree-loop-distribute-patterns -ftree-loop-if-convert -ftree-loop-im
// -ftree-loop-ivcanon -ftree-loop-optimize -ftree-parallelize-loops=
// -ftree-phiprop -ftree-pre -ftree-pta -ftree-reassoc -ftree-scev-cprop
// -ftree-sink -ftree-slsr -ftree-sra -ftree-switch-conversion
// -ftree-tail-merge -ftree-ter -ftree-vrp -funit-at-a-time -funwind-tables
// -fverbose-asm -fzero-initialized-in-bss -mfix-cortex-a53-835769
// -mfix-cortex-a53-843419 -mglibc -mlittle-endian
// -momit-leaf-frame-pointer -mpc-relative-literal-loads

	.text
	.align	2
	.p2align 4,,11
	.global	_Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi
	.type	_Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi, %function
_Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi:
.LFB2499:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!	//,,,
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp	//,
	stp	x21, x22, [sp, 32]	//,,
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x1	// n_byte, tmp155
// md5.cpp:19: 	int length = input.length();
	ldp	x21, x5, [x0]	// _20, MEM[(const struct basic_string *)input_19(D)]._M_string_length, MEM[(const struct basic_string *)input_19(D)]._M_dataplus._M_p
// md5.cpp:16: {
	stp	x19, x20, [sp, 16]	//,,
	stp	x23, x24, [sp, 48]	//,,
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.cfi_offset 23, -16
	.cfi_offset 24, -8
// md5.cpp:22: 	int bitLength = length * 8;
	lsl	w2, w5, 3	// bitLength, MEM[(const struct basic_string *)input_19(D)]._M_string_length,
// md5.cpp:27: 	int paddingBits = bitLength % 512;
	negs	w0, w2	// tmp124, bitLength
	and	w2, w2, 511	// tmp125, bitLength,
	and	w0, w0, 511	// tmp126, tmp124,
	csneg	w0, w2, w0, mi	// paddingBits, tmp125, tmp126,
// md5.cpp:28: 	if (paddingBits > 448)
	cmp	w0, 448	// paddingBits,
	ble	.L2		//,
// md5.cpp:30: 		paddingBits = 512 - (paddingBits - 448);
	mov	w4, 960	// tmp128,
	sub	w4, w4, w0	// paddingBits, tmp128, paddingBits
// md5.cpp:42: 	int paddingBytes = paddingBits / 8;
	asr	w4, w4, 3	// _54, paddingBits,
// md5.cpp:57: 	memset(paddedMessage + length + 1, 0, paddingBytes - 1); // 填充0字节
	sub	w23, w4, #1	// tmp129, _54,
// md5.cpp:57: 	memset(paddedMessage + length + 1, 0, paddingBytes - 1); // 填充0字节
	sxtw	x23, w23	// _59, tmp129
.L3:
// md5.cpp:48: 	int paddedLength = length + paddingBytes + 8;
	add	w19, w4, w5	// _1, _54, MEM[(const struct basic_string *)input_19(D)]._M_string_length
// md5.cpp:52: 	memcpy(paddedMessage, blocks, length);
	sxtw	x20, w5	// _2, MEM[(const struct basic_string *)input_19(D)]._M_string_length
// md5.cpp:48: 	int paddedLength = length + paddingBytes + 8;
	add	w24, w19, 8	// paddedLength, _1,
// md5.cpp:49: 	Byte *paddedMessage = new Byte[paddedLength];
	sxtw	x0, w24	//, paddedLength
	bl	_Znam		//
// md5.cpp:52: 	memcpy(paddedMessage, blocks, length);
	mov	x1, x21	//, _20
// md5.cpp:49: 	Byte *paddedMessage = new Byte[paddedLength];
	mov	x21, x0	// <retval>, tmp156
// md5.cpp:52: 	memcpy(paddedMessage, blocks, length);
	mov	x2, x20	//, _2
	bl	memcpy		//
// md5.cpp:56: 	paddedMessage[length] = 0x80;							 // 添加一个0x80字节
	mov	w3, -128	// tmp140,
// md5.cpp:57: 	memset(paddedMessage + length + 1, 0, paddingBytes - 1); // 填充0字节
	add	x0, x20, 1	// tmp141, _2,
// md5.cpp:56: 	paddedMessage[length] = 0x80;							 // 添加一个0x80字节
	strb	w3, [x21, x20]	// tmp140, *_3
// md5.cpp:57: 	memset(paddedMessage + length + 1, 0, paddingBytes - 1); // 填充0字节
	mov	x2, x23	//, _59
	add	x0, x21, x0	//, <retval>, tmp141
	mov	w1, 0	//,
	bl	memset		//
// md5.cpp:64: 		paddedMessage[length + paddingBytes + i] = ((uint64_t)length * 8 >> (i * 8)) & 0xFF;
	add	x4, x21, x19, sxtw	// tmp148, <retval>, _1
// md5.cpp:64: 		paddedMessage[length + paddingBytes + i] = ((uint64_t)length * 8 >> (i * 8)) & 0xFF;
	lsl	x5, x20, 3	// _8, _2,
	mov	x2, 0	// ivtmp.543,
	.p2align 3,,7
.L4:
// md5.cpp:64: 		paddedMessage[length + paddingBytes + i] = ((uint64_t)length * 8 >> (i * 8)) & 0xFF;
	lsl	w3, w2, 3	// tmp149, ivtmp.543,
// md5.cpp:64: 		paddedMessage[length + paddingBytes + i] = ((uint64_t)length * 8 >> (i * 8)) & 0xFF;
	lsr	x3, x5, x3	// tmp150, _8, tmp149
// md5.cpp:64: 		paddedMessage[length + paddingBytes + i] = ((uint64_t)length * 8 >> (i * 8)) & 0xFF;
	strb	w3, [x4, x2]	// tmp150, MEM[base: _45, index: ivtmp.543_52, offset: 0B]
// md5.cpp:60: 	for (int i = 0; i < 8; ++i)
	add	x2, x2, 1	// ivtmp.543, ivtmp.543,
	cmp	x2, 8	// ivtmp.543,
	bne	.L4		//,
// md5.cpp:74: }
	ldp	x19, x20, [sp, 16]	//,,
// md5.cpp:72: 	*n_byte = paddedLength;
	str	w24, [x22]	// paddedLength, *n_byte_37(D)
// md5.cpp:74: }
	mov	x0, x21	//, <retval>
	ldp	x21, x22, [sp, 32]	//,,
	ldp	x23, x24, [sp, 48]	//,,
	ldp	x29, x30, [sp], 64	//,,,
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret	
	.p2align 2,,3
.L2:
	.cfi_restore_state
// md5.cpp:32: 	else if (paddingBits < 448)
	beq	.L5		//,
// md5.cpp:34: 		paddingBits = 448 - paddingBits;
	mov	w4, 448	// tmp131,
	sub	w4, w4, w0	// paddingBits, tmp131, paddingBits
// md5.cpp:42: 	int paddingBytes = paddingBits / 8;
	asr	w4, w4, 3	// _54, paddingBits,
// md5.cpp:57: 	memset(paddedMessage + length + 1, 0, paddingBytes - 1); // 填充0字节
	sub	w23, w4, #1	// tmp132, _54,
// md5.cpp:57: 	memset(paddedMessage + length + 1, 0, paddingBytes - 1); // 填充0字节
	sxtw	x23, w23	// _59, tmp132
	b	.L3		//
	.p2align 2,,3
.L5:
	mov	w4, 64	// _54,
	mov	x23, 63	// _59,
	b	.L3		//
	.cfi_endproc
.LFE2499:
	.size	_Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi, .-_Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"basic_string::_M_construct null not valid"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z7MD5HashNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPj
	.type	_Z7MD5HashNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPj, %function
_Z7MD5HashNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPj:
.LFB2500:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA2500
	stp	x29, x30, [sp, -192]!	//,,,
	.cfi_def_cfa_offset 192
	.cfi_offset 29, -192
	.cfi_offset 30, -184
	mov	x29, sp	//,
	stp	x19, x20, [sp, 16]	//,,
	.cfi_offset 19, -176
	.cfi_offset 20, -168
	mov	x20, x0	// input, tmp1207
	mov	x19, x1	// state, tmp1208
// md5.cpp:87: 	int *messageLength = new int[1];
	mov	x0, 4	//,
// md5.cpp:84: {
	stp	x21, x22, [sp, 32]	//,,
.LEHB0:
	.cfi_offset 21, -160
	.cfi_offset 22, -152
// md5.cpp:87: 	int *messageLength = new int[1];
	bl	_Znam		//
.LEHE0:
// /usr/include/c++/10.3.1/bits/basic_string.h:908:       { return _M_string_length; }
	ldp	x21, x20, [x20]	// _622, prephitmp_471, MEM[(const struct basic_string *)input_568(D)]._M_dataplus._M_p
// /usr/include/c++/10.3.1/bits/basic_string.h:160: 	: allocator_type(std::move(__a)), _M_p(__dat) { }
	add	x1, sp, 144	// tmp666,,
// md5.cpp:87: 	int *messageLength = new int[1];
	str	x0, [sp, 104]	// tmp1209, %sfp
// /usr/include/c++/10.3.1/bits/basic_string.h:160: 	: allocator_type(std::move(__a)), _M_p(__dat) { }
	str	x1, [sp, 128]	// tmp666, MEM[(struct _Alloc_hider *)_567]._M_p
// /usr/include/c++/10.3.1/bits/basic_string.tcc:211: 	if (__gnu_cxx::__is_null_pointer(__beg) && __beg != __end)
	cmn	x21, x20	// _622, prephitmp_471
	ccmp	x21, 0, 0, ne	// _622,,,
	beq	.L33		//,
// /usr/include/c++/10.3.1/bits/basic_string.tcc:215: 	size_type __dnew = static_cast<size_type>(std::distance(__beg, __end));
	str	x20, [sp, 120]	// prephitmp_471, __dnew
// /usr/include/c++/10.3.1/bits/basic_string.tcc:217: 	if (__dnew > size_type(_S_local_capacity))
	cmp	x20, 15	// prephitmp_471,
	bhi	.L34		//,
// /usr/include/c++/10.3.1/bits/basic_string.h:348: 	if (__n == 1)
	cmp	x20, 1	// prephitmp_471,
	bne	.L13		//,
// /usr/include/c++/10.3.1/bits/char_traits.h:329:       { __c1 = __c2; }
	ldrb	w2, [x21]	// _635, MEM[(const char_type &)_622]
// /usr/include/c++/10.3.1/bits/char_traits.h:329:       { __c1 = __c2; }
	mov	x0, x1	// pretmp_472, tmp666
// /usr/include/c++/10.3.1/bits/char_traits.h:329:       { __c1 = __c2; }
	strb	w2, [sp, 144]	// _635, MEM[(char_type &)_567]
.L14:
// md5.cpp:90: 		paddedMessage = StringProcess(input, &messageLength[i]);
	ldr	x1, [sp, 104]	//, %sfp
// /usr/include/c++/10.3.1/bits/basic_string.h:183:       { _M_string_length = __length; }
	str	x20, [sp, 136]	// prephitmp_471, MEM[(struct basic_string *)_567]._M_string_length
// /usr/include/c++/10.3.1/bits/char_traits.h:329:       { __c1 = __c2; }
	strb	wzr, [x0, x20]	//, MEM[(char_type &)_632]
// md5.cpp:90: 		paddedMessage = StringProcess(input, &messageLength[i]);
	add	x0, sp, 128	// tmp1240,,
.LEHB1:
	bl	_Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi		//
.LEHE1:
// /usr/include/c++/10.3.1/bits/basic_string.h:187:       { return _M_dataplus._M_p; }
	ldr	x2, [sp, 128]	// _636, MEM[(struct basic_string *)_567]._M_dataplus._M_p
// /usr/include/c++/10.3.1/bits/basic_string.h:231: 	if (!_M_is_local())
	add	x1, sp, 144	// tmp685,,
	stp	x25, x26, [sp, 64]	//,,
	.cfi_offset 26, -120
	.cfi_offset 25, -128
// md5.cpp:90: 		paddedMessage = StringProcess(input, &messageLength[i]);
	mov	x21, x0	// _571, tmp1211
// /usr/include/c++/10.3.1/bits/basic_string.h:231: 	if (!_M_is_local())
	cmp	x2, x1	// _636, tmp685
	beq	.L15		//,
// /usr/include/c++/10.3.1/bits/basic_string.h:237:       { _Alloc_traits::deallocate(_M_get_allocator(), _M_data(), __size + 1); }
	ldr	x1, [sp, 144]	// MEM[(struct basic_string *)_567].D.21340._M_allocated_capacity, MEM[(struct basic_string *)_567].D.21340._M_allocated_capacity
// /usr/include/c++/10.3.1/ext/new_allocator.h:133: 	::operator delete(__p
	mov	x0, x2	//, _636
	add	x1, x1, 1	//, MEM[(struct basic_string *)_567].D.21340._M_allocated_capacity,
	bl	_ZdlPvm		//
.L15:
// md5.cpp:94: 	int n_blocks = messageLength[0] / 64;
	ldr	x0, [sp, 104]	// _564, %sfp
// md5.cpp:97: 	state[0] = 0x67452301;
	mov	x2, 8961	// tmp691,
// md5.cpp:99: 	state[2] = 0x98badcfe;
	mov	x1, 56574	// tmp692,
// md5.cpp:97: 	state[0] = 0x67452301;
	movk	x2, 0x6745, lsl 16	// tmp691,,
// md5.cpp:99: 	state[2] = 0x98badcfe;
	movk	x1, 0x98ba, lsl 16	// tmp692,,
// md5.cpp:97: 	state[0] = 0x67452301;
	movk	x2, 0xab89, lsl 32	// tmp691,,
// md5.cpp:94: 	int n_blocks = messageLength[0] / 64;
	ldr	w0, [x0]	//, *_564
// md5.cpp:99: 	state[2] = 0x98badcfe;
	movk	x1, 0x5476, lsl 32	// tmp692,,
// md5.cpp:97: 	state[0] = 0x67452301;
	movk	x2, 0xefcd, lsl 48	// tmp691,,
// md5.cpp:99: 	state[2] = 0x98badcfe;
	movk	x1, 0x1032, lsl 48	// tmp692,,
// md5.cpp:94: 	int n_blocks = messageLength[0] / 64;
	cmp	w0, 0	// _5,
	add	w20, w0, 63	// tmp689, _5,
	csel	w20, w20, w0, lt	// _5, tmp689, _5,
// md5.cpp:99: 	state[2] = 0x98badcfe;
	stp	x2, x1, [x19]	// tmp691, tmp692, MEM <unsigned long> [(bit32 *)state_576(D)]
// md5.cpp:94: 	int n_blocks = messageLength[0] / 64;
	asr	w25, w20, 6	// n_blocks, _5,
// md5.cpp:103: 	for (int i = 0; i < n_blocks; i += 1)
	cmp	w0, 63	// _5,
	ble	.L24		//,
	mov	w20, 43913	// prephitmp_495,
	mov	w22, 8961	// prephitmp_488,
	stp	x27, x28, [sp, 80]	//,,
	.cfi_offset 28, -104
	.cfi_offset 27, -112
	mov	w27, 21622	// prephitmp_503,
	mov	w28, 56574	// prephitmp_496,
	movk	w27, 0x1032, lsl 16	// prephitmp_503,,
	movk	w28, 0x98ba, lsl 16	// prephitmp_496,,
	movk	w20, 0xefcd, lsl 16	// prephitmp_495,,
	movk	w22, 0x6745, lsl 16	// prephitmp_488,,
	stp	x23, x24, [sp, 48]	//,,
	.cfi_offset 24, -136
	.cfi_offset 23, -144
	mov	x24, 0	// ivtmp.589,
// md5.cpp:103: 	for (int i = 0; i < n_blocks; i += 1)
	mov	w23, 0	// i,
	.p2align 3,,7
.L18:
	add	x0, x21, x24	// ivtmp.581, _571, ivtmp.589
	add	x4, sp, 128	// tmp1244,,
	add	x6, sp, 192	// _400,,
	.p2align 3,,7
.L17:
// md5.cpp:113: 					(paddedMessage[4 * i1 + 3 + i * 64] << 24);
	ldrb	w3, [x0, 3]	// MEM[base: _423, offset: 3B], MEM[base: _423, offset: 3B]
// md5.cpp:108: 		for (int i1 = 0; i1 < 16; ++i1)
	add	x0, x0, 4	// ivtmp.581, ivtmp.581,
// md5.cpp:112: 					(paddedMessage[4 * i1 + 2 + i * 64] << 16) |
	ldrb	w1, [x0, -2]	// MEM[base: _423, offset: 2B], MEM[base: _423, offset: 2B]
// md5.cpp:110: 			x[i1] = (paddedMessage[4 * i1 + i * 64]) |
	ldrb	w5, [x0, -4]	// MEM[base: _432, index: ivtmp.589_399, offset: 0B], MEM[base: _432, index: ivtmp.589_399, offset: 0B]
// md5.cpp:111: 					(paddedMessage[4 * i1 + 1 + i * 64] << 8) |
	ldrb	w2, [x0, -3]	// MEM[base: _423, offset: 1B], MEM[base: _423, offset: 1B]
// md5.cpp:113: 					(paddedMessage[4 * i1 + 3 + i * 64] << 24);
	lsl	w3, w3, 24	// tmp696, MEM[base: _423, offset: 3B],
// md5.cpp:112: 					(paddedMessage[4 * i1 + 2 + i * 64] << 16) |
	orr	w1, w3, w1, lsl 16	// tmp697, tmp696, MEM[base: _423, offset: 2B],
	orr	w2, w5, w2, lsl 8	// tmp702, MEM[base: _432, index: ivtmp.589_399, offset: 0B], MEM[base: _423, offset: 1B],
	orr	w1, w1, w2	// tmp703, tmp697, tmp702
// md5.cpp:110: 			x[i1] = (paddedMessage[4 * i1 + i * 64]) |
	str	w1, [x4], 4	// tmp703, MEM[base: _408, offset: 0B]
// md5.cpp:108: 		for (int i1 = 0; i1 < 16; ++i1)
	cmp	x6, x4	// _400, ivtmp.582
	bne	.L17		//,
// md5.cpp:118: 		auto start = system_clock::now();
	bl	_ZNSt6chrono3_V212system_clock3nowEv		//
// md5.cpp:103: 	for (int i = 0; i < n_blocks; i += 1)
	add	w23, w23, 1	// i, i,
// md5.cpp:121: 		FF(d, a, b, c, x[1], s12, 0xe8c7b756);
	ldp	w26, w9, [sp, 128]	//,, MEM[(unsigned int[16] *)_567][0]
// md5.cpp:120: 		FF(a, b, c, d, x[0], s11, 0xd76aa478);
	eor	w0, w28, w27	// tmp704, prephitmp_496, prephitmp_503
	and	w0, w0, w20	// tmp705, tmp704, prephitmp_495
	mov	w1, 42104	// tmp1245,
	eor	w0, w0, w27	// tmp706, tmp705, prephitmp_503
	movk	w1, 0xd76a, lsl 16	// tmp1245,,
	add	w0, w0, w22	// tmp707, tmp706, prephitmp_488
	add	w1, w26, w1	// tmp708, _50, tmp1245
	add	w0, w0, w1	// tmp710, tmp707, tmp708
// md5.cpp:121: 		FF(d, a, b, c, x[1], s12, 0xe8c7b756);
	eor	w3, w20, w28	// tmp712, prephitmp_495, prephitmp_496
	mov	w1, 46934	// tmp1246,
// md5.cpp:122: 		FF(c, d, a, b, x[2], s13, 0x242070db);
	mov	w4, 28891	// tmp1247,
// md5.cpp:121: 		FF(d, a, b, c, x[1], s12, 0xe8c7b756);
	movk	w1, 0xe8c7, lsl 16	// tmp1246,,
// md5.cpp:120: 		FF(a, b, c, d, x[0], s11, 0xd76aa478);
	ror	w0, w0, 25	// tmp711, tmp710,
	add	w0, w0, w20	// _58, tmp711, prephitmp_495
// md5.cpp:121: 		FF(d, a, b, c, x[1], s12, 0xe8c7b756);
	add	w1, w9, w1	// tmp716, _65, tmp1246
	and	w3, w3, w0	// tmp713, tmp712, _58
// md5.cpp:122: 		FF(c, d, a, b, x[2], s13, 0x242070db);
	eor	w2, w0, w20	// tmp720, _58, prephitmp_495
// md5.cpp:121: 		FF(d, a, b, c, x[1], s12, 0xe8c7b756);
	eor	w3, w3, w28	// tmp714, tmp713, prephitmp_496
// md5.cpp:122: 		FF(c, d, a, b, x[2], s13, 0x242070db);
	movk	w4, 0x2420, lsl 16	// tmp1247,,
// md5.cpp:121: 		FF(d, a, b, c, x[1], s12, 0xe8c7b756);
	add	w3, w3, w27	// tmp715, tmp714, prephitmp_503
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	mov	w22, 50730	// tmp749,
// md5.cpp:121: 		FF(d, a, b, c, x[1], s12, 0xe8c7b756);
	add	w3, w3, w1	// tmp718, tmp715, tmp716
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	mov	w1, 52974	// tmp1248,
	ldp	w13, w11, [sp, 136]	//,, MEM[(unsigned int[16] *)_567][2]
// md5.cpp:121: 		FF(d, a, b, c, x[1], s12, 0xe8c7b756);
	ror	w3, w3, 20	// tmp719, tmp718,
	add	w3, w3, w0	// _73, tmp719, _58
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	movk	w1, 0xc1bd, lsl 16	// tmp1248,,
// md5.cpp:122: 		FF(c, d, a, b, x[2], s13, 0x242070db);
	and	w2, w2, w3	// tmp721, tmp720, _73
	add	w7, w13, w4	// tmp724, _80, tmp1247
	eor	w2, w2, w20	// tmp722, tmp721, prephitmp_495
// md5.cpp:124: 		FF(a, b, c, d, x[4], s11, 0xf57c0faf);
	ldr	w4, [sp, 144]	//, MEM[(unsigned int[16] *)_567][4]
// md5.cpp:122: 		FF(c, d, a, b, x[2], s13, 0x242070db);
	add	w2, w2, w28	// tmp723, tmp722, prephitmp_496
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	add	w5, w11, w1	// tmp732, _95, tmp1248
// md5.cpp:122: 		FF(c, d, a, b, x[2], s13, 0x242070db);
	add	w2, w2, w7	// tmp726, tmp723, tmp724
// md5.cpp:124: 		FF(a, b, c, d, x[4], s11, 0xf57c0faf);
	mov	w1, 4015	// tmp1249,
	movk	w1, 0xf57c, lsl 16	// tmp1249,,
	add	w14, w4, w1	// tmp740, _110, tmp1249
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	eor	w1, w0, w3	// tmp728, _58, _73
// md5.cpp:122: 		FF(c, d, a, b, x[2], s13, 0x242070db);
	ror	w2, w2, 15	// tmp727, tmp726,
	add	w2, w2, w3	// _88, tmp727, _73
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	movk	w22, 0x4787, lsl 16	// tmp749,,
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	and	w1, w1, w2	// tmp729, tmp728, _88
// md5.cpp:124: 		FF(a, b, c, d, x[4], s11, 0xf57c0faf);
	eor	w10, w3, w2	// tmp736, _73, _88
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	eor	w1, w1, w0	// tmp730, tmp729, _58
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	mov	w12, 17939	// tmp757,
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	add	w1, w1, w20	// tmp731, tmp730, prephitmp_495
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	movk	w12, 0xa830, lsl 16	// tmp757,,
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	add	w1, w1, w5	// tmp734, tmp731, tmp732
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	mov	w7, 38145	// tmp765,
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	ldp	w17, w6, [sp, 148]	//,, MEM[(unsigned int[16] *)_567][5]
// md5.cpp:123: 		FF(b, c, d, a, x[3], s14, 0xc1bdceee);
	ror	w1, w1, 10	// tmp735, tmp734,
	add	w1, w1, w2	// _103, tmp735, _88
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	movk	w7, 0xfd46, lsl 16	// tmp765,,
// md5.cpp:124: 		FF(a, b, c, d, x[4], s11, 0xf57c0faf);
	and	w10, w10, w1	// tmp737, tmp736, _103
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	eor	w27, w2, w1	// tmp744, _88, _103
// md5.cpp:124: 		FF(a, b, c, d, x[4], s11, 0xf57c0faf);
	eor	w10, w10, w3	// tmp738, tmp737, _73
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	add	w22, w17, w22	// tmp748, _120, tmp749
// md5.cpp:124: 		FF(a, b, c, d, x[4], s11, 0xf57c0faf);
	add	w0, w10, w0	// tmp739, tmp738, _58
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	add	w12, w6, w12	// tmp756, _127, tmp757
// md5.cpp:124: 		FF(a, b, c, d, x[4], s11, 0xf57c0faf);
	add	w0, w0, w14	// tmp742, tmp739, tmp740
// md5.cpp:128: 		FF(a, b, c, d, x[8], s11, 0x698098d8);
	mov	w5, 39128	// tmp773,
	ldp	w18, w8, [sp, 156]	//,, MEM[(unsigned int[16] *)_567][7]
// md5.cpp:124: 		FF(a, b, c, d, x[4], s11, 0xf57c0faf);
	ror	w0, w0, 25	// tmp743, tmp742,
	add	w0, w0, w1	// _118, tmp743, _103
// md5.cpp:128: 		FF(a, b, c, d, x[8], s11, 0x698098d8);
	movk	w5, 0x6980, lsl 16	// tmp773,,
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	and	w27, w27, w0	// tmp745, tmp744, _118
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	add	w7, w18, w7	// tmp764, _134, tmp765
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	eor	w27, w27, w2	// tmp746, tmp745, _88
// md5.cpp:128: 		FF(a, b, c, d, x[8], s11, 0x698098d8);
	add	w5, w8, w5	// tmp772, _141, tmp773
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	add	w3, w27, w3	// tmp747, tmp746, _73
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	eor	w27, w1, w0	// tmp752, _103, _118
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	add	w3, w3, w22	// tmp750, tmp747, tmp748
// md5.cpp:129: 		FF(d, a, b, c, x[9], s12, 0x8b44f7af);
	ldr	w15, [sp, 164]	//, MEM[(unsigned int[16] *)_567][9]
	mov	w20, 63407	// tmp781,
// md5.cpp:130: 		FF(c, d, a, b, x[10], s13, 0xffff5bb1);
	mov	w16, -42063	//,
// md5.cpp:129: 		FF(d, a, b, c, x[9], s12, 0x8b44f7af);
	movk	w20, 0x8b44, lsl 16	// tmp781,,
// md5.cpp:125: 		FF(d, a, b, c, x[5], s12, 0x4787c62a);
	ror	w3, w3, 20	// tmp751, tmp750,
	add	w3, w3, w0	// _125, tmp751, _118
// md5.cpp:129: 		FF(d, a, b, c, x[9], s12, 0x8b44f7af);
	add	w20, w15, w20	// tmp780, _148, tmp781
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	and	w27, w27, w3	// tmp753, tmp752, _125
// md5.cpp:131: 		FF(b, c, d, a, x[11], s14, 0x895cd7be);
	mov	w22, 55230	// tmp797,
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	eor	w27, w27, w1	// tmp754, tmp753, _103
// md5.cpp:131: 		FF(b, c, d, a, x[11], s14, 0x895cd7be);
	movk	w22, 0x895c, lsl 16	// tmp797,,
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	add	w2, w27, w2	// tmp755, tmp754, _88
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	eor	w27, w0, w3	// tmp760, _118, _125
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	add	w2, w2, w12	// tmp758, tmp755, tmp756
// md5.cpp:139: 		GG(d, a, b, c, x[6], s22, 0xc040b340);
	mov	w28, 45888	// tmp845,
// md5.cpp:131: 		FF(b, c, d, a, x[11], s14, 0x895cd7be);
	ldp	w10, w14, [sp, 168]	//,, MEM[(unsigned int[16] *)_567][10]
// md5.cpp:126: 		FF(c, d, a, b, x[6], s13, 0xa8304613);
	ror	w2, w2, 15	// tmp759, tmp758,
	add	w2, w2, w3	// _132, tmp759, _125
// md5.cpp:139: 		GG(d, a, b, c, x[6], s22, 0xc040b340);
	movk	w28, 0xc040, lsl 16	// tmp845,,
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	and	w27, w27, w2	// tmp761, tmp760, _132
// md5.cpp:130: 		FF(c, d, a, b, x[10], s13, 0xffff5bb1);
	add	w16, w10, w16	// tmp788, _155,
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	eor	w27, w27, w0	// tmp762, tmp761, _118
// md5.cpp:131: 		FF(b, c, d, a, x[11], s14, 0x895cd7be);
	add	w22, w14, w22	// tmp796, _162, tmp797
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	add	w1, w27, w1	// tmp763, tmp762, _103
// md5.cpp:128: 		FF(a, b, c, d, x[8], s11, 0x698098d8);
	eor	w27, w3, w2	// tmp768, _125, _132
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	add	w1, w1, w7	// tmp766, tmp763, tmp764
// md5.cpp:132: 		FF(a, b, c, d, x[12], s11, 0x6b901122);
	mov	w7, 4386	// tmp805,
	movk	w7, 0x6b90, lsl 16	// tmp805,,
// md5.cpp:139: 		GG(d, a, b, c, x[6], s22, 0xc040b340);
	add	w28, w6, w28	// tmp844, _127, tmp845
// md5.cpp:103: 	for (int i = 0; i < n_blocks; i += 1)
	add	x24, x24, 64	// ivtmp.589, ivtmp.589,
// md5.cpp:127: 		FF(b, c, d, a, x[7], s14, 0xfd469501);
	ror	w1, w1, 10	// tmp767, tmp766,
	add	w1, w1, w2	// _139, tmp767, _132
// md5.cpp:128: 		FF(a, b, c, d, x[8], s11, 0x698098d8);
	and	w27, w27, w1	// tmp769, tmp768, _139
	eor	w27, w27, w3	// tmp770, tmp769, _125
	add	w0, w27, w0	// tmp771, tmp770, _118
// md5.cpp:129: 		FF(d, a, b, c, x[9], s12, 0x8b44f7af);
	eor	w27, w2, w1	// tmp776, _132, _139
// md5.cpp:128: 		FF(a, b, c, d, x[8], s11, 0x698098d8);
	add	w0, w0, w5	// tmp774, tmp771, tmp772
// md5.cpp:133: 		FF(d, a, b, c, x[13], s12, 0xfd987193);
	ldp	w12, w5, [sp, 176]	//,, MEM[(unsigned int[16] *)_567][12]
// md5.cpp:128: 		FF(a, b, c, d, x[8], s11, 0x698098d8);
	ror	w0, w0, 25	// tmp775, tmp774,
	add	w0, w0, w1	// _146, tmp775, _139
// md5.cpp:129: 		FF(d, a, b, c, x[9], s12, 0x8b44f7af);
	and	w27, w27, w0	// tmp777, tmp776, _146
// md5.cpp:132: 		FF(a, b, c, d, x[12], s11, 0x6b901122);
	add	w7, w12, w7	// tmp804, _169, tmp805
// md5.cpp:129: 		FF(d, a, b, c, x[9], s12, 0x8b44f7af);
	eor	w27, w27, w2	// tmp778, tmp777, _132
	add	w3, w27, w3	// tmp779, tmp778, _125
// md5.cpp:130: 		FF(c, d, a, b, x[10], s13, 0xffff5bb1);
	eor	w27, w1, w0	// tmp784, _139, _146
// md5.cpp:129: 		FF(d, a, b, c, x[9], s12, 0x8b44f7af);
	add	w3, w3, w20	// tmp782, tmp779, tmp780
// md5.cpp:133: 		FF(d, a, b, c, x[13], s12, 0xfd987193);
	mov	w20, 29075	// tmp813,
	movk	w20, 0xfd98, lsl 16	// tmp813,,
	add	w20, w5, w20	// tmp812, _176, tmp813
// md5.cpp:129: 		FF(d, a, b, c, x[9], s12, 0x8b44f7af);
	ror	w3, w3, 20	// tmp783, tmp782,
	add	w3, w3, w0	// _153, tmp783, _146
// md5.cpp:130: 		FF(c, d, a, b, x[10], s13, 0xffff5bb1);
	and	w27, w27, w3	// tmp785, tmp784, _153
	eor	w27, w27, w1	// tmp786, tmp785, _139
	add	w2, w27, w2	// tmp787, tmp786, _132
// md5.cpp:131: 		FF(b, c, d, a, x[11], s14, 0x895cd7be);
	eor	w27, w0, w3	// tmp792, _146, _153
// md5.cpp:130: 		FF(c, d, a, b, x[10], s13, 0xffff5bb1);
	add	w2, w2, w16	// tmp790, tmp787, tmp788
	ror	w2, w2, 15	// tmp791, tmp790,
	add	w2, w2, w3	// _160, tmp791, _153
// md5.cpp:131: 		FF(b, c, d, a, x[11], s14, 0x895cd7be);
	and	w27, w27, w2	// tmp793, tmp792, _160
	eor	w27, w27, w0	// tmp794, tmp793, _146
	add	w1, w27, w1	// tmp795, tmp794, _139
// md5.cpp:132: 		FF(a, b, c, d, x[12], s11, 0x6b901122);
	eor	w27, w3, w2	// tmp800, _153, _160
// md5.cpp:131: 		FF(b, c, d, a, x[11], s14, 0x895cd7be);
	add	w1, w1, w22	// tmp798, tmp795, tmp796
// md5.cpp:134: 		FF(c, d, a, b, x[14], s13, 0xa679438e);
	mov	w22, 17294	// tmp821,
	movk	w22, 0xa679, lsl 16	// tmp821,,
// md5.cpp:131: 		FF(b, c, d, a, x[11], s14, 0x895cd7be);
	ror	w1, w1, 10	// tmp799, tmp798,
	add	w1, w1, w2	// _167, tmp799, _160
// md5.cpp:132: 		FF(a, b, c, d, x[12], s11, 0x6b901122);
	and	w27, w27, w1	// tmp801, tmp800, _167
	eor	w27, w27, w3	// tmp802, tmp801, _153
	add	w0, w27, w0	// tmp803, tmp802, _146
// md5.cpp:133: 		FF(d, a, b, c, x[13], s12, 0xfd987193);
	eor	w27, w2, w1	// tmp808, _160, _167
// md5.cpp:132: 		FF(a, b, c, d, x[12], s11, 0x6b901122);
	add	w0, w0, w7	// tmp806, tmp803, tmp804
// md5.cpp:135: 		FF(b, c, d, a, x[15], s14, 0x49b40821);
	ldp	w16, w7, [sp, 184]	//,, MEM[(unsigned int[16] *)_567][14]
// md5.cpp:132: 		FF(a, b, c, d, x[12], s11, 0x6b901122);
	ror	w0, w0, 25	// tmp807, tmp806,
	add	w0, w0, w1	// _174, tmp807, _167
// md5.cpp:133: 		FF(d, a, b, c, x[13], s12, 0xfd987193);
	and	w27, w27, w0	// tmp809, tmp808, _174
// md5.cpp:134: 		FF(c, d, a, b, x[14], s13, 0xa679438e);
	add	w22, w16, w22	// tmp820, _183, tmp821
// md5.cpp:133: 		FF(d, a, b, c, x[13], s12, 0xfd987193);
	eor	w27, w27, w2	// tmp810, tmp809, _160
	add	w3, w27, w3	// tmp811, tmp810, _153
// md5.cpp:134: 		FF(c, d, a, b, x[14], s13, 0xa679438e);
	eor	w27, w1, w0	// tmp816, _167, _174
// md5.cpp:133: 		FF(d, a, b, c, x[13], s12, 0xfd987193);
	add	w3, w3, w20	// tmp814, tmp811, tmp812
// md5.cpp:135: 		FF(b, c, d, a, x[15], s14, 0x49b40821);
	mov	w20, 2081	// tmp829,
	movk	w20, 0x49b4, lsl 16	// tmp829,,
	add	w20, w7, w20	// tmp828, _190, tmp829
// md5.cpp:133: 		FF(d, a, b, c, x[13], s12, 0xfd987193);
	ror	w3, w3, 20	// tmp815, tmp814,
	add	w3, w3, w0	// _181, tmp815, _174
// md5.cpp:134: 		FF(c, d, a, b, x[14], s13, 0xa679438e);
	and	w27, w27, w3	// tmp817, tmp816, _181
	eor	w27, w27, w1	// tmp818, tmp817, _167
	add	w2, w27, w2	// tmp819, tmp818, _160
// md5.cpp:135: 		FF(b, c, d, a, x[15], s14, 0x49b40821);
	eor	w27, w0, w3	// tmp824, _174, _181
// md5.cpp:134: 		FF(c, d, a, b, x[14], s13, 0xa679438e);
	add	w2, w2, w22	// tmp822, tmp819, tmp820
// md5.cpp:138: 		GG(a, b, c, d, x[1], s21, 0xf61e2562);
	mov	w22, 9570	// tmp837,
	movk	w22, 0xf61e, lsl 16	// tmp837,,
	add	w22, w9, w22	// tmp836, _65, tmp837
// md5.cpp:134: 		FF(c, d, a, b, x[14], s13, 0xa679438e);
	ror	w2, w2, 15	// tmp823, tmp822,
	add	w2, w2, w3	// _188, tmp823, _181
// md5.cpp:135: 		FF(b, c, d, a, x[15], s14, 0x49b40821);
	and	w27, w27, w2	// tmp825, tmp824, _188
	eor	w27, w27, w0	// tmp826, tmp825, _174
	add	w1, w27, w1	// tmp827, tmp826, _167
// md5.cpp:140: 		GG(c, d, a, b, x[11], s23, 0x265e5a51);
	mov	w27, 23121	// tmp853,
// md5.cpp:135: 		FF(b, c, d, a, x[15], s14, 0x49b40821);
	add	w1, w1, w20	// tmp830, tmp827, tmp828
// md5.cpp:140: 		GG(c, d, a, b, x[11], s23, 0x265e5a51);
	movk	w27, 0x265e, lsl 16	// tmp853,,
	add	w27, w14, w27	// tmp852, _162, tmp853
// md5.cpp:135: 		FF(b, c, d, a, x[15], s14, 0x49b40821);
	ror	w1, w1, 10	// tmp831, tmp830,
	add	w1, w1, w2	// _195, tmp831, _188
// md5.cpp:138: 		GG(a, b, c, d, x[1], s21, 0xf61e2562);
	eor	w20, w2, w1	// tmp832, _188, _195
	and	w20, w20, w3	// tmp833, tmp832, _181
	eor	w20, w20, w2	// tmp834, tmp833, _188
	add	w0, w20, w0	// tmp835, tmp834, _174
	add	w0, w0, w22	// tmp838, tmp835, tmp836
// md5.cpp:141: 		GG(b, c, d, a, x[0], s24, 0xe9b6c7aa);
	mov	w22, 51114	// tmp861,
	movk	w22, 0xe9b6, lsl 16	// tmp861,,
	add	w22, w26, w22	// tmp860, _50, tmp861
// md5.cpp:138: 		GG(a, b, c, d, x[1], s21, 0xf61e2562);
	ror	w0, w0, 27	// tmp839, tmp838,
	add	w0, w0, w1	// _201, tmp839, _195
// md5.cpp:139: 		GG(d, a, b, c, x[6], s22, 0xc040b340);
	eor	w20, w1, w0	// tmp840, _195, _201
	and	w20, w20, w2	// tmp841, tmp840, _188
	eor	w20, w20, w1	// tmp842, tmp841, _195
	add	w3, w20, w3	// tmp843, tmp842, _181
	add	w3, w3, w28	// tmp846, tmp843, tmp844
// md5.cpp:142: 		GG(a, b, c, d, x[5], s21, 0xd62f105d);
	mov	w28, 4189	// tmp869,
	movk	w28, 0xd62f, lsl 16	// tmp869,,
	add	w28, w17, w28	// tmp868, _120, tmp869
// md5.cpp:139: 		GG(d, a, b, c, x[6], s22, 0xc040b340);
	ror	w3, w3, 23	// tmp847, tmp846,
	add	w3, w3, w0	// _207, tmp847, _201
// md5.cpp:140: 		GG(c, d, a, b, x[11], s23, 0x265e5a51);
	eor	w20, w0, w3	// tmp848, _201, _207
	and	w20, w20, w1	// tmp849, tmp848, _195
	eor	w20, w20, w0	// tmp850, tmp849, _201
	add	w2, w20, w2	// tmp851, tmp850, _188
	add	w2, w2, w27	// tmp854, tmp851, tmp852
// md5.cpp:143: 		GG(d, a, b, c, x[10], s22, 0x2441453);
	mov	w27, 5203	// tmp877,
	movk	w27, 0x244, lsl 16	// tmp877,,
	add	w27, w10, w27	// tmp876, _155, tmp877
// md5.cpp:140: 		GG(c, d, a, b, x[11], s23, 0x265e5a51);
	ror	w2, w2, 18	// tmp855, tmp854,
	add	w2, w2, w3	// _213, tmp855, _207
// md5.cpp:141: 		GG(b, c, d, a, x[0], s24, 0xe9b6c7aa);
	eor	w20, w3, w2	// tmp856, _207, _213
	and	w20, w20, w0	// tmp857, tmp856, _201
	eor	w20, w20, w3	// tmp858, tmp857, _207
	add	w1, w20, w1	// tmp859, tmp858, _195
	add	w1, w1, w22	// tmp862, tmp859, tmp860
// md5.cpp:144: 		GG(c, d, a, b, x[15], s23, 0xd8a1e681);
	mov	w22, 59009	// tmp885,
	movk	w22, 0xd8a1, lsl 16	// tmp885,,
	add	w22, w7, w22	// tmp884, _190, tmp885
// md5.cpp:141: 		GG(b, c, d, a, x[0], s24, 0xe9b6c7aa);
	ror	w1, w1, 12	// tmp863, tmp862,
	add	w1, w1, w2	// _219, tmp863, _213
// md5.cpp:142: 		GG(a, b, c, d, x[5], s21, 0xd62f105d);
	eor	w20, w2, w1	// tmp864, _213, _219
	and	w20, w20, w3	// tmp865, tmp864, _207
	eor	w20, w20, w2	// tmp866, tmp865, _213
	add	w0, w20, w0	// tmp867, tmp866, _201
	add	w0, w0, w28	// tmp870, tmp867, tmp868
// md5.cpp:145: 		GG(b, c, d, a, x[4], s24, 0xe7d3fbc8);
	mov	w28, 64456	// tmp893,
	movk	w28, 0xe7d3, lsl 16	// tmp893,,
	add	w28, w4, w28	// tmp892, _110, tmp893
// md5.cpp:142: 		GG(a, b, c, d, x[5], s21, 0xd62f105d);
	ror	w0, w0, 27	// tmp871, tmp870,
	add	w0, w0, w1	// _225, tmp871, _219
// md5.cpp:143: 		GG(d, a, b, c, x[10], s22, 0x2441453);
	eor	w20, w1, w0	// tmp872, _219, _225
	and	w20, w20, w2	// tmp873, tmp872, _213
	eor	w20, w20, w1	// tmp874, tmp873, _219
	add	w3, w20, w3	// tmp875, tmp874, _207
	add	w3, w3, w27	// tmp878, tmp875, tmp876
// md5.cpp:146: 		GG(a, b, c, d, x[9], s21, 0x21e1cde6);
	mov	w27, 52710	// tmp901,
	movk	w27, 0x21e1, lsl 16	// tmp901,,
	add	w27, w15, w27	// tmp900, _148, tmp901
// md5.cpp:143: 		GG(d, a, b, c, x[10], s22, 0x2441453);
	ror	w3, w3, 23	// tmp879, tmp878,
	add	w3, w3, w0	// _231, tmp879, _225
// md5.cpp:144: 		GG(c, d, a, b, x[15], s23, 0xd8a1e681);
	eor	w20, w0, w3	// tmp880, _225, _231
	and	w20, w20, w1	// tmp881, tmp880, _219
	eor	w20, w20, w0	// tmp882, tmp881, _225
	add	w2, w20, w2	// tmp883, tmp882, _213
	add	w2, w2, w22	// tmp886, tmp883, tmp884
// md5.cpp:147: 		GG(d, a, b, c, x[14], s22, 0xc33707d6);
	mov	w22, 2006	// tmp909,
	movk	w22, 0xc337, lsl 16	// tmp909,,
	add	w22, w16, w22	// tmp908, _183, tmp909
// md5.cpp:144: 		GG(c, d, a, b, x[15], s23, 0xd8a1e681);
	ror	w2, w2, 18	// tmp887, tmp886,
	add	w2, w2, w3	// _237, tmp887, _231
// md5.cpp:145: 		GG(b, c, d, a, x[4], s24, 0xe7d3fbc8);
	eor	w20, w3, w2	// tmp888, _231, _237
	and	w20, w20, w0	// tmp889, tmp888, _225
	eor	w20, w20, w3	// tmp890, tmp889, _231
	add	w1, w20, w1	// tmp891, tmp890, _219
	add	w1, w1, w28	// tmp894, tmp891, tmp892
// md5.cpp:148: 		GG(c, d, a, b, x[3], s23, 0xf4d50d87);
	mov	w28, 3463	// tmp917,
	movk	w28, 0xf4d5, lsl 16	// tmp917,,
	add	w28, w11, w28	// tmp916, _95, tmp917
// md5.cpp:145: 		GG(b, c, d, a, x[4], s24, 0xe7d3fbc8);
	ror	w1, w1, 12	// tmp895, tmp894,
	add	w1, w1, w2	// _243, tmp895, _237
// md5.cpp:146: 		GG(a, b, c, d, x[9], s21, 0x21e1cde6);
	eor	w20, w2, w1	// tmp896, _237, _243
	and	w20, w20, w3	// tmp897, tmp896, _231
	eor	w20, w20, w2	// tmp898, tmp897, _237
	add	w0, w20, w0	// tmp899, tmp898, _225
	add	w0, w0, w27	// tmp902, tmp899, tmp900
// md5.cpp:149: 		GG(b, c, d, a, x[8], s24, 0x455a14ed);
	mov	w27, 5357	// tmp925,
	movk	w27, 0x455a, lsl 16	// tmp925,,
	add	w27, w8, w27	// tmp924, _141, tmp925
// md5.cpp:146: 		GG(a, b, c, d, x[9], s21, 0x21e1cde6);
	ror	w0, w0, 27	// tmp903, tmp902,
	add	w0, w0, w1	// _249, tmp903, _243
// md5.cpp:147: 		GG(d, a, b, c, x[14], s22, 0xc33707d6);
	eor	w20, w1, w0	// tmp904, _243, _249
	and	w20, w20, w2	// tmp905, tmp904, _237
	eor	w20, w20, w1	// tmp906, tmp905, _243
	add	w3, w20, w3	// tmp907, tmp906, _231
	add	w3, w3, w22	// tmp910, tmp907, tmp908
// md5.cpp:150: 		GG(a, b, c, d, x[13], s21, 0xa9e3e905);
	mov	w22, 59653	// tmp933,
	movk	w22, 0xa9e3, lsl 16	// tmp933,,
	add	w22, w5, w22	// tmp932, _176, tmp933
// md5.cpp:147: 		GG(d, a, b, c, x[14], s22, 0xc33707d6);
	ror	w3, w3, 23	// tmp911, tmp910,
	add	w3, w3, w0	// _255, tmp911, _249
// md5.cpp:148: 		GG(c, d, a, b, x[3], s23, 0xf4d50d87);
	eor	w20, w0, w3	// tmp912, _249, _255
	and	w20, w20, w1	// tmp913, tmp912, _243
	eor	w20, w20, w0	// tmp914, tmp913, _249
	add	w2, w20, w2	// tmp915, tmp914, _237
	add	w2, w2, w28	// tmp918, tmp915, tmp916
// md5.cpp:151: 		GG(d, a, b, c, x[2], s22, 0xfcefa3f8);
	mov	w28, 41976	// tmp941,
	movk	w28, 0xfcef, lsl 16	// tmp941,,
	add	w28, w13, w28	// tmp940, _80, tmp941
// md5.cpp:148: 		GG(c, d, a, b, x[3], s23, 0xf4d50d87);
	ror	w2, w2, 18	// tmp919, tmp918,
	add	w2, w2, w3	// _261, tmp919, _255
// md5.cpp:149: 		GG(b, c, d, a, x[8], s24, 0x455a14ed);
	eor	w20, w3, w2	// tmp920, _255, _261
	and	w20, w20, w0	// tmp921, tmp920, _249
	eor	w20, w20, w3	// tmp922, tmp921, _255
	add	w1, w20, w1	// tmp923, tmp922, _243
	add	w1, w1, w27	// tmp926, tmp923, tmp924
// md5.cpp:152: 		GG(c, d, a, b, x[7], s23, 0x676f02d9);
	mov	w27, 729	// tmp949,
	movk	w27, 0x676f, lsl 16	// tmp949,,
	add	w27, w18, w27	// tmp948, _134, tmp949
// md5.cpp:149: 		GG(b, c, d, a, x[8], s24, 0x455a14ed);
	ror	w1, w1, 12	// tmp927, tmp926,
	add	w1, w1, w2	// _267, tmp927, _261
// md5.cpp:150: 		GG(a, b, c, d, x[13], s21, 0xa9e3e905);
	eor	w20, w2, w1	// tmp928, _261, _267
	and	w20, w20, w3	// tmp929, tmp928, _255
	eor	w20, w20, w2	// tmp930, tmp929, _261
	add	w0, w20, w0	// tmp931, tmp930, _249
	add	w0, w0, w22	// tmp934, tmp931, tmp932
// md5.cpp:153: 		GG(b, c, d, a, x[12], s24, 0x8d2a4c8a);
	mov	w22, 19594	// tmp956,
	movk	w22, 0x8d2a, lsl 16	// tmp956,,
	add	w22, w12, w22	// tmp955, _169, tmp956
// md5.cpp:150: 		GG(a, b, c, d, x[13], s21, 0xa9e3e905);
	ror	w0, w0, 27	// tmp935, tmp934,
	add	w0, w0, w1	// _273, tmp935, _267
// md5.cpp:151: 		GG(d, a, b, c, x[2], s22, 0xfcefa3f8);
	eor	w20, w1, w0	// tmp936, _267, _273
	and	w20, w20, w2	// tmp937, tmp936, _261
	eor	w20, w20, w1	// tmp938, tmp937, _267
	add	w3, w20, w3	// tmp939, tmp938, _255
	add	w3, w3, w28	// tmp942, tmp939, tmp940
	ror	w3, w3, 23	// tmp943, tmp942,
	add	w3, w3, w0	// _279, tmp943, _273
// md5.cpp:152: 		GG(c, d, a, b, x[7], s23, 0x676f02d9);
	eor	w20, w0, w3	// tmp944, _273, _279
	and	w20, w20, w1	// tmp945, tmp944, _267
	eor	w20, w20, w0	// tmp946, tmp945, _273
	add	w2, w20, w2	// tmp947, tmp946, _261
// md5.cpp:156: 		HH(a, b, c, d, x[5], s31, 0xfffa3942);
	sub	w20, w17, #376832	// tmp961, _120,
// md5.cpp:152: 		GG(c, d, a, b, x[7], s23, 0x676f02d9);
	add	w2, w2, w27	// tmp950, tmp947, tmp948
// md5.cpp:156: 		HH(a, b, c, d, x[5], s31, 0xfffa3942);
	sub	w20, w20, #1726	// tmp961, tmp961,
// md5.cpp:152: 		GG(c, d, a, b, x[7], s23, 0x676f02d9);
	ror	w2, w2, 18	// tmp951, tmp950,
	add	w2, w2, w3	// _285, tmp951, _279
	eor	w27, w3, w2	// _117, _279, _285
// md5.cpp:153: 		GG(b, c, d, a, x[12], s24, 0x8d2a4c8a);
	and	w28, w27, w0	// tmp952, _117, _273
	eor	w28, w28, w3	// tmp953, tmp952, _279
	add	w1, w28, w1	// tmp954, tmp953, _267
// md5.cpp:157: 		HH(d, a, b, c, x[8], s32, 0x8771f681);
	mov	w28, 63105	// tmp969,
// md5.cpp:153: 		GG(b, c, d, a, x[12], s24, 0x8d2a4c8a);
	add	w22, w1, w22	// tmp957, tmp954, tmp955
// md5.cpp:157: 		HH(d, a, b, c, x[8], s32, 0x8771f681);
	movk	w28, 0x8771, lsl 16	// tmp969,,
	add	w28, w8, w28	// tmp968, _141, tmp969
// md5.cpp:153: 		GG(b, c, d, a, x[12], s24, 0x8d2a4c8a);
	ror	w22, w22, 12	// tmp958, tmp957,
	add	w22, w22, w2	// _291, tmp958, _285
// md5.cpp:156: 		HH(a, b, c, d, x[5], s31, 0xfffa3942);
	eor	w27, w27, w22	// tmp959, _117, _291
// md5.cpp:157: 		HH(d, a, b, c, x[8], s32, 0x8771f681);
	eor	w1, w2, w22	// tmp965, _285, _291
// md5.cpp:156: 		HH(a, b, c, d, x[5], s31, 0xfffa3942);
	add	w0, w27, w0	// tmp960, tmp959, _273
// md5.cpp:158: 		HH(c, d, a, b, x[11], s33, 0x6d9d6122);
	mov	w27, 24866	// tmp976,
// md5.cpp:156: 		HH(a, b, c, d, x[5], s31, 0xfffa3942);
	add	w0, w0, w20	// tmp963, tmp960, tmp961
// md5.cpp:158: 		HH(c, d, a, b, x[11], s33, 0x6d9d6122);
	movk	w27, 0x6d9d, lsl 16	// tmp976,,
	add	w27, w14, w27	// tmp975, _162, tmp976
// md5.cpp:156: 		HH(a, b, c, d, x[5], s31, 0xfffa3942);
	ror	w0, w0, 28	// tmp964, tmp963,
	add	w0, w0, w22	// _298, tmp964, _291
// md5.cpp:157: 		HH(d, a, b, c, x[8], s32, 0x8771f681);
	eor	w20, w1, w0	// tmp966, tmp965, _298
	add	w20, w20, w3	// tmp967, tmp966, _279
// md5.cpp:158: 		HH(c, d, a, b, x[11], s33, 0x6d9d6122);
	eor	w3, w22, w0	// tmp972, _291, _298
// md5.cpp:157: 		HH(d, a, b, c, x[8], s32, 0x8771f681);
	add	w20, w20, w28	// tmp970, tmp967, tmp968
// md5.cpp:159: 		HH(b, c, d, a, x[14], s34, 0xfde5380c);
	mov	w28, 14348	// tmp983,
	movk	w28, 0xfde5, lsl 16	// tmp983,,
	add	w28, w16, w28	// tmp982, _183, tmp983
// md5.cpp:157: 		HH(d, a, b, c, x[8], s32, 0x8771f681);
	ror	w20, w20, 21	// tmp971, tmp970,
	add	w20, w20, w0	// _305, tmp971, _298
// md5.cpp:158: 		HH(c, d, a, b, x[11], s33, 0x6d9d6122);
	eor	w3, w3, w20	// tmp973, tmp972, _305
	add	w3, w3, w2	// tmp974, tmp973, _285
// md5.cpp:159: 		HH(b, c, d, a, x[14], s34, 0xfde5380c);
	eor	w2, w0, w20	// tmp979, _298, _305
// md5.cpp:158: 		HH(c, d, a, b, x[11], s33, 0x6d9d6122);
	add	w3, w3, w27	// tmp977, tmp974, tmp975
// md5.cpp:160: 		HH(a, b, c, d, x[1], s31, 0xa4beea44);
	mov	w27, 59972	// tmp990,
	movk	w27, 0xa4be, lsl 16	// tmp990,,
	add	w27, w9, w27	// tmp989, _65, tmp990
// md5.cpp:158: 		HH(c, d, a, b, x[11], s33, 0x6d9d6122);
	ror	w3, w3, 16	// tmp978, tmp977,
	add	w3, w3, w20	// _312, tmp978, _305
// md5.cpp:159: 		HH(b, c, d, a, x[14], s34, 0xfde5380c);
	eor	w2, w2, w3	// tmp980, tmp979, _312
// md5.cpp:160: 		HH(a, b, c, d, x[1], s31, 0xa4beea44);
	eor	w1, w20, w3	// tmp986, _305, _312
// md5.cpp:159: 		HH(b, c, d, a, x[14], s34, 0xfde5380c);
	add	w2, w2, w22	// tmp981, tmp980, _291
// md5.cpp:161: 		HH(d, a, b, c, x[4], s32, 0x4bdecfa9);
	mov	w22, 53161	// tmp997,
// md5.cpp:159: 		HH(b, c, d, a, x[14], s34, 0xfde5380c);
	add	w2, w2, w28	// tmp984, tmp981, tmp982
// md5.cpp:161: 		HH(d, a, b, c, x[4], s32, 0x4bdecfa9);
	movk	w22, 0x4bde, lsl 16	// tmp997,,
	add	w22, w4, w22	// tmp996, _110, tmp997
// md5.cpp:162: 		HH(c, d, a, b, x[7], s33, 0xf6bb4b60);
	mov	w28, 19296	// tmp1004,
	movk	w28, 0xf6bb, lsl 16	// tmp1004,,
// md5.cpp:159: 		HH(b, c, d, a, x[14], s34, 0xfde5380c);
	ror	w2, w2, 9	// tmp985, tmp984,
	add	w2, w2, w3	// _319, tmp985, _312
// md5.cpp:162: 		HH(c, d, a, b, x[7], s33, 0xf6bb4b60);
	add	w28, w18, w28	// tmp1003, _134, tmp1004
// md5.cpp:160: 		HH(a, b, c, d, x[1], s31, 0xa4beea44);
	eor	w1, w1, w2	// tmp987, tmp986, _319
	add	w1, w1, w0	// tmp988, tmp987, _298
// md5.cpp:161: 		HH(d, a, b, c, x[4], s32, 0x4bdecfa9);
	eor	w0, w3, w2	// tmp993, _312, _319
// md5.cpp:160: 		HH(a, b, c, d, x[1], s31, 0xa4beea44);
	add	w1, w1, w27	// tmp991, tmp988, tmp989
	ror	w1, w1, 28	// tmp992, tmp991,
	add	w1, w1, w2	// _326, tmp992, _319
// md5.cpp:161: 		HH(d, a, b, c, x[4], s32, 0x4bdecfa9);
	eor	w0, w0, w1	// tmp994, tmp993, _326
	add	w0, w0, w20	// tmp995, tmp994, _305
// md5.cpp:162: 		HH(c, d, a, b, x[7], s33, 0xf6bb4b60);
	eor	w20, w2, w1	// tmp1000, _319, _326
// md5.cpp:161: 		HH(d, a, b, c, x[4], s32, 0x4bdecfa9);
	add	w0, w0, w22	// tmp998, tmp995, tmp996
// md5.cpp:163: 		HH(b, c, d, a, x[10], s34, 0xbebfbc70);
	mov	w22, 48240	// tmp1011,
	movk	w22, 0xbebf, lsl 16	// tmp1011,,
	add	w22, w10, w22	// tmp1010, _155, tmp1011
// md5.cpp:180: 		II(c, d, a, b, x[10], s43, 0xffeff47d);
	sub	w10, w10, #1048576	// tmp1122, _155,
// md5.cpp:161: 		HH(d, a, b, c, x[4], s32, 0x4bdecfa9);
	ror	w0, w0, 21	// tmp999, tmp998,
	add	w0, w0, w1	// _333, tmp999, _326
// md5.cpp:180: 		II(c, d, a, b, x[10], s43, 0xffeff47d);
	sub	w10, w10, #2947	// tmp1122, tmp1122,
// md5.cpp:162: 		HH(c, d, a, b, x[7], s33, 0xf6bb4b60);
	eor	w20, w20, w0	// tmp1001, tmp1000, _333
// md5.cpp:163: 		HH(b, c, d, a, x[10], s34, 0xbebfbc70);
	eor	w27, w1, w0	// tmp1007, _326, _333
// md5.cpp:162: 		HH(c, d, a, b, x[7], s33, 0xf6bb4b60);
	add	w3, w20, w3	// tmp1002, tmp1001, _312
// md5.cpp:164: 		HH(a, b, c, d, x[13], s31, 0x289b7ec6);
	mov	w20, 32454	// tmp1018,
// md5.cpp:162: 		HH(c, d, a, b, x[7], s33, 0xf6bb4b60);
	add	w3, w3, w28	// tmp1005, tmp1002, tmp1003
// md5.cpp:164: 		HH(a, b, c, d, x[13], s31, 0x289b7ec6);
	movk	w20, 0x289b, lsl 16	// tmp1018,,
	add	w20, w5, w20	// tmp1017, _176, tmp1018
// md5.cpp:162: 		HH(c, d, a, b, x[7], s33, 0xf6bb4b60);
	ror	w3, w3, 16	// tmp1006, tmp1005,
	add	w3, w3, w0	// _340, tmp1006, _333
// md5.cpp:163: 		HH(b, c, d, a, x[10], s34, 0xbebfbc70);
	eor	w27, w27, w3	// tmp1008, tmp1007, _340
	add	w2, w27, w2	// tmp1009, tmp1008, _319
// md5.cpp:164: 		HH(a, b, c, d, x[13], s31, 0x289b7ec6);
	eor	w27, w0, w3	// tmp1014, _333, _340
// md5.cpp:163: 		HH(b, c, d, a, x[10], s34, 0xbebfbc70);
	add	w2, w2, w22	// tmp1012, tmp1009, tmp1010
// md5.cpp:165: 		HH(d, a, b, c, x[0], s32, 0xeaa127fa);
	mov	w22, 10234	// tmp1025,
	movk	w22, 0xeaa1, lsl 16	// tmp1025,,
	add	w22, w26, w22	// tmp1024, _50, tmp1025
// md5.cpp:163: 		HH(b, c, d, a, x[10], s34, 0xbebfbc70);
	ror	w2, w2, 9	// tmp1013, tmp1012,
	add	w2, w2, w3	// _347, tmp1013, _340
// md5.cpp:164: 		HH(a, b, c, d, x[13], s31, 0x289b7ec6);
	eor	w27, w27, w2	// tmp1015, tmp1014, _347
	add	w1, w27, w1	// tmp1016, tmp1015, _326
// md5.cpp:165: 		HH(d, a, b, c, x[0], s32, 0xeaa127fa);
	eor	w27, w3, w2	// tmp1021, _340, _347
// md5.cpp:164: 		HH(a, b, c, d, x[13], s31, 0x289b7ec6);
	add	w1, w1, w20	// tmp1019, tmp1016, tmp1017
// md5.cpp:166: 		HH(c, d, a, b, x[3], s33, 0xd4ef3085);
	mov	w20, 12421	// tmp1032,
	movk	w20, 0xd4ef, lsl 16	// tmp1032,,
	add	w20, w11, w20	// tmp1031, _95, tmp1032
// md5.cpp:164: 		HH(a, b, c, d, x[13], s31, 0x289b7ec6);
	ror	w1, w1, 28	// tmp1020, tmp1019,
	add	w1, w1, w2	// _354, tmp1020, _347
// md5.cpp:165: 		HH(d, a, b, c, x[0], s32, 0xeaa127fa);
	eor	w27, w27, w1	// tmp1022, tmp1021, _354
	add	w0, w27, w0	// tmp1023, tmp1022, _333
// md5.cpp:166: 		HH(c, d, a, b, x[3], s33, 0xd4ef3085);
	eor	w27, w2, w1	// tmp1028, _347, _354
// md5.cpp:165: 		HH(d, a, b, c, x[0], s32, 0xeaa127fa);
	add	w0, w0, w22	// tmp1026, tmp1023, tmp1024
// md5.cpp:167: 		HH(b, c, d, a, x[6], s34, 0x4881d05);
	mov	w22, 7429	// tmp1039,
	movk	w22, 0x488, lsl 16	// tmp1039,,
	add	w22, w6, w22	// tmp1038, _127, tmp1039
// md5.cpp:165: 		HH(d, a, b, c, x[0], s32, 0xeaa127fa);
	ror	w0, w0, 21	// tmp1027, tmp1026,
	add	w0, w0, w1	// _361, tmp1027, _354
// md5.cpp:166: 		HH(c, d, a, b, x[3], s33, 0xd4ef3085);
	eor	w27, w27, w0	// tmp1029, tmp1028, _361
	add	w3, w27, w3	// tmp1030, tmp1029, _340
// md5.cpp:167: 		HH(b, c, d, a, x[6], s34, 0x4881d05);
	eor	w27, w1, w0	// tmp1035, _354, _361
// md5.cpp:166: 		HH(c, d, a, b, x[3], s33, 0xd4ef3085);
	add	w3, w3, w20	// tmp1033, tmp1030, tmp1031
// md5.cpp:168: 		HH(a, b, c, d, x[9], s31, 0xd9d4d039);
	mov	w20, 53305	// tmp1046,
	movk	w20, 0xd9d4, lsl 16	// tmp1046,,
	add	w20, w15, w20	// tmp1045, _148, tmp1046
// md5.cpp:166: 		HH(c, d, a, b, x[3], s33, 0xd4ef3085);
	ror	w3, w3, 16	// tmp1034, tmp1033,
	add	w3, w3, w0	// _368, tmp1034, _361
// md5.cpp:167: 		HH(b, c, d, a, x[6], s34, 0x4881d05);
	eor	w27, w27, w3	// tmp1036, tmp1035, _368
	add	w2, w27, w2	// tmp1037, tmp1036, _347
// md5.cpp:168: 		HH(a, b, c, d, x[9], s31, 0xd9d4d039);
	eor	w27, w0, w3	// tmp1042, _361, _368
// md5.cpp:167: 		HH(b, c, d, a, x[6], s34, 0x4881d05);
	add	w2, w2, w22	// tmp1040, tmp1037, tmp1038
// md5.cpp:169: 		HH(d, a, b, c, x[12], s32, 0xe6db99e5);
	mov	w22, 39397	// tmp1053,
	movk	w22, 0xe6db, lsl 16	// tmp1053,,
	add	w22, w12, w22	// tmp1052, _169, tmp1053
// md5.cpp:167: 		HH(b, c, d, a, x[6], s34, 0x4881d05);
	ror	w2, w2, 9	// tmp1041, tmp1040,
	add	w2, w2, w3	// _375, tmp1041, _368
// md5.cpp:168: 		HH(a, b, c, d, x[9], s31, 0xd9d4d039);
	eor	w27, w27, w2	// tmp1043, tmp1042, _375
	add	w1, w27, w1	// tmp1044, tmp1043, _354
// md5.cpp:169: 		HH(d, a, b, c, x[12], s32, 0xe6db99e5);
	eor	w27, w3, w2	// tmp1049, _368, _375
// md5.cpp:168: 		HH(a, b, c, d, x[9], s31, 0xd9d4d039);
	add	w1, w1, w20	// tmp1047, tmp1044, tmp1045
// md5.cpp:170: 		HH(c, d, a, b, x[15], s33, 0x1fa27cf8);
	mov	w20, 31992	// tmp1060,
	movk	w20, 0x1fa2, lsl 16	// tmp1060,,
	add	w20, w7, w20	// tmp1059, _190, tmp1060
// md5.cpp:168: 		HH(a, b, c, d, x[9], s31, 0xd9d4d039);
	ror	w1, w1, 28	// tmp1048, tmp1047,
	add	w1, w1, w2	// _382, tmp1048, _375
// md5.cpp:169: 		HH(d, a, b, c, x[12], s32, 0xe6db99e5);
	eor	w27, w27, w1	// tmp1050, tmp1049, _382
	add	w0, w27, w0	// tmp1051, tmp1050, _361
// md5.cpp:170: 		HH(c, d, a, b, x[15], s33, 0x1fa27cf8);
	eor	w27, w2, w1	// tmp1056, _375, _382
// md5.cpp:169: 		HH(d, a, b, c, x[12], s32, 0xe6db99e5);
	add	w0, w0, w22	// tmp1054, tmp1051, tmp1052
// md5.cpp:171: 		HH(b, c, d, a, x[2], s34, 0xc4ac5665);
	mov	w22, 22117	// tmp1067,
	movk	w22, 0xc4ac, lsl 16	// tmp1067,,
	add	w22, w13, w22	// tmp1066, _80, tmp1067
// md5.cpp:169: 		HH(d, a, b, c, x[12], s32, 0xe6db99e5);
	ror	w0, w0, 21	// tmp1055, tmp1054,
	add	w0, w0, w1	// _389, tmp1055, _382
// md5.cpp:170: 		HH(c, d, a, b, x[15], s33, 0x1fa27cf8);
	eor	w27, w27, w0	// tmp1057, tmp1056, _389
	add	w3, w27, w3	// tmp1058, tmp1057, _368
// md5.cpp:171: 		HH(b, c, d, a, x[2], s34, 0xc4ac5665);
	eor	w27, w1, w0	// tmp1063, _382, _389
// md5.cpp:170: 		HH(c, d, a, b, x[15], s33, 0x1fa27cf8);
	add	w3, w3, w20	// tmp1061, tmp1058, tmp1059
// md5.cpp:174: 		II(a, b, c, d, x[0], s41, 0xf4292244);
	mov	w20, 8772	// tmp1075,
	movk	w20, 0xf429, lsl 16	// tmp1075,,
	add	w20, w26, w20	// tmp1074, _50, tmp1075
// md5.cpp:175: 		II(d, a, b, c, x[7], s42, 0x432aff97);
	mov	w26, 65431	// tmp1083,
// md5.cpp:170: 		HH(c, d, a, b, x[15], s33, 0x1fa27cf8);
	ror	w3, w3, 16	// tmp1062, tmp1061,
	add	w3, w3, w0	// _396, tmp1062, _389
// md5.cpp:175: 		II(d, a, b, c, x[7], s42, 0x432aff97);
	movk	w26, 0x432a, lsl 16	// tmp1083,,
	add	w18, w18, w26	// tmp1082, _134, tmp1083
// md5.cpp:171: 		HH(b, c, d, a, x[2], s34, 0xc4ac5665);
	eor	w26, w27, w3	// tmp1064, tmp1063, _396
	add	w2, w26, w2	// tmp1065, tmp1064, _375
// md5.cpp:176: 		II(c, d, a, b, x[14], s43, 0xab9423a7);
	mov	w27, 9127	// tmp1091,
// md5.cpp:171: 		HH(b, c, d, a, x[2], s34, 0xc4ac5665);
	add	w2, w2, w22	// tmp1068, tmp1065, tmp1066
// md5.cpp:177: 		II(b, c, d, a, x[5], s44, 0xfc93a039);
	mov	w22, 41017	// tmp1099,
	movk	w22, 0xfc93, lsl 16	// tmp1099,,
	add	w17, w17, w22	// tmp1098, _120, tmp1099
// md5.cpp:178: 		II(a, b, c, d, x[12], s41, 0x655b59c3);
	mov	w22, 22979	// tmp1107,
// md5.cpp:171: 		HH(b, c, d, a, x[2], s34, 0xc4ac5665);
	ror	w2, w2, 9	// tmp1069, tmp1068,
	add	w2, w2, w3	// _403, tmp1069, _396
// md5.cpp:178: 		II(a, b, c, d, x[12], s41, 0x655b59c3);
	movk	w22, 0x655b, lsl 16	// tmp1107,,
	add	w12, w12, w22	// tmp1106, _169, tmp1107
// md5.cpp:174: 		II(a, b, c, d, x[0], s41, 0xf4292244);
	orn	w22, w2, w0	// tmp1071, _403, _389
	eor	w22, w22, w3	// tmp1072, tmp1071, _396
// md5.cpp:176: 		II(c, d, a, b, x[14], s43, 0xab9423a7);
	movk	w27, 0xab94, lsl 16	// tmp1091,,
// md5.cpp:174: 		II(a, b, c, d, x[0], s41, 0xf4292244);
	add	w1, w22, w1	// tmp1073, tmp1072, _382
// md5.cpp:176: 		II(c, d, a, b, x[14], s43, 0xab9423a7);
	add	w16, w16, w27	// tmp1090, _183, tmp1091
// md5.cpp:174: 		II(a, b, c, d, x[0], s41, 0xf4292244);
	add	w1, w1, w20	// tmp1076, tmp1073, tmp1074
// md5.cpp:182: 		II(a, b, c, d, x[8], s41, 0x6fa87e4f);
	mov	w20, 32335	// tmp1139,
	movk	w20, 0x6fa8, lsl 16	// tmp1139,,
	add	w8, w8, w20	// tmp1138, _141, tmp1139
// md5.cpp:179: 		II(d, a, b, c, x[3], s42, 0x8f0ccc92);
	mov	w26, 52370	// tmp1115,
// md5.cpp:174: 		II(a, b, c, d, x[0], s41, 0xf4292244);
	ror	w1, w1, 26	// tmp1077, tmp1076,
	add	w1, w1, w2	// _411, tmp1077, _403
// md5.cpp:179: 		II(d, a, b, c, x[3], s42, 0x8f0ccc92);
	movk	w26, 0x8f0c, lsl 16	// tmp1115,,
// md5.cpp:175: 		II(d, a, b, c, x[7], s42, 0x432aff97);
	orn	w20, w1, w3	// tmp1079, _411, _396
// md5.cpp:179: 		II(d, a, b, c, x[3], s42, 0x8f0ccc92);
	add	w11, w11, w26	// tmp1114, _95, tmp1115
// md5.cpp:175: 		II(d, a, b, c, x[7], s42, 0x432aff97);
	eor	w20, w20, w2	// tmp1080, tmp1079, _403
// md5.cpp:181: 		II(b, c, d, a, x[1], s44, 0x85845dd1);
	mov	w22, 24017	// tmp1131,
// md5.cpp:175: 		II(d, a, b, c, x[7], s42, 0x432aff97);
	add	w0, w20, w0	// tmp1081, tmp1080, _389
// md5.cpp:187: 		II(d, a, b, c, x[11], s42, 0xbd3af235);
	mov	w20, 62005	// tmp1179,
// md5.cpp:175: 		II(d, a, b, c, x[7], s42, 0x432aff97);
	add	w0, w0, w18	// tmp1084, tmp1081, tmp1082
// md5.cpp:185: 		II(b, c, d, a, x[13], s44, 0x4e0811a1);
	mov	w18, 4513	// tmp1163,
	movk	w18, 0x4e08, lsl 16	// tmp1163,,
	add	w5, w5, w18	// tmp1162, _176, tmp1163
// md5.cpp:186: 		II(a, b, c, d, x[4], s41, 0xf7537e82);
	mov	w18, 32386	// tmp1171,
// md5.cpp:175: 		II(d, a, b, c, x[7], s42, 0x432aff97);
	ror	w0, w0, 22	// tmp1085, tmp1084,
	add	w0, w0, w1	// _419, tmp1085, _411
// md5.cpp:186: 		II(a, b, c, d, x[4], s41, 0xf7537e82);
	movk	w18, 0xf753, lsl 16	// tmp1171,,
	add	w4, w4, w18	// tmp1170, _110, tmp1171
// md5.cpp:176: 		II(c, d, a, b, x[14], s43, 0xab9423a7);
	orn	w18, w0, w2	// tmp1087, _419, _403
	eor	w18, w18, w1	// tmp1088, tmp1087, _411
// md5.cpp:187: 		II(d, a, b, c, x[11], s42, 0xbd3af235);
	movk	w20, 0xbd3a, lsl 16	// tmp1179,,
// md5.cpp:176: 		II(c, d, a, b, x[14], s43, 0xab9423a7);
	add	w18, w18, w3	// tmp1089, tmp1088, _396
// md5.cpp:187: 		II(d, a, b, c, x[11], s42, 0xbd3af235);
	add	w14, w14, w20	// tmp1178, _162, tmp1179
// md5.cpp:176: 		II(c, d, a, b, x[14], s43, 0xab9423a7);
	add	w18, w18, w16	// tmp1092, tmp1089, tmp1090
// md5.cpp:181: 		II(b, c, d, a, x[1], s44, 0x85845dd1);
	movk	w22, 0x8584, lsl 16	// tmp1131,,
	add	w9, w9, w22	// tmp1130, _65, tmp1131
// md5.cpp:183: 		II(d, a, b, c, x[15], s42, 0xfe2ce6e0);
	mov	w22, 59104	// tmp1147,
	movk	w22, 0xfe2c, lsl 16	// tmp1147,,
// md5.cpp:176: 		II(c, d, a, b, x[14], s43, 0xab9423a7);
	ror	w18, w18, 17	// tmp1093, tmp1092,
	add	w18, w18, w0	// _427, tmp1093, _419
// md5.cpp:183: 		II(d, a, b, c, x[15], s42, 0xfe2ce6e0);
	add	w7, w7, w22	// tmp1146, _190, tmp1147
// md5.cpp:177: 		II(b, c, d, a, x[5], s44, 0xfc93a039);
	orn	w20, w18, w1	// tmp1095, _427, _411
// md5.cpp:184: 		II(c, d, a, b, x[6], s43, 0xa3014314);
	mov	w22, 17172	// tmp1155,
// md5.cpp:177: 		II(b, c, d, a, x[5], s44, 0xfc93a039);
	eor	w20, w20, w0	// tmp1096, tmp1095, _419
// md5.cpp:184: 		II(c, d, a, b, x[6], s43, 0xa3014314);
	movk	w22, 0xa301, lsl 16	// tmp1155,,
// md5.cpp:177: 		II(b, c, d, a, x[5], s44, 0xfc93a039);
	add	w2, w20, w2	// tmp1097, tmp1096, _403
// md5.cpp:184: 		II(c, d, a, b, x[6], s43, 0xa3014314);
	add	w6, w6, w22	// tmp1154, _127, tmp1155
// md5.cpp:177: 		II(b, c, d, a, x[5], s44, 0xfc93a039);
	add	w17, w2, w17	// tmp1100, tmp1097, tmp1098
// md5.cpp:188: 		II(c, d, a, b, x[2], s43, 0x2ad7d2bb);
	mov	w3, 53947	// tmp1187,
	movk	w3, 0x2ad7, lsl 16	// tmp1187,,
	add	w13, w13, w3	// tmp1186, _80, tmp1187
// md5.cpp:189: 		II(b, c, d, a, x[9], s44, 0xeb86d391);
	mov	w3, 54161	// tmp1196,
// md5.cpp:177: 		II(b, c, d, a, x[5], s44, 0xfc93a039);
	ror	w17, w17, 11	// tmp1101, tmp1100,
	add	w17, w17, w18	// _435, tmp1101, _427
// md5.cpp:189: 		II(b, c, d, a, x[9], s44, 0xeb86d391);
	movk	w3, 0xeb86, lsl 16	// tmp1196,,
// md5.cpp:178: 		II(a, b, c, d, x[12], s41, 0x655b59c3);
	orn	w2, w17, w0	// tmp1103, _435, _419
// md5.cpp:189: 		II(b, c, d, a, x[9], s44, 0xeb86d391);
	add	w3, w15, w3	// tmp1195, _148, tmp1196
// md5.cpp:178: 		II(a, b, c, d, x[12], s41, 0x655b59c3);
	eor	w2, w2, w18	// tmp1104, tmp1103, _427
	add	w1, w2, w1	// tmp1105, tmp1104, _411
	add	w12, w1, w12	// tmp1108, tmp1105, tmp1106
// md5.cpp:192: 		state[1] += b;
	ldp	w22, w16, [x19]	//,, *state_576(D)
// md5.cpp:178: 		II(a, b, c, d, x[12], s41, 0x655b59c3);
	ror	w12, w12, 26	// tmp1109, tmp1108,
	add	w12, w12, w17	// _443, tmp1109, _435
// md5.cpp:179: 		II(d, a, b, c, x[3], s42, 0x8f0ccc92);
	orn	w2, w12, w18	// tmp1111, _443, _427
	eor	w2, w2, w17	// tmp1112, tmp1111, _435
	add	w2, w2, w0	// tmp1113, tmp1112, _419
	add	w2, w2, w11	// tmp1116, tmp1113, tmp1114
// md5.cpp:194: 		state[3] += d;
	ldp	w15, w27, [x19, 8]	//,, MEM[(bit32 *)state_576(D) + 8B]
// md5.cpp:179: 		II(d, a, b, c, x[3], s42, 0x8f0ccc92);
	ror	w2, w2, 22	// tmp1117, tmp1116,
	add	w2, w2, w12	// _451, tmp1117, _443
// md5.cpp:180: 		II(c, d, a, b, x[10], s43, 0xffeff47d);
	orn	w1, w2, w17	// tmp1119, _451, _435
	eor	w1, w1, w12	// tmp1120, tmp1119, _443
	add	w1, w1, w18	// tmp1121, tmp1120, _427
	add	w1, w1, w10	// tmp1124, tmp1121, tmp1122
	ror	w1, w1, 17	// tmp1125, tmp1124,
	add	w1, w1, w2	// _459, tmp1125, _451
// md5.cpp:181: 		II(b, c, d, a, x[1], s44, 0x85845dd1);
	orn	w0, w1, w12	// tmp1127, _459, _443
	eor	w0, w0, w2	// tmp1128, tmp1127, _451
	add	w0, w0, w17	// tmp1129, tmp1128, _435
	add	w0, w0, w9	// tmp1132, tmp1129, tmp1130
	ror	w0, w0, 11	// tmp1133, tmp1132,
	add	w0, w0, w1	// _467, tmp1133, _459
// md5.cpp:182: 		II(a, b, c, d, x[8], s41, 0x6fa87e4f);
	orn	w9, w0, w2	// tmp1135, _467, _451
	eor	w9, w9, w1	// tmp1136, tmp1135, _459
	add	w9, w9, w12	// tmp1137, tmp1136, _443
	add	w8, w9, w8	// tmp1140, tmp1137, tmp1138
	ror	w8, w8, 26	// tmp1141, tmp1140,
	add	w8, w8, w0	// _475, tmp1141, _467
// md5.cpp:183: 		II(d, a, b, c, x[15], s42, 0xfe2ce6e0);
	orn	w9, w8, w1	// tmp1143, _475, _459
	eor	w9, w9, w0	// tmp1144, tmp1143, _467
	add	w2, w9, w2	// tmp1145, tmp1144, _451
	add	w7, w2, w7	// tmp1148, tmp1145, tmp1146
	ror	w7, w7, 22	// tmp1149, tmp1148,
	add	w7, w7, w8	// _483, tmp1149, _475
// md5.cpp:184: 		II(c, d, a, b, x[6], s43, 0xa3014314);
	orn	w2, w7, w0	// tmp1151, _483, _467
	eor	w2, w2, w8	// tmp1152, tmp1151, _475
	add	w2, w2, w1	// tmp1153, tmp1152, _459
	add	w2, w2, w6	// tmp1156, tmp1153, tmp1154
	ror	w2, w2, 17	// tmp1157, tmp1156,
	add	w2, w2, w7	// _491, tmp1157, _483
// md5.cpp:185: 		II(b, c, d, a, x[13], s44, 0x4e0811a1);
	orn	w1, w2, w8	// tmp1159, _491, _475
	eor	w1, w1, w7	// tmp1160, tmp1159, _483
	add	w1, w1, w0	// tmp1161, tmp1160, _467
	add	w1, w1, w5	// tmp1164, tmp1161, tmp1162
	ror	w1, w1, 11	// tmp1165, tmp1164,
	add	w1, w1, w2	// _499, tmp1165, _491
// md5.cpp:186: 		II(a, b, c, d, x[4], s41, 0xf7537e82);
	orn	w0, w1, w7	// tmp1167, _499, _483
	eor	w0, w0, w2	// tmp1168, tmp1167, _491
	add	w0, w0, w8	// tmp1169, tmp1168, _475
	add	w0, w0, w4	// tmp1172, tmp1169, tmp1170
	ror	w0, w0, 26	// tmp1173, tmp1172,
	add	w0, w0, w1	// _507, tmp1173, _499
// md5.cpp:187: 		II(d, a, b, c, x[11], s42, 0xbd3af235);
	orn	w4, w0, w2	// tmp1175, _507, _491
// md5.cpp:191: 		state[0] += a;
	add	w22, w0, w22	// prephitmp_488, _507, *state_576(D)
// md5.cpp:187: 		II(d, a, b, c, x[11], s42, 0xbd3af235);
	eor	w4, w4, w1	// tmp1176, tmp1175, _499
	add	w4, w4, w7	// tmp1177, tmp1176, _483
	add	w4, w4, w14	// tmp1180, tmp1177, tmp1178
	ror	w4, w4, 22	// tmp1181, tmp1180,
	add	w4, w4, w0	// _515, tmp1181, _507
// md5.cpp:188: 		II(c, d, a, b, x[2], s43, 0x2ad7d2bb);
	orn	w28, w4, w1	// tmp1183, _515, _499
// md5.cpp:194: 		state[3] += d;
	add	w27, w4, w27	// prephitmp_503, _515, MEM[(bit32 *)state_576(D) + 12B]
// md5.cpp:188: 		II(c, d, a, b, x[2], s43, 0x2ad7d2bb);
	eor	w28, w28, w0	// tmp1184, tmp1183, _507
	add	w28, w28, w2	// tmp1185, tmp1184, _491
	add	w28, w28, w13	// tmp1188, tmp1185, tmp1186
	ror	w28, w28, 17	// tmp1189, tmp1188,
	add	w28, w28, w4	// _523, tmp1189, _515
// md5.cpp:189: 		II(b, c, d, a, x[9], s44, 0xeb86d391);
	orn	w20, w28, w0	// tmp1192, _523, _507
// md5.cpp:192: 		state[1] += b;
	add	w16, w28, w16	// tmp1199, _523, MEM[(bit32 *)state_576(D) + 4B]
// md5.cpp:189: 		II(b, c, d, a, x[9], s44, 0xeb86d391);
	eor	w20, w20, w4	// tmp1193, tmp1192, _515
// md5.cpp:193: 		state[2] += c;
	add	w28, w28, w15	// prephitmp_496, _523, MEM[(bit32 *)state_576(D) + 8B]
// md5.cpp:189: 		II(b, c, d, a, x[9], s44, 0xeb86d391);
	add	w20, w20, w1	// tmp1194, tmp1193, _499
// md5.cpp:194: 		state[3] += d;
	stp	w28, w27, [x19, 8]	// prephitmp_496, prephitmp_503, MEM[(bit32 *)state_576(D) + 8B]
// md5.cpp:189: 		II(b, c, d, a, x[9], s44, 0xeb86d391);
	add	w20, w20, w3	// tmp1197, tmp1194, tmp1195
	ror	w20, w20, 11	// tmp1198, tmp1197,
// md5.cpp:192: 		state[1] += b;
	add	w20, w20, w16	// prephitmp_495, tmp1198, tmp1199
	stp	w22, w20, [x19]	// prephitmp_488, prephitmp_495, *state_576(D)
// md5.cpp:103: 	for (int i = 0; i < n_blocks; i += 1)
	cmp	w25, w23	// n_blocks, i
	bgt	.L18		//,
	ldp	x23, x24, [sp, 48]	//,,
	.cfi_restore 24
	.cfi_restore 23
	rev	w2, w22	// _835, prephitmp_488
	ldp	x27, x28, [sp, 80]	//,,
	.cfi_restore 28
	.cfi_restore 27
.L16:
// md5.cpp:103: 	for (int i = 0; i < n_blocks; i += 1)
	mov	x0, 0	// ivtmp.571,
// md5.cpp:201: 		state[i] = ((value & 0xff) << 24) |		 // 将最低字节移到最高位
	str	w2, [x19, x0]	// _835, MEM[base: state_576(D), index: ivtmp.571_547, offset: 0B]
// md5.cpp:198: 	for (int i = 0; i < 4; i++)
	add	x0, x0, 4	// ivtmp.571, ivtmp.571,
	cmp	x0, 16	// ivtmp.571,
	beq	.L19		//,
.L35:
	ldr	w2, [x19, x0]	//, MEM[base: state_576(D), index: ivtmp.571_548, offset: 0B]
	rev	w2, w2	// _835, MEM[base: state_576(D), index: ivtmp.571_548, offset: 0B]
// md5.cpp:201: 		state[i] = ((value & 0xff) << 24) |		 // 将最低字节移到最高位
	str	w2, [x19, x0]	// _835, MEM[base: state_576(D), index: ivtmp.571_547, offset: 0B]
// md5.cpp:198: 	for (int i = 0; i < 4; i++)
	add	x0, x0, 4	// ivtmp.571, ivtmp.571,
	cmp	x0, 16	// ivtmp.571,
	bne	.L35		//,
.L19:
// md5.cpp:216: 	delete[] paddedMessage;
	cbz	x21, .L21	// _571,
// md5.cpp:216: 	delete[] paddedMessage;
	mov	x0, x21	//, _571
	bl	_ZdaPv		//
.L21:
// md5.cpp:218: }
	ldp	x19, x20, [sp, 16]	//,,
	ldp	x21, x22, [sp, 32]	//,,
// md5.cpp:217: 	delete[] messageLength;
	ldp	x25, x26, [sp, 64]	//,,
	.cfi_restore 26
	.cfi_restore 25
	ldr	x0, [sp, 104]	//, %sfp
// md5.cpp:218: }
	ldp	x29, x30, [sp], 192	//,,,
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
// md5.cpp:217: 	delete[] messageLength;
	b	_ZdaPv		//
.L13:
	.cfi_def_cfa_offset 192
	.cfi_offset 19, -176
	.cfi_offset 20, -168
	.cfi_offset 21, -160
	.cfi_offset 22, -152
	.cfi_offset 29, -192
	.cfi_offset 30, -184
	mov	x0, x1	// pretmp_472, tmp666
// /usr/include/c++/10.3.1/bits/char_traits.h:403: 	if (__n == 0)
	cbz	x20, .L14	// prephitmp_471,
	b	.L12		//
	.p2align 2,,3
.L34:
// /usr/include/c++/10.3.1/bits/basic_string.tcc:219: 	    _M_data(_M_create(__dnew, size_type(0)));
	add	x1, sp, 120	//,,
	add	x0, sp, 128	// tmp1239,,
	mov	x2, 0	//,
.LEHB2:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm		//
// /usr/include/c++/10.3.1/bits/basic_string.h:211:       { _M_allocated_capacity = __capacity; }
	ldr	x1, [sp, 120]	// __dnew, __dnew
// /usr/include/c++/10.3.1/bits/basic_string.h:179:       { _M_dataplus._M_p = __p; }
	str	x0, [sp, 128]	// _3, MEM[(struct basic_string *)_567]._M_dataplus._M_p
// /usr/include/c++/10.3.1/bits/basic_string.h:211:       { _M_allocated_capacity = __capacity; }
	str	x1, [sp, 144]	// __dnew, MEM[(struct basic_string *)_567].D.21340._M_allocated_capacity
.L12:
// /usr/include/c++/10.3.1/bits/char_traits.h:409: 	return static_cast<char_type*>(__builtin_memcpy(__s1, __s2, __n));
	mov	x2, x20	//, prephitmp_471
	mov	x1, x21	//, _622
	bl	memcpy		//
// /usr/include/c++/10.3.1/bits/basic_string.h:187:       { return _M_dataplus._M_p; }
	ldp	x20, x0, [sp, 120]	// prephitmp_471, pretmp_472, __dnew
// /usr/include/c++/10.3.1/bits/char_traits.h:409: 	return static_cast<char_type*>(__builtin_memcpy(__s1, __s2, __n));
	b	.L14		//
.L24:
	.cfi_offset 25, -128
	.cfi_offset 26, -120
// md5.cpp:103: 	for (int i = 0; i < n_blocks; i += 1)
	mov	w2, 17767	// _835,
	movk	w2, 0x123, lsl 16	// _835,,
	b	.L16		//
.L33:
	.cfi_restore 25
	.cfi_restore 26
// /usr/include/c++/10.3.1/bits/basic_string.tcc:212: 	  std::__throw_logic_error(__N("basic_string::"
	adrp	x0, .LC0	// tmp673,
	add	x0, x0, :lo12:.LC0	//, tmp673,
	stp	x23, x24, [sp, 48]	//,,
	.cfi_remember_state
	.cfi_offset 24, -136
	.cfi_offset 23, -144
	stp	x25, x26, [sp, 64]	//,,
	.cfi_offset 26, -120
	.cfi_offset 25, -128
	stp	x27, x28, [sp, 80]	//,,
	.cfi_offset 28, -104
	.cfi_offset 27, -112
	bl	_ZSt19__throw_logic_errorPKc		//
.L25:
	.cfi_restore_state
// /usr/include/c++/10.3.1/bits/basic_string.h:658:       { _M_dispose(); }
	mov	x19, x0	// tmp1212,
	add	x0, sp, 128	// tmp1250,,
	stp	x23, x24, [sp, 48]	//,,
	.cfi_offset 24, -136
	.cfi_offset 23, -144
	stp	x25, x26, [sp, 64]	//,,
	.cfi_offset 26, -120
	.cfi_offset 25, -128
	stp	x27, x28, [sp, 80]	//,,
	.cfi_offset 28, -104
	.cfi_offset 27, -112
// /usr/include/c++/10.3.1/bits/basic_string.h:658:       { _M_dispose(); }
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv		//
	mov	x0, x19	//, tmp1205
	bl	_Unwind_Resume		//
.LEHE2:
	.cfi_endproc
.LFE2500:
	.global	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA2500:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2500-.LLSDACSB2500
.LLSDACSB2500:
	.uleb128 .LEHB0-.LFB2500
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB2500
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L25-.LFB2500
	.uleb128 0
	.uleb128 .LEHB2-.LFB2500
	.uleb128 .LEHE2-.LEHB2
	.uleb128 0
	.uleb128 0
.LLSDACSE2500:
	.text
	.size	_Z7MD5HashNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPj, .-_Z7MD5HashNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPj
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.type	_GLOBAL__sub_I__Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi, %function
_GLOBAL__sub_I__Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi:
.LFB3028:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!	//,,,
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp	//,
	str	x19, [sp, 16]	//,
	.cfi_offset 19, -16
// /usr/include/c++/10.3.1/iostream:74:   static ios_base::Init __ioinit;
	adrp	x19, .LANCHOR0	// tmp93,
	add	x19, x19, :lo12:.LANCHOR0	// tmp92, tmp93,
	mov	x0, x19	//, tmp92
	bl	_ZNSt8ios_base4InitC1Ev		//
	mov	x1, x19	//, tmp92
	adrp	x2, __dso_handle	// tmp95,
// md5.cpp:218: }
	ldr	x19, [sp, 16]	//,
// /usr/include/c++/10.3.1/iostream:74:   static ios_base::Init __ioinit;
	add	x2, x2, :lo12:__dso_handle	//, tmp95,
// md5.cpp:218: }
	ldp	x29, x30, [sp], 32	//,,,
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
// /usr/include/c++/10.3.1/iostream:74:   static ios_base::Init __ioinit;
	adrp	x0, _ZNSt8ios_base4InitD1Ev	// tmp99,
	add	x0, x0, :lo12:_ZNSt8ios_base4InitD1Ev	//, tmp99,
	b	__cxa_atexit		//
	.cfi_endproc
.LFE3028:
	.size	_GLOBAL__sub_I__Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi, .-_GLOBAL__sub_I__Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi
	.section	.init_array,"aw"
	.align	3
	.xword	_GLOBAL__sub_I__Z13StringProcessNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPi
	.bss
	.align	3
	.set	.LANCHOR0,. + 0
	.type	_ZStL8__ioinit, %object
	.size	_ZStL8__ioinit, 1
_ZStL8__ioinit:
	.zero	1
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align	3
	.type	DW.ref.__gxx_personality_v0, %object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.xword	__gxx_personality_v0
	.hidden	__dso_handle
	.ident	"GCC: (GNU) 10.3.1"
	.section	.note.GNU-stack,"",@progbits
