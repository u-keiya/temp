# テキストのスタイル

[目次に戻る](../index.md) | [前へ: コネクタのスタイル](./edge.md) | [次へ: 画像の埋め込み](../advanced/images.md)

---

テキストラベルの外観と配置を定義するスタイル属性について解説します。

## フォント設定

### fontColor

文字色：

```
fontColor=#333333;   /* 濃いグレー */
fontColor=#ffffff;   /* 白 */
fontColor=#0000ff;   /* 青 */
```

### fontSize

文字サイズ（ポイント）：

```
fontSize=12;   /* 標準 */
fontSize=14;   /* やや大きい */
fontSize=18;   /* 大きい */
fontSize=24;   /* 見出し */
```

### fontFamily

フォント名：

```
fontFamily=Helvetica;
fontFamily=Arial;
fontFamily=Times New Roman;
fontFamily=Courier New;
fontFamily=メイリオ;
```

### fontStyle

太字・斜体・下線をビットマスクで指定：

| 値 | 説明 |
|----|------|
| `0` | 標準 |
| `1` | 太字 |
| `2` | 斜体 |
| `4` | 下線 |

組み合わせる場合は加算します：

```
fontStyle=1;   /* 太字 */
fontStyle=2;   /* 斜体 */
fontStyle=3;   /* 太字 + 斜体 (1+2) */
fontStyle=5;   /* 太字 + 下線 (1+4) */
fontStyle=7;   /* 太字 + 斜体 + 下線 (1+2+4) */
```

## テキスト配置

### align（水平方向）

| 値 | 説明 |
|----|------|
| `left` | 左揃え |
| `center` | 中央揃え（デフォルト） |
| `right` | 右揃え |

```
align=left;
align=center;
align=right;
```

### verticalAlign（垂直方向）

| 値 | 説明 |
|----|------|
| `top` | 上揃え |
| `middle` | 中央揃え（デフォルト） |
| `bottom` | 下揃え |

```
verticalAlign=top;
verticalAlign=middle;
verticalAlign=bottom;
```

### 配置の組み合わせ例

```
align=left;verticalAlign=top;      /* 左上 */
align=center;verticalAlign=middle; /* 中央 */
align=right;verticalAlign=bottom;  /* 右下 */
```

## テキストの折り返し

### whiteSpace

| 値 | 説明 |
|----|------|
| `wrap` | シェイプ幅で折り返す |
| （未指定） | 折り返さない |

```
whiteSpace=wrap;
```

### overflow

テキストがシェイプからはみ出した場合の動作：

| 値 | 説明 |
|----|------|
| `visible` | はみ出して表示 |
| `hidden` | 切り取る |
| `fill` | シェイプを拡大して収める |
| `width` | 幅に合わせて折り返し |

```
overflow=hidden;
```

### labelWidth

テキストの折り返し幅を固定（シェイプ幅と別に指定）：

```
labelWidth=100;   /* 100px で折り返し */
```

## パディング（余白）

### spacing

全方向の余白：

```
spacing=10;   /* 全方向 10px */
```

### 個別の余白

```
spacingLeft=10;    /* 左 */
spacingRight=10;   /* 右 */
spacingTop=5;      /* 上 */
spacingBottom=5;   /* 下 */
```

## ラベル位置

### labelPosition / verticalLabelPosition

ラベルをシェイプの外側に配置する場合に使用：

| labelPosition | 説明 |
|---------------|------|
| `left` | シェイプの左側 |
| `center` | シェイプ上（デフォルト） |
| `right` | シェイプの右側 |

| verticalLabelPosition | 説明 |
|-----------------------|------|
| `top` | シェイプの上側 |
| `middle` | シェイプ上（デフォルト） |
| `bottom` | シェイプの下側 |

### 例：アイコンの下にラベル

```
verticalLabelPosition=bottom;verticalAlign=top;
```

この設定では、ラベルがシェイプの下に配置され、上揃えで表示されます。

### 例：シェイプの右側にラベル

```
labelPosition=right;align=left;
```

## 不透明度

### textOpacity

テキストのみの不透明度（0〜100）：

```
textOpacity=50;   /* 半透明 */
```

## ラベル非表示

### noLabel

ラベルを非表示にする：

```
noLabel=1;
```

## HTML ラベル

### html

HTML としてラベルを解釈：

```
html=1;
```

HTML ラベルを有効にすると、`value` 属性内で HTML タグを使用できます。

### HTML タグの例

XML 内では `<` や `>` をエスケープする必要があります：

| 実際の HTML | XML での記述 |
|------------|--------------|
| `<b>` | `&lt;b&gt;` |
| `<br>` | `&lt;br&gt;` |
| `<font>` | `&lt;font&gt;` |

### よく使う HTML タグ

```xml
<!-- 改行 -->
value="1行目&lt;br&gt;2行目"

<!-- 太字 -->
value="&lt;b&gt;重要&lt;/b&gt;"

<!-- 斜体 -->
value="&lt;i&gt;補足&lt;/i&gt;"

<!-- 下線 -->
value="&lt;u&gt;強調&lt;/u&gt;"

<!-- 色付きテキスト -->
value="&lt;font color=&quot;#ff0000&quot;&gt;赤文字&lt;/font&gt;"

<!-- サイズ変更 -->
value="&lt;font style=&quot;font-size:18px&quot;&gt;大きい文字&lt;/font&gt;"

<!-- 組み合わせ -->
value="&lt;b&gt;タイトル&lt;/b&gt;&lt;br&gt;説明文"
```

## テキスト専用シェイプ

### text シェイプ

テキストのみを表示する場合：

```xml
<mxCell id="text1" value="注釈テキスト"
        style="text;html=1;align=center;verticalAlign=middle;
               fontSize=14;fontColor=#333333;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="200" height="30" as="geometry"/>
</mxCell>
```

`shape=text` または `text;` スタイルを使用すると、枠線や塗りつぶしのないテキストボックスになります。

## 完全な例

### 標準的なラベル付きシェイプ

```xml
<mxCell id="box1" value="処理名"
        style="rounded=0;whiteSpace=wrap;html=1;
               fontSize=12;fontColor=#333333;
               align=center;verticalAlign=middle;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="120" height="60" as="geometry"/>
</mxCell>
```

### 左揃え・上揃えのテキスト

```xml
<mxCell id="note1" value="メモ内容をここに記載します。長い文章も自動的に折り返されます。"
        style="rounded=0;whiteSpace=wrap;html=1;
               align=left;verticalAlign=top;
               spacingLeft=10;spacingTop=10;spacingRight=10;spacingBottom=10;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="200" width="200" height="100" as="geometry"/>
</mxCell>
```

### 太字タイトル付きシェイプ

```xml
<mxCell id="titled1"
        value="&lt;b&gt;タイトル&lt;/b&gt;&lt;br&gt;説明文がここに入ります"
        style="rounded=1;whiteSpace=wrap;html=1;
               fillColor=#dae8fc;strokeColor=#6c8ebf;
               align=center;verticalAlign=middle;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="350" width="150" height="80" as="geometry"/>
</mxCell>
```

### アイコン下にラベル

```xml
<mxCell id="icon1" value="サーバー"
        style="shape=image;image=...;
               verticalLabelPosition=bottom;verticalAlign=top;
               fontSize=11;fontColor=#333333;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="450" width="48" height="48" as="geometry"/>
</mxCell>
```

### 注釈テキスト

```xml
<mxCell id="annotation1" value="※ここに注釈を記載"
        style="text;html=1;align=left;verticalAlign=middle;
               fontSize=11;fontColor=#666666;fontStyle=2;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="550" width="200" height="20" as="geometry"/>
</mxCell>
```

---

[目次に戻る](../index.md) | [前へ: コネクタのスタイル](./edge.md) | [次へ: 画像の埋め込み](../advanced/images.md)
