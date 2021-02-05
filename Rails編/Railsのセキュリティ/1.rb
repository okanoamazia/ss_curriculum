#Railsのセキュリティ
#https://railsguides.jp/security.html

■セッション・ハイジャック
①概要
ユーザーのセッションIDを盗み、そのユーザーをかたってWebアプリケーションを利用すること

②Rails はどのような機能で不正なアクセスを防止しているのか
・アプリケーションの設定ファイルでSSL接続を強制する
例）config.force_ssl = true


■CookieStore セッションに対する再生攻撃
①概要
予めcookieをコピーしておき、購入等のリクエストの後に送られてくるcookieと差し替えることで購入等をなかったことにする

②Rails はどのような機能で不正なアクセスを防止しているのか
・この攻撃対象となりうるデータはcookieではなく、データベースで管理する


■セッション固定攻撃
①概要
ユーザーのセッションIDを盗む代りに、攻撃者が意図的にセッションIDを既知のものに固定するという方法
（クッキー内のセッションIDを変更するJavaScriptを標的ユーザーのブラウザに送り込んで読み込ませる）

②Rails はどのような機能で不正なアクセスを防止しているのか
・ログイン成功後に古いセッションを無効にし、新しいセッションIDを発行すること
例）reset_session でセッションにある全ての値の削除が可能


■クロスサイトリクエストフォージェリ (CSRF)
①概要
ユーザーによる認証が完了したと考えられるWebアプリケーションのページに、悪意のあるコードやリンクを仕込むというもの

②Rails はどのような機能で不正なアクセスを防止しているのか
（１）GET と POST を適切に使う
    ・GET
      基本的に問い合わせである場合 (クエリ、読み出し操作、検索のような安全な操作)
    ・POST
      基本的に命令である場合、ユーザーにわかる形でリソースの状態が変わる場合 (サービスへの申し込みなど)
（２）GET 以外のリクエストにセキュリティトークンを追加する
      protect_from_forgery with: :exception
      （＊Rails で新規作成したアプリケーションにはこのコードがデフォルトで含まれていて、このコードによってGET以外のリクエストにセキュリティトークンが含まれる）


■リダイレクト
①概要
ユーザーを本物そっくりの偽Webサイトにリダイレクトする

②Rails はどのような機能で不正なアクセスを防止しているのか
URL をリダイレクトする場合は、ホワイトリストまたは正規表現でチェックする


■ファイルアップロード
①概要
攻撃者が危険なファイル名をわざと使ってサーバーのファイルを上書きしようとする

②Rails はどのような機能で不正なアクセスを防止しているのか
ユーザーが選択/入力できるファイル名 (またはその一部) は必ずホワイトリストでフィルタする


■アカウントに対する総当たり攻撃
①概要
ログイン情報に対して試行錯誤を繰り返す攻撃

②Rails はどのような機能で不正なアクセスを防止しているのか
・エラーメッセージを具体的でない、より一般的なものにする
・CAPTCHA (相手がコンピュータでないことを確認するためのテスト) への情報入力の義務付け


■ログ出力
①概要
攻撃者がWebサーバーへのフルアクセスに成功した後、ログからパスワード等を読み取られる危険性がある

②Rails はどのような機能で不正なアクセスを防止しているのか
特定のリクエストパラメータをログ出力時にフィルタする設定を追加
例）config.filter_parameters << :password


■ホワイトリスト方式
①概要
ブラックリスト方式（こちらで有害であるものを指定）よりホワイトリスト方式（有効であるもの飲みを指定）を使う
②例
・セキュリティに関連するbefore_actionでは、except: [...]ではなくonly: [...]を使う
・クロスサイトスクリプティング (XSS) 対策として<script>を削除するブラックリスト方式ではなく、たとえば<strong>だけを許可するホワイトリスト方式にする


■SQLインジェクション
①概要
Web アプリケーションのパラメータを操作してデータベースクエリに影響を与えることを目的とした攻撃手法

②Rails はどのような機能で不正なアクセスを防止しているのか
Model.find(id)やModel.find_by_なんちゃら(かんちゃら)といったクエリでは自動的にこの対応策が適用される

＊下記のメソッドについては手動でエスケープする必要があり
(where("..."))、connection.execute()またはModel.find_by_sql()メソッド
エスケープ例）
Model.where("login = ? AND password = ?", entered_user_name, entered_password).first


■クロスサイトスクリプティング (XSS)
①概要
・攻撃者が何らかのコードをWebアプリケーションに注入し、後に標的ユーザーのWebページ上に表示する
・cookieの盗み出し、セッションのハイジャック、標的ユーザーを偽のWebサイトに誘い込む、攻撃者の利益になるような広告を表示する、
  Web サイトの要素を書き換えてユーザー情報を盗み出す、あるいはWebブラウザのセキュリティ・ホールを経由して邪悪なソフトウェアをインストールする等

②Rails はどのような機能で不正なアクセスを防止しているのか
・悪意のある入力をホワイトリストでフィルタする（例 sanitize()メソッド）
・Web アプリケーションの出力をエスケープする


ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
セッション、cookie について
【Web 全般における概念の話】
■セッション
・ログインしてからログアウトするまでの一連の操作や処理の流れのこと（Webを支える技術、プロになるためのWeb技術入門）

■cookie
・ステートレスなHTTPにおいて、ユーザーの状態（ステート）を保持するために作られた技術
・Web サーバーから Web ブラウザに HTTP レスポンスの一部として送信される情報
・Web サーバーから Web ブラウザに 送信された cookie は Web ブラウザに保持される
・Web サーバーに再度 Web ブラウザからリクエストする場合にこの保存された cookie も送信され、Web サーバー側にこの Web ブラウザの状態（ステート）が伝わる

【Rails アプリケーションにおける話】
■セッション
・Rails は ユーザー毎にセッションを管理する
・Rails は セッション に関する情報を保存するためのいくつかのストレージ機能をもつ
・ストレージ機能はデフォルトでは、CookieStore が使用される
・CookieStore は セッション毎のIDを含めた全てのセッションに関する情報を、cookie（ブラウザ）に保存する
（他のストレージ機能では、セッションをRailsアプリケーションやデータベースに保存する場合もある）

■cookie
・Web 全般における話と同様

■seseionメソッドとcookiesメソッド
・seseionメソッド
セッションにアクセスする
・cookiesメソッド
cookieにアクセスする

■seseionメソッドとcookiesメソッドの違いについて（考察）
・CookieStore を使っている場合、セッションはcookieに保存されるためcookiesメソッドとアクセスする場所は一緒なのではないか
・sessionメソッドは、保存する情報を暗号化する、有効期限がブラウザを閉じた瞬間に設定される
・cookiesメソッドは、sessionsメソッドのような機能はなく、ただ単にcookieに情報を保存できる
（そのため、セッションをsessionメソッドで実装するときより長く設定したい（いわゆる remember me的な機能を作りたい）場合に使う）
