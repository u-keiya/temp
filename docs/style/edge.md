# コネクタのスタイル

[目次に戻る](../index.md) | [前へ: シェイプのスタイル](./shape.md) | [次へ: テキストのスタイル](./text.md)

---

コネクタ（辺）の経路、矢印、外観を定義するスタイル属性について解説します。

## 経路スタイル（edgeStyle）

コネクタの経路計算方法を指定します。

### 主な経路スタイル

| 値 | 説明 |
|----|------|
| （未指定） | 直線 |
| `orthogonalEdgeStyle` | 直交（カギ線） |
| `elbowEdgeStyle` | エルボー（1 回折れ） |
| `entityRelationEdgeStyle` | ER 図用 |
| `segmentEdgeStyle` | セグメント |

### 直線コネクタ

```
endArrow=classic;html=1;
```

```xml
<mxCell id="e1" style="endArrow=classic;html=1;"
        edge="1" parent="1" source="s1" target="s2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 直交（カギ線）コネクタ

```
edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=classic;
```

```xml
<mxCell id="e2"
        style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=classic;"
        edge="1" parent="1" source="s1" target="s2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 曲線コネクタ

```
curved=1;endArrow=classic;html=1;
```

## 矢印

### endArrow / startArrow

線の終端・始端の矢印の種類：

| 値 | 説明 |
|----|------|
| `none` | 矢印なし |
| `classic` | 標準の三角矢印 |
| `classicThin` | 細い三角矢印 |
| `block` | 塗りつぶしブロック |
| `blockThin` | 細いブロック |
| `open` | 開いた矢印 |
| `openThin` | 細い開いた矢印 |
| `oval` | 丸 |
| `diamond` | ひし形 |
| `diamondThin` | 細いひし形 |
| `dash` | 短い横線 |
| `cross` | バツ印 |
| `circlePlus` | 丸に十字 |
| `circle` | 丸（空） |
| `ERone` | ER 図用（1） |
| `ERmandOne` | ER 図用（必須 1） |
| `ERmany` | ER 図用（多） |
| `ERoneToMany` | ER 図用（1 対多） |
| `ERzeroToOne` | ER 図用（0 または 1） |
| `ERzeroToMany` | ER 図用（0 以上） |

### 例：片方向矢印

```
endArrow=classic;startArrow=none;html=1;
```

### 例：双方向矢印

```
endArrow=classic;startArrow=classic;html=1;
```

### 例：矢印なしの線

```
endArrow=none;startArrow=none;html=1;
```

### endFill / startFill

矢印を塗りつぶすかどうか：

| 値 | 説明 |
|----|------|
| `1` | 塗りつぶし（デフォルト） |
| `0` | 中空（白抜き） |

```
endArrow=classic;endFill=0;   /* 白抜き矢印 */
endArrow=diamond;endFill=0;   /* 白抜きひし形 */
```

### endSize / startSize

矢印のサイズ：

```
endArrow=classic;endSize=12;   /* 大きい矢印 */
endArrow=classic;endSize=6;    /* 小さい矢印 */
```

## 接続点の指定

シェイプのどこからコネクタを出入りさせるかを指定します。

### exitX / exitY（出発点）

接続元シェイプでの位置（0〜1 の比率）：

```
      exitX=0.5
         ↓
    ┌─────────┐
    │         │ exitY=0
    │         │
exitX=0       │ exitY=0.5
    │         │
    │         │ exitY=1
    └─────────┘
         ↑
      exitX=0.5
              exitX=1
```

| 位置 | exitX | exitY |
|------|-------|-------|
| 左上 | 0 | 0 |
| 上中央 | 0.5 | 0 |
| 右上 | 1 | 0 |
| 左中央 | 0 | 0.5 |
| 中央 | 0.5 | 0.5 |
| 右中央 | 1 | 0.5 |
| 左下 | 0 | 1 |
| 下中央 | 0.5 | 1 |
| 右下 | 1 | 1 |

### entryX / entryY（到着点）

接続先シェイプでの位置（exitX/exitY と同様）。

### 例：右から左へ接続

```
exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;
```

### exitDx / exitDy / entryDx / entryDy

ピクセル単位のオフセット（通常は `0`）。

## 線のスタイル

### strokeColor

線の色：

```
strokeColor=#6c8ebf;   /* 青 */
strokeColor=#82b366;   /* 緑 */
strokeColor=#b85450;   /* 赤 */
```

### strokeWidth

線の太さ：

```
strokeWidth=1;   /* 標準 */
strokeWidth=2;   /* やや太い */
strokeWidth=3;   /* 太い */
```

### dashed / dashPattern

破線の設定：

```
dashed=1;                    /* デフォルトの破線 */
dashed=1;dashPattern=8 8;    /* 8px 線、8px 空白 */
dashed=1;dashPattern=1 4;    /* 点線 */
```

### rounded

直交コネクタの角を丸くする：

```
edgeStyle=orthogonalEdgeStyle;rounded=1;
```

## 直交コネクタの設定

### orthogonalLoop

自己ループ（同じシェイプへの接続）を直交で描画：

```
orthogonalLoop=1;
```

### jettySize

シェイプからの「飛び出し」距離：

```
jettySize=auto;   /* 自動計算 */
jettySize=20;     /* 20px */
```

## ジャンプ（交差処理）

コネクタが交差する部分の表示方法。

### jumpStyle

| 値 | 説明 |
|----|------|
| `none` | 何もしない（デフォルト） |
| `arc` | 弧で跨ぐ |
| `gap` | 隙間を空ける |
| `sharp` | 鋭角で跨ぐ |

### jumpSize

ジャンプの大きさ：

```
jumpStyle=arc;jumpSize=10;
```

## ラベル関連

### labelBackgroundColor

ラベルの背景色（交差する線の上にラベルを見やすくする）：

```
labelBackgroundColor=#ffffff;
```

### labelBorderColor

ラベルの枠線色：

```
labelBorderColor=#000000;
```

## 完全な例

### シンプルな直線矢印

```xml
<mxCell id="arrow1" value=""
        style="endArrow=classic;html=1;"
        edge="1" parent="1" source="box1" target="box2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 直交コネクタ（青）

```xml
<mxCell id="ortho1" value=""
        style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;
               jettySize=auto;html=1;endArrow=classic;strokeColor=#6c8ebf;"
        edge="1" parent="1" source="box1" target="box2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 破線の双方向矢印

```xml
<mxCell id="bidir1" value=""
        style="endArrow=classic;startArrow=classic;html=1;dashed=1;"
        edge="1" parent="1" source="box1" target="box2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### ER 図用のリレーション

```xml
<mxCell id="er1" value=""
        style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;
               jettySize=auto;html=1;endArrow=ERoneToMany;startArrow=ERone;
               endFill=0;startFill=0;"
        edge="1" parent="1" source="entity1" target="entity2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### ラベル付きコネクタ

```xml
<mxCell id="labeled1" value="関連"
        style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;
               jettySize=auto;html=1;endArrow=classic;
               labelBackgroundColor=#ffffff;"
        edge="1" parent="1" source="box1" target="box2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 接続点を明示したコネクタ

```xml
<mxCell id="precise1" value=""
        style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;
               jettySize=auto;html=1;endArrow=classic;
               exitX=1;exitY=0.5;exitDx=0;exitDy=0;
               entryX=0;entryY=0.5;entryDx=0;entryDy=0;"
        edge="1" parent="1" source="box1" target="box2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

---

[目次に戻る](../index.md) | [前へ: シェイプのスタイル](./shape.md) | [次へ: テキストのスタイル](./text.md)
