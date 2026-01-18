# Tips と注意点

[目次に戻る](./index.md) | [前へ: サンプル集](./examples.md)

---

`.drawio` ファイルを手動で作成・編集する際のヒントと注意事項をまとめます。

## ID の命名規則

### 必須の ID

| ID | 説明 | 変更可否 |
|----|------|:--------:|
| `0` | ルートセル | 不可 |
| `1` | デフォルトレイヤー | 不可 |

これらは必ず存在し、変更してはいけません。

### カスタム ID の付け方

```xml
<!-- 数字 ID（シンプル） -->
<mxCell id="2" .../>
<mxCell id="3" .../>

<!-- 意味のある ID（推奨） -->
<mxCell id="server1" .../>
<mxCell id="db-primary" .../>
<mxCell id="flow_start" .../>
```

**ルール：**
- 一意であること（重複禁止）
- `0` と `1` は使用しない
- 英数字、ハイフン、アンダースコアが使用可能
- スペースは避ける

### ID の重複に注意

ID が重複すると、予期しない動作が発生します：
- シェイプが表示されない
- コネクタが正しく接続されない
- 編集時にエラーが発生

## よくあるエラーと対処法

### 図が表示されない

**原因 1: ルートセルが欠けている**
```xml
<!-- 正しい -->
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>
  ...
</root>
```

**原因 2: parent 属性が不正**
```xml
<!-- 誤り: 存在しない親を参照 -->
<mxCell id="shape1" parent="999" .../>

<!-- 正しい -->
<mxCell id="shape1" parent="1" .../>
```

**原因 3: mxGeometry がない**
```xml
<!-- 誤り -->
<mxCell id="shape1" style="..." vertex="1" parent="1"/>

<!-- 正しい -->
<mxCell id="shape1" style="..." vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="120" height="60" as="geometry"/>
</mxCell>
```

### コネクタが表示されない

**原因: source/target が不正な ID を参照**
```xml
<!-- 誤り: 存在しないセルを参照 -->
<mxCell id="edge1" edge="1" source="nonexistent" target="shape1" .../>

<!-- 正しい -->
<mxCell id="edge1" edge="1" source="shape1" target="shape2" .../>
```

### XML パースエラー

**原因 1: エスケープ漏れ**
```xml
<!-- 誤り -->
<mxCell value="A & B" .../>

<!-- 正しい -->
<mxCell value="A &amp; B" .../>
```

**原因 2: 引用符の不一致**
```xml
<!-- 誤り -->
<mxCell value="text" style='rounded=0;' .../>

<!-- 正しい（どちらかに統一） -->
<mxCell value="text" style="rounded=0;" .../>
```

### スタイルが適用されない

**原因: セミコロンの欠落**
```xml
<!-- 誤り -->
<mxCell style="rounded=1fillColor=#dae8fc" .../>

<!-- 正しい -->
<mxCell style="rounded=1;fillColor=#dae8fc;" .../>
```

## 圧縮・エンコードの仕組み

### 非圧縮形式（推奨）

手動編集する場合は非圧縮形式を使用：

```xml
<mxfile compressed="false">
  <diagram id="..." name="ページ1">
    <mxGraphModel ...>
      <!-- 読み取り可能な XML -->
    </mxGraphModel>
  </diagram>
</mxfile>
```

### 圧縮形式

draw.io のデフォルト保存形式：

```xml
<mxfile compressed="true">
  <diagram id="..." name="ページ1">
    zVbfb5swEP5reOwUMBD2uKZZW2mb...（Base64 文字列）
  </diagram>
</mxfile>
```

### 圧縮の解除方法

**方法 1: draw.io で設定変更**
1. **ファイル** → **プロパティ**
2. **圧縮** のチェックを外す
3. ファイルを保存

**方法 2: プログラムで解凍**

```python
import zlib
import base64
import urllib.parse

def decompress_drawio(compressed_data):
    # URL デコード
    decoded = urllib.parse.unquote(compressed_data)
    # Base64 デコード
    binary = base64.b64decode(decoded)
    # zlib 解凍
    xml = zlib.decompress(binary, -15).decode('utf-8')
    return xml
```

## 特殊文字のエスケープ

### XML エスケープ

| 文字 | エスケープ |
|------|-----------|
| `<` | `&lt;` |
| `>` | `&gt;` |
| `&` | `&amp;` |
| `"` | `&quot;` |
| `'` | `&apos;` |

### value 属性内の HTML

```xml
<!-- 改行 -->
value="1行目&lt;br&gt;2行目"

<!-- 太字 -->
value="&lt;b&gt;重要&lt;/b&gt;"

<!-- 引用符を含むスタイル -->
value="&lt;font style=&quot;color:red&quot;&gt;赤&lt;/font&gt;"
```

## デバッグ方法

### XML の検証

1. `.drawio` ファイルを draw.io で開く
2. **その他** → **図を編集** で XML を確認
3. エラーがあれば修正

### ステップバイステップの構築

1. 最小限の構造から始める：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="test" name="テスト">
    <mxGraphModel>
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

2. 1 つずつシェイプを追加して動作確認
3. 問題が発生したら直前の変更を確認

### コンソールでのエラー確認

ブラウザ版 draw.io では、開発者ツールのコンソールでエラーを確認できます。

## パフォーマンスの考慮

### 大きなファイルの注意点

| 要素数 | パフォーマンス |
|--------|----------------|
| 〜100 | 問題なし |
| 100〜500 | やや重くなる可能性 |
| 500〜 | 分割を検討 |

### 最適化のヒント

1. **不要なセルを削除**
   - 使われていない非表示セル
   - 重複したスタイル定義

2. **画像の最適化**
   - 大きな画像は外部 URL を使用
   - 必要以上に高解像度の画像を避ける

3. **ページの分割**
   - 複雑な図は複数ページに分ける

## プログラムからの生成

### Python での生成例

```python
def create_shape(id, value, x, y, width, height, style="rounded=0;whiteSpace=wrap;html=1;"):
    return f'''<mxCell id="{id}" value="{value}" style="{style}" vertex="1" parent="1">
  <mxGeometry x="{x}" y="{y}" width="{width}" height="{height}" as="geometry"/>
</mxCell>'''

def create_edge(id, source, target, style="endArrow=classic;html=1;"):
    return f'''<mxCell id="{id}" style="{style}" edge="1" parent="1" source="{source}" target="{target}">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>'''

# 使用例
shapes = [
    create_shape("s1", "開始", 100, 100, 120, 60),
    create_shape("s2", "処理", 100, 200, 120, 60),
    create_edge("e1", "s1", "s2")
]

xml = f'''<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="generated" name="生成図">
    <mxGraphModel dx="800" dy="600" grid="1" gridSize="10" page="1" pageWidth="800" pageHeight="600">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        {"".join(shapes)}
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>'''

with open("generated.drawio", "w", encoding="utf-8") as f:
    f.write(xml)
```

### バリデーション

生成した XML を検証するためのチェックリスト：

- [ ] XML 宣言がある（`<?xml version="1.0" encoding="UTF-8"?>`）
- [ ] `mxfile` がルート要素
- [ ] `diagram` 要素に `id` と `name` がある
- [ ] `root` に `id="0"` と `id="1"` のセルがある
- [ ] すべてのシェイプに `mxGeometry` がある
- [ ] すべての ID が一意
- [ ] `parent` 属性が有効な ID を参照している
- [ ] コネクタの `source`/`target` が有効な ID を参照している

## 参考情報

### 公式リソース

- [draw.io ドキュメント](https://www.drawio.com/doc/)
- [mxGraph API リファレンス](https://jgraph.github.io/mxgraph/docs/js-api/files/model/mxCell-js.html)

### スタイルの調査方法

1. draw.io で目的のシェイプを作成
2. 右クリック → **スタイルを編集**
3. 表示されたスタイル文字列をコピー

---

[目次に戻る](./index.md) | [前へ: サンプル集](./examples.md)
