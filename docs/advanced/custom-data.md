# カスタムデータ

[目次に戻る](../index.md) | [前へ: グループ化とコンテナ](./grouping.md) | [次へ: カスタムライブラリ](./library.md)

---

draw.io では、シェイプやコネクタにカスタムデータ（メタデータ）を付与できます。これは「データを編集」機能で設定でき、XML では `object` 要素として表現されます。

## object 要素

カスタムデータを持つセルは、`mxCell` を `object` 要素でラップします。

### 基本構造

```xml
<object label="サーバー" id="server1" type="server" ip="192.168.1.1" status="active">
  <mxCell style="shape=cylinder;whiteSpace=wrap;html=1;"
          vertex="1" parent="1">
    <mxGeometry x="100" y="100" width="60" height="80" as="geometry"/>
  </mxCell>
</object>
```

### 属性の配置

| 場所 | 属性 |
|------|------|
| `object` | `id`, `label`, カスタムデータ |
| `mxCell` | `style`, `vertex`/`edge`, `parent`, `source`, `target` |

### 通常のセルとの違い

**通常のセル：**
```xml
<mxCell id="cell1" value="ラベル" style="..." vertex="1" parent="1">
  <mxGeometry ... />
</mxCell>
```

**カスタムデータ付きセル：**
```xml
<object id="cell1" label="ラベル" customAttr="value">
  <mxCell style="..." vertex="1" parent="1">
    <mxGeometry ... />
  </mxCell>
</object>
```

ポイント：
- `id` は `object` に移動
- `value` は `label` に名前変更
- カスタム属性は `object` の属性として追加
- 内部の `mxCell` には `id` がない

## カスタムデータの例

### サーバー情報

```xml
<object label="Web Server"
        id="webserver1"
        type="server"
        hostname="web01.example.com"
        ip="192.168.1.10"
        os="Ubuntu 22.04"
        status="running">
  <mxCell style="shape=cylinder;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;"
          vertex="1" parent="1">
    <mxGeometry x="100" y="100" width="80" height="100" as="geometry"/>
  </mxCell>
</object>
```

### ネットワーク機器

```xml
<object label="Router"
        id="router1"
        type="network"
        model="Cisco ASR 1000"
        location="DC-1"
        vlan="10,20,30">
  <mxCell style="shape=mxgraph.cisco.routers.router;html=1;"
          vertex="1" parent="1">
    <mxGeometry x="200" y="100" width="78" height="53" as="geometry"/>
  </mxCell>
</object>
```

### プロセスステップ

```xml
<object label="承認処理"
        id="approval1"
        type="process"
        owner="管理部"
        sla="2営業日"
        system="ワークフローシステム">
  <mxCell style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;"
          vertex="1" parent="1">
    <mxGeometry x="100" y="200" width="120" height="60" as="geometry"/>
  </mxCell>
</object>
```

## コネクタへのカスタムデータ

コネクタにもカスタムデータを付与できます。

```xml
<object label="データ連携"
        id="dataflow1"
        type="dataflow"
        protocol="REST API"
        frequency="リアルタイム"
        encryption="TLS 1.3">
  <mxCell style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;
                 jettySize=auto;html=1;endArrow=classic;"
          edge="1" parent="1" source="server1" target="server2">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>
</object>
```

## ラベルの動的表示

`label` 属性では、プレースホルダーを使用してカスタムデータを表示できます：

```xml
<object label="%hostname%&lt;br&gt;%ip%"
        id="server1"
        hostname="web01"
        ip="192.168.1.10">
  ...
</object>
```

この例では、ラベルに「web01」と「192.168.1.10」が改行区切りで表示されます。

### プレースホルダーの書式

```
%属性名%
```

HTML と組み合わせ可能：
```
label="&lt;b&gt;%name%&lt;/b&gt;&lt;br&gt;IP: %ip%"
```

## draw.io での操作

### データの追加方法

1. シェイプを選択
2. 右クリック → **データを編集** または
3. メニュー → **編集** → **データを編集**

### データの表示

1. シェイプを選択
2. 右パネルの「プロパティ」で確認

## 複数セルへのデータ付与

グループ内の各シェイプに個別のデータを付与できます：

```xml
<!-- グループ -->
<mxCell id="group1" style="group" vertex="1" connectable="0" parent="1">
  <mxGeometry x="50" y="50" width="300" height="200" as="geometry"/>
</mxCell>

<!-- データ付きシェイプ1 -->
<object label="DB1" id="db1" role="primary" version="15.2">
  <mxCell style="shape=cylinder;whiteSpace=wrap;html=1;"
          vertex="1" parent="group1">
    <mxGeometry x="10" y="10" width="60" height="80" as="geometry"/>
  </mxCell>
</object>

<!-- データ付きシェイプ2 -->
<object label="DB2" id="db2" role="replica" version="15.2">
  <mxCell style="shape=cylinder;whiteSpace=wrap;html=1;"
          vertex="1" parent="group1">
    <mxGeometry x="100" y="10" width="60" height="80" as="geometry"/>
  </mxCell>
</object>
```

## データの活用例

### 自動生成ツールとの連携

カスタムデータを使用して、外部ツールから図を生成したり、図からデータを抽出したりできます：

```python
import xml.etree.ElementTree as ET

# XMLを解析
tree = ET.parse('diagram.drawio')
root = tree.getroot()

# objectタグを検索してデータを抽出
for obj in root.iter('object'):
    label = obj.get('label', '')
    obj_type = obj.get('type', '')
    ip = obj.get('ip', '')

    if obj_type == 'server':
        print(f"Server: {label}, IP: {ip}")
```

### ドキュメント生成

図からカスタムデータを抽出して、ドキュメントを自動生成：

```python
# サーバー一覧を生成
servers = []
for obj in root.iter('object'):
    if obj.get('type') == 'server':
        servers.append({
            'name': obj.get('label'),
            'hostname': obj.get('hostname'),
            'ip': obj.get('ip'),
            'os': obj.get('os')
        })

# Markdown表形式で出力
print("| 名前 | ホスト名 | IP | OS |")
print("|------|----------|----|----|")
for s in servers:
    print(f"| {s['name']} | {s['hostname']} | {s['ip']} | {s['os']} |")
```

## 注意事項

### 属性名の制約

- 属性名に使用できる文字：英数字、アンダースコア、ハイフン
- `id`, `label` は予約済み
- スペースや特殊文字は避ける

### 値のエスケープ

XML 属性内の特殊文字はエスケープが必要：

| 文字 | エスケープ |
|------|-----------|
| `<` | `&lt;` |
| `>` | `&gt;` |
| `&` | `&amp;` |
| `"` | `&quot;` |
| `'` | `&apos;` |

```xml
<object label="Server &amp; Client" note="Size &gt; 100MB" ...>
```

---

[目次に戻る](../index.md) | [前へ: グループ化とコンテナ](./grouping.md) | [次へ: カスタムライブラリ](./library.md)
