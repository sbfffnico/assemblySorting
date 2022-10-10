; Nico Edrich
; Sorting Integers assignment

%include "/usr/local/share/csc314/asm_io.inc"


segment .data

	array		dd		0,0,0,0,0,0,0,0,0,0
	space		db		" ",0
	asc			db		"Ascending:  ",10,0
	des			db		"Descending: ",10,0

segment .bss


segment .text
	global  asm_main

asm_main:
	push	ebp
	mov		ebp, esp
	; ********** CODE STARTS HERE **********

	mov		ebx, 0

	user_input:
	call	read_int
	mov		DWORD [array + ebx * 4], eax
	inc 	ebx
	cmp		ebx, 10
	jge		sort_setup
	jmp		user_input

	swap:
	mov		edi, DWORD [array + ecx * 4]		; was unable to swap dwords directly
	mov		esi, DWORD [array + edx * 4]		; had to use two registers vs expected one
	mov		DWORD [array + ecx * 4], esi
	mov		DWORD [array + edx * 4], edi
	jmp		return_from_swap

	sort_setup:
	mov		ebx, 0		; initializing a variable for start of loop
	sort_start:
	cmp		ebx, 9		; will jump out of sorting loop when counter reached
	jge		reset_counters
	mov		ecx, 0		; setting ecx to 0 and edx to the "+1" for index checking
	mov		edx, 1
		sort_inner_loop:
		mov		edi, DWORD [array + ecx * 4] ; was unable to compare without first
		mov		esi, DWORD [array + edx * 4] ; being in a register
		cmp		edi, esi
		jg		swap						 
		return_from_swap:
		; increments and then tests if inner loop has completed
		inc		ecx							 
		inc		edx
		mov		eax, 9
		sub		eax, ebx
		cmp		ecx, eax
		jge		inc_first_loop
		jmp		sort_inner_loop
	inc_first_loop:
	; increments counter and jumps back to first loop
	inc		ebx
	jmp		sort_start

	reset_counters:
	; resets counters for use in printing
	mov		ebx, 0
	mov		ecx, 0
	
	print_ascending:
	cmp 	ecx, 0
	je		ascending_header
	mov		eax, DWORD [array + ebx * 4]
	call	print_int
	mov		eax, space
	call	print_string
	inc		ebx
	cmp		ebx, 10
	jl		print_ascending

	call	print_nl
	mov		ebx, 9
	mov		ecx, 0

	print_descending:
	cmp 	ecx, 0
	je		descending_header
	mov		eax, DWORD [array + ebx * 4]
	call 	print_int
	mov		eax, space
	call	print_string
	dec		ebx
	cmp		ebx, 0
	jl		end
	jmp		print_descending

	ascending_header:
	; extra function used for formatting / styling of data output
	mov		eax, asc
	call	print_string
	inc		ecx
	jmp		print_ascending

	descending_header:
	; extra function used for formatting / styling of data output
	mov		eax, des
	call	print_string
	inc		ecx
	jmp 	print_descending

	end:
	call	print_nl
	; *********** CODE ENDS HERE ***********
	mov		eax, 0
	mov		esp, ebp
	pop		ebp
	ret
