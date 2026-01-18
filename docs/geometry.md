# ジオメトリ（位置とサイズ）

[目次に戻る](./index.md) | [前へ: mxCell 要素](./mxcell.md) | [次へ: スタイル概要](./style/index.md)

---

`mxGeometry` 要素は、セルの位置、サイズ、およびコネクタの経路を定義します。

## 基本構造

```xml
<mxCell id="shape1" ... vertex="1" parent="1">
  <mxGeometry x="100" y="50" width="120" height="60" as="geometry"/>
</mxCell>
```

`as="geometry"` 属性は必須で、この要素がジオメトリ情報であることを示します。

## シェイプのジオメトリ

### 属性

| 属性 | 説明 | 単位 |
|------|------|------|
| `x` | 左上 X 座標 | ピクセル |
| `y` | 左上 Y 座標 | ピクセル |
| `width` | 幅 | ピクセル |
| `height` | 高さ | ピクセル |

### 座標系

- 原点 (0, 0) は左上
- X 軸は右方向が正
- Y 軸は下方向が正

```
(0,0) ────────────→ X
  │
  │    ┌─────────┐
  │    │  shape  │
  │    │ (x,y)   │
  │    └─────────┘
  ↓
  Y
```

### 例：複数のシェイプを配置

```xml
<!-- 左上のシェイプ -->
<mxCell id="s1" value="A" style="..." vertex="1" parent="1">
  <mxGeometry x="50" y="50" width="100" height="50" as="geometry"/>
</mxCell>

<!-- 右に並べる -->
<mxCell id="s2" value="B" style="..." vertex="1" parent="1">
  <mxGeometry x="200" y="50" width="100" height="50" as="geometry"/>
</mxCell>

<!-- 下に並べる -->
<mxCell id="s3" value="C" style="..." vertex="1" parent="1">
  <mxGeometry x="50" y="150" width="100" height="50" as="geometry"/>
</mxCell>
```

## グループ内の相対座標

グループに含まれるセルの座標は、グループの左上を原点とした相対座標になります。

```xml
<!-- グループ本体（キャンバス上の位置） -->
<mxCell id="group1" style="group" vertex="1" connectable="0" parent="1">
  <mxGeometry x="100" y="100" width="200" height="150" as="geometry"/>
</mxCell>

<!-- グループ内のシェイプ（グループ内での相対位置） -->
<mxCell id="child1" value="子" style="..." vertex="1" parent="group1">
  <mxGeometry x="10" y="10" width="80" height="40" as="geometry"/>
</mxCell>
```

上記の例では：
- グループはキャンバスの (100, 100) に配置
- 子シェイプはグループ内の (10, 10) = キャンバス上では (110, 110)

## コネクタのジオメトリ

コネクタの `mxGeometry` は通常 `relative="1"` を持ち、経路は自動計算されます。

### 基本形

```xml
<mxCell id="edge1" style="..." edge="1" parent="1" source="s1" target="s2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### `relative` 属性

| 値 | 説明 |
|----|------|
| `1` | 経路を自動計算（通常のコネクタ） |
| `0` | 絶対座標で経路を指定 |

## 経路点（ウェイポイント）

コネクタの経路を細かく制御するには、`mxPoint` 要素を使用します。

### mxPoint の種類

| `as` 属性 | 説明 |
|-----------|------|
| `sourcePoint` | 出発点の座標（source が未接続の場合） |
| `targetPoint` | 到着点の座標（target が未接続の場合） |
| `offset` | ラベル位置のオフセット |
| （なし） | 中間経路点 |

### 例：固定端点のコネクタ

シェイプに接続せず、固定座標で線を引く場合：

```xml
<mxCell id="line1" style="endArrow=classic;html=1;" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="100" y="200" as="sourcePoint"/>
    <mxPoint x="300" y="100" as="targetPoint"/>
  </mxGeometry>
</mxCell>
```

### 例：中間経路点の指定

```xml
<mxCell id="edge2" style="edgeStyle=orthogonalEdgeStyle;..."
        edge="1" parent="1" source="s1" target="s2">
  <mxGeometry relative="1" as="geometry">
    <Array as="points">
      <mxPoint x="200" y="75"/>
      <mxPoint x="200" y="200"/>
      <mxPoint x="350" y="200"/>
    </Array>
  </mxGeometry>
</mxCell>
```

`Array as="points"` の中に `mxPoint` を列挙すると、コネクタはその点を順に通過します。

### 例：自己ループ

同じシェイプを source と target にすると自己ループになります：

```xml
<mxCell id="loop1"
        style="edgeStyle=orthogonalEdgeStyle;orthogonalLoop=1;
               exitX=1;exitY=0.25;entryX=1;entryY=0.75;
               endArrow=classic;html=1;"
        edge="1" parent="1" source="s1" target="s1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="200" y="30" as="sourcePoint"/>
    <mxPoint x="200" y="80" as="targetPoint"/>
  </mxGeometry>
</mxCell>
```

## ラベル位置のオフセット

コネクタのラベル位置を調整するには `offset` を使用します：

```xml
<mxCell id="edge3" value="ラベル" style="..." edge="1" parent="1" source="s1" target="s2">
  <mxGeometry relative="1" as="geometry">
    <mxPoint as="offset" x="10" y="-20"/>
  </mxGeometry>
</mxCell>
```

- `x`: 線に沿った方向のオフセット
- `y`: 線に垂直な方向のオフセット（負の値で上にずらす）

## ジオメトリなしのセル

以下のセルには `mxGeometry` が不要または省略可能です：

| セル | 説明 |
|------|------|
| `id="0"` | ルートセル |
| `id="1"` | デフォルトレイヤー |
| 追加レイヤー | `parent="0"` のレイヤーセル |

```xml
<root>
  <mxCell id="0"/>                           <!-- ジオメトリなし -->
  <mxCell id="1" parent="0"/>                <!-- ジオメトリなし -->
  <mxCell id="layer2" value="背景" parent="0"/>  <!-- ジオメトリなし -->
  ...
</root>
```

## サイズと位置の計算例

### 横に等間隔で配置

```
間隔 20px、幅 100px のシェイプを 3 つ横に並べる：

シェイプ1: x=50,  y=50, width=100
シェイプ2: x=170, y=50, width=100  (50 + 100 + 20)
シェイプ3: x=290, y=50, width=100  (170 + 100 + 20)
```

### 中央揃え

```
キャンバス幅 800px、シェイプ幅 200px の場合：

x = (800 - 200) / 2 = 300
```

### 垂直方向の中央揃え

```
キャンバス高さ 600px、シェイプ高さ 100px の場合：

y = (600 - 100) / 2 = 250
```

---

[目次に戻る](./index.md) | [前へ: mxCell 要素](./mxcell.md) | [次へ: スタイル概要](./style/index.md)
