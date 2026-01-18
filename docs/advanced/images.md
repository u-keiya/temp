# 画像の埋め込み

[目次に戻る](../index.md) | [前へ: テキストのスタイル](../style/text.md) | [次へ: グループ化とコンテナ](./grouping.md)

---

draw.io では、画像をシェイプとして配置できます。外部 URL または Base64 エンコードされたデータとして埋め込むことができます。

## 基本構造

画像シェイプは `shape=image` スタイルを使用します：

```xml
<mxCell id="img1" value=""
        style="shape=image;image=...;aspect=fixed;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="100" height="100" as="geometry"/>
</mxCell>
```

## image 属性

### 外部 URL

```
image=https://example.com/image.png;
```

### Base64 エンコード（PNG）

```
image=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...;
```

### Base64 エンコード（JPEG）

```
image=data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABI...;
```

### SVG（インライン）

```
image=data:image/svg+xml,...;
```

## 画像スタイルの属性

### aspect

| 値 | 説明 |
|----|------|
| `fixed` | アスペクト比を維持 |
| （未指定） | 自由に変形可能 |

```
aspect=fixed;
```

### imageAspect

内部フラグ。通常は `aspect=fixed` と共に `imageAspect=0` を使用：

```
aspect=fixed;imageAspect=0;
```

### imageBorder

画像の枠線色：

```
imageBorder=#000000;
```

### imageBackground

画像の背景色（透明部分に表示）：

```
imageBackground=#ffffff;
```

## ラベル位置

画像にキャプションを付ける場合：

```
verticalLabelPosition=bottom;verticalAlign=top;
```

この設定で、ラベルが画像の下に表示されます。

## 完全な例

### 外部画像

```xml
<mxCell id="extImg" value="ロゴ"
        style="shape=image;aspect=fixed;imageAspect=0;
               image=https://example.com/logo.png;
               verticalLabelPosition=bottom;verticalAlign=top;"
        vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="80" height="80" as="geometry"/>
</mxCell>
```

### Base64 埋め込み画像（PNG）

```xml
<mxCell id="b64Img" value=""
        style="shape=image;aspect=fixed;imageAspect=0;
               image=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==;"
        vertex="1" parent="1">
  <mxGeometry x="200" y="100" width="50" height="50" as="geometry"/>
</mxCell>
```

### SVG 埋め込み

SVG を直接埋め込む場合は URL エンコードが必要です：

```xml
<mxCell id="svgImg" value=""
        style="shape=image;aspect=fixed;
               image=data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2224%22%20height%3D%2224%22%20viewBox%3D%220%200%2024%2024%22%3E%3Ccircle%20cx%3D%2212%22%20cy%3D%2212%22%20r%3D%2210%22%20fill%3D%22%23007bff%22%2F%3E%3C%2Fsvg%3E;"
        vertex="1" parent="1">
  <mxGeometry x="300" y="100" width="48" height="48" as="geometry"/>
</mxCell>
```

## Base64 エンコードの方法

### コマンドライン（Linux/Mac）

```bash
base64 -w 0 image.png
```

### Python

```python
import base64

with open("image.png", "rb") as f:
    encoded = base64.b64encode(f.read()).decode("utf-8")
print(f"data:image/png;base64,{encoded}")
```

### JavaScript

```javascript
const fs = require('fs');
const data = fs.readFileSync('image.png');
const base64 = data.toString('base64');
console.log(`data:image/png;base64,${base64}`);
```

## SVG のエンコード

### URL エンコード（推奨）

```python
import urllib.parse

svg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><circle cx="12" cy="12" r="10" fill="#007bff"/></svg>'
encoded = urllib.parse.quote(svg, safe='')
print(f"data:image/svg+xml,{encoded}")
```

### Base64 エンコード

```python
import base64

svg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><circle cx="12" cy="12" r="10" fill="#007bff"/></svg>'
encoded = base64.b64encode(svg.encode('utf-8')).decode('utf-8')
print(f"data:image/svg+xml;base64,{encoded}")
```

## 注意点

### ファイルサイズ

Base64 エンコードされた画像はファイルサイズを約 33% 増加させます。大きな画像を多数埋め込むと、`.drawio` ファイルが非常に大きくなる可能性があります。

### 外部 URL の制限

- CORS の制限により、一部の外部画像は表示されない場合があります
- ネットワーク接続がない環境では外部画像は表示されません
- 画像 URL が変更されると図が壊れます

### 推奨事項

| シナリオ | 推奨方法 |
|----------|----------|
| 配布用の図 | Base64 埋め込み |
| 社内共有 | 外部 URL（社内サーバー） |
| 小さいアイコン | SVG または Base64 |
| 大きな写真 | 外部 URL |

## アイコンライブラリの利用

draw.io には多くの組み込みアイコンがあります。これらは `shape=mxgraph.xxx` の形式で指定できます：

```
shape=mxgraph.aws4.compute;
shape=mxgraph.azure.compute;
shape=mxgraph.gcp2.compute_engine;
```

組み込みアイコンを使用する方が、画像を埋め込むよりもファイルサイズを小さく保てます。

---

[目次に戻る](../index.md) | [前へ: テキストのスタイル](../style/text.md) | [次へ: グループ化とコンテナ](./grouping.md)
