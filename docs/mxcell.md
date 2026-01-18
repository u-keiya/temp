# mxCell 要素

[目次に戻る](./index.md) | [前へ: 基本構造](./basic-structure.md) | [次へ: ジオメトリ](./geometry.md)

---

`mxCell` は draw.io の図を構成する基本単位です。シェイプ（図形）、コネクタ（線）、グループなど、すべての視覚要素は `mxCell` として表現されます。

## セルの種類

| 種類 | 識別方法 | 説明 |
|------|----------|------|
| 頂点（Vertex） | `vertex="1"` | シェイプ、テキスト、画像など |
| 辺（Edge） | `edge="1"` | コネクタ、矢印、線 |
| レイヤー | `parent="0"` | シェイプを分類するレイヤー |
| グループ | `style="group"` | 複数セルをまとめるコンテナ |

## 基本的な属性

### 共通属性

```xml
<mxCell id="cell-1"
        value="ラベルテキスト"
        style="rounded=1;fillColor=#e1d5e7;"
        parent="1"
        vertex="1">
  <mxGeometry ... />
</mxCell>
```

| 属性 | 必須 | 説明 |
|------|:----:|------|
| `id` | ○ | 一意な識別子。他のセルから参照される |
| `value` | - | 表示するテキスト（ラベル）。HTML 可 |
| `style` | - | 外観を定義するスタイル文字列 |
| `parent` | ○ | 親セルの ID（通常は `"1"`） |
| `vertex` | △ | シェイプの場合は `"1"` |
| `edge` | △ | コネクタの場合は `"1"` |

### コネクタ固有の属性

```xml
<mxCell id="edge-1"
        style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;"
        edge="1"
        parent="1"
        source="cell-1"
        target="cell-2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

| 属性 | 説明 |
|------|------|
| `source` | 接続元シェイプの ID |
| `target` | 接続先シェイプの ID |

`source` や `target` を省略すると、端点が固定されない「浮いた」コネクタになります。

### 制御用属性

| 属性 | 値 | 説明 |
|------|-----|------|
| `connectable` | `0` | コネクタの接続を禁止 |
| `collapsed` | `1` | 折りたたまれた状態 |
| `visible` | `0` | 非表示（あまり使用されない） |

## シェイプの例

### 基本的な四角形

```xml
<mxCell id="rect1" value="四角形"
        style="rounded=0;whiteSpace=wrap;html=1;"
        vertex="1" parent="1">
  <mxGeometry x="50" y="50" width="120" height="60" as="geometry"/>
</mxCell>
```

### 角丸の四角形

```xml
<mxCell id="rounded1" value="角丸"
        style="rounded=1;whiteSpace=wrap;html=1;"
        vertex="1" parent="1">
  <mxGeometry x="50" y="150" width="120" height="60" as="geometry"/>
</mxCell>
```

### 楕円

```xml
<mxCell id="ellipse1" value="楕円"
        style="ellipse;whiteSpace=wrap;html=1;"
        vertex="1" parent="1">
  <mxGeometry x="50" y="250" width="120" height="80" as="geometry"/>
</mxCell>
```

### ひし形

```xml
<mxCell id="diamond1" value="判断"
        style="rhombus;whiteSpace=wrap;html=1;"
        vertex="1" parent="1">
  <mxGeometry x="50" y="350" width="80" height="80" as="geometry"/>
</mxCell>
```

## コネクタの例

### 直線コネクタ

```xml
<mxCell id="line1"
        style="endArrow=classic;html=1;"
        edge="1" parent="1"
        source="rect1" target="ellipse1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 直交（カギ線）コネクタ

```xml
<mxCell id="ortho1"
        style="edgeStyle=orthogonalEdgeStyle;rounded=0;
               orthogonalLoop=1;jettySize=auto;html=1;
               endArrow=classic;"
        edge="1" parent="1"
        source="rect1" target="diamond1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 双方向矢印

```xml
<mxCell id="bidir1"
        style="endArrow=classic;startArrow=classic;html=1;"
        edge="1" parent="1"
        source="ellipse1" target="diamond1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 接続点を指定したコネクタ

```xml
<mxCell id="precise1"
        style="edgeStyle=orthogonalEdgeStyle;html=1;
               exitX=1;exitY=0.5;exitDx=0;exitDy=0;
               entryX=0;entryY=0.5;entryDx=0;entryDy=0;
               endArrow=classic;"
        edge="1" parent="1"
        source="rect1" target="ellipse1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

接続点の指定：
- `exitX`, `exitY`: 接続元での出発位置（0〜1 の比率）
- `entryX`, `entryY`: 接続先での到着位置（0〜1 の比率）
- `exitDx`, `exitDy`, `entryDx`, `entryDy`: ピクセル単位のオフセット

## 親子関係

### 基本的な階層

```
mxCell id="0"           ← ルート（変更不可）
└── mxCell id="1"       ← デフォルトレイヤー（parent="0"）
    ├── mxCell id="2"   ← シェイプ A（parent="1"）
    ├── mxCell id="3"   ← シェイプ B（parent="1"）
    └── mxCell id="4"   ← コネクタ（parent="1"）
```

### グループ化

複数のシェイプをグループ化するには、グループ用のセルを作成し、子セルの `parent` をそのグループに設定します：

```xml
<!-- グループコンテナ -->
<mxCell id="group1" value=""
        style="group"
        vertex="1" connectable="0" parent="1">
  <mxGeometry x="100" y="100" width="200" height="150" as="geometry"/>
</mxCell>

<!-- グループ内のシェイプ（親をグループに設定） -->
<mxCell id="child1" value="子1"
        style="rounded=0;whiteSpace=wrap;html=1;"
        vertex="1" parent="group1">
  <mxGeometry x="10" y="10" width="80" height="40" as="geometry"/>
</mxCell>

<mxCell id="child2" value="子2"
        style="rounded=0;whiteSpace=wrap;html=1;"
        vertex="1" parent="group1">
  <mxGeometry x="10" y="60" width="80" height="40" as="geometry"/>
</mxCell>
```

ポイント：
- グループの `style` に `group` を含める
- グループには通常 `connectable="0"` を設定（コネクタはグループではなく中の子に接続させる）
- 子セルの座標はグループの左上を原点とした相対座標

## value 属性と HTML ラベル

### プレーンテキスト

```xml
<mxCell id="plain" value="シンプルなテキスト" .../>
```

### HTML ラベル

`style` に `html=1` を含めると、`value` を HTML として解釈します：

```xml
<mxCell id="html1"
        value="&lt;b&gt;太字&lt;/b&gt;&lt;br&gt;&lt;i&gt;斜体&lt;/i&gt;"
        style="rounded=0;whiteSpace=wrap;html=1;"
        vertex="1" parent="1">
  ...
</mxCell>
```

HTML タグは XML エスケープが必要：
- `<` → `&lt;`
- `>` → `&gt;`
- `&` → `&amp;`
- `"` → `&quot;`

よく使う HTML タグ：
- `<b>`, `<strong>` - 太字
- `<i>`, `<em>` - 斜体
- `<u>` - 下線
- `<br>` - 改行
- `<font color="#ff0000">` - 文字色
- `<font size="14">` - フォントサイズ

## 描画順序（Z-order）

XML での出現順序が描画順序を決定します。後に記述されたセルが上に描画されます。

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>
  <mxCell id="back" .../>   <!-- 最背面 -->
  <mxCell id="middle" .../> <!-- 中間 -->
  <mxCell id="front" .../>  <!-- 最前面 -->
</root>
```

---

[目次に戻る](./index.md) | [前へ: 基本構造](./basic-structure.md) | [次へ: ジオメトリ](./geometry.md)
