global _start

section .text
_start:
    mov rax, 7          ; operand1
    mov rbx, 3          ; operand2

    cmp rax, rbx
    je equal
    jg greater
    jl less

greater:
    mov rdi, 1
    jmp exit_program

equal:
    mov rdi, 0
    jmp exit_program

less:
    mov rdi, -1

exit_program:
    mov rax, 60
    syscall
