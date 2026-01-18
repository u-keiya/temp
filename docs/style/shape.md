# シェイプのスタイル

[目次に戻る](../index.md) | [前へ: スタイル概要](./index.md) | [次へ: コネクタのスタイル](./edge.md)

---

シェイプ（頂点）の外観を定義するスタイル属性について解説します。

## 形状（shape）

`shape` キーで基本形状を指定します。省略時は四角形（`rectangle`）になります。

### 基本形状

| 値 | 説明 | 例 |
|----|------|-----|
| `rectangle` | 四角形（デフォルト） | `shape=rectangle;` |
| `ellipse` | 楕円・円 | `ellipse;` ※ |
| `rhombus` | ひし形 | `rhombus;` ※ |
| `triangle` | 三角形 | `triangle;` ※ |
| `hexagon` | 六角形 | `shape=hexagon;` |
| `parallelogram` | 平行四辺形 | `shape=parallelogram;` |
| `cylinder` | 円柱（データベース） | `shape=cylinder;` |
| `cloud` | 雲 | `shape=cloud;` |
| `document` | 書類 | `shape=document;` |
| `step` | ステップ | `shape=step;` |
| `callout` | 吹き出し | `shape=callout;` |

※ 一部の形状は `shape=` を省略して直接指定できます。

### 形状の例

```xml
<!-- 楕円 -->
<mxCell style="ellipse;whiteSpace=wrap;html=1;" vertex="1" parent="1" ...>

<!-- ひし形 -->
<mxCell style="rhombus;whiteSpace=wrap;html=1;" vertex="1" parent="1" ...>

<!-- 円柱 -->
<mxCell style="shape=cylinder;whiteSpace=wrap;html=1;" vertex="1" parent="1" ...>
```

### 方向指定（direction）

一部の形状は向きを変更できます：

| 値 | 説明 |
|----|------|
| `north` | 上向き（デフォルト） |
| `south` | 下向き |
| `east` | 右向き |
| `west` | 左向き |

```
shape=triangle;direction=south;
```

## 塗りつぶし

### fillColor

背景色を 16 進数で指定します：

```
fillColor=#dae8fc;   /* 薄い青 */
fillColor=#d5e8d4;   /* 薄い緑 */
fillColor=#ffe6cc;   /* 薄いオレンジ */
fillColor=#fff2cc;   /* 薄い黄色 */
fillColor=#f8cecc;   /* 薄い赤 */
fillColor=#e1d5e7;   /* 薄い紫 */
fillColor=none;      /* 透明 */
```

### gradientColor / gradientDirection

グラデーション塗りつぶし：

```
fillColor=#dae8fc;gradientColor=#7ea6e0;gradientDirection=south;
```

| gradientDirection | 説明 |
|-------------------|------|
| `north` | 下から上へ |
| `south` | 上から下へ（デフォルト） |
| `east` | 左から右へ |
| `west` | 右から左へ |

### opacity

全体の不透明度（0〜100）：

```
opacity=50;   /* 半透明 */
```

## 枠線（ストローク）

### strokeColor

枠線の色：

```
strokeColor=#6c8ebf;   /* 青系 */
strokeColor=#82b366;   /* 緑系 */
strokeColor=#000000;   /* 黒 */
strokeColor=none;      /* 枠線なし */
```

### strokeWidth

枠線の太さ（ピクセル）：

```
strokeWidth=1;    /* 標準 */
strokeWidth=2;    /* やや太い */
strokeWidth=3;    /* 太い */
```

### dashed / dashPattern

破線の設定：

```
dashed=1;                    /* デフォルトの破線 */
dashed=1;dashPattern=5 5;    /* 5px 線、5px 空白 */
dashed=1;dashPattern=10 5;   /* 10px 線、5px 空白 */
dashed=1;dashPattern=1 4;    /* 点線 */
```

## 角丸

### rounded

角を丸くします：

```
rounded=0;   /* 角丸なし（デフォルト） */
rounded=1;   /* 角丸あり */
```

### arcSize

角丸の半径を指定：

```
rounded=1;arcSize=20;   /* 角丸の半径 20px */
```

## 影

### shadow

影を表示：

```
shadow=1;   /* 影あり */
shadow=0;   /* 影なし（デフォルト） */
```

## 光沢効果

### glass

ガラス風の光沢効果：

```
glass=1;   /* 光沢あり */
```

## 接続点（ペリメーター）

### perimeter

コネクタがシェイプに接続する際の境界線の計算方法：

| 値 | 説明 |
|----|------|
| `rectanglePerimeter` | 四角形（デフォルト） |
| `ellipsePerimeter` | 楕円 |
| `rhombusPerimeter` | ひし形 |
| `trianglePerimeter` | 三角形 |

```
shape=ellipse;perimeter=ellipsePerimeter;
```

### perimeterSpacing

コネクタと境界線の間隔：

```
perimeterSpacing=5;   /* 5px の間隔 */
```

## 回転

### rotation

シェイプを回転（度数）：

```
rotation=45;    /* 45度回転 */
rotation=90;    /* 90度回転 */
rotation=-30;   /* -30度回転 */
```

## 編集制御

| スタイル | 値 | 説明 |
|----------|-----|------|
| `resizable` | `0` | リサイズ禁止 |
| `rotatable` | `0` | 回転禁止 |
| `movable` | `0` | 移動禁止 |
| `deletable` | `0` | 削除禁止 |
| `editable` | `0` | テキスト編集禁止 |
| `connectable` | `0` | コネクタ接続禁止 |

```
resizable=0;rotatable=0;movable=0;
```

## 色の組み合わせ例

### 青系

```
fillColor=#dae8fc;strokeColor=#6c8ebf;
```

### 緑系

```
fillColor=#d5e8d4;strokeColor=#82b366;
```

### オレンジ系

```
fillColor=#ffe6cc;strokeColor=#d79b00;
```

### 黄色系

```
fillColor=#fff2cc;strokeColor=#d6b656;
```

### 赤系

```
fillColor=#f8cecc;strokeColor=#b85450;
```

### 紫系

```
fillColor=#e1d5e7;strokeColor=#9673a6;
```

### グレー系

```
fillColor=#f5f5f5;strokeColor=#666666;
```

## 完全な例

### 標準的な青い四角形

```xml
<mxCell id="box1" value="処理"
        style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="120" height="60" as="geometry"/>
</mxCell>
```

### 影付きの角丸四角形

```xml
<mxCell id="box2" value="重要"
        style="rounded=1;whiteSpace=wrap;html=1;shadow=1;fillColor=#fff2cc;strokeColor=#d6b656;"
        vertex="1" parent="1">
  <mxGeometry x="250" y="100" width="120" height="60" as="geometry"/>
</mxCell>
```

### 判断（ひし形）

```xml
<mxCell id="decision1" value="条件?"
        style="rhombus;whiteSpace=wrap;html=1;fillColor=#ffe6cc;strokeColor=#d79b00;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="200" width="80" height="80" as="geometry"/>
</mxCell>
```

### データベース（円柱）

```xml
<mxCell id="db1" value="DB"
        style="shape=cylinder;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;"
        vertex="1" parent="1">
  <mxGeometry x="250" y="200" width="60" height="80" as="geometry"/>
</mxCell>
```

---

[目次に戻る](../index.md) | [前へ: スタイル概要](./index.md) | [次へ: コネクタのスタイル](./edge.md)
