from __future__ import annotations

import logging
from typing import Final

from mcp.server.fastmcp import FastMCP

# -----------------------------------------------------------------------------
# 設定（ログは stdout ではなく stderr に出す：MCP/STDIO では重要）
# 参考: 公式ガイドのベストプラクティス（print禁止・logging推奨）
# https://modelcontextprotocol.io/docs/develop/build-server
# -----------------------------------------------------------------------------
logging.basicConfig(level=logging.INFO)

# -----------------------------------------------------------------------------
# MCP サーバー本体
# FastMCP は関数の型ヒントと docstring から自動的にツール定義を生成します。
# -----------------------------------------------------------------------------
SERVER_NAME: Final[str] = "hello"
mcp: FastMCP = FastMCP(SERVER_NAME)


@mcp.tool()
def greet(name: str) -> str:
    """
    指定した名前に挨拶します。

    Args:
        name: 挨拶する相手の名前。
    Returns:
        "Hello, <name>!" の形式の挨拶文。
    """
    return f"Hello, {name}!"


@mcp.tool()
def add(a: float, b: float) -> float:
    """
    2つの数値を加算します。

    Args:
        a: 1つ目の数値。
        b: 2つ目の数値。
    Returns:
        a と b の合計（float）。
    """
    return a + b


# もしリソースやプロンプトを足したくなったら以下のように拡張できます:
# @mcp.resource("about")
# def about() -> str:
#     """サーバーの簡単な説明文を返します。"""
#     return "This is a minimal MCP server exposing greet and add tools."

# -----------------------------------------------------------------------------
# エントリポイント
# 公式クイックスタート通り、stdio トランスポートで起動します。
# -----------------------------------------------------------------------------
def main() -> None:
    """
    MCP サーバーを STDIO トランスポートで起動します。

    Returns:
        なし
    """
    # 注意: 標準出力に任意の文字列を出さないこと（JSON-RPC が壊れます）
    # 公式の examples でも mcp.run(transport='stdio') で起動します。
    mcp.run(transport="stdio")


if __name__ == "__main__":
    main()
