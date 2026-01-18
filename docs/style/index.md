# スタイル概要

[目次に戻る](../index.md) | [前へ: ジオメトリ](../geometry.md) | [次へ: シェイプのスタイル](./shape.md)

---

スタイルは `mxCell` の `style` 属性で指定し、セルの外観や動作を定義します。

## スタイルの書式

スタイルは `キー=値` のペアをセミコロン (`;`) で区切った文字列です：

```
キー1=値1;キー2=値2;キー3=値3;
```

### 例

```xml
<mxCell style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" .../>
```

この例では：
- `rounded=1` - 角を丸くする
- `whiteSpace=wrap` - テキストを折り返す
- `html=1` - HTML ラベルを有効化
- `fillColor=#dae8fc` - 塗りつぶし色
- `strokeColor=#6c8ebf` - 枠線の色

## 値の指定方法

### 数値

```
strokeWidth=2;opacity=50;fontSize=14;
```

### 真偽値

`1` が真（有効）、`0` が偽（無効）：

```
rounded=1;shadow=0;dashed=1;
```

### 色

16 進数カラーコード（`#` 付き）または `none`：

```
fillColor=#ff0000;strokeColor=#000000;fontColor=#333333;
fillColor=none;   /* 透明 */
```

### 文字列

```
shape=ellipse;fontFamily=Arial;align=center;
```

## スタイルのカテゴリ

### [シェイプ（図形）のスタイル](./shape.md)

- 形状の種類（`shape`）
- 塗りつぶし・枠線
- 角丸・影・グラデーション
- サイズ・回転の制御

### [コネクタ（線）のスタイル](./edge.md)

- 経路スタイル（直線・直交・曲線）
- 矢印の種類とサイズ
- 接続点の指定
- 破線・ジャンプ

### [テキストのスタイル](./text.md)

- フォント設定
- 配置（水平・垂直）
- パディング
- HTML ラベル

## よく使うスタイルの組み合わせ

### 標準的な四角形

```
rounded=0;whiteSpace=wrap;html=1;
```

### 角丸の四角形

```
rounded=1;whiteSpace=wrap;html=1;
```

### 楕円

```
ellipse;whiteSpace=wrap;html=1;
```

### ひし形（判断）

```
rhombus;whiteSpace=wrap;html=1;
```

### 直線コネクタ

```
endArrow=classic;html=1;
```

### 直交コネクタ

```
edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=classic;
```

### テキストのみ

```
text;html=1;align=center;verticalAlign=middle;
```

## スタイルの確認方法

draw.io でスタイルを確認・編集するには：

1. シェイプを選択
2. 右クリック → **スタイルを編集** または
3. メニュー → **書式** → **スタイルを編集**

これにより、現在のスタイル文字列を確認・編集できます。

## スタイルの継承

draw.io には CSS のようなスタイル継承はありませんが、デフォルト値があります：

| スタイル | デフォルト値 |
|----------|--------------|
| `fillColor` | `#ffffff`（白） |
| `strokeColor` | `#000000`（黒） |
| `strokeWidth` | `1` |
| `fontSize` | `12` |
| `fontColor` | `#000000`（黒） |
| `align` | `center` |
| `verticalAlign` | `middle` |

明示的に指定しない場合、これらのデフォルト値が使用されます。

## 特殊なスタイル値

### none

塗りつぶしや枠線を無効にします：

```
fillColor=none;    /* 透明な背景 */
strokeColor=none;  /* 枠線なし */
```

### デフォルトへリセット

スタイルキーを省略すると、デフォルト値にリセットされます。

---

[目次に戻る](../index.md) | [前へ: ジオメトリ](../geometry.md) | [次へ: シェイプのスタイル](./shape.md)
