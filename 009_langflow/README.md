# 概要

Langflow を使用してみたサンプルコードです

~~また自作した MCP と連携するようにしています~~

# 開発環境作成方法

### 1. 環境変数の作成

`env`フォルダの中の`.env.XX.example`を参考してそれぞれ`.env.XX`を作成する

例)

`env/.env.langflow.example`を`env/.env.langflow`とコピーし中の値を適切に設定する

### 1. 以下のコマンド実行

```
make init
```

# 運用方法

## 1. ワークフローの Git 管理方法

LangFlow でワークフローを作成し Git に含めたい場合は、json 出力して`projects/langflow/imports`にセットする

git pull したあとは Docker を再起動する

```
make down
make restart
```

## 2. 環境変数について

`env/.env.langflow`でセットした OpenAI の API キーは UI 上の`Settings -> Global Variables -> OPENAI_API_KEY`の value には反映されていないですが、しっかりシステム上は反映されています
