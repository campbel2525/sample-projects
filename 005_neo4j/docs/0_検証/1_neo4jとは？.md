# Neo4j とは？

- グラフ理論を用いた DB です

# 名称まとめ

- https://neo4j.com/docs/getting-started/appendix/graphdb-concepts/?utm_source=chatgpt.com

関係表(gpt より)

| 概念レベル (ER モデル) | Neo4j / Cypher 上の呼び方 | 例                   |
| ---------------------- | ------------------------- | -------------------- |
| エンティティ           | ノード                    | `(a:Person {…})`     |
| 属性                   | プロパティ                | `a.name` / `a.age`   |
| リレーション           | リレーション              | `()-[:LIVES_IN]->()` |

名称の図(Neo4j の画面)

- 画面に表示されるエンティティは代表的なもの(id, name, title,,,)が１つ表示されるっぽい(gpt)

<img width="310" height="267" alt="スクリーンショット 2025-08-02 3 01 00" src="https://github.com/user-attachments/assets/db4f9d65-2d42-48d9-b51e-dcc0fd397fe0" />

# サンプルクエリ

サンプルクエリを事項して Neo4j の動きを確認してみます

作成

- 映画と出演俳優と監督のデータを作成
  - ACTED_IN: 出演
  - DIRECTED: 監督

```
// ---------- 1. データベースを空にする ----------
// 既存のデータをすべて削除して、まっさらな状態にします
MATCH (n) DETACH DELETE n;

// ---------- 2. ノードを作成する ----------
// Movieノード
CREATE (:Movie {title: 'The Matrix', released: 1999, tagline: 'Welcome to the Real World'});
CREATE (:Movie {title: 'Forrest Gump', released: 1994, tagline: 'Life is like a box of chocolates...'});
CREATE (:Movie {title: 'Cloud Atlas', released: 2012, tagline: 'Everything is Connected'});

// Personノード (俳優と監督)
CREATE (:Person {name: 'Keanu Reeves', born: 1964});
CREATE (:Person {name: 'Tom Hanks', born: 1956});
CREATE (:Person {name: 'Halle Berry', born: 1966});
CREATE (:Person {name: 'Lana Wachowski', born: 1965});
CREATE (:Person {name: 'Robert Zemeckis', born: 1952});

// ---------- 3. 関係性でノードをつなぐ ----------
// MATCHでノードを見つけてから、CREATEで関係を作成します

// The Matrixの関係
MATCH (m:Movie {title: 'The Matrix'})
MATCH (p1:Person {name: 'Keanu Reeves'})
MATCH (p2:Person {name: 'Lana Wachowski'})
CREATE (p1)-[:ACTED_IN {role: 'Neo'}]->(m)
CREATE (p2)-[:DIRECTED]->(m);

// Forrest Gumpの関係
MATCH (m:Movie {title: 'Forrest Gump'})
MATCH (p1:Person {name: 'Tom Hanks'})
MATCH (p2:Person {name: 'Robert Zemeckis'})
CREATE (p1)-[:ACTED_IN {role: 'Forrest'}]->(m)
CREATE (p2)-[:DIRECTED]->(m);

// Cloud Atlasの関係
MATCH (m:Movie {title: 'Cloud Atlas'})
MATCH (p1:Person {name: 'Tom Hanks'})
MATCH (p2:Person {name: 'Halle Berry'})
MATCH (p3:Person {name: 'Lana Wachowski'})
CREATE (p1)-[:ACTED_IN {role: 'Dr. Henry Goose'}]->(m)
CREATE (p2)-[:ACTED_IN {role: 'Jocasta Ayrs'}]->(m)
CREATE (p3)-[:DIRECTED]->(m);
```

## Neo4j の管理画面で確認

グラフデータが作成されていることが確認できました

![スクリーンショット 2025-08-03 19.47.05.png](attachment:0586c50b-d90a-48a7-8a40-abd6473a4c19:スクリーンショット_2025-08-03_19.47.05.png)

取得

```
// トム・ハンクスが出演した映画は？
// Forrest Gump、Cloud Atlas
MATCH (p:Person {name: 'Tom Hanks'})-[:ACTED_IN]->(m:Movie)
RETURN m.title AS movie_title;

// 『The Matrix』でキアヌ・リーブスと共演した俳優は？
// なし
MATCH (p:Person {name: 'Keanu Reeves'})-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(colleague:Person)
RETURN colleague.name AS colleague_name;

// トム・ハンクスが出演し、ラナ・ウォシャウスキーが監督した映画は？
// Cloud Atlas
MATCH (p1:Person {name: 'Tom Hanks'})-[:ACTED_IN]->(m:Movie)
MATCH (p2:Person {name: 'Lana Wachowski'})-[:DIRECTED]->(m)
RETURN m.title AS movie_title;
```

メモ

- **Keanu Reeves**
  - キアヌ・リーブス
- **Tom Hanks**
  - トム・ハンクス
- **Halle Berry**
  - ハル・ベリー
- **Lana Wachowski**
  - ラナ・ウォシャウスキー
- **Robert Zemeckis**
  - ロバート・ゼメキス
- **The Matrix**
  - ザ・マトリックス
- **Forrest Gump**
  - フォレスト・ガンプ
- **Cloud Atlas**
  - クラウド・アトラス

# メモ

- DB の個数

  - https://neo4j.com/docs/operations-manual/current/database-administration/
  - Community Edition: 1 個(DB 名: neo4j)
  - Enterprise Edition: 制限なし

- クエリ言語: Cypher（サイファー）

  - MySQL の言語が SQL
  - グラフ DB の言語が Cypher

- Go back to old Browser を押して古い画面仕様になって戻したい場合は、localstorage の

「prefersOldBrowser」を削除すれば OK

- csv 一括インストール方法(本)(試していない)

  - [neo4j-admin database import](https://neo4j.com/docs/operations-manual/current/tutorial/neo4j-admin-import/)
  - local の csv、gzip の取り込みが可能
  - AWS S3 は不可能

- サーバーサイドプロシージャ(本)

  - Neo4j から SQL サーバーに接続して SQL を実行できる機能
    - Python なりで SQL を実行してから Neo4j を実行する方がいいと思う(古谷)

- NER: 固有表現認識。文
