# カスタムマッチャのファイル
# マッチャは必ず名前付きで定義され、その名前をスペック内で呼び出すときに使用し、マッチャにはmatchメソッドが必要となる。

RSpec::Matchers.define :have_content_type do |expected|
  match do |actual|
    # begin rescueはデバッグ処理
    # もしArgumenterrorを出したらfalseを返す。
    begin
      actual.content_type == content_type(expected)
    rescue ArgumentError
      false
    end
  end

  # 失敗メッセージ(failure message)と、否定の失敗メッセージ゙(negated failure message )を定義するメソッド
  # これらはtoやto_notで失敗したときの報告方法を定義できる
  failure_message do |actual|
    "Expected \"#{content_type(actual.content_type)} " + "(#{actual.content_type})\" to be Content Type " + "\"#{content_type(expected)}\" (#{expected})"
  end

  failure_message_when_negated do |actual|
    "Expected \"#{content_type(actual.content_type)} " + "(#{actual.content_type})\" to not be Content Type " + "\"#{content_type(expected)}\" (#{expected})"
  end

  def content_type(type)
    types = {
      # 一つは期待される値(expected value 、マッチャをパスさせるのに必要な結果）
      html: "text/html",
      # もう一つは実際の値(actual value 、テストを実行するステップで渡される値)
      json: "application/json",
    }
    types[type.to_sym] || "unknown content type"
  end
end

# カスタムマッチャのエイリアス
RSpec::Matchers.alias_matcher :be_content_type, :have_content_type
