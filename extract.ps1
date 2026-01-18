# * index
#   セッション内の何往復目か（0始まり）

# * modelId
#   Copilot側のモデル識別子（例：`copilot/auto`, `copilot/gpt-5-mini`）
#   ※ `auto` の場合、実際に使われたモデルは別フィールド（`result.details` 等）にしか出ないことがある

# * responseKinds
#   Copilotのレスポンスが「どんな部品(kind)で構成されていたか」の集合

#   * `"<null>"`：通常の文章パート（kindが無い/NULLのパート）
#   * `thinking`：思考パート（ただし中身が空/暗号のことが多い）
#   * `toolInvocationSerialized`：ツール呼び出し（コードベース検索など）
#   * `inlineReference`：ファイル参照リンクが挿入された
#   * `mcpServersStarting`：内部サーバ起動系のイベント（UI/内部処理）

# * variableKinds
#   リクエストに付与された変数（コンテキスト）の種類
#   例：`file`（ファイル）、`tool`（ツール/機能）、`selection`（選択範囲）など
#   ※あなたの例だと、空のとき `{}` になってるけど、本来は配列 `[]` or 文字列の集合に揃えるのがおすすめ

# * variableNames
#   `variableData.variables[].name` の抜粋（人間向けの名前）
#   例：ファイル名、ツール名（「コードベース」）など
#   ※これも `{}` になってるケースがあるので、型は揃えるの推奨

# * thinking
#   `response` 内の `kind:"thinking"` の `value` を抽出したもの
#   実態としては空配列/空文字になりやすい（平文の思考が保存されないことが多い）

# * thinkingPresent
#   `responseKinds` に `thinking` が含まれていたか（思考パートが存在したか）

# * thinkingTokensTotal
#   thinking の token 数の合計（`result.metadata.toolCallRounds[].thinking.tokens` を合算した想定）

# * thinkingTokensMax
#   thinking の token 数の最大値（ラウンドごとの最大）

# * thinkingEncryptedPresent
#   thinking が暗号化された形で保存されていたか（`toolCallRounds[].thinking.encrypted` があるか）
#   ※暗号文のままでは復号できない前提で、「存在フラグ」として扱うのが現実的

# * user
#   ユーザー入力本文（元ログの `message.text`）

# * assistant
#   Copilotの通常返答本文（`response[]` のうち kindがnullの `value` を連結して復元）

# .\extract.ps1 -InputPath "in.json" -OutputPath "out.jsonl"


param(
  [Parameter(Mandatory=$true)]
  [string]$InputPath,

  [string]$OutputPath = ""
)

function Get-AgentTextFromResponseParts($parts) {
  if ($null -eq $parts) { return "" }

  $texts = @()
  foreach ($p in $parts) {
    $kind = $null
    if ($p.PSObject.Properties.Name -contains "kind") { $kind = $p.kind }

    # kind が null（または存在しない）で value があるものだけ連結 = 通常テキスト
    if (($null -eq $kind) -and ($p.PSObject.Properties.Name -contains "value") -and $null -ne $p.value) {
      $texts += [string]$p.value
    }
  }
  return ($texts -join "")
}

function Get-ResponseKinds($parts) {
  # 常に string[] を返す（空なら []）
  if ($null -eq $parts) { return @() }

  $kinds = @()
  foreach ($p in $parts) {
    if ($p.PSObject.Properties.Name -contains "kind") {
      if ($null -eq $p.kind) { $kinds += "<null>" } else { $kinds += [string]$p.kind }
    } else {
      $kinds += "<null>"
    }
  }
  return ($kinds | Sort-Object -Unique)
}

function Get-ThinkingParts($parts) {
  # 常に string[] を返す（空なら []）
  if ($null -eq $parts) { return @() }

  $thinking = @()
  foreach ($p in $parts) {
    if (($p.PSObject.Properties.Name -contains "kind") -and ($p.kind -eq "thinking")) {
      if (($p.PSObject.Properties.Name -contains "value") -and $null -ne $p.value) {
        # value が配列/文字列どっちでも来うるので吸収
        if ($p.value -is [System.Collections.IEnumerable] -and -not ($p.value -is [string])) {
          foreach ($x in $p.value) {
            if ($null -ne $x -and ([string]$x).Length -gt 0) { $thinking += [string]$x }
          }
        } else {
          $s = [string]$p.value
          if ($s.Length -gt 0) { $thinking += $s }
        }
      }
    }
  }
  return $thinking
}

function Get-VariableKinds($req) {
  # 常に string[] を返す（空なら []）
  if ($null -eq $req) { return @() }
  if (!($req.PSObject.Properties.Name -contains "variableData")) { return @() }
  if ($null -eq $req.variableData) { return @() }
  if (!($req.variableData.PSObject.Properties.Name -contains "variables")) { return @() }
  if ($null -eq $req.variableData.variables) { return @() }

  $kinds = @()
  foreach ($v in $req.variableData.variables) {
    if ($null -ne $v -and ($v.PSObject.Properties.Name -contains "kind") -and $null -ne $v.kind) {
      $kinds += [string]$v.kind
    }
  }
  return ($kinds | Sort-Object -Unique)
}

function Get-VariableNames($req) {
  # 常に string[] を返す（空なら []）
  if ($null -eq $req) { return @() }
  if (!($req.PSObject.Properties.Name -contains "variableData")) { return @() }
  if ($null -eq $req.variableData) { return @() }
  if (!($req.variableData.PSObject.Properties.Name -contains "variables")) { return @() }
  if ($null -eq $req.variableData.variables) { return @() }

  $names = @()
  foreach ($v in $req.variableData.variables) {
    if ($null -ne $v -and ($v.PSObject.Properties.Name -contains "name") -and $null -ne $v.name) {
      $names += [string]$v.name
    }
  }
  return ($names | Sort-Object -Unique)
}

function Get-ThinkingMetrics($req) {
  $metrics = [ordered]@{
    thinkingPresent = $false
    thinkingTokensTotal = 0
    thinkingTokensMax = 0
    thinkingEncryptedPresent = $false
  }

  # response parts に thinking があるか
  if ($req -and ($req.PSObject.Properties.Name -contains "response") -and $req.response) {
    foreach ($p in $req.response) {
      if (($p.PSObject.Properties.Name -contains "kind") -and ($p.kind -eq "thinking")) {
        $metrics.thinkingPresent = $true
        break
      }
    }
  }

  # toolCallRounds 内の thinking.tokens / encrypted（ある場合）
  try {
    $rounds = $req.result.metadata.toolCallRounds
    if ($rounds) {
      foreach ($r in $rounds) {
        if ($r.PSObject.Properties.Name -contains "thinking" -and $null -ne $r.thinking) {
          if ($r.thinking.PSObject.Properties.Name -contains "tokens" -and $null -ne $r.thinking.tokens) {
            $t = [int]$r.thinking.tokens
            $metrics.thinkingTokensTotal += $t
            if ($t -gt $metrics.thinkingTokensMax) { $metrics.thinkingTokensMax = $t }
          }
          if ($r.thinking.PSObject.Properties.Name -contains "encrypted" -and $null -ne $r.thinking.encrypted -and ([string]$r.thinking.encrypted).Length -gt 0) {
            $metrics.thinkingEncryptedPresent = $true
          }
        }
      }
    }
  } catch { }

  return $metrics
}

# --- Main ---
$jsonText = Get-Content -LiteralPath $InputPath -Raw -Encoding UTF8
$data = $jsonText | ConvertFrom-Json

$out = [ordered]@{
  sessionId = $data.sessionId
  interactions = @()
}

$idx = 0
foreach ($req in $data.requests) {
  $userText = ""
  if ($req.PSObject.Properties.Name -contains "message" -and $null -ne $req.message) {
    if ($req.message.PSObject.Properties.Name -contains "text") {
      $userText = [string]$req.message.text
    }
  }

  $modelId = if ($req.PSObject.Properties.Name -contains "modelId") { [string]$req.modelId } else { "" }

  $assistantText = Get-AgentTextFromResponseParts $req.response
  $responseKinds = Get-ResponseKinds $req.response
  $thinkingParts = Get-ThinkingParts $req.response

  $variableKinds = Get-VariableKinds $req
  $variableNames = Get-VariableNames $req

  $thinkingMetrics = Get-ThinkingMetrics $req

  $out.interactions += [ordered]@{
    index = $idx
    modelId = $modelId
    responseKinds = $responseKinds

    # ここが型揃え（常に配列）
    variableKinds = $variableKinds
    variableNames = $variableNames
    thinking = $thinkingParts

    thinkingPresent = $thinkingMetrics.thinkingPresent
    thinkingTokensTotal = $thinkingMetrics.thinkingTokensTotal
    thinkingTokensMax = $thinkingMetrics.thinkingTokensMax
    thinkingEncryptedPresent = $thinkingMetrics.thinkingEncryptedPresent

    user = $userText
    assistant = $assistantText
  }

  $idx++
}

# JSONL形式で出す（1 interaction = 1行）
$lines = @()
foreach ($i in $out.interactions) {
    $lines += ($i | ConvertTo-Json -Depth 10 -Compress)
}

$result = [ordered]@{
    sessionId = $out.sessionId
    interactions = $lines
}

if ($OutputPath -and $OutputPath.Trim() -ne "") {
    $lines | Set-Content -LiteralPath $OutputPath -Encoding UTF8
} else {
    $lines -join "`n"
}
