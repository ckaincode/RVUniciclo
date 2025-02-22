.data

.text

	li a0,5
	li a1,0
	li a2,1
	li a3,0x2000
	jal jaj
	
jaj:
	beq a0,x0,end
	addi a0,a0,-1
	add a1,a1,a2
	jal jaj
	
end:
	sw a1,0(a3)