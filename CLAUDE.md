# Claude Code 向けガイドライン

このファイルは Claude Code での開発における「常駐コア」です。詳細は docs/ 配下や関連ドキュメントを参照してください。

## 重要：Railsコマンドの実行

**必ずRailsコマンドはDockerコンテナ内で実行してください。**

```bash
docker compose exec web rails [command]
# 例:
# docker compose exec web rails console
# docker compose exec web rails db:migrate
# docker compose exec web rails generate model User
# docker compose exec web bundle exec rspec
```

## 常駐コア

### 目的
- Rails規約（CoC）とセキュリティを最優先に、動くコードとRSpecテストを常にセットで提供する。

### 言語・スタイル
- すべて日本語（英語不可）。
- 可能な限りテスト（RSpec）を先に、次に実装コードを示す。テンプレートはSlim推奨。

### セキュリティ
- SQLインジェクション/XSSを回避。Strong Parametersは Rails 8 の `params.expect` を推奨。
```ruby
# 例（Rails 8）
def user_params
  params.expect(user: [:name, :email, :age])
end
```

### Rails規約と設計
- RESTful、CoC順守、責務分離（Fat Controller/Model回避、Service/Presenter活用）。
- N+1回避、必要に応じてインデックス/プリロード。

### テスト
- RSpecのdescribe/context/itを適切に使い分け、FactoryBot活用。
- Red → Green → Refactor を徹底。落ちるテストを先に書く。

### 品質ゲート（PR前に必須）
- RSpec成功（意味あるPendingのみ）。
- RuboCop重大違反なし（意図的除外には根拠コメント）。
- セキュリティツール重大警告なし（Brakeman 等）。
- ローカル起動で簡易回帰確認。

### Git運用
- 1論理変更=1コミット、Prefix使用（feat/fix/test/refactor/style/chore/docs 等）。
- 各コミットは動く状態を保つ。関連ファイル（Model/Controller/View/テスト）をなるべく同コミットに含める。
- Bodyは書かず、Co-Aurhorにclaudeを含めない。

---

注記: 以前このファイルに含まれていた詳細な長文ガイドは、上記の各ドキュメントへ分割・移動しました。必要に応じて参照してください。
