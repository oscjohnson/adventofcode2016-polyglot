default rel ;

extern  _printf

global _main
section .bss
  	buffer: resb 180000
	test_string: resb 300
     matches_outside: resb 100
     matches_inside: resb 100
section .data
	null_string: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,00,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	path:   db  "./input.txt",0
	fmt: db `%c`,0
	fmt2: db `%s: %d\n`,0
	fmt3: db `%d, %d\n`,0
	file_descriptor: dq 0
	line: dq 0
	index_in_file: dq 0
	index_in_string: dq 0
	newline: db `\n`


    i:  dq  0 ; string i
    format:    db `%s: %d\n`, 0  ; The printf format
    valid_lines_counter: dq 0
    valid_ssl_lines_counter: dq 0
    inner_palindrome_counter: dq 0
    outer_palindrome_counter: dq 0
    inside: dq 0
    left_bracket: db `[`
    right_bracket: db `]`

    ; star 2
    fmt_short:    db `%s: %d\n`, 0  ; The printf format
    fmt_debug:    db `string: %s\nmatches outside: %s\nmatches inside: %s\n ssl: %d\n`, 0  ; The printf format
    current_string_length: dq 0
    matches_outside_length: dq 0
    matches_outside_index: dq 0
    matches_inside_length: dq 0
    matches_inside_index: dq 0

section .text
_main:
  call read_file_into_buffer


file_loop:
	mov r15, buffer
	add r15, [index_in_file]

  ; set string to zero
  mov rcx, 200
  mov rsi, null_string ; got to be a better way to do this
  mov rdi, test_string
  cld ; Clears the DF flag in the EFLAGS register. When the DF flag is set to 0, string operations increment the index registers (ESI and/or EDI).
  rep movsb
  ; move string
  mov rbx, buffer
  add rbx, [index_in_file]
  sub rbx, [index_in_string]
  ;
  mov rcx, [index_in_string]
  mov rsi, rbx
  mov rdi, test_string
  cld ; Clears the DF flag in the EFLAGS register. When the DF flag is set to 0, string operations increment the index registers (ESI and/or EDI).
  rep movsb

line_loop:

	mov al, [newline]
	cmp [r15], al
	jz end_of_line

; do stuff here
; do stuff here end

  cmp byte [r15], 0
	jz end_of_file
	inc qword [index_in_file]
	inc qword [index_in_string]
	jmp file_loop



end_of_line:


  ; ---- VALIDATOR
  push rbp
  mov rdi, test_string
  mov rsi, [index_in_string]

  call detector
  cmp qword rax, 1
  jnz skip_increase_ssl
  inc qword [valid_ssl_lines_counter]
skip_increase_ssl:
  mov r15, test_string
  mov r14, index_in_string
  call is_valid_tls
  pop rbp
  cmp qword rax, 1
  jnz skip_increase
  inc qword [valid_lines_counter]
  ; ---- VALIDATOR END

skip_increase:

	; do clean up for this row
	push rbp  ; set up stack frame
	mov rdi, fmt2
  mov rsi, test_string
	mov rdx, rax
	;call _printf
	pop rbp   ; restore stack

	inc qword [index_in_file]
	mov qword [index_in_string], 0
	jmp file_loop

end_of_file:
	push rbp        ; set up stack frame
	mov rdi, fmt3
  mov rsi, [valid_lines_counter]
	mov rdx, [valid_ssl_lines_counter]
	call _printf

	pop rbp   ; restore stack
	mov rax, 0   ; normal, no error, return value
	ret


is_valid_tls:
  jmp loop
    ;
  ret

loop:
  mov rdi, r15
  call is_segment_palindrome
  call increase_counters

  inc qword [i]

  ; check to see if last char is '['
  mov dl, [r15+3]
  cmp byte [left_bracket], dl
  jz adjust_left
  mov dl, [r15+3]
  cmp byte [right_bracket], dl
  jz adjust_right


  mov r15, test_string
  add r15, [i]

  mov r13, [i]
  cmp qword r13, [r14]
  jz exit
  jg exit
  jmp loop

adjust_left:
  mov r15, test_string
  add qword [i], 3
  add r15, [i]
  mov qword [inside], 1
  jmp loop

adjust_right:
  mov r15, test_string
  add qword [i], 3
  add r15, [i]
  mov qword [inside], 0
  jmp loop

; is_palindrome subroutine
; checks if four first chars in rdi register is a palindrome
; also checks that string is not of type 'aaaa' as this is considered a false palindrome
; returns result in rax register
is_segment_palindrome:
  mov dl, [rdi]
  mov cl, [rdi+1]
  mov r8b, [rdi+2]
  mov r9b, [rdi+3]
  mov dl, [rdi]
  cmp byte dl, cl
  jz not_palindrome
  cmp byte dl, r9b
  jnz not_palindrome
  cmp byte cl, r8b
  jnz not_palindrome

  mov qword rax, 1
  ret

not_palindrome:
  mov qword rax, 0
  ret

; is valid subroutine
; Requires that the inner counter > 0 and the outer counter == 0
validate:
  cmp qword [inner_palindrome_counter], 0
  jnz not_valid
  cmp qword [outer_palindrome_counter], 0
  jg valid

not_valid:
  mov rax, 0
  ret

valid:
  mov rax, 1
  ret

; increase counters subroutine
increase_counters:
  cmp qword rax, 0
  jng increase_counters_exit
  cmp qword [inside], 1
  jz increase_inner

increase_outer:
  inc qword [outer_palindrome_counter]
  ret

increase_inner:
  inc qword [inner_palindrome_counter]
  ret

increase_counters_exit:
  ret

read_file_into_buffer:
;open
  mov rax, 0x2000005 ; 5 is the number for open, returns a file descriptor in `rax` register
  mov rdi, path
  mov rsi, 2 ; flags
  mov rdx, 0 ; file permisson
  syscall

;read
  mov qword [file_descriptor], rax
  mov rdi, [file_descriptor]
  mov rax, 0x2000003 ; 0 is the system_call for "read". System call enuomerations are passed in the rax register.
  mov rsi, buffer
  mov rdx, 180000
  syscall

ret

memset_zero:
 mov byte [rdi], 0
 inc rdi
 dec rsi
 jne memset_zero
 ret

detector_with_debug:

  call detector

  mov rdi, fmt_debug
  mov rsi, r13
  mov rdx, matches_outside
  mov rcx, matches_inside
  mov r8, rax
  push rbp
  call _printf
  pop rbp
  ret

detector_with_print:

  call detector

  mov rdi, fmt_short
  mov rsi, r13
  mov rdx, rax
  push rbp
  call _printf
  pop rbp
  ret


detector:
  ; initialization
  mov [current_string_length], rsi

  mov r13, rdi
  mov rdx, r13

  mov r14, 0 ; 'is inside' register, default value is: outside
  mov r8, 0 ; index for string

  mov qword [matches_outside_length], 0
  mov qword [matches_outside_index], 0
  mov qword [matches_inside_length], 0
  mov qword [matches_inside_index], 0

  mov rdi, matches_outside
  mov rsi, 100
  call memset_zero

  mov rdi, matches_inside
  mov rsi, 100
  call memset_zero

detector_loop:

  ; test string
  mov r15, r13
  add r15, r8

  mov cl, [r15]
  cmp byte [left_bracket], cl
  jz is_inside
  cmp byte [right_bracket], cl
  jz is_outside

  jmp after_outside_checks

is_inside:
  mov r14, 1
  jmp continue

is_outside:
  mov r14, 0
  jmp continue

after_outside_checks:

  mov rdi, r15
  call is_three_letter_palindrome
  cmp rax, 0
  jz continue

add:
  cmp r14, 1
  jz add_to_inside

add_to_outside:
  mov rcx, 3
  mov rsi, r15
  mov rdi, matches_outside
  add rdi, [matches_outside_length]
  rep movsb
  add qword [matches_outside_length], 3
  jmp continue

add_to_inside:
  mov rcx, 3
  mov rsi, r15
  mov rdi, matches_inside
  add rdi, [matches_inside_length]
  rep movsb
  add qword [matches_inside_length], 3


continue:
  ; loop logic increase
  inc qword r8
  mov rdx, r13
  add rdx, r8
  mov r10, r8
  cmp qword r10, [current_string_length]
  jz detector_exit
  jmp detector_loop

detector_exit:
  call has_ssl_support
  ret

; *******************
; is_inverse_match
; parameters
; rdi: 'aba'
; rsi: 'bab'
; return rax: 0 for not inverse or 1 if inverse
; *******************
is_inverse_match:
  mov r10b, [rdi]
  mov r11b, [rsi+1]
  cmp byte r10b, r11b ; a[0] == b[1]
  jnz has_no_inverse_match
  mov r10b, [rdi+1]
  mov r11b, [rsi]
  cmp byte r10b, r11b ; a[1] == b[0]
  jnz has_no_inverse_match
  mov r10b, [rdi+2]
  mov r11b, [rsi+1]
  cmp byte r10b, r11b ; a[2] == b[1]
  jnz has_no_inverse_match

  ; has match
  mov rax, 1
  ret

has_no_inverse_match:
  mov rax, 0
  ret

; ***************
; is_three_letter_palindrome
; ***************
is_three_letter_palindrome:
  mov r10b, [rdi]
  mov r11b, [rdi+1]
  mov r12b, [rdi+2]
  cmp byte r12b, r10b
  jnz not_three_letter_palindrome
  cmp byte r10b, r11b
  jz not_three_letter_palindrome
  cmp byte [left_bracket], r11b
  jz not_three_letter_palindrome
  cmp byte [right_bracket], r11b
  jz not_three_letter_palindrome

  mov rax, 1
  ret

not_three_letter_palindrome:
  mov rax, 0
  ret

; ***************
; has_ssl_support
; ***************
has_ssl_support:
  mov rax, 0
  cmp qword [matches_inside_length], 0
  jz ssl_exit
  cmp qword [matches_outside_length], 0
  jz ssl_exit

ssl_outer_loop:
  mov qword [matches_inside_index], 0
ssl_inner_loop:
  mov r10, matches_inside
  add qword r10, [matches_inside_index]
  mov r15, matches_outside
  add qword r15, [matches_outside_index]

  mov rdi, r10
  mov rsi, r15
  call is_inverse_match
  cmp qword rax, 1
  jnz ssl_increase_loop_counters
  mov rax, 1
  ret

ssl_increase_loop_counters:
  ; looping logic inner
  add qword [matches_inside_index], 3
  mov rdx, [matches_inside_index]
  cmp qword rdx, [matches_inside_length]
  jnz ssl_inner_loop

  ; looping logic outer
  add qword [matches_outside_index], 3
  mov rdx,  [matches_outside_index]
  cmp qword rdx, [matches_outside_length]
  jnz ssl_outer_loop

ssl_exit:
  ret


exit:
  call validate

  ;cleanup
  mov qword [inner_palindrome_counter], 0
  mov qword [outer_palindrome_counter], 0
  mov qword [inside], 0
  mov qword [i], 0
  ret










