	.data

Sim:	.float -0.75
Dob:	.double 0.75
	.globl __start
	.text

__start:
	la $t0, Sim
	lb $a0, 3($t0)
	

	li $v0, 1
	syscall
	
	la $t1, Dob
	lb $a0, 7($t1)
	.
	
	
	
	
	

	
	li $v0, 10

	syscall
