# X680x0のキーボードLEDの輝度を変更する

## 概要
X680x0のキーボードLEDの輝度をコマンドラインから変更します。

## 使い方
引数に0～3の数値を与えて実行します。
引数を与えない場合はヘルプメッセージが表示されます。
- 最大輝度  
	```
	led_dim 0
	```  
- 最小輝度  
	```
	led_dim 3
	```  

## 補足
Compact系以外のX680x0のキーボードは、キーボードコントローラに電源が入った時に何のキーを押していた/押していなかったかによって、キーボードLEDの輝度を変更することができます。
| 押すキー | LED輝度 |
|---|---|
| 何も押さない | 明るい |
| XF3 | 少し明るい |
| XF4 | 少し暗い |
| XF5 | 暗い |

キーボードコントローラに電源が入るタイミングですが、以下のようになります。
- Compact系以外の機種ではキーボードケーブルを本体に接続した時
- Compact系の機種は本体の電源が入った時

ですが、X68030 CompactではPOST途中でXF3～XF5の状態を読み取りシステムの速度を決定しているため、Compact用のキーボードでは上記の方法は使えないと思われます(要検証)。

さて、キーボードLEDの点灯状態や輝度の変更はX680x0本体からも行うことができます。  
このプログラムはこれを実現するためのものです。

## ビルド方法
XC2.1を使っていますが、準拠するアセンブラ/リンカなら問題ありません。
```
as led_dim.s
lk led_dim.o
```
で実行ファイルが得られる筈です。

.r 形式の実行ファイルが必要なら、上記に続けて
```
cv led_dim.x
```
としてください。

## 謝辞
作成にあたって以下の書籍を参照しました。  
- Inside X68000  (ISBN4-89052-304-9)  
これ以前にも同様の情報を記した書籍は有ったようなのですが、それら情報への手がかりを網羅した本は少なく、著者の方々と、これを手にする幸運に恵まれたことを感謝します。

作成にあたって主に以下のツールを使用させていただきました。  
関係する皆様には深く感謝申し上げます。

- 無償公開されたシャープのソフトウェア  
	http://retropc.net/x68000/software/sharp/
- XM6g  
	http://retropc.net/pi/xm6/
- Ghidra  
	https://ghidra-sre.org/



# X680x0 keyboard LED dimmer

## Usage
Specify LED dimming knob from 0 (brighter) to 3 (darker).
- maximum brightness  
	```
	led_dim 0
	```  
- minimum brightness  
	```
	led_dim 3
	``` 

## Note
May not work on Keyboard for X680x0 'Compact' models.

## Build
Use XC2.1 or equivalent.

## Special Thanks
- Inside X68000  
  ISBN4-89052-304-9
- SHARP X680x0 software released free of charge  
	http://retropc.net/x68000/software/sharp/
- XM6g  
	http://retropc.net/pi/xm6/
- Ghidra  
	https://ghidra-sre.org/
