# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample Ryukyu University students
puts "Creating sample Ryukyu University students..."
users = []

student_profiles = [
  { email: "user@example.com", name: "ほげ太郎", department: "工学部", year: 4 },
  { email: "tanaka.hiroshi@s.u-ryukyu.ac.jp", name: "田中大志", department: "工学部", year: 4 },
  { email: "yamada.sakura@s.u-ryukyu.ac.jp", name: "山田さくら", department: "法文学部", year: 4 },
  { email: "suzuki.kenta@s.u-ryukyu.ac.jp", name: "鈴木健太", department: "理学部", year: 3 },
  { email: "sato.yui@s.u-ryukyu.ac.jp", name: "佐藤結衣", department: "教育学部", year: 4 },
  { email: "watanabe.ryo@s.u-ryukyu.ac.jp", name: "渡辺涼", department: "農学部", year: 3 },
  { email: "takahashi.mei@s.u-ryukyu.ac.jp", name: "高橋恵", department: "医学部", year: 6 },
  { email: "ito.daiki@s.u-ryukyu.ac.jp", name: "伊藤大輝", department: "国際地域創造学部", year: 4 },
  { email: "kobayashi.aina@s.u-ryukyu.ac.jp", name: "小林愛奈", department: "工学部", year: 3 }
]

student_profiles.each do |profile|
  user = User.find_or_create_by!(email: profile[:email]) do |u|
    u.password = "password"
    u.password_confirmation = "password"
    u.name = profile[:name]
    # 追加のユーザー情報があれば設定
    # u.department = profile[:department] if u.respond_to?(:department)
    # u.year = profile[:year] if u.respond_to?(:year)
  end
  users << user
  puts "Created user: #{profile[:name]} (#{profile[:department]}#{profile[:year]}年) - #{user.email}"
end

# Create job hunting related posts
puts "Creating job hunting posts for Ryukyu University students..."

job_hunting_posts = [
  # エントリーシート・応募関連
  "JALのエントリーシート提出完了！沖縄の会社だから地元愛をアピールしました✈️ #就活 #エントリーシート #JAL",
  "琉球銀行の説明会に参加してきました。地元で働くイメージが湧いてきた！ #説明会 #琉球銀行 #地元就職",
  "東京の合同説明会から帰ってきました。本土企業も沖縄出身者を積極採用してるみたい！ #合同説明会 #本土就職",
  "オリオンビールのインターンシップ申し込み完了！倍率高そうだけど頑張る🍺 #インターンシップ #オリオンビール",
  "沖縄電力のエントリーシート、締切ギリギリで提出💦みんなはもう出した？ #エントリーシート #沖縄電力",

  # 面接・選考関連
  "県庁の一次試験通過した〜！二次の面接対策始めなきゃ💪 #公務員試験 #沖縄県庁",
  "リウボウの最終面接終了。緊張したけど、沖縄愛を伝えられたかな... #面接 #リウボウ #最終面接",
  "Web面接の準備中。背景に海が映り込まないように注意しないと😅 #Web面接 #就活あるある",
  "グループディスカッションで「沖縄の観光業の課題」について話し合った。みんな詳しくてびっくり！ #グループディスカッション",
  "面接で「なぜ沖縄を離れたいのか」を聞かれて答えに困った...みんなどう答えてる？ #面接対策 #本土就職",

  # 内定・結果報告
  "第一志望から内定もらいました！！！😭✨ 琉大生でもやればできる！ #内定 #就活終了",
  "残念ながらお祈りメールが...でも次頑張る！琉大生は諦めない💪 #就活 #切り替え",
  "地元の建設会社から内定いただきました。沖縄の発展に貢献したい！ #内定 #地元就職 #建設業界",
  "東京のIT企業から内定！リモートワークで沖縄から働ける会社を見つけました🏝️ #内定 #IT業界 #リモートワーク",

  # 就活の悩み・相談
  "本土就職するか地元に残るか迷ってる...みんなはどう考えてる？ #就活相談 #キャリア選択",
  "交通費が高くて本土の面接に行くのがきつい😰同じような人いる？ #就活費用 #本土就職",
  "親から「沖縄に残りなさい」って言われてるけど、夢は本土で叶えたい... #就活 #家族",
  "琉大生って就活不利なの？そんなことないよね？ #琉球大学 #就活不安",
  "方言が面接で出ちゃうのが心配...標準語の練習してる人いる？ #面接対策 #方言",

  # 業界研究・企業研究
  "沖縄の観光業界について調べてる。コロナ後の復活が期待できそう！ #業界研究 #観光業界",
  "ソフトバンクの沖縄支社の情報知ってる人いる？ #企業研究 #ソフトバンク",
  "地元のベンチャー企業も面白そう。成長できる環境があるかも！ #ベンチャー企業 #沖縄",
  "公務員志望だけど、県庁と市役所どっちがいいかな？ #公務員 #沖縄県庁 #那覇市役所",

  # 就活イベント・情報共有
  "明日の学内説明会、誰か一緒に行く人いる？ #学内説明会 #琉球大学",
  "沖縄就職フェアの情報まとめました！みんなで情報共有しよう📝 #就職フェア #情報共有",
  "先輩から面接のコツ教えてもらった！みんなとシェアします✨ #先輩からのアドバイス",
  "キャリアセンターの個別相談、予約取れた人いる？ #キャリアセンター #琉球大学",

  # 沖縄特有の就活事情
  "台風で説明会が延期になった...沖縄あるあるですね🌀 #台風 #就活あるある",
  "本土の企業の人事の方が沖縄に来てくれるの、本当にありがたい🙏 #企業説明会",
  "「沖縄出身です」って言うと話が盛り上がる😊沖縄ブランド活用中！ #沖縄出身 #アイスブレイク",
  "かりゆしウェアでオフィスカジュアル面接っていいのかな？ #服装 #かりゆしウェア",

  # 励まし・応援
  "みんなで頑張ろう！琉大生の底力を見せよう💪 #琉大生 #就活仲間",
  "不安になったらここで吐き出そう。一人じゃないよ！ #就活不安 #仲間",
  "内地に出る人も、地元に残る人も、それぞれの道で頑張ろう🌺 #エール #就活仲間",
  "就活疲れた時は美ら海でリフレッシュ🐠明日からまた頑張ろう！ #リフレッシュ #沖縄の良さ",

  # 具体的な企業・業界情報
  "沖縄ツーリストの説明会情報です。旅行業界志望の人チェック！ #沖縄ツーリスト #旅行業界",
  "琉球セメントの工場見学、めちゃくちゃ勉強になった！ #琉球セメント #工場見学",
  "沖縄タイムスの記者職、倍率高そうだけど挑戦する！ #沖縄タイムス #マスコミ",
  "地元のIT企業、レキサスの話を聞いてきました。技術力高そう！ #レキサス #IT業界",

  # 就活グッズ・準備
  "リクルートスーツ、沖縄の湿気でシワになりやすい...対策教えて💦 #リクルートスーツ #沖縄の気候",
  "履歴書の写真、どこで撮るのがおすすめ？ #履歴書写真 #就活準備",
  "SPIの勉強場所、図書館以外でどこがいいかな？ #SPI対策 #勉強場所",

  # 就活終了後・進路決定
  "就活終わったら石垣島旅行する約束してる。みんなも何か楽しみ作ろう🏝️ #就活後の楽しみ",
  "卒業後は本土だけど、いつかは沖縄に帰ってきたい❤️ #将来の夢 #故郷愛",
  "地元で就職決まったから、沖縄を盛り上げていきたい！ #地元愛 #沖縄発展"
]

# Randomly assign posts to users
job_hunting_posts.each_with_index do |content, index|
  user = users[index % users.length]

  post = Post.create!(
    content: content,
    user: user
  )

  puts "Created post #{index + 1}: #{content[0..30]}... by #{user.email}"
end

# Add some additional posts for variety
additional_posts = [
  "今日のランチはタコライス🌮気分転換大事！ #ランチ #沖縄グルメ",
  "ゼミの発表準備中。就活と両立大変だけど頑張る📚 #ゼミ #大学生活",
  "友達と首里城見に行ってきた。沖縄の誇り✨ #首里城 #沖縄",
  "バイト先でも就活の話題が...みんな頑張ってる💪 #バイト #就活",
  "卒論のテーマも就活に活かせそう！一石二鳥😊 #卒論 #就活"
]

additional_posts.each_with_index do |content, index|
  user = users[index % users.length]

  post = Post.create!(
    content: content,
    user: user
  )

  puts "Created additional post: #{content[0..30]}..."
end

puts "Seed data creation completed!"
puts "Created #{User.count} Ryukyu University students and #{Post.count} job hunting posts."
puts "Welcome to Chinokatsu - 琉球大学生向け就活SNS！"
