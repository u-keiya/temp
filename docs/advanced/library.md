# カスタムライブラリ

[目次に戻る](../index.md) | [前へ: カスタムデータ](./custom-data.md) | [次へ: サンプル集](../examples.md)

---

draw.io では、よく使うシェイプをカスタムライブラリとして保存・配布できます。ライブラリは `mxlibrary` 形式で記述されます。

## mxlibrary 形式

### 基本構造

```xml
<mxlibrary>[
  {
    "xml": "<mxGraphModel>...</mxGraphModel>",
    "w": 120,
    "h": 60,
    "title": "シェイプ名",
    "aspect": "fixed"
  },
  {
    "xml": "...",
    "w": 80,
    "h": 80,
    "title": "別のシェイプ"
  }
]</mxlibrary>
```

### ポイント

- ルート要素は `<mxlibrary>`
- 内容は JSON 配列
- 各エントリはシェイプ 1 つを表す

## ライブラリエントリの構造

| プロパティ | 必須 | 説明 |
|-----------|:----:|------|
| `xml` | ○ | シェイプの XML（エスケープ済み） |
| `w` | ○ | デフォルト幅（ピクセル） |
| `h` | ○ | デフォルト高さ（ピクセル） |
| `title` | ○ | パレットに表示される名前 |
| `aspect` | - | `"fixed"` でアスペクト比を固定 |
| `data` | - | 画像データ（`xml` の代わり） |

## xml プロパティ

### 内容

シェイプを表す完全な `mxGraphModel` を文字列として格納します。

```json
{
  "xml": "<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"ラベル\" style=\"rounded=1;whiteSpace=wrap;html=1;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"120\" height=\"60\" as=\"geometry\"/></mxCell></root></mxGraphModel>",
  "w": 120,
  "h": 60,
  "title": "角丸四角形"
}
```

### エスケープ規則

JSON 文字列内では以下のエスケープが必要：

| 文字 | エスケープ |
|------|-----------|
| `"` | `\"` |
| `\` | `\\` |
| 改行 | `\n` |
| タブ | `\t` |

さらに、XML 内の特殊文字もエスケープが必要です（`&lt;`, `&gt;` など）。

## シンプルな例

### 1 つのシェイプを持つライブラリ

```xml
<mxlibrary>[{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"OK\" style=\"ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"60\" height=\"60\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":60,"h":60,"title":"OK ボタン"}]</mxlibrary>
```

### 複数シェイプのライブラリ

```xml
<mxlibrary>[
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"開始\" style=\"ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"80\" height=\"40\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":80,"h":40,"title":"開始"},
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"終了\" style=\"ellipse;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"80\" height=\"40\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":80,"h":40,"title":"終了"},
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"処理\" style=\"rounded=0;whiteSpace=wrap;html=1;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"120\" height=\"60\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":120,"h":60,"title":"処理"},
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"判断\" style=\"rhombus;whiteSpace=wrap;html=1;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"80\" height=\"80\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":80,"h":80,"title":"判断"}
]</mxlibrary>
```

## グループシェイプ

複数のセルで構成されるシェイプも定義できます：

```json
{
  "xml": "<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"group\" style=\"group\" vertex=\"1\" connectable=\"0\" parent=\"1\"><mxGeometry width=\"150\" height=\"80\" as=\"geometry\"/></mxCell><mxCell id=\"header\" value=\"タイトル\" style=\"rounded=0;whiteSpace=wrap;html=1;fillColor=#6c8ebf;fontColor=#ffffff;\" vertex=\"1\" parent=\"group\"><mxGeometry width=\"150\" height=\"25\" as=\"geometry\"/></mxCell><mxCell id=\"body\" value=\"内容\" style=\"rounded=0;whiteSpace=wrap;html=1;\" vertex=\"1\" parent=\"group\"><mxGeometry y=\"25\" width=\"150\" height=\"55\" as=\"geometry\"/></mxCell></root></mxGraphModel>",
  "w": 150,
  "h": 80,
  "title": "カード"
}
```

## 画像ライブラリ

`xml` の代わりに `data` を使用して画像を含めることもできます：

```json
{
  "data": "data:image/png;base64,iVBORw0KGgo...",
  "w": 48,
  "h": 48,
  "title": "アイコン"
}
```

## ライブラリの作成方法

### draw.io から作成

1. シェイプを選択
2. 右クリック → **ライブラリに追加**
3. ライブラリ名を入力
4. **エクスポート** でファイルに保存

### プログラムから作成

```python
import json

def create_library_entry(value, style, width, height, title):
    xml = f'<mxGraphModel><root><mxCell id="0"/><mxCell id="1" parent="0"/><mxCell id="2" value="{value}" style="{style}" vertex="1" parent="1"><mxGeometry width="{width}" height="{height}" as="geometry"/></mxCell></root></mxGraphModel>'
    return {
        "xml": xml,
        "w": width,
        "h": height,
        "title": title
    }

# ライブラリを作成
entries = [
    create_library_entry("処理A", "rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;", 120, 60, "処理A"),
    create_library_entry("処理B", "rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;", 120, 60, "処理B"),
]

# XML形式で出力
library_json = json.dumps(entries, ensure_ascii=False)
print(f"<mxlibrary>{library_json}</mxlibrary>")
```

## ライブラリの読み込み

### draw.io での読み込み

1. **ファイル** → **ライブラリを開く** → **デバイス** または **URL**
2. `.xml` ファイルを選択

### 永続化

読み込んだライブラリは draw.io に保存され、次回起動時も使用できます。

## ライブラリファイルの例

### flowchart-library.xml

```xml
<mxlibrary>[
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"開始\" style=\"ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"100\" height=\"50\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":100,"h":50,"title":"開始","aspect":"fixed"},
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"終了\" style=\"ellipse;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;fontStyle=1;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"100\" height=\"50\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":100,"h":50,"title":"終了","aspect":"fixed"},
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"処理\" style=\"rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"120\" height=\"60\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":120,"h":60,"title":"処理"},
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"判断\" style=\"rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"80\" height=\"80\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":80,"h":80,"title":"判断"},
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"入出力\" style=\"shape=parallelogram;perimeter=parallelogramPerimeter;whiteSpace=wrap;html=1;fillColor=#ffe6cc;strokeColor=#d79b00;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"120\" height=\"60\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":120,"h":60,"title":"入出力"},
{"xml":"<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/><mxCell id=\"2\" value=\"データ\" style=\"shape=cylinder;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;\" vertex=\"1\" parent=\"1\"><mxGeometry width=\"60\" height=\"80\" as=\"geometry\"/></mxCell></root></mxGraphModel>","w":60,"h":80,"title":"データ"}
]</mxlibrary>
```

## 注意事項

### JSON の妥当性

- JSON 配列は有効な形式である必要があります
- 文字列内のエスケープを正しく行う
- 末尾のカンマに注意（JSON では許可されない）

### シェイプの ID

ライブラリ内のシェイプ ID は配置時に自動的に再割り当てされるため、固定値で問題ありません（例：`id="2"`）。

### バージョン互換性

古いバージョンの draw.io で作成したライブラリは新しいバージョンで動作しますが、その逆は保証されません。

---

[目次に戻る](../index.md) | [前へ: カスタムデータ](./custom-data.md) | [次へ: サンプル集](../examples.md)
