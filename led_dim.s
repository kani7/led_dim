* X680x0�̃L�[�{�[�hLED�̋P�x��ύX����
*   by kani7
*   GPL2.0
*   2021-05-09 ����������

	.include	DOSCALL.MAC
	.include	IOCSCALL.MAC

*IOCS_STAT	equ $0000_0a0e		* ���s����IOCS�R�[���ԍ����������[�N(-1�ŉ������s���Ă��Ȃ�)
MFP_TSR		equ $00e8_802d		* MFP��TSR(���M��ԃ��W�X�^)
*MFP_TSR_BE	equ 7			* MFP��TSR��BE�t���O�̈ʒu(bit7)
MFP_UDR		equ $00e8_802f		* MFP��UDR(���M�f�[�^���W�X�^)
*BRIGHT_CMD	equ %0101_0100		* �L�[�{�[�hLED�P�x�ύX�R�}���h

_LEDCTRL	equ $06
_LEDSET		equ $07

	.text

start:
	lea.l	user_stack(PC),SP

	tst.b	(A2)+
	beq	help
	move.b	(A2)+,D0
	cmp.b	#'0',D0
	bcs	help
	cmp.b	#'4',D0
	bcc	help

check_option:
	cmp.b	#' ',(A2)+
	beq	check_option

	tst.b	-(A2)
	bne	help

	sub.b	#'0',D0
	move.l	#3,D1
	sub.b	D0,D1
	or.b	#%01010100,D1		* LED�P�x�ݒ�R�}���h(���6�r�b�g)+�ݒ�l(����2�r�b�g)

mfp_wait:
	lea.l	MFP_TSR,A1		* MFP��TSR��
	IOCS	_B_BPEEK		*
	btst.l	#7,D0			*	BE�t���O(bit7)���m�F����
	beq	mfp_wait		* ���M�o�b�t�@����łȂ���΃��[�v���đ҂�
	lea.l	MFP_UDR,A1		* MFP��UDR��
	IOCS	_B_BPOKE		*	LED�P�x����R�}���h(D1)����������

	move.l	#$7f,D1			* 0x7f��LED�S�_��
	IOCS	_LEDCTRL

	DOS	_GETTIM2		* 1�b+���҂��߂�1���[�v��
wait2sec1:
	DOS	_GETTIM2
	move.l	(SP)+,D1
	move.l	(SP),D0
	cmp.l	D0,D1
	bne	wait2sec1
	add.l	#4,SP

	DOS	_GETTIM2		* 1�b+���҂��߂�2���[�v��
wait2sec2:
	DOS	_GETTIM2
	move.l	(SP)+,D1
	move.l	(SP),D0
	cmp.l	D0,D1
	bne	wait2sec2
	add.l	#4,SP

	IOCS	_LEDSET			* LED�̓_���ӏ������ɖ߂�
	DOS	_EXIT

help:
	pea.l	help_msg(PC)
	DOS	_PRINT
	add.l	#4,SP
	DOS	_EXIT


	.data
help_msg:
	dc.b	'Usage: led_dim [LED dimming]',$0d,$0a
	dc.b	'Function: Keyboard LED dimmer',$0d,$0a
	dc.b	$09,'Specify LED dimming knob from 0 (brighter) to 3 (darker)',$0d,$0a
	.even

	.stack
	ds.l	256
user_stack:

	.end	start
