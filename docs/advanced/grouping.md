# グループ化とコンテナ

[目次に戻る](../index.md) | [前へ: 画像の埋め込み](./images.md) | [次へ: カスタムデータ](./custom-data.md)

---

複数のシェイプをまとめて操作したり、階層構造を作成するための機能について解説します。

## グループ

### グループの基本

グループは、複数のシェイプを 1 つの単位として扱うための仕組みです。

```xml
<!-- グループコンテナ -->
<mxCell id="group1" value=""
        style="group"
        vertex="1" connectable="0" parent="1">
  <mxGeometry x="100" y="100" width="200" height="150" as="geometry"/>
</mxCell>

<!-- グループ内のシェイプ -->
<mxCell id="child1" value="要素1"
        style="rounded=0;whiteSpace=wrap;html=1;"
        vertex="1" parent="group1">
  <mxGeometry x="10" y="10" width="80" height="40" as="geometry"/>
</mxCell>

<mxCell id="child2" value="要素2"
        style="rounded=0;whiteSpace=wrap;html=1;"
        vertex="1" parent="group1">
  <mxGeometry x="110" y="10" width="80" height="40" as="geometry"/>
</mxCell>
```

### ポイント

| 要素 | 説明 |
|------|------|
| `style="group"` | グループコンテナであることを示す |
| `connectable="0"` | グループ自体へのコネクタ接続を禁止 |
| `parent="group1"` | 子シェイプの親をグループに設定 |
| 子の座標 | グループ左上を原点とした相対座標 |

### グループのサイズ

グループの `mxGeometry` は、子シェイプを囲む外接矩形のサイズを設定します。draw.io は自動的に調整しませんので、手動で適切なサイズを指定してください。

## スイムレーン

スイムレーンは、フローチャートやプロセス図でよく使用される特殊なコンテナです。

### 横向きスイムレーン

```xml
<mxCell id="lane1" value="担当者A"
        style="swimlane;horizontal=1;startSize=30;
               fillColor=#dae8fc;strokeColor=#6c8ebf;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="400" height="200" as="geometry"/>
</mxCell>

<!-- スイムレーン内のシェイプ -->
<mxCell id="task1" value="タスク1"
        style="rounded=0;whiteSpace=wrap;html=1;"
        vertex="1" parent="lane1">
  <mxGeometry x="30" y="50" width="100" height="50" as="geometry"/>
</mxCell>
```

### 縦向きスイムレーン

```xml
<mxCell id="lane2" value="フェーズ1"
        style="swimlane;horizontal=0;startSize=30;
               fillColor=#d5e8d4;strokeColor=#82b366;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="200" height="400" as="geometry"/>
</mxCell>
```

### スイムレーンのスタイル

| スタイル | 説明 |
|----------|------|
| `swimlane` | スイムレーン形状 |
| `horizontal=1` | 横向き（ヘッダーが上） |
| `horizontal=0` | 縦向き（ヘッダーが左） |
| `startSize=30` | ヘッダー領域の高さ/幅（px） |

### ネストしたスイムレーン

```xml
<!-- 外側のスイムレーン -->
<mxCell id="outerLane" value="部門A"
        style="swimlane;horizontal=1;startSize=30;"
        vertex="1" parent="1">
  <mxGeometry x="50" y="50" width="500" height="300" as="geometry"/>
</mxCell>

<!-- 内側のスイムレーン（外側の子） -->
<mxCell id="innerLane1" value="チーム1"
        style="swimlane;horizontal=1;startSize=25;"
        vertex="1" parent="outerLane">
  <mxGeometry x="10" y="40" width="230" height="250" as="geometry"/>
</mxCell>

<mxCell id="innerLane2" value="チーム2"
        style="swimlane;horizontal=1;startSize=25;"
        vertex="1" parent="outerLane">
  <mxGeometry x="250" y="40" width="230" height="250" as="geometry"/>
</mxCell>
```

## 折りたたみ可能なコンテナ

### 基本構造

```xml
<mxCell id="container1" value="セクション"
        style="swimlane;startSize=25;collapsible=1;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="200" height="150" as="geometry"/>
</mxCell>
```

### 折りたたみ状態

```xml
<!-- 折りたたまれた状態 -->
<mxCell id="collapsed1" value="折りたたみ中"
        style="swimlane;startSize=25;collapsible=1;"
        vertex="1" collapsed="1" parent="1">
  <mxGeometry x="100" y="100" width="200" height="150" as="geometry">
    <mxRectangle x="100" y="100" width="200" height="25" as="alternateBounds"/>
  </mxGeometry>
</mxCell>
```

| 属性/要素 | 説明 |
|-----------|------|
| `collapsed="1"` | 折りたたまれた状態 |
| `mxRectangle as="alternateBounds"` | 折りたたみ時のサイズ |
| `collapsible=1` | 折りたたみ可能（スタイル） |

## 子シェイプの制御

グループ内の子シェイプに制限を設けることができます：

```xml
<mxCell id="fixedChild" value="固定"
        style="rounded=0;whiteSpace=wrap;html=1;
               movable=0;resizable=0;rotatable=0;"
        vertex="1" parent="group1">
  ...
</mxCell>
```

| スタイル | 説明 |
|----------|------|
| `movable=0` | 移動禁止 |
| `resizable=0` | リサイズ禁止 |
| `rotatable=0` | 回転禁止 |
| `deletable=0` | 削除禁止 |
| `editable=0` | テキスト編集禁止 |
| `connectable=0` | コネクタ接続禁止 |

## 複合シェイプの例

### カード型シェイプ

```xml
<!-- カードコンテナ -->
<mxCell id="card1" value=""
        style="group"
        vertex="1" connectable="0" parent="1">
  <mxGeometry x="100" y="100" width="200" height="120" as="geometry"/>
</mxCell>

<!-- ヘッダー -->
<mxCell id="cardHeader" value="タイトル"
        style="rounded=0;whiteSpace=wrap;html=1;
               fillColor=#6c8ebf;fontColor=#ffffff;
               movable=0;resizable=0;"
        vertex="1" parent="card1">
  <mxGeometry width="200" height="30" as="geometry"/>
</mxCell>

<!-- ボディ -->
<mxCell id="cardBody" value="内容をここに記載"
        style="rounded=0;whiteSpace=wrap;html=1;
               align=left;verticalAlign=top;spacingLeft=10;spacingTop=10;
               movable=0;resizable=0;"
        vertex="1" parent="card1">
  <mxGeometry y="30" width="200" height="90" as="geometry"/>
</mxCell>
```

### テーブル型シェイプ

```xml
<!-- テーブルコンテナ -->
<mxCell id="table1" value=""
        style="group"
        vertex="1" connectable="0" parent="1">
  <mxGeometry x="100" y="100" width="300" height="90" as="geometry"/>
</mxCell>

<!-- ヘッダー行 -->
<mxCell id="headerRow" value=""
        style="group"
        vertex="1" connectable="0" parent="table1">
  <mxGeometry width="300" height="30" as="geometry"/>
</mxCell>

<mxCell id="h1" value="列1" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#f5f5f5;fontStyle=1;" vertex="1" parent="headerRow">
  <mxGeometry width="100" height="30" as="geometry"/>
</mxCell>
<mxCell id="h2" value="列2" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#f5f5f5;fontStyle=1;" vertex="1" parent="headerRow">
  <mxGeometry x="100" width="100" height="30" as="geometry"/>
</mxCell>
<mxCell id="h3" value="列3" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#f5f5f5;fontStyle=1;" vertex="1" parent="headerRow">
  <mxGeometry x="200" width="100" height="30" as="geometry"/>
</mxCell>

<!-- データ行1 -->
<mxCell id="r1c1" value="A" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="table1">
  <mxGeometry y="30" width="100" height="30" as="geometry"/>
</mxCell>
<mxCell id="r1c2" value="B" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="table1">
  <mxGeometry x="100" y="30" width="100" height="30" as="geometry"/>
</mxCell>
<mxCell id="r1c3" value="C" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="table1">
  <mxGeometry x="200" y="30" width="100" height="30" as="geometry"/>
</mxCell>

<!-- データ行2 -->
<mxCell id="r2c1" value="D" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="table1">
  <mxGeometry y="60" width="100" height="30" as="geometry"/>
</mxCell>
<mxCell id="r2c2" value="E" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="table1">
  <mxGeometry x="100" y="60" width="100" height="30" as="geometry"/>
</mxCell>
<mxCell id="r2c3" value="F" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="table1">
  <mxGeometry x="200" y="60" width="100" height="30" as="geometry"/>
</mxCell>
```

## コネクタとグループ

グループに `connectable="0"` を設定すると、コネクタはグループではなく内部の子シェイプに接続されます。

```xml
<!-- グループ（接続不可） -->
<mxCell id="g1" style="group" vertex="1" connectable="0" parent="1">
  ...
</mxCell>

<!-- 子シェイプ（接続可能） -->
<mxCell id="c1" style="..." vertex="1" parent="g1">
  ...
</mxCell>

<!-- コネクタは子シェイプに接続 -->
<mxCell id="e1" style="..." edge="1" parent="1" source="c1" target="other">
  ...
</mxCell>
```

---

[目次に戻る](../index.md) | [前へ: 画像の埋め込み](./images.md) | [次へ: カスタムデータ](./custom-data.md)
