
({
  onDidParseMarkdown: async function (html) {
    // PoC: コメントデータを一時的にここに定義する。
    // JSONファイルとの連携はVS Code拡張機能で実装する。
    const comments = [
      { id: 'c1', tag: 'p', text: 'Logic層は外部システムに依存しない。', comment: '外部依存を排除するための設計判断です。', resolved: false },
      { id: 'c2', tag: 'p', text: 'Controller層は外部入力を担当する。', comment: '例外の変換もController側に寄せる想定です。', resolved: false }
    ];
    const escapeHtml = (s) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    for (const item of comments) {
      if (item.resolved) continue;
      // 検証用の厳密一致。Markdown装飾や同一文の重複は未対応。
      const escaped = escapeHtml(item.text);
      const target = `<${item.tag}>${escaped}</${item.tag}>`;
      const replacement = `<${item.tag} class="review-highlight" data-review-id="${escapeHtml(item.id)}">${escaped}</${item.tag}>` +
        `<aside class="review-comment"><strong>AI解説</strong><p>${escapeHtml(item.comment)}</p></aside>`;
      html = html.replace(target, replacement);
    }
    return html;
  }
});




.markdown-preview.markdown-preview {
  .review-highlight {
    background: rgba(234, 179, 8, 0.16);

  border-left: 3px solid #d6a100;
    padding: 0.35em 0.65em;
    border-radius: 3px;
  }
  .review-comment {
    margin: 0.4em 0 1.2em 1.2em;
    padding: 0.6em 0.9em;
    border-left: 3px solid #64748b;
    background: rgba(100, 116, 139, 0.09);
    border-radius: 4px;
  }
  .review-comment p { margin: 0.3em 0 0; }
}




# 通知処理の設計

## 3. 通知処理の責務分離

通知処理は以下の責務に分割する。

Logic層は外部システムに依存しない。

Controller層は外部入力を担当する。




{
  "document": "design.md",
  "comments": [
    {
      "id": "c1",
      "anchor": {
        "text": "Logic層は外部システムに依存しない。",
        "heading": "3. 通知処理の責務分離"
      },
      "comment": "外部依存を排除するための設計判断です。",
      "resolved": false
    },
    {
      "id": "c2",
      "anchor": {
        "text": "Controller層は外部入力を担当する。",
        "heading": "3. 通知処理の責務分離"
      },
      "comment": "例外の変換もController側に寄せる想定です。",
      "resolved": false
    }
  ]
}




# MPEレビュー表示PoC

## 手順

1. このフォルダをVS Codeで開く。
2. Markdown Preview Enhanced拡張機能を有効にする。
3. `design.md` を開いて
   `Markdown Preview Enhanced: Open Preview to the Side`
   を実行する。
4. `Markdown Preview Enhanced: Extend Parser (Workspace)`
   でワークスペースの `.crossnote/parser.js` を認識させ、
   必要に応じてプレビューを再読み込みする。
5. `Markdown Preview Enhanced: Customize CSS (Workspace)`
   で `.crossnote/style.less` を認識させ、
   プレビューを更新する。

## 現在の範囲

- parser.js 内の固定コメント2件を、HTML変換後に
  一致した段落へ挿入する。
- Markdown自体は変更しない。
- comments.json は将来のデータ形式の見本であり、
  現時点では読み込まない。
- 解決ボタン、JSON書き戻し、複数一致の曖昧性解決、
  複雑なMarkdown構文は未実装。
- MPEのバージョンやHTML出力によって、
  段落の厳密一致が失敗する可能性がある。

## 次の段階

markdown-it のトークンとソース位置情報を使って
ブロック単位のアンカー解決を実装し、
VS Code拡張機能側でJSONの読み書きを担当する。
