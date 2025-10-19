# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating Ryukyu University students with job hunting posts..."

# タグの作成
puts "Creating tags..."
tag_names = [
  # 就活関連
  "就活", "内定", "面接", "エントリーシート", "SPI", "就活相談", "就活成功", "お祈りメール",
  "面接対策", "企業研究", "自己PR", "志望動機", "グループディスカッション", "最終面接",

  # 企業・業界関連
  "NTTデータ", "ソニー", "富士通", "NEC", "楽天", "サイバーエージェント", "任天堂", "DeNA",
  "LINE", "KDDI", "ソフトバンク", "IBM", "Yahoo", "Google", "マイクロソフト", "アクセンチュア",
  "IT業界", "ゲーム業界", "金融IT", "コンサル", "外資系", "ベンチャー",

  # 地域・キャリア選択
  "地元就職", "本土就職", "沖縄", "東京", "キャリア選択", "地元愛", "沖縄セルラー", "OIST",
  "沖縄IT津梁パーク", "琉球大学", "琉大", "知能情報コース",

  # インターン・経験
  "インターン", "長期インターン", "夏インターン", "体験談", "実務経験", "アルバイト",

  # 技術・学習関連
  "プログラミング", "技術学習", "資格", "AWS", "Java", "Python", "React", "AI", "機械学習",
  "基本情報技術者", "応用情報技術者", "OCJP", "TOEIC", "ポートフォリオ", "GitHub", "Kaggle",
  "TensorFlow", "Unity", "セキュリティ", "クラウド", "データサイエンス",

  # 研究関連
  "研究", "研究室", "画像処理", "アルゴリズム", "論文", "卒論", "博士課程", "院進学",

  # 悩み・相談
  "悩み", "不安", "相談", "焦り", "両立", "時間管理", "スケジュール管理", "先輩", "アドバイス",

  # その他
  "大学生活", "友達", "同期", "説明会", "就職フェア", "合同説明会", "学内説明会",
  "リモートワーク", "コーディングテスト", "ハッカソン", "勉強会", "ゲーム開発"
]

tags = {}
tag_names.each do |tag_name|
  tag = Tag.find_or_create_by!(name: tag_name)
  tags[tag_name] = tag
  puts "Created tag: #{tag_name}"
end

# タグ付与のヘルパーメソッド
def assign_tags_to_post(post, content, tags_hash)
  assigned_tags = []

  # 基本的な就活タグは全投稿に
  assigned_tags << tags_hash["就活"]
  assigned_tags << tags_hash["琉大"]

  # 内定関連
  if content.include?("内定")
    assigned_tags << tags_hash["内定"]
    assigned_tags << tags_hash["就活成功"]
  end

  # 企業名に基づくタグ付け
  companies = {
    "NTTデータ" => "NTTデータ", "ソニー" => "ソニー", "富士通" => "富士通",
    "NEC" => "NEC", "楽天" => "楽天", "サイバーエージェント" => "サイバーエージェント",
    "任天堂" => "任天堂", "DeNA" => "DeNA", "LINE" => "LINE", "KDDI" => "KDDI",
    "ソフトバンク" => "ソフトバンク", "IBM" => "IBM", "Yahoo" => "Yahoo",
    "Google" => "Google", "マイクロソフト" => "マイクロソフト",
    "アクセンチュア" => "アクセンチュア", "沖縄セルラー" => "沖縄セルラー", "OIST" => "OIST"
  }

  companies.each do |company, tag_name|
    if content.include?(company)
      assigned_tags << tags_hash[tag_name] if tags_hash[tag_name]
    end
  end

  # 業界タグ
  if content.match?(/(IT|エンジニア|プログラミング|システム|ソフトウェア)/i)
    assigned_tags << tags_hash["IT業界"]
  end

  if content.match?(/(ゲーム|任天堂|SEGA|バンダイナムコ|Unity)/i)
    assigned_tags << tags_hash["ゲーム業界"]
  end

  if content.match?(/(金融|証券|銀行)/i)
    assigned_tags << tags_hash["金融IT"]
  end

  # 面接・選考関連
  if content.include?("面接")
    assigned_tags << tags_hash["面接"]
    assigned_tags << tags_hash["面接対策"]
  end

  if content.include?("最終面接")
    assigned_tags << tags_hash["最終面接"]
  end

  if content.match?(/(グループ|ディスカッション|GD)/i)
    assigned_tags << tags_hash["グループディスカッション"]
  end

  if content.match?(/(エントリーシート|ES)/i)
    assigned_tags << tags_hash["エントリーシート"]
  end

  if content.include?("SPI")
    assigned_tags << tags_hash["SPI"]
  end

  # 地域関連
  if content.match?(/(地元|沖縄)/i) && content.match?(/(残|働)/i)
    assigned_tags << tags_hash["地元就職"]
    assigned_tags << tags_hash["沖縄"]
  end

  if content.match?(/(本土|東京)/i) && content.match?(/(就職|働)/i)
    assigned_tags << tags_hash["本土就職"]
    assigned_tags << tags_hash["東京"]
  end

  # インターン関連
  if content.include?("インターン")
    assigned_tags << tags_hash["インターン"]
    assigned_tags << tags_hash["体験談"]
  end

  if content.include?("長期インターン")
    assigned_tags << tags_hash["長期インターン"]
  end

  # 技術関連
  technologies = {
    "Java" => "Java", "Python" => "Python", "React" => "React",
    "AWS" => "AWS", "AI" => "AI", "機械学習" => "機械学習",
    "TensorFlow" => "TensorFlow", "Unity" => "Unity", "GitHub" => "GitHub"
  }

  technologies.each do |tech, tag_name|
    if content.include?(tech)
      assigned_tags << tags_hash[tag_name] if tags_hash[tag_name]
      assigned_tags << tags_hash["技術学習"]
    end
  end

  # 資格関連
  if content.match?(/(資格|基本情報|応用情報|OCJP|TOEIC)/i)
    assigned_tags << tags_hash["資格"]
  end

  if content.include?("基本情報")
    assigned_tags << tags_hash["基本情報技術者"]
  end

  # 研究関連
  if content.match?(/(研究|論文|卒論)/i)
    assigned_tags << tags_hash["研究"]
    assigned_tags << tags_hash["研究室"]
  end

  if content.include?("画像処理")
    assigned_tags << tags_hash["画像処理"]
  end

  # 悩み・相談関連
  if content.match?(/(悩|不安|迷|困)/i)
    assigned_tags << tags_hash["悩み"]
    assigned_tags << tags_hash["就活相談"]
  end

  if content.include?("お祈り")
    assigned_tags << tags_hash["お祈りメール"]
  end

  # 説明会関連
  if content.include?("説明会")
    assigned_tags << tags_hash["説明会"]
  end

  # 重複を削除してタグを設定
  assigned_tags.uniq.compact.each do |tag|
    PostTag.create!(post: post, tag: tag)
    tag.increment!(:posts_count) # posts_countを更新
  end

  assigned_tags.uniq.compact
end
favorite_languages = [
  "Ruby", "Python", "JavaScript", "Java", "C++", "C#", "PHP", "TypeScript",
  "Go", "Swift", "Kotlin", "Rust", "Scala", "R", "MATLAB", "SQL"
]

# 研究室の配列
research_labs = [ "城間研", "赤嶺研", "國田研", "NAL研", "長山研", "岡崎研", "玉城研" ]

# 個人メッセージの配列
personal_messages = [
  "本土就職を目指して頑張っています！",
  "地元沖縄で働きたいです。",
  "IT業界でエンジニアとして成長したい！",
  "沖縄の発展に貢献できる仕事を探しています。",
  "リモートワークで働ける会社を希望しています。",
  "データサイエンティストを目指しています。",
  "Web開発に興味があります。",
  "AIやML分野で働きたいです。",
  "スタートアップ企業に興味があります。",
  "ゲーム業界で働いてみたいです。",
  "インフラエンジニアを目指しています。",
  "フルスタックエンジニアになりたい！",
  "サイバーセキュリティに興味があります。",
  "モバイルアプリ開発をやりたいです。",
  "クラウド技術を学びたいです。",
  "オープンソース開発に貢献したい！",
  "テックリードを目指しています。",
  "プロダクトマネージャーにも興味があります。",
  "技術で社会課題を解決したいです。",
  "グローバルに活躍できるエンジニアになりたい！"
]

# 学生と投稿のデータ（20人に絞る）
student_posts_data = [
  { name: "比嘉大輝", post: "初めての企業説明会に参加してきました。緊張したけど勉強になった！" },
  { name: "金城舞", post: "東京のIT企業を調べてるけど、沖縄から働けるリモートワークの求人が気になる" },
  { name: "新垣翔太", post: "地元に残るか、本土に行くかまだ迷ってます。先輩はどうして決めたんだろう" },
  { name: "宮里彩花", post: "エントリーシートの自己PR、書き直しすぎてよく分からなくなってきた…" },
  { name: "大城健太", post: "内定をもらった友達がいて焦るけど、自分のペースで進めたい" },
  { name: "上原結菜", post: "初めてのグループディスカッションでうまく話せなかった。要練習！" },
  { name: "知念亮", post: "合同説明会でたくさんの企業と話せて、視野が広がった気がする" },
  { name: "仲村真央", post: "沖縄で働きたい気持ちもあるけど、東京の企業にも挑戦したい" },
  { name: "平良智也", post: "SPIの勉強、英語が難しくてつまずいてる。みんなはどうしてる？" },
  { name: "屋比久さくら", post: "インターンで先輩社員と話して、社会人のイメージが少し掴めた" },
  { name: "与那覇悠斗", post: "第一志望の面接が近づいてきて、毎日ドキドキしてる" },
  { name: "玉城美咲", post: "就活用の証明写真、どこで撮るかまだ決められない" },
  { name: "照屋海斗", post: "学内説明会に参加したけど、人が多すぎて話を聞けなかった…" },
  { name: "我那覇真理子", post: "沖縄の観光業界も魅力的だし、IT業界にも興味ある。迷い中" },
  { name: "島袋大地", post: "まだ就活を本格的に始めていないけど、そろそろ動かないとやばい" },
  { name: "知花萌", post: "キャリアセンターで相談したら少し安心した。もっと利用しようかな" },
  { name: "仲宗根亮太", post: "お祈りメールが来て落ち込んだけど、気持ちを切り替えて頑張る" },
  { name: "喜友名沙耶", post: "就活と研究の両立が大変。スケジュール管理が必須だな…" },
  { name: "具志堅航", post: "沖縄に残って働きたい。地元のインフラ系企業を中心に探してる" },
  { name: "上江洲ひかり", post: "就活情報を友達とシェアできるのがありがたい" }
]

users = []

# メールアドレスの前半部分を生成するヘルパー
def generate_email_prefix(name, index)
  # 名前をローマ字化（簡易版）
  romanized_map = {
    '比嘉' => 'higa', '金城' => 'kinjo', '新垣' => 'aragaki', '宮里' => 'miyazato',
    '大城' => 'oshiro', '上原' => 'uehara', '知念' => 'chinen', '仲村' => 'nakamura',
    '平良' => 'taira', '屋比久' => 'yabiku', '与那覇' => 'yonaha', '玉城' => 'tamaki',
    '照屋' => 'teruya', '我那覇' => 'ganaha', '島袋' => 'shimabukuro', '知花' => 'chibana',
    '仲宗根' => 'nakasone', '喜友名' => 'kiyuna', '具志堅' => 'gushiken', '上江洲' => 'uezu'
  }

  # 名字と名前を分割
  family_name = name[0..1] # 最初の2文字を名字として扱う
  given_name = name[2..-1] # 残りを名前として扱う

  # ローマ字変換
  family_roman = romanized_map[family_name] || family_name.downcase
  given_roman = given_name.tr('大輝舞翔太彩花健太結菜亮真央智也さくら悠斗美咲海斗真理子地萌亮太沙耶航ひかり',
                              'daikimaishot_taaayakakentayuinaakiramaochimatosakurayuutomisak_ikaitmarikodaichimoearyotasayakouhikari')

  "#{family_roman}.#{given_roman}#{index}"
end

puts "Creating users and posts..."

student_posts_data.each_with_index do |data, index|
  # メールアドレスを生成
  email_prefix = generate_email_prefix(data[:name], index + 1)
  email = "#{email_prefix}@s.u-ryukyu.ac.jp"

  # ランダムで好きな言語、研究室、インターン回数、個人メッセージを選択
  favorite_language = favorite_languages.sample
  research_lab = research_labs.sample
  internship_count = rand(0..5) # 0-5回のインターン経験
  personal_message = personal_messages.sample

  # ユーザーを作成
  user = User.find_or_create_by!(email: email) do |u|
    u.password = "password"
    u.password_confirmation = "password"
    u.name = data[:name]
    u.favorite_language = favorite_language
    u.research_lab = research_lab
    u.internship_count = internship_count
    u.personal_message = personal_message
  end

  users << user

  # 投稿を作成（過去6ヶ月に分散）
  # 既存の投稿があるか確認（ユーザーと内容で一意性を判定）
  random_date = rand(6.months.ago..Time.current)
  post = Post.find_or_create_by!(
    content: data[:post],
    user: user
  ) do |p|
    p.created_at = random_date
    p.updated_at = random_date
  end

  # タグを付与（既に存在する場合はスキップ）
  if post.post_tags.empty?
    assigned_tags = assign_tags_to_post(post, data[:post], tags)
  else
    assigned_tags = post.tags
  end
  tag_names = assigned_tags.map(&:name).join(", ")

  puts "Created user #{index + 1}: #{data[:name]}"
  puts "  ├ Email: #{email}"
  puts "  ├ Research Lab: #{research_lab}"
  puts "  ├ Favorite Language: #{favorite_language}"
  puts "  ├ Internship Count: #{internship_count}回"
  puts "  ├ Personal Message: #{personal_message}"
  puts "  ├ Post: #{data[:post][0..40]}..."
  puts "  └ Tags: #{tag_names}"
  puts
end

# デモ用の管理者ユーザーを追加
admin_user = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.name = "管理者"
  u.favorite_language = "Ruby"
  u.research_lab = "NAL研"
  u.internship_count = 0
  u.personal_message = "琉球大学知能情報コースの就活を応援します！"
end

# 追加の投稿をランダムに作成（アクティブなSNSに見せるため）
additional_posts = [
  # 内定報告系
  "NTTデータから内定いただきました！4年の夏インターン参加が大きかったと思います。",
  "ソニーグループに内定！研究での画像処理の経験をアピールできました。",
  "富士通のSE職で内定を獲得しました。SPI対策をしっかりやってよかった。",
  "NECに内定決まりました！グループワークの経験を強調しました。",
  "楽天の内定いただきました。JavaとSpring Bootの勉強が役立ちました。",
  "サイバーエージェントから内定！長期インターンでの経験が評価されたみたい。",
  "任天堂に内定しました！小さい頃からの夢が叶いました。",
  "DeNAから内定！Reactとモバイル開発経験を面接で話しました。",
  "LINEヤフーの内定もらえました。研究室でのAI開発が強みになりました。",
  "KDDIから内定。地元沖縄でのインターンがきっかけでした。",
  "ソフトバンクの選考通過！最終面接まで頑張ります。",
  "楽天証券のエンジニア職に内定決まりました。金融ITに進みます。",
  "GMOインターネットで内定いただきました！セキュリティ勉強しててよかった。",
  "SEGAのゲーム開発部門に内定！Unityの自主制作を評価してもらえました。",
  "バンダイナムコの内定が決まりました！ゲーム好きとして最高です。",
  "沖縄セルラー電話のエンジニア職に内定！地元就職で安心しました。",
  "日本IBMの内定をもらいました。研究室での機械学習経験を活かせそうです。",
  "Yahoo! JAPANのエンジニアに内定決まりました。Pythonスキルを評価されました。",
  "OISTの研究補助職に決まりました！AI研究を続けます。",
  "JALシステムの内定をいただきました。空港システムに関わる仕事に挑戦！",
  "TISから内定！アルバイトでのプログラミング経験を聞かれました。",
  "日立製作所に内定！面接で研究内容をうまく伝えられました。",
  "アクセンチュアの内定が決まりました！英語面接が大変でした。",
  "PwCコンサルティングに内定！IT戦略に関われるのが楽しみです。",
  "NRI（野村総合研究所）の内定をもらいました。金融ITでキャリアを積みます。",
  "JR東日本ITソリューションズに内定！交通系システムに関われるのが嬉しい。",
  "日本ユニシスに内定！C言語での基礎力を見られました。",
  "エヌビディア日本法人に内定！GPU研究が活かせました。",
  "Google Japanの新卒採用に挑戦中！コーディングテスト難しすぎる。",
  "マイクロソフトジャパンの面接を受けました。英語での受け答え緊張した…。",

  # 就活の悩み・体験系
  "就活不安で眠れない…。SPIと面接対策どっちを優先すべき？",
  "沖縄のベンチャー企業でインターン中。スタートアップのスピード感が刺激的。",
  "博士課程に進学して研究職を目指すか、就職するか迷っています。",
  "東京で就職するか沖縄で働くか悩み中…。みんなはどう決めてる？",
  "インターン先でReactを使ったWebアプリを作成中！楽しいけど難しい。",
  "就活用ポートフォリオをGitHubにまとめ中。デザインに悩む…。",
  "SPI非言語が本当に苦手…。効率的な勉強法ないかな。",
  "志望動機がなかなかまとまらない。自己PRより難しい気がする。",
  "研究と就活の両立がきつい…。時間の使い方どうすれば？",
  "地元企業の沖縄ソフトウェアセンターの説明会に参加しました。",
  "インターンでのアルゴリズム実装が評価されて自信がついた！",
  "面接で「チーム開発の経験」を深掘りされることが多い。準備大事。",
  "就活エージェントから「東京での就職を勧めたい」と言われて迷ってます。",
  "沖縄IT津梁パークの企業説明会に参加！地元でのキャリアも魅力的。",
  "インターンでAWSを使った環境構築を任されて成長できた気がする。",
  "面接で「なぜ沖縄から東京に出たいのか」必ず聞かれる…。答えを磨かないと。",
  "先輩から「TOEICスコアも見られる」と言われて勉強始めました。",
  "就活で悩んだ時は研究室の先輩に相談して助けられた。",

  # 技術学習・資格系
  "Javaの資格（OCJP）取得に向けて勉強中！履歴書に書けるよう頑張る。",
  "AWS認定ソリューションアーキテクトに挑戦しています。クラウド強みになるかな。",
  "基本情報技術者試験に合格しました！応用情報も目指します。",
  "Pythonの資格試験を受ける予定。就活にプラスになるはず。",
  "AIエンジニアを目指してTensorFlowを独学中。面接で活かしたい。",
  "Google Cloud認定資格に挑戦してます！クラウド人材不足って本当？",
  "Kaggleで機械学習コンペ参加中！面接で話せるネタになるかな。",

  # 一般的な技術系投稿
  "今日のコーディング、Pythonでデータ解析してる🐍",
  "GitHubのコントリビューション増やしたい！",
  "ハッカソンに参加してみたいな🚀",
  "就活の合間にLeetCode解いてる💻",
  "先輩のポートフォリオ見て刺激を受けた✨",
  "今度の技術勉強会、誰か一緒に行く人いる？",
  "インターンで使った技術について投稿しよう！",
  "コードレビューで指摘されたことをまとめてみた📝",
  "新しいフレームワーク学習中。難しいけど楽しい！",
  "就活の息抜きにゲーム開発してる🎮"
]

# ランダムにユーザーに追加投稿を割り当て（アクティブなSNSにするため多めに投稿）
# 既存の投稿数を確認して、既に十分な投稿がある場合はスキップ
current_post_count = Post.count
target_additional_posts = 30

if current_post_count < (student_posts_data.length + target_additional_posts)
  posts_to_create = [(student_posts_data.length + target_additional_posts - current_post_count), target_additional_posts].min

  posts_to_create.times do |i|
    random_user = users.sample
    random_post = additional_posts.sample

    # ランダムな日付を生成（過去6ヶ月に分散）
    random_date = rand(6.months.ago..Time.current)

    # 既存チェック：同じユーザー+同じ内容の投稿がないか確認
    post = Post.find_or_create_by!(
      content: random_post,
      user: random_user
    ) do |p|
      p.created_at = random_date
      p.updated_at = random_date
    end

    # 追加投稿にもタグを付与（既に存在する場合はスキップ）
    if post.post_tags.empty?
      assigned_tags = assign_tags_to_post(post, random_post, tags)
      puts "Created additional post #{i + 1} with tags: #{assigned_tags.map(&:name).join(', ')}"
    else
      puts "Skipped additional post #{i + 1} (already exists)"
    end
  end
else
  puts "Skipping additional posts creation - already have enough posts (#{current_post_count} posts)"
end

puts "\n" + "="*70
puts "🌺 Seed data creation completed! 🌺"
puts "="*70
puts "👥 Created #{User.count} users (#{User.count - 1} students + 1 admin)"
puts "📝 Created #{Post.count} posts"
puts "🏷️ Created #{Tag.count} tags"
puts "🔗 Created #{PostTag.count} post-tag relationships"
puts "🔬 Research Labs: #{research_labs.join(', ')}"
puts "💻 Programming Languages: #{favorite_languages.join(', ')}"
puts "📊 Internship Experience: 0-5回 (ランダム設定)"
puts ""
puts "📈 Top 10 Tags by Usage:"
Tag.order(posts_count: :desc).limit(10).each_with_index do |tag, index|
  puts "  #{index + 1}. #{tag.name} (#{tag.posts_count}件)"
end
puts "="*70
puts "🎉 Welcome to Chinokatsu - 琉球大学知能情報コース向け就活SNS！"
puts "みんなで就活とプログラミング学習を頑張りましょう！💪✨"
puts "="*70
