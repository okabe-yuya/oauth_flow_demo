# Oauth Demo Flow
Oauthの認証処理の流れを簡易化して、プロセス間通信での再現に挑戦  
Elixirの軽量プロセスを使用して、`message passing`による同期を行っている  
なお、今回はリハビリのため、`Task`、`Agent`を使用せずに、初歩的なspawnでのプロセス生成とpidを用いた`message passing`のみを使用した

## infomation
```
Erlang/OTP 23 [erts-11.0.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Elixir 1.10.3 (compiled with Erlang/OTP 22)
```

## 調査メモ
### 認証について
- SSO(SingleSignOn) -> eg: 免許書1枚で様々な契約が可能
  - 知ってるやつ: SAML(プロトコル) -> Idp(IdentityProvider: ユーザー認証)とSP(ServiceProvider)でお互いに利用できるように設定(SAML対応していることが大前提)
  - Oauth(以下に詳細: Oauth -> 認可, OpenIDConnect -> 認証)
- Basic認証
  - IDとPASSをheader paramaterに含めて送信して認証

#### OAuth(authorization = 認可 -> 権限を与えること)
- プロトコルらしい
  - Oauth1.0が公開されていたものの、認証が標準化されておらずヤバイ問題がたくさん...
    - 不正なデータアクセスを許してしまう(アクセストークン発行の認証が標準化されていない)
    - スケールに対応出来ない -> 認証フローがめっさ複雑らしい
    - Webアプリには強いが、デスクトップアプリだと不安定
  - Oauth2.0の登場
    - アクセストークン発行の認証が標準化 -> よりセキュアに

- 認証の流れ(簡略)
  - 登場人物
    - クライアントアプリ(myアプリ -> twitterアカウントでログインさせたい)
    - twitter
      - 認可サーバー(認証とアクセストークンの発行)
      - リソースサーバー(ユーザーデータなど在)


- クライアントアプリ(ID, PASS) --request--> twitter::認可サーバー
- 認可ページを提示(RFCでは定義されていない)
  - 誰に? -> app
  - 何の権限を? -> ユーザー情報閲覧
  - 誰が? -> ID, PASS
- アクセストークンの発行(許可コードを発行してからアクセストークンを発行する方式も在り)
- アクセストークンをheader::autherizationに含めてリソースサーバーにリクエスト


### 分からなかったこと
- アクセストークンを受け取ってから、認可サーバーに不正なトークンかどうかを問い合わせているのか -> 問い合わせる形式もある模様(認可コード形式の場合)
- クライアントアプリからのリクエストの場合と、正規アプリ(twitterのフロントエンド)からのリクエストで、認証の方法は分けているのか(ipを見るなどして??) -> 見分けるらしい

### 今回、調べなかったこと
- アクセストークンの発行に用いられるアルゴリズム
- 複数ある認証フローの種類

### 覚えた英単語
- grant -> 権限を付与(giveに近い単語)
- signature -> 署名

### JWT
- json形式(フレーム-> key value)
- ヘッダー.ペイロード.署名 -> JSON
　
- インプリシットブロー 認可コードを持たずアクセストークンをそのまま持つ

### URIとURLとURN
- Uniform Resource Identifier -> Webにあるリソースを認識するための識別子でURLとURNの合体したやつ
  - URL -> Web上の住所(google.com)
  - URN -> Web上の名前(google)