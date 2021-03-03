.text

.global add_3
.func add_3, add_3
.type add_3, %function

add_3:
add r0, r0, r1
add r0, r0, r2
bx lr
.endfunc

.text

.global add_10
.func add_10, add_10
.type add_10, %function

add_10:
cmp r1, #0
beq end_add
mov r2, #0
add_loop:
	ldr r3, [r0], #4
	add r2, r2, r3
	subs r1, r1, #1
	bne  add_loop
mov r0, r2
end_add:
bx lr
.endfunc

.text

.global arr_copy
.func arr_copy, arr_copy
.type arr_copy, %function

arr_copy:
cmp r2, #0
beq end_add
copy_loop:
	ldr r3, [r0], #4
	str r3, [r1], #4
	subs r2, r2, #1
	bne  copy_loop
end_copy:
bx lr
.endfunc

.text

.global multiply
.func multiply, multiply
.type multiply, %function

multiply:
	push {r4-r9}
	// If more registers are used in the function make sure to do push them on the stack to preserve them
	ldr r4, [sp, #24]		@m pointer is stored in R4
	ldr r5, [sp, #28]		@n pointer is stored in R5
	add r1, r1, r0, lsl #2
	ldr r6, [r4]
	ldr r7, [r5]
	umull r8, r9, r6, r7
	ldr r6, [r2]
	ldr r7, [r3]
	umull r4, r5, r6, r7
	adds r8, r8, r4
	adc r9, r9, r5
	stmia r1, {r8, r9}
	pop {r4-r9}
	bx lr
.endfunc


//CarryAdd;

.text
.global _AddAssembly
.func _AddAssembly, _AddAssembly
.type _AddAssembly, %function

_AddAssembly:
	@r0->t, r1: i, r2: C;
	push {r4, r5, r6}
	//mov r6, #4
	//mul r1, r1, r6
	lsl r1, r1, #2
	Add_loop:
		cmp r2, #0
		beq End_loop
		ldr r4, [r0, r1]  @r4: t[i]
		adds r5, r4, r2	@r5 : sum[0]
		mov r2, #0
		movcs r2, #1
		mov r4, r5
		str r4, [r0, r1]
		add r1, r1, #4
		b Add_loop
	End_loop:
		pop {r4, r5, r6}
		bx lr
.endfunc


//sub_cond; only save time when n<u;
.text
.global _Sub_Assembly
.func _Sub_Assembly, _Sub_Assembly
.type _Sub_Assembly, %function

_Sub_Assembly:
	@r0:u_pointer, r1:n_pointer, r2:SIZE
	push {r4-r8}
	@start with MSB to LSB
	add r4, r0, #128 @r4->u[32]
	add r5, r1, #128 @r5->n[32]
	check_loop:
		ldr r6, [r4] @r6=u[32]
		ldr r7, [r5] @r7=n[32]
		cmp r6, r7
		bcc end_loop @if u smaller than n, assign dum with u
		bhi subtract_set @if u larger than n, do subtraction
		sub r4, r4, #4 @if u equal to n, keep check next index
		sub r5, r5, #4
		b check_loop
	subtract_set:
	@start with LSB to MSB
		sub r4, r4, #128 @r4->u[0]
		sub r5, r5, #128 @r5->n[0]
		mov r8, #0
	subtract_loop:
		ldr r6, [r4]
		ldr r7, [r5]
		sub r6, r6, r8
		subs r6, r6, r7
		mov r8, #0 @set borrow bit to zero
		movcc r8, #1 @else set to one
		str r6, [r3], #4
		cmp r4, r0
		beq end_loop
		sub r4, r4, #4
		sub r5, r5, #4
		b subtract_loop
	end_loop:
		pop {r4-r8}
		bx lr
.endfunc



//32bit addition, with 2 32bit result, C and S;
//void _32add(uint32_t* sum, uint32_t t);
.text
.global _32add
.func _32add, _32add
.type _32add, %function

_32add:
	ldr r2, [r0]
	adds r1, r1, r2
	str r1, [r0]
	ldr r2, [r0, #4]!
	adc	 r2, r2, #0
	str r2, [r0]
	bx lr
.endfunc



//32bit add 3 elements;
.text
.global _32add3
.func _32add3, _32add3
.type _32add3, %function

_32add3:
	push {r4}
	ldr r3, [r0]
	adds r1, r1, r2
	mov r4, #0
	addcs r4, r4, #1
	adds r1, r1, r3
	addcs r4, r4, #1
	str r1, [r0]
	ldr r3, [r0, #4]!
	add r3, r3, r4
	str r3, [r0]
	bx lr
.endfunc


//_32mul
.text
.global _32mulAssembly
.func _32mulAssembly, _32mulAssembly
.type _32mulAssembly, %function

_32mulAssembly:
    push {r4, r5}
    umull r4, r5, r0, r1 @r0:x, r1:y
    str r4, [r2]
    str r5, [r2, #4]
    pop {r4, r5}
    bx lr
.endfunc    


//inner loop _32mulAssembly+_32add3 merge
//combine _32mulAssembly and _32add3 for inner loop
//muladd3(uint32 aj, uint32 bi, uint32* sum, uint32 tj)
//S = sum[0], C = sum[1]
.text
.global muladd3
.func muladd3, muladd3
.type muladd3, %function

muladd3:
	push {r4-r6}
	@ldr r4, [r2] @r4 = sum[0]
	ldr r5, [r2, #4] @r5 = C
	umull r4, r6, r0, r1 @r4=sum[0], r6=sum[1]
	adds r3, r3, r5 @r3=tj, r5=C
	mov r5, #0 @r5 = internal carry
	movcs r5, #1
	adds r4, r4, r3 @r4 = sum[0]
	addcs r5, r5, #1 
	add r6, r6, r5 @r6 = sum[1]
	str r4, [r2]
	str r6, [r2, #4]
	pop {r4-r6}
	bx lr
.endfunc


//muladd3 + _AddAssembly
.text
.global muladd3add
.func muladd3add, muladd3add
.type muladd3add, %function

muladd3add:
	@ muladd3add(uin32_t* a, uint32_t bi, uint32_t* sum, uint32_t* t, uint8_t j)
	@ r0->a, r1:bi, r2->sum, r3->t, r4:S, r5:j
	@ C in add assembly is sum[1], which is [r2, #4]
	@ S in add assembly is sum[0], which is [r2], S in r4 is a dummy variable
	@ the index j will be assigned to r5
	push {r4-r8}
	ldr r4, [sp, #20]
	@ldr r4, [sp, #28]
	ldr r6, [r2, #4] @r6 = C
	lsl r4, r4, #2	@shift r4:j to time it by 4
	ldr r0, [r0, r4]	@r0:a[j]
	umull r5, r7, r0, r1 @r5=sum[0], r7=sum[1]
	ldr r8, [r3, r4]
	adds r8, r8, r6 @r8:t[j], r6=C
	mov r6, #0 @r6 = internal carry
	movcs r6, #1
	adds r5, r5, r8 @r5 = sum[0] ,which is S now
	addcs r6, r6, #1 
	add r7, r7, r6 @r7 = sum[1], which is C now
	str r5, [r2]
	str r7, [r2, #4]
	add r4, r4, #4	@ j+1
	muladd3add_loop:
		cmp r7, #0
		beq End_muladd3addloop
		ldr r6, [r3, r4] @r6:t[j+1], r3->t, r4:j+1
		adds r8, r6, r7 @r8: new t[j+1], added with internal r7 from last loop
		mov r7, #0	@r7: internal carry set to 0
		movcs r7, #1 	@ if t[j+1] + C gives another carry to t[j+2]
		str r8, [r3, r4]
		add r4, r4, #4
		b muladd3add_loop
	End_muladd3addloop:
		pop {r4-r8}
		bx lr
.endfunc
	



//inner loop _32mulAssembly+_32add merge
//combine _32mulAssembly and _32add for inner loop
//muladd(uint32_t m, uint32_t n[j], uint32_t* sum, uint32_t S)
//@r0:m, r1:nj, r2->sum, r3:S, r4:j
.text
.global muladd
.func muladd, muladd
.type muladd, %function

muladd:
	push {r5, r6}
	umull r5, r6, r0, r1	@r5:sum[0], r6:sum[1]
	adds r3, r3, r5
	str r3, [r2]
	adc r6, r6, #0
	str r6, [r2, #4]
	pop {r5, r6}
	bx lr
.endfunc




//outter loop last part
@r0->t
@r1->sum
@r2:C
@size = 32
@void byteadd(uint32_t* t, uint32_t* sum, uint32_t C);
.text
.global byteadd
.func byteadd, byteadd
.type byteadd, %function

byteadd:
    @index of size
    mov r3, #32
    lsl r3, r3, #2
    @t[size]
    ldr r0, [r0, r3]
    @calculate sum[0]:S
    adds r0, r0, r2
    str r0, [r1]
    mov r2, #0
    movcs r2, #1
    str r2, [r1, #4]
    bx lr
.endfunc



//inner loop final combine
.text
.global inner
@.func inner, inner
@.type inner, %function


@void inner(uint32_t* a, uint32_t b[i], uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t j);
@r0->a
@r1:bi
@r2->sum
@r3->res
@r4:m
@r5->n
@r6:j
@r7,r8,r9,r10,r11 prepared for use
inner:
	push {r4-r11}
	ldr r4, [sp, #32]
	ldr r5, [sp, #36]
	ldr r6, [sp, #40]
	ldr r7, [r2, #4] @r7 = C
	lsl r6, r6, #2	@shift r6:j to time it by 4
	ldr r11, [r0, r6]	@r0:a[j]
	umull r10, r8, r11, r1 @r10=sum[0], r8=sum[1]
	ldr r9, [r3, r6]
	adds r9, r9, r7 @r9:t[j], r7=C
	mov r7, #0 @r7 = internal carry
	movcs r7, #1
	adds r10, r10, r9 @r10 = sum[0] ,which is S now
	addcs r7, r7, #1
	add r8, r8, r7 @r8 = sum[1], which is C now
	str r10, [r2]
	str r8, [r2, #4]
	add r6, r6, #4	@ j+1
	mov r10, r6
	muladd3add_loop_in:
		cmp r8, #0
		beq End_muladd3addloop_in
		ldr r7, [r3, r6] @r7:t[j+1], r3->t, r6:j+1
		adds r9, r7, r8 @r9: new t[j+1], added with internal r8 from last loop
		mov r8, #0	@r8: internal carry set to 0
		movcs r8, #1 	@ if t[j+1] + C gives another carry to t[j+2]
		str r9, [r3, r6]
		add r6, r6, #4
		b muladd3add_loop_in
	End_muladd3addloop_in:
		@nj
		sub r11, r10, #4
		ldr r9, [r5, r11] @r9:nj
		umull r7, r8, r4, r9
		@load sum[0]
		ldr r11, [r2]
		adds r11, r11, r7
		str r11, [r2]
		adc r8, r8, #0
		str r8, [r2, #4]
		@j-1
		sub r8, r10, #8
		str r11, [r3, r8]
		pop {r4-r11}
		bx lr
@.endfunc


//inner for loop
//void forj(uint32_t* a, uint32_t b[i], uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t j);
.text
.global forj
.func forj, forj
.type forj, %function

forj:
	push {r4-r11}
	ldr r4, [sp, #32]
	ldr r5, [sp, #36]
	ldr r6, [sp, #40]
	mov r6, #1
	forjloop:
		@bl inner
		ldr r7, [r2, #4] @r7 = C
		lsl r6, r6, #2	@shift r6:j to time it by 4
		ldr r11, [r0, r6]	@r0:a[j]
		umull r10, r8, r11, r1 @r10=sum[0], r8=sum[1]
		ldr r9, [r3, r6]
		adds r9, r9, r7 @r9:t[j], r7=C
		mov r7, #0 @r7 = internal carry
		movcs r7, #1
		adds r10, r10, r9 @r10 = sum[0] ,which is S now
		addcs r7, r7, #1
		add r8, r8, r7 @r8 = sum[1], which is C now
		str r10, [r2]
		str r8, [r2, #4]
		add r6, r6, #4	@ j+1
		mov r10, r6
	mul3a_forj:
		cmp r8, #0
		beq endmul3a_forj
		ldr r7, [r3, r6] @r7:t[j+1], r3->t, r6:j+1
		adds r9, r7, r8 @r9: new t[j+1], added with internal r8 from last loop
		mov r8, #0	@r8: internal carry set to 0
		movcs r8, #1 	@ if t[j+1] + C gives another carry to t[j+2]
		str r9, [r3, r6]
		add r6, r6, #4
		b mul3a_forj
	endmul3a_forj:
		@nj
		sub r11, r10, #4
		ldr r9, [r5, r11] @r9:nj
		umull r7, r8, r4, r9
		@load sum[0]
		ldr r11, [r2]
		adds r11, r11, r7
		str r11, [r2]
		adc r8, r8, #0
		str r8, [r2, #4]
		@j-1
		sub r8, r10, #8
		str r11, [r3, r8]
		@j+1/4
		lsr r10, r10, #2
		@cmp and loop
		cmp r10, #32
		beq endloop
		mov r6, r10
		b forjloop
	endloop:
		pop {r4-r11}
		bx lr
.endfunc




@USEFUL FUNCTIONS

@ add Rx, Ry, Rz	//Rx = Ry + Rz  second operand can be constant
@ sub Rx, Ry, Rz	//Rx = Ry - Rz second operand can be constant
@ addc Rx, Ry, Rz	//Rx = Ry + Rz + CARRY   one operand can be constant
@ cmp Rx, Ry		//compares Rx and Ry and if they are equal sets Z flag, otherwise resets Z flag (works by subtracting two values and checks if result is zero)
@ b{cond} <label>		//Jumps to given label in the code if given condition is satisfied
@ umull Rn, Rm, Rx, Ry 	//{Rm, Rn} = Rx * Ry Multiplies unsigned 32bit values in Rx and Ry. Stores the higher 32 bits in Rm, and lower in Rn
@ ldr Rx, [Ry]		//Loads from memory pointed by Ry to register Rx, see addressing modes for post increment, pre decrement
@ str Rx, [Ry]		//Stores to memory pointed by Ry value in register Rx, see addressing modes for post increment, pre decrement
@ pop {}			//Pops values from stack to specified registers in order they are specified
@ push {}			//Push registers to stack in orded they are specified
@ ldmia rx, {set of registers} //Loads to specified set of registers memory values, starting from rx. Increasing addresses
@ stmia rx, {set of registers} //Stores specified set of registers in memory, starting from address pointed by rx. Increasing addresses


//HOW TO WRITE NESTED LOOP?


//void muadadas(uint32_t* a, uint32_t* b, uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t i, uint32_t np0);
.text
.global muadadas
.func muadadas, muadadas
.type muadadas, %function

muadadas:
	//muladd
	push {r4-r12}
	ldr r10, [r0]					@a0
	ldr r6, [sp, #44]				@i
	lsl r6, r6, #2					@i in bytes
	ldr r11, [r1, r6]				@bi
	umull r8, r9, r10, r11
	ldr r10, [r3]
	adds r10, r10, r8
	str r10, [r2]					@r10: sum[0]:S
	adc r9, r9, #0
	str r9, [r2, #4]				@r9: sum[1]:C

	//r8 r11 are free, r6, r9, r10 are occupied
	//_AddAssembly(r3, r12, r9)
	//r12 occupied
	mov r12, #1
	lsl r12, r12, #2
	loop1:
		cmp r9, #0
		beq endloop1
		ldr r8, [r3, r12]
		adds r11, r8, r9
		//r8 r9free, r11 occupied
		mov r9, #0
		movcs r9, #1
		str r11, [r3, r12]
		add r12, r12, #4
		b loop1
	endloop1:
		pop {r4-r12}
		bx lr
.endfunc



//muadadas+32mulassembly+muladd
//uint32_t mua_32mul(uint32_t* a, uint32_t* b, uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t i, uint32_t np0);
.text
.global mua_32mul
.func mua_32mul, mua_32mul
.type mua_32mul, %function

mua_32mul:
	//muladd
	push {r4-r12}
	ldr r10, [r0]					@a0
 	ldr r4, [sp, #36]				@m
	ldr r5, [sp, #40]				@n
	ldr r6, [sp, #44]				@i
	ldr r7, [sp, #48]				@np0
	lsl r6, r6, #2					@i in bytes
	ldr r11, [r1, r6]				@bi
	umull r8, r9, r10, r11
	ldr r10, [r3]
	adds r10, r10, r8
	str r10, [r2]					@r10: sum[0]:S
	adc r9, r9, #0
	str r9, [r2, #4]				@r9: sum[1]:C

	//r8 r11 are free, r6, r9, r10 are occupied
	//_AddAssembly(r3, r12, r9)
	//r12 occupied
	mov r12, #1
	lsl r12, r12, #2
	loop2:
		cmp r9, #0
		beq endloop2
		ldr r8, [r3, r12]
		adds r11, r8, r9
		//r8 r9free, r11 occupied
		mov r9, #0
		movcs r9, #1
		str r11, [r3, r12]
		add r12, r12, #4
		b loop2
	endloop2:
		//r10:S, r7:np0, r2->sum
		umull r8, r9, r10, r7
		str r8, [r2]
		str r9, [r2, #4]

		//m = sum[0]
		ldr r4, [r2]

		//muladd
		@n0
		ldr r7, [r5]
		umull r8, r9, r4, r7
		adds r10, r10, r8				@r10 jumps to zero
		str r10, [r2]
		adc r9, r9, #0
		str r9, [r2, #4]
		mov r0, r4
		pop {r4-r12}
		bx lr
.endfunc





//forj+byteadd
//void forjba(uint32_t* a, uint32_t b[i], uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t j);
.text
.global forjba
.func forjba, forjba
.type forjba, %function

forjba:
	push {r4-r12, r14}      @r12:S, r14:C
	ldr r4, [sp, #40]
	ldr r5, [sp, #44]
	ldr r6, [sp, #48]
	mov r6, #1

	////////////
	//ldr r12, [r2]			@r12:S
	//ldr r14, [r2, #4]       @r14:C
	////////////
	ldr r8, [r2, #4]
	forjloopba:
		@bl inner
/////////////////
		//ldr r7, [r2, #4] @r7 = C
		lsl r6, r6, #2	@shift r6:j to time it by 4
		ldr r11, [r0, r6]	@r0:a[j]
		umull r10, r7, r11, r1 @r10=sum[0], r8=sum[1]
		ldr r9, [r3, r6]
		adds r9, r9, r8 @r9:t[j], r8=C
		mov r8, #0 @r7 = internal carry
		movcs r8, #1
		adds r10, r10, r9 @r10 = sum[0] ,which is S now
		addcs r8, r8, #1
		add r7, r7, r8 @r8 = sum[1], which is C now
		str r10, [r2]
		//str r7, [r2, #4]
		adds r6, r6, #4	@ j+1
		mov r10, r6
		ldr r9, [r3, r6]
	mul3a_forjba:
		//cmp r7, #0
		//beq endmul3a_forjba
		//ldr r8, [r3, r6] @r7:res[j+1], r3->t, r6:j+1
		bcc endmul3a_forjba
		adcs r9, r9, r7  @r9: new res[j+1], added with internal r8 from last loop
		//mov r7, #0	@r8: internal carry set to 0
		//movcs r7, #1 	@ if res[j+1] + C gives another carry to res[j+2]
		//str r9, [r3, r6]@@@@@@@@@@@@@@@@@@@
		add r6, r6, #4
		b mul3a_forjba
	endmul3a_forjba:
		str r9, [r3, r6]
		@nj
		sub r11, r10, #4
		ldr r9, [r5, r11] @r9:nj
		umull r7, r8, r4, r9
		@load sum[0]
		ldr r11, [r2]
		adds r11, r11, r7
		str r11, [r2]
		adc r8, r8, #0
		//str r8, [r2, #4]
		@j-1
		sub r9, r10, #8
		str r11, [r3, r9]
		@j+1/4
		lsr r10, r10, #2
		@cmp and loop
		cmp r10, #32
		beq endloopba
		mov r6, r10
		b forjloopba
/////////////////////////
	endloopba:
		str r8, [r2, #4]
		//byteadd(res, sum, sum[1]);
		mov r9, #32
    	lsl r9, r9, #2
    	@t[size]
    	ldr r10, [r3, r9]
    	@calculate sum[0]:S

    	ldr r11, [r2, #4]

    	adds r10, r10, r11

   	 	str r10, [r2]

    	mov r11, #0
    	movcs r11, #1

    	str r11, [r2, #4]

    	str r12, [r2]
    	str r14, [r2, #4]

    	//res[size-1]...
    	sub r7, r9, #4
    	str r10, [r3, r7]
    	add r7, r9, #4
    	ldr r8, [r3, r7]
    	add r8, r8, r11
    	str r8, [r3, r9]
    	mov r8, #0
    	str r8, [r3, r7]

		pop {r4-r12, r14}
		bx lr
.endfunc
























//fori
//void fori(*a, *b, *sum, *res, *m, *n, i, np0);
.text
.global fori
.func fori, fori
.type fori, %function

fori:
	//mua_32mul
	push {r4-r12, r14}
	ldr r10, [r0]					@a0
	ldr r4, [sp, #40]				@m
	ldr r5, [sp, #44]				@n
	ldr r6, [sp, #48]				@i
	ldr r7, [sp, #52]				@np0
	lsl r6, r6, #2					@i in bytes


	foriloop:
	ldr r11, [r1, r6]				@bi
	umull r8, r9, r10, r11
	ldr r10, [r3]
	adds r10, r10, r8
	str r10, [r2]					@r10: sum[0]:S
	adc r9, r9, #0
	str r9, [r2, #4]				@r9: sum[1]:C

	//r8 r11 are free, r6, r9, r10 are occupied
	//_AddAssembly(r3, r12, r9)
	//r12 occupied
	mov r12, #1
	lsl r12, r12, #2
	loop3:
		cmp r9, #0
		beq endloop3
		ldr r8, [r3, r12]
		adds r11, r8, r9
		//r8 r9free, r11 occupied
		mov r9, #0
		movcs r9, #1
		str r11, [r3, r12]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		add r12, r12, #4
		b loop3
	endloop3:
		//r10:S, r7:np0, r2->sum
		umull r8, r9, r10, r7
		str r8, [r2]
		str r9, [r2, #4]

		//m = sum[0]
		ldr r4, [r2]

		//muladd
		@n0
		ldr r7, [r5]
		umull r8, r9, r4, r7
		adds r10, r10, r8				@r10 jumps to zero
		str r10, [r2]
		adc r9, r9, #0
		str r9, [r2, #4]
										@r4 is m
		//forjba
		@r4 is m
		@don't change r4!!!
		@r9 was b(pointer) in iloop
		@and it should be changed to b[i] in jloop
		//ldr r9, [r1, r6]

		@use r6 for both i and j, to separate them, make j local
		@pass i, j in the form of pointer
		//lsr r6, r6, #2			@r6 is in byte!!!
		mov r14, r6			@r14 saves i(bytes)
		mov r6, #4			@give j = 1


	forjiloopba:
		@bl inner
		/////////////////////
		ldr r7, [r2, #4] @r7 = C
		//lsl r6, r6, #2	@shift r6:j to time it by 4
		ldr r11, [r0, r6]	@r0:a[j]
		ldr r9, [r1, r14]
		umull r10, r8, r11, r9 @r10=sum[0], r8=sum[1]
		ldr r9, [r3, r6]
		adds r9, r9, r7 @r9:t[j], r7=C
		mov r7, #0 @r7 = internal carry
		movcs r7, #1
		adds r10, r10, r9 @r10 = sum[0] ,which is S now
		addcs r7, r7, #1
		add r8, r8, r7 @r8 = sum[1], which is C now
		str r10, [r2]
		str r8, [r2, #4]
		add r6, r6, #4	@ j+1
		mov r10, r6
	mul3a_forjiba:
		cmp r8, #0
		beq endmul3a_forjiba
		ldr r7, [r3, r6] @r7:res[j+1], r3->res, r6:j+1
		adds r9, r7, r8 @r9: new res[j+1], added with internal r8 from last loop
		mov r8, #0	@r8: internal carry set to 0
		movcs r8, #1 	@ if t[j+1] + C gives another carry to t[j+2]
		str r9, [r3, r6]
		add r6, r6, #4
		b mul3a_forjiba
	endmul3a_forjiba:
		@nj
		sub r11, r10, #4
		ldr r9, [r5, r11] @r9:nj
		umull r7, r8, r4, r9
		@load sum[0]
		ldr r11, [r2]
		adds r11, r11, r7
		str r11, [r2]
		adc r8, r8, #0
		str r8, [r2, #4]
		@j-1
		sub r8, r10, #8
		str r11, [r3, r8]  @@@@@@@@@@@@@@@
		@j+1/4
		//lsr r10, r10, #2
		@cmp and loop
		cmp r10, #128
		beq endjiloopba
		mov r6, r10
		b forjiloopba
		///////////////////////
	endjiloopba:
		//byteadd(res, sum, sum[1]);
		mov r9, #128
    	//lsl r9, r9, #2
    	@res[size]
    	ldr r10, [r3, r9]
    	@calculate sum[0]:S
    	ldr r11, [r2, #4]
    	adds r10, r10, r11
   	 	str r10, [r2]
    	mov r11, #0
    	movcs r11, #1
    	str r11, [r2, #4]
    	//res[size-1]...
    	sub r12, r9, #4
    	str r10, [r3, r12]
    	add r12, r9, #4
    	ldr r8, [r3, r12]
    	add r8, r8, r11
    	str r8, [r3, r9]
    	mov r8, #0
    	str r8, [r3, r12]

		mov r6, r14
		cmp r6, #128
		beq endiloop
		add r6, r6, #4
		b foriloop
	endiloop:
		pop {r4-r12, r14}
		bx lr
.endfunc



