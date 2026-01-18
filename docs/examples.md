# サンプル集

[目次に戻る](./index.md) | [前へ: カスタムライブラリ](./advanced/library.md) | [次へ: Tips と注意点](./tips.md)

---

実用的な図のサンプル XML を紹介します。これらをコピーして `.drawio` ファイルとして保存し、draw.io で開くことができます。

## シンプルなフローチャート

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="flowchart-simple" name="フローチャート">
    <mxGraphModel dx="800" dy="600" grid="1" gridSize="10" guides="1"
                  page="1" pageWidth="800" pageHeight="600">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>

        <!-- 開始 -->
        <mxCell id="start" value="開始"
                style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;"
                vertex="1" parent="1">
          <mxGeometry x="340" y="40" width="80" height="40" as="geometry"/>
        </mxCell>

        <!-- 処理1 -->
        <mxCell id="process1" value="データ入力"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="320" y="120" width="120" height="60" as="geometry"/>
        </mxCell>

        <!-- 判断 -->
        <mxCell id="decision" value="有効?"
                style="rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;"
                vertex="1" parent="1">
          <mxGeometry x="340" y="220" width="80" height="80" as="geometry"/>
        </mxCell>

        <!-- 処理2 -->
        <mxCell id="process2" value="処理実行"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="320" y="340" width="120" height="60" as="geometry"/>
        </mxCell>

        <!-- エラー処理 -->
        <mxCell id="error" value="エラー表示"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;"
                vertex="1" parent="1">
          <mxGeometry x="500" y="240" width="100" height="40" as="geometry"/>
        </mxCell>

        <!-- 終了 -->
        <mxCell id="end" value="終了"
                style="ellipse;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;"
                vertex="1" parent="1">
          <mxGeometry x="340" y="440" width="80" height="40" as="geometry"/>
        </mxCell>

        <!-- コネクタ: 開始 → 処理1 -->
        <mxCell id="e1" style="endArrow=classic;html=1;"
                edge="1" parent="1" source="start" target="process1">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>

        <!-- コネクタ: 処理1 → 判断 -->
        <mxCell id="e2" style="endArrow=classic;html=1;"
                edge="1" parent="1" source="process1" target="decision">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>

        <!-- コネクタ: 判断 → 処理2 (Yes) -->
        <mxCell id="e3" value="Yes"
                style="endArrow=classic;html=1;labelBackgroundColor=#ffffff;"
                edge="1" parent="1" source="decision" target="process2">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>

        <!-- コネクタ: 判断 → エラー (No) -->
        <mxCell id="e4" value="No"
                style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;
                       jettySize=auto;html=1;endArrow=classic;
                       labelBackgroundColor=#ffffff;
                       exitX=1;exitY=0.5;exitDx=0;exitDy=0;"
                edge="1" parent="1" source="decision" target="error">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>

        <!-- コネクタ: エラー → 処理1 (ループバック) -->
        <mxCell id="e5"
                style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;
                       jettySize=auto;html=1;endArrow=classic;dashed=1;"
                edge="1" parent="1" source="error" target="process1">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="550" y="150"/>
            </Array>
          </mxGeometry>
        </mxCell>

        <!-- コネクタ: 処理2 → 終了 -->
        <mxCell id="e6" style="endArrow=classic;html=1;"
                edge="1" parent="1" source="process2" target="end">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## シーケンス図風

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="sequence" name="シーケンス">
    <mxGraphModel dx="800" dy="600" grid="1" gridSize="10" guides="1"
                  page="1" pageWidth="800" pageHeight="500">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>

        <!-- アクター: クライアント -->
        <mxCell id="client" value="クライアント"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="100" y="40" width="100" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="clientLine"
                style="endArrow=none;dashed=1;html=1;strokeWidth=2;"
                edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="150" y="80" as="sourcePoint"/>
            <mxPoint x="150" y="400" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- アクター: サーバー -->
        <mxCell id="server" value="サーバー"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;"
                vertex="1" parent="1">
          <mxGeometry x="350" y="40" width="100" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="serverLine"
                style="endArrow=none;dashed=1;html=1;strokeWidth=2;"
                edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="400" y="80" as="sourcePoint"/>
            <mxPoint x="400" y="400" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- アクター: データベース -->
        <mxCell id="db" value="データベース"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;"
                vertex="1" parent="1">
          <mxGeometry x="600" y="40" width="100" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="dbLine"
                style="endArrow=none;dashed=1;html=1;strokeWidth=2;"
                edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="650" y="80" as="sourcePoint"/>
            <mxPoint x="650" y="400" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- メッセージ1: リクエスト -->
        <mxCell id="msg1" value="1. HTTPリクエスト"
                style="endArrow=classic;html=1;strokeWidth=2;"
                edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="150" y="120" as="sourcePoint"/>
            <mxPoint x="400" y="120" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- メッセージ2: DBクエリ -->
        <mxCell id="msg2" value="2. SQLクエリ"
                style="endArrow=classic;html=1;strokeWidth=2;"
                edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="400" y="180" as="sourcePoint"/>
            <mxPoint x="650" y="180" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- メッセージ3: DB応答 -->
        <mxCell id="msg3" value="3. 結果"
                style="endArrow=classic;html=1;dashed=1;strokeWidth=2;"
                edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="650" y="240" as="sourcePoint"/>
            <mxPoint x="400" y="240" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- メッセージ4: レスポンス -->
        <mxCell id="msg4" value="4. HTTPレスポンス"
                style="endArrow=classic;html=1;dashed=1;strokeWidth=2;"
                edge="1" parent="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="400" y="300" as="sourcePoint"/>
            <mxPoint x="150" y="300" as="targetPoint"/>
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## ネットワーク構成図

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="network" name="ネットワーク">
    <mxGraphModel dx="800" dy="600" grid="1" gridSize="10" guides="1"
                  page="1" pageWidth="800" pageHeight="600">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>

        <!-- インターネット -->
        <mxCell id="internet" value="インターネット"
                style="ellipse;shape=cloud;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;"
                vertex="1" parent="1">
          <mxGeometry x="320" y="20" width="120" height="80" as="geometry"/>
        </mxCell>

        <!-- ファイアウォール -->
        <mxCell id="firewall" value="FW"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;"
                vertex="1" parent="1">
          <mxGeometry x="355" y="140" width="50" height="40" as="geometry"/>
        </mxCell>

        <!-- ロードバランサー -->
        <mxCell id="lb" value="LB"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#ffe6cc;strokeColor=#d79b00;"
                vertex="1" parent="1">
          <mxGeometry x="340" y="220" width="80" height="40" as="geometry"/>
        </mxCell>

        <!-- Webサーバー1 -->
        <mxCell id="web1" value="Web1"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="200" y="320" width="80" height="60" as="geometry"/>
        </mxCell>

        <!-- Webサーバー2 -->
        <mxCell id="web2" value="Web2"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="340" y="320" width="80" height="60" as="geometry"/>
        </mxCell>

        <!-- Webサーバー3 -->
        <mxCell id="web3" value="Web3"
                style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="480" y="320" width="80" height="60" as="geometry"/>
        </mxCell>

        <!-- データベース -->
        <mxCell id="database" value="DB"
                style="shape=cylinder;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;"
                vertex="1" parent="1">
          <mxGeometry x="350" y="440" width="60" height="80" as="geometry"/>
        </mxCell>

        <!-- 接続線 -->
        <mxCell id="c1" style="endArrow=classic;startArrow=classic;html=1;"
                edge="1" parent="1" source="internet" target="firewall">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c2" style="endArrow=classic;startArrow=classic;html=1;"
                edge="1" parent="1" source="firewall" target="lb">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c3" style="endArrow=classic;startArrow=classic;html=1;"
                edge="1" parent="1" source="lb" target="web1">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c4" style="endArrow=classic;startArrow=classic;html=1;"
                edge="1" parent="1" source="lb" target="web2">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c5" style="endArrow=classic;startArrow=classic;html=1;"
                edge="1" parent="1" source="lb" target="web3">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c6" style="endArrow=classic;startArrow=classic;html=1;"
                edge="1" parent="1" source="web1" target="database">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c7" style="endArrow=classic;startArrow=classic;html=1;"
                edge="1" parent="1" source="web2" target="database">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c8" style="endArrow=classic;startArrow=classic;html=1;"
                edge="1" parent="1" source="web3" target="database">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## クラス図風

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="class" name="クラス図">
    <mxGraphModel dx="800" dy="600" grid="1" gridSize="10" guides="1"
                  page="1" pageWidth="800" pageHeight="600">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>

        <!-- クラス: User -->
        <mxCell id="userClass" value=""
                style="swimlane;fontStyle=1;align=center;verticalAlign=top;
                       childLayout=stackLayout;horizontal=1;startSize=26;
                       horizontalStack=0;resizeParent=1;resizeParentMax=0;
                       resizeLast=0;collapsible=0;marginBottom=0;
                       fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="100" y="100" width="160" height="130" as="geometry"/>
        </mxCell>
        <mxCell id="userTitle" value="User"
                style="text;strokeColor=none;fillColor=none;align=center;
                       verticalAlign=middle;spacingLeft=4;spacingRight=4;
                       overflow=hidden;rotatable=0;fontStyle=1;"
                vertex="1" parent="userClass">
          <mxGeometry y="0" width="160" height="26" as="geometry"/>
        </mxCell>
        <mxCell id="userAttrs" value="- id: int&#xa;- name: string&#xa;- email: string"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;spacingRight=4;
                       overflow=hidden;rotatable=0;whiteSpace=wrap;html=0;"
                vertex="1" parent="userClass">
          <mxGeometry y="26" width="160" height="52" as="geometry"/>
        </mxCell>
        <mxCell id="userMethods" value="+ login()&#xa;+ logout()"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;spacingRight=4;
                       overflow=hidden;rotatable=0;whiteSpace=wrap;html=0;"
                vertex="1" parent="userClass">
          <mxGeometry y="78" width="160" height="52" as="geometry"/>
        </mxCell>

        <!-- クラス: Order -->
        <mxCell id="orderClass" value=""
                style="swimlane;fontStyle=1;align=center;verticalAlign=top;
                       childLayout=stackLayout;horizontal=1;startSize=26;
                       horizontalStack=0;resizeParent=1;resizeParentMax=0;
                       resizeLast=0;collapsible=0;marginBottom=0;
                       fillColor=#d5e8d4;strokeColor=#82b366;"
                vertex="1" parent="1">
          <mxGeometry x="350" y="100" width="160" height="130" as="geometry"/>
        </mxCell>
        <mxCell id="orderTitle" value="Order"
                style="text;strokeColor=none;fillColor=none;align=center;
                       verticalAlign=middle;spacingLeft=4;spacingRight=4;
                       overflow=hidden;rotatable=0;fontStyle=1;"
                vertex="1" parent="orderClass">
          <mxGeometry y="0" width="160" height="26" as="geometry"/>
        </mxCell>
        <mxCell id="orderAttrs" value="- id: int&#xa;- userId: int&#xa;- total: decimal"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;spacingRight=4;
                       overflow=hidden;rotatable=0;whiteSpace=wrap;html=0;"
                vertex="1" parent="orderClass">
          <mxGeometry y="26" width="160" height="52" as="geometry"/>
        </mxCell>
        <mxCell id="orderMethods" value="+ create()&#xa;+ cancel()"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;spacingRight=4;
                       overflow=hidden;rotatable=0;whiteSpace=wrap;html=0;"
                vertex="1" parent="orderClass">
          <mxGeometry y="78" width="160" height="52" as="geometry"/>
        </mxCell>

        <!-- 関連: User 1 --- * Order -->
        <mxCell id="relation1" value="1        *"
                style="endArrow=none;html=1;
                       exitX=1;exitY=0.5;exitDx=0;exitDy=0;
                       entryX=0;entryY=0.5;entryDx=0;entryDy=0;"
                edge="1" parent="1" source="userClass" target="orderClass">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## ER 図

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="er" name="ER図">
    <mxGraphModel dx="800" dy="600" grid="1" gridSize="10" guides="1"
                  page="1" pageWidth="800" pageHeight="600">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>

        <!-- エンティティ: users -->
        <mxCell id="users" value="users"
                style="swimlane;fontStyle=1;align=center;verticalAlign=top;
                       childLayout=stackLayout;horizontal=1;startSize=26;
                       fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="100" y="150" width="140" height="104" as="geometry"/>
        </mxCell>
        <mxCell id="users_id" value="id (PK)"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;fontStyle=4;"
                vertex="1" parent="users">
          <mxGeometry y="26" width="140" height="26" as="geometry"/>
        </mxCell>
        <mxCell id="users_name" value="name"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;"
                vertex="1" parent="users">
          <mxGeometry y="52" width="140" height="26" as="geometry"/>
        </mxCell>
        <mxCell id="users_email" value="email"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;"
                vertex="1" parent="users">
          <mxGeometry y="78" width="140" height="26" as="geometry"/>
        </mxCell>

        <!-- エンティティ: orders -->
        <mxCell id="orders" value="orders"
                style="swimlane;fontStyle=1;align=center;verticalAlign=top;
                       childLayout=stackLayout;horizontal=1;startSize=26;
                       fillColor=#d5e8d4;strokeColor=#82b366;"
                vertex="1" parent="1">
          <mxGeometry x="350" y="150" width="140" height="130" as="geometry"/>
        </mxCell>
        <mxCell id="orders_id" value="id (PK)"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;fontStyle=4;"
                vertex="1" parent="orders">
          <mxGeometry y="26" width="140" height="26" as="geometry"/>
        </mxCell>
        <mxCell id="orders_user_id" value="user_id (FK)"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;fontStyle=2;"
                vertex="1" parent="orders">
          <mxGeometry y="52" width="140" height="26" as="geometry"/>
        </mxCell>
        <mxCell id="orders_total" value="total"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;"
                vertex="1" parent="orders">
          <mxGeometry y="78" width="140" height="26" as="geometry"/>
        </mxCell>
        <mxCell id="orders_date" value="created_at"
                style="text;strokeColor=none;fillColor=none;align=left;
                       verticalAlign=top;spacingLeft=4;"
                vertex="1" parent="orders">
          <mxGeometry y="104" width="140" height="26" as="geometry"/>
        </mxCell>

        <!-- リレーション: users 1 ── 0..* orders -->
        <mxCell id="rel_users_orders"
                style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;
                       jettySize=auto;html=1;
                       endArrow=ERoneToMany;startArrow=ERone;
                       endFill=0;startFill=0;"
                edge="1" parent="1" source="users" target="orders">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## 組織図

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile compressed="false">
  <diagram id="org" name="組織図">
    <mxGraphModel dx="800" dy="600" grid="1" gridSize="10" guides="1"
                  page="1" pageWidth="800" pageHeight="600">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>

        <!-- CEO -->
        <mxCell id="ceo" value="&lt;b&gt;CEO&lt;/b&gt;&lt;br&gt;山田 太郎"
                style="rounded=1;whiteSpace=wrap;html=1;
                       fillColor=#dae8fc;strokeColor=#6c8ebf;"
                vertex="1" parent="1">
          <mxGeometry x="320" y="40" width="120" height="50" as="geometry"/>
        </mxCell>

        <!-- CTO -->
        <mxCell id="cto" value="&lt;b&gt;CTO&lt;/b&gt;&lt;br&gt;佐藤 花子"
                style="rounded=1;whiteSpace=wrap;html=1;
                       fillColor=#d5e8d4;strokeColor=#82b366;"
                vertex="1" parent="1">
          <mxGeometry x="160" y="140" width="120" height="50" as="geometry"/>
        </mxCell>

        <!-- CFO -->
        <mxCell id="cfo" value="&lt;b&gt;CFO&lt;/b&gt;&lt;br&gt;鈴木 一郎"
                style="rounded=1;whiteSpace=wrap;html=1;
                       fillColor=#d5e8d4;strokeColor=#82b366;"
                vertex="1" parent="1">
          <mxGeometry x="480" y="140" width="120" height="50" as="geometry"/>
        </mxCell>

        <!-- 開発部長 -->
        <mxCell id="dev_mgr" value="開発部長&lt;br&gt;田中 次郎"
                style="rounded=1;whiteSpace=wrap;html=1;
                       fillColor=#fff2cc;strokeColor=#d6b656;"
                vertex="1" parent="1">
          <mxGeometry x="60" y="240" width="100" height="50" as="geometry"/>
        </mxCell>

        <!-- インフラ部長 -->
        <mxCell id="infra_mgr" value="インフラ部長&lt;br&gt;高橋 三郎"
                style="rounded=1;whiteSpace=wrap;html=1;
                       fillColor=#fff2cc;strokeColor=#d6b656;"
                vertex="1" parent="1">
          <mxGeometry x="180" y="240" width="100" height="50" as="geometry"/>
        </mxCell>

        <!-- 経理部長 -->
        <mxCell id="acc_mgr" value="経理部長&lt;br&gt;伊藤 美咲"
                style="rounded=1;whiteSpace=wrap;html=1;
                       fillColor=#fff2cc;strokeColor=#d6b656;"
                vertex="1" parent="1">
          <mxGeometry x="480" y="240" width="100" height="50" as="geometry"/>
        </mxCell>

        <!-- 接続線 -->
        <mxCell id="l1" style="endArrow=none;html=1;"
                edge="1" parent="1" source="ceo" target="cto">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="l2" style="endArrow=none;html=1;"
                edge="1" parent="1" source="ceo" target="cfo">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="l3" style="endArrow=none;html=1;"
                edge="1" parent="1" source="cto" target="dev_mgr">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="l4" style="endArrow=none;html=1;"
                edge="1" parent="1" source="cto" target="infra_mgr">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="l5" style="endArrow=none;html=1;"
                edge="1" parent="1" source="cfo" target="acc_mgr">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

[目次に戻る](./index.md) | [前へ: カスタムライブラリ](./advanced/library.md) | [次へ: Tips と注意点](./tips.md)
