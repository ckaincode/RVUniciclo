.data

.text

	li a0,0xFE
	xori a1,a0,0x00
	jalr a2,x0,20
	
	add a0,a1,a1
	li a7,8
	addi s5,s5,1
	srl s1,a7,s5
	li a6,4
	bne a6,x0,end
	
end:
	nop
	