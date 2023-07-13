			DEVICE  ZXSPECTRUM48
			org 	25000
NULL			equ	0
MemoryBuffer		equ	$9000
Start			ei
			ld	a, 2
			call	5633
			ld	hl, Text
Start1			ld	a, (hl)
			or	a
			jr	z, Start2
			push	hl
			ld	hl, LinkedList	;	
			call	LL_AddNode		
			ld	a, $0d
			rst	16
			ld	hl, LinkedList
			call	LL_Print
			pop	hl
			inc	hl
			jr	Start1
Start2			ld	a, $0d
			rst	16
			ld	hl, LinkedList
			call	LL_Print
			ret 
LL_Print		ld	e, (hl)
			inc	hl
			ld	d, (hl)
			ex	de, hl
LL_Print1		ld	a, h
			or	l
			ret	z	; return if hl = NULL
			ld	e, (hl)
			inc	hl
			ld	d, (hl)
			inc	hl
			ld	a, (hl)
			rst	16
			ex	de, hl
			jr	LL_Print1	
LL_DelNode		ld	(LL_DelNode4 + 1), a
			ld	e, (hl)
			inc	hl
			ld	d, (hl)
			ex	de, hl
			ld	(AdrOfNode), hl	; Save the AdrOfNode of the current node in the AdrOfNode variable
LL_DelNode1		ld	a, h
			or	l
			ret	z	; return if hl = NULL		
LL_DelNode3		inc	hl
			inc	hl
LL_DelNode4		ld	a, 0
			cp	(hl)
			jr	nz, LL_DelNode5	; if the current node does not contain the searched value, we go further  
			ld	(hl), 0
			dec	hl
			ld	d, (hl)
			ld	(hl), 0
			dec	hl
			ld	e, (hl)
			ld	(hl), 0
			ld	hl, (AdrOfNode)
			ld	(hl), e
			inc	hl
			ld	(hl), d
			ret
LL_DelNode5		dec	hl
			ld	d, (hl)
			dec	hl
			ld	e, (hl)
			ld	(AdrOfNode), hl ; Save the adress of the current node in the AdrOfNode variable
			ex	de, hl
			jr	LL_DelNode1		
LL_SearchLastNode	ld	e, (hl)
			inc	hl
			ld	d, (hl)
			ex	de, hl
LL_SearchLastNode1	ld	a, h
			or	l
			ret	z	; de - Last node of the Linked List
			ld	e, (hl)
			inc	hl
			ld	d, (hl)
			ex	de, hl
			jr	LL_SearchLastNode1
LL_AddNode		ld	(LL_AddNode3 + 1), a
			ld	ix, MemoryBuffer
LL_AddNode1		ld	a, (ix + 0)
			or	(ix + 1)
			or	(ix + 2)
			jr	z, LL_AddNode2	; if you can find a free memory location
			inc	ix
			jr	LL_AddNode1
LL_AddNode2		call	LL_SearchLastNode  ; find the last element of the linked list . de - last
			ex	de, hl		; hl - The pointer to the last Node of the linked list
LL_AddNode3		ld	a, 0
			push	ix
			pop	de
			ld	(hl), d
			dec	hl
			ld	(hl), e
			ex	de, hl
			ld	(hl), 0
			inc	hl
			ld	(hl), 0
			inc	hl
			ld	(hl), a
			ret
Text 			defb	"Hello World", 0
AdrOfNode		defw	0	
LinkedList		defw	NULL  ; address of the initial element of the linked list in memory
			SAVESNA "linkedlist.sna", Start
