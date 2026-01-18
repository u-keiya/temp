# 基本構造

[目次に戻る](./index.md) | [次へ: mxCell 要素](./mxcell.md)

---

`.drawio` ファイルは XML 形式で構成されており、入れ子構造で図の情報を保持しています。

## 全体構造

```
mxfile                    ← ファイルのルート
└── diagram               ← 各ページ（タブ）
    └── mxGraphModel      ← 図のモデル
        └── root          ← セルのコンテナ
            ├── mxCell    ← ルートセル (id="0")
            ├── mxCell    ← デフォルトレイヤー (id="1")
            ├── mxCell    ← シェイプやコネクタ
            └── ...
```

## mxfile 要素

ファイル全体を囲むルート要素です。メタデータと 1 つ以上の `diagram` 要素を含みます。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile modified="2025-01-18T12:00:00.000Z"
        host="app.diagrams.net"
        version="24.0.0"
        type="device"
        compressed="false">
  <diagram id="..." name="ページ1">
    ...
  </diagram>
</mxfile>
```

### 主な属性

| 属性 | 説明 | 例 |
|------|------|-----|
| `modified` | 最終更新日時（ISO 8601 形式） | `2025-01-18T12:00:00.000Z` |
| `host` | 編集に使用したアプリケーション | `app.diagrams.net`, `Electron` |
| `version` | draw.io のバージョン | `24.0.0` |
| `type` | 保存元の種類 | `device`, `google`, `browser` |
| `compressed` | 内容が圧縮されているか | `true`, `false` |
| `etag` | 内部用のハッシュ値 | `jyk4LjRpkp5MiVdB0UgM` |

### 圧縮について

`compressed="true"`（デフォルト）の場合、`diagram` 要素の内容は Base64 + deflate で圧縮されています。手動編集する場合は `compressed="false"` を指定し、XML をそのまま記述できるようにします。

詳細は [Tips と注意点](./tips.md) を参照してください。

## diagram 要素

1 つのページ（タブ）を表します。複数ページの図では、`diagram` 要素が複数並びます。

```xml
<diagram id="unique-id-123" name="メイン図">
  <mxGraphModel ...>
    ...
  </mxGraphModel>
</diagram>

<diagram id="unique-id-456" name="詳細図">
  <mxGraphModel ...>
    ...
  </mxGraphModel>
</diagram>
```

### 属性

| 属性 | 説明 |
|------|------|
| `id` | ページの一意な識別子 |
| `name` | タブに表示される名前 |

## mxGraphModel 要素

図の描画設定とすべてのセル（シェイプ・コネクタ）を含む要素です。

```xml
<mxGraphModel dx="800" dy="600"
              grid="1" gridSize="10"
              guides="1" tooltips="1"
              connect="1" arrows="1" fold="1"
              page="1" pageScale="1"
              pageWidth="827" pageHeight="1169"
              background="#ffffff"
              math="0" shadow="0">
  <root>
    ...
  </root>
</mxGraphModel>
```

### キャンバス設定

| 属性 | 説明 | 既定値 |
|------|------|--------|
| `dx` | キャンバスの幅（ピクセル） | - |
| `dy` | キャンバスの高さ（ピクセル） | - |
| `background` | 背景色（16 進数） | `#ffffff` |

### グリッド・ガイド

| 属性 | 説明 | 値 |
|------|------|-----|
| `grid` | グリッド表示 | `1`=表示, `0`=非表示 |
| `gridSize` | グリッド間隔（ピクセル） | `10` |
| `guides` | 整列ガイド | `1`=有効, `0`=無効 |

### ページ設定

| 属性 | 説明 | 値 |
|------|------|-----|
| `page` | ページ境界の表示 | `1`=表示, `0`=無限キャンバス |
| `pageScale` | ページの拡大率 | `1` |
| `pageWidth` | ページ幅（ピクセル） | `827`（A4 縦） |
| `pageHeight` | ページ高さ（ピクセル） | `1169`（A4 縦） |

### 機能設定

| 属性 | 説明 | 値 |
|------|------|-----|
| `tooltips` | ツールチップ | `1`=表示, `0`=非表示 |
| `connect` | コネクタの接続スナップ | `1`=有効, `0`=無効 |
| `arrows` | 矢印表示 | `1`=表示, `0`=非表示 |
| `fold` | 折りたたみ機能 | `1`=有効, `0`=無効 |
| `math` | LaTeX 数式（MathJax） | `1`=有効, `0`=無効 |
| `shadow` | 影のデフォルト | `1`=有効, `0`=無効 |

## root 要素とレイヤー

`root` 要素は、すべての `mxCell` を格納するコンテナです。

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>
  <!-- 以降にシェイプやコネクタを追加 -->
</root>
```

### 必須セル

最初の 2 つの `mxCell` は必ず含める必要があります：

| ID | 役割 | 説明 |
|----|------|------|
| `0` | ルートセル | グラフ全体の親。削除・変更不可 |
| `1` | デフォルトレイヤー | 通常のシェイプはこれを `parent` に指定 |

### レイヤーの追加

追加のレイヤーは `parent="0"` を持つ `mxCell` として定義します：

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>                          <!-- デフォルトレイヤー -->
  <mxCell id="layer2" value="背景" parent="0"/>        <!-- 追加レイヤー -->
  <mxCell id="layer3" value="注釈" parent="0"/>        <!-- 追加レイヤー -->

  <!-- レイヤー1のシェイプ -->
  <mxCell id="shape1" parent="1" .../>

  <!-- 背景レイヤーのシェイプ -->
  <mxCell id="bg1" parent="layer2" .../>
</root>
```

- `value` 属性でレイヤー名を指定
- 各シェイプの `parent` 属性で所属レイヤーを指定
- XML での出現順がレイヤーの重なり順（前=下、後=上）

## 最小限の完全なファイル

以下は、1 つの四角形を含む最小限の `.drawio` ファイルです：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="simple" name="ページ1">
    <mxGraphModel dx="800" dy="600" grid="1" gridSize="10"
                  page="1" pageWidth="800" pageHeight="600">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="2" value="Hello"
                style="rounded=0;whiteSpace=wrap;html=1;"
                vertex="1" parent="1">
          <mxGeometry x="100" y="100" width="120" height="60" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

この例では：
- `id="2"` のセルが四角形シェイプ
- `vertex="1"` でシェイプ（頂点）であることを示す
- `parent="1"` でデフォルトレイヤーに配置
- `mxGeometry` で位置 (100, 100) とサイズ (120×60) を指定

---

[目次に戻る](./index.md) | [次へ: mxCell 要素](./mxcell.md)
