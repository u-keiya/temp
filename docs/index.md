# draw.io XML リファレンス

draw.io（diagrams.net）で使用される `.drawio` ファイルフォーマットの日本語リファレンスです。

## このリファレンスについて

`.drawio` ファイルは XML 形式で記述されており、手動での作成・編集が可能です。このリファレンスでは、XML の構造を理解し、プログラムからの図の生成や細かな調整ができるようになることを目指します。

## 目次

### 基礎編

1. **[基本構造](./basic-structure.md)**
   - ファイル全体の構成（`mxfile`、`diagram`、`mxGraphModel`）
   - ルート要素と階層構造
   - レイヤーの仕組み

2. **[mxCell 要素](./mxcell.md)**
   - シェイプ（頂点）とコネクタ（辺）の表現
   - 主要な属性の解説
   - 親子関係とグループ化の基礎

3. **[ジオメトリ（位置とサイズ）](./geometry.md)**
   - `mxGeometry` 要素の使い方
   - 座標系と相対位置
   - コネクタの経路点（ウェイポイント）

### スタイル編

4. **[スタイル概要](./style/index.md)**
   - スタイル属性の書式
   - 共通パターン

5. **[シェイプのスタイル](./style/shape.md)**
   - 形状の指定（`shape`）
   - 塗りつぶし・枠線・影
   - 角丸・グラデーション

6. **[コネクタのスタイル](./style/edge.md)**
   - 経路スタイル（直線・直交・曲線）
   - 矢印の種類とサイズ
   - 接続点の指定

7. **[テキストのスタイル](./style/text.md)**
   - フォント設定
   - 配置とパディング
   - HTML ラベル

### 応用編

8. **[画像の埋め込み](./advanced/images.md)**
   - 画像シェイプの作成
   - Base64 エンコード
   - SVG の埋め込み

9. **[グループ化とコンテナ](./advanced/grouping.md)**
   - グループの作成
   - スイムレーン
   - 折りたたみ可能なコンテナ

10. **[カスタムデータ](./advanced/custom-data.md)**
    - `object` 要素によるメタデータ付与
    - データ属性の追加
    - コネクタへのデータ付与

11. **[カスタムライブラリ](./advanced/library.md)**
    - `mxlibrary` 形式
    - ライブラリエントリの構造
    - 独自シェイプの配布

### 実践編

12. **[サンプル集](./examples.md)**
    - 基本的な図形
    - フローチャート
    - ネットワーク図

13. **[Tips と注意点](./tips.md)**
    - ID の命名規則
    - よくあるエラーと対処法
    - 圧縮・エンコードの仕組み

## クイックスタート

最小限の `.drawio` ファイルは以下のような構造になります：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile>
  <diagram id="example" name="ページ1">
    <mxGraphModel>
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <!-- ここにシェイプやコネクタを追加 -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

詳細は[基本構造](./basic-structure.md)を参照してください。

## 動作確認方法

作成した XML は以下の方法で確認できます：

1. `.drawio` 拡張子で保存し、draw.io で開く
2. draw.io のメニューから **その他 > 図を編集** で XML を直接貼り付ける
3. VS Code の Draw.io Integration 拡張機能を使用する

## 参考リンク

- [draw.io 公式サイト](https://www.drawio.com/)
- [diagrams.net](https://app.diagrams.net/)（Web 版）
- [mxGraph ドキュメント](https://jgraph.github.io/mxgraph/)（draw.io の基盤ライブラリ）
