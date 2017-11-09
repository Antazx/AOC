	.data

A: .word 0x20, 0x40, 0x10, 0x01, 0x03, 0x22, 0x08

	.text
	.globl __main
	
__main:
	
	
	j Exit
	

Exit:
	li $v0, 10
	syscall
	
	
	
	
	
