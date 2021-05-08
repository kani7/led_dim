* X680x0のキーボードLEDの輝度を変更する
*   by kani7
*   GPL2.0
*   2021-05-09 多分動く版

	.include	DOSCALL.MAC
	.include	IOCSCALL.MAC

*IOCS_STAT	equ $0000_0a0e		* 実行中のIOCSコール番号を示すワーク(-1で何も実行していない)
MFP_TSR		equ $00e8_802d		* MFPのTSR(送信状態レジスタ)
*MFP_TSR_BE	equ 7			* MFPのTSRのBEフラグの位置(bit7)
MFP_UDR		equ $00e8_802f		* MFPのUDR(送信データレジスタ)
*BRIGHT_CMD	equ %0101_0100		* キーボードLED輝度変更コマンド

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
	or.b	#%01010100,D1		* LED輝度設定コマンド(上位6ビット)+設定値(下位2ビット)

mfp_wait:
	lea.l	MFP_TSR,A1		* MFPのTSRの
	IOCS	_B_BPEEK		*
	btst.l	#7,D0			*	BEフラグ(bit7)を確認する
	beq	mfp_wait		* 送信バッファが空でなければループして待つ
	lea.l	MFP_UDR,A1		* MFPのUDRに
	IOCS	_B_BPOKE		*	LED輝度制御コマンド(D1)を書き込む

	move.l	#$7f,D1			* 0x7fでLED全点灯
	IOCS	_LEDCTRL

	DOS	_GETTIM2		* 1秒+α待つための1ループ目
wait2sec1:
	DOS	_GETTIM2
	move.l	(SP)+,D1
	move.l	(SP),D0
	cmp.l	D0,D1
	bne	wait2sec1
	add.l	#4,SP

	DOS	_GETTIM2		* 1秒+α待つための2ループ目
wait2sec2:
	DOS	_GETTIM2
	move.l	(SP)+,D1
	move.l	(SP),D0
	cmp.l	D0,D1
	bne	wait2sec2
	add.l	#4,SP

	IOCS	_LEDSET			* LEDの点灯箇所を元に戻す
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
