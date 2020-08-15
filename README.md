# Oauth Demo Flow
Oauthの認証処理の流れを簡易化して、プロセス間通信での再現に挑戦  
Elixirの軽量プロセスを使用して、`message passing`による同期を行っている  
なお、今回はリハビリのため、`Task`、`Agent`を使用せずに、初歩的なspawnでのプロセス生成とpidを用いた`message passing`のみを使用した

## infomation
```
Erlang/OTP 23 [erts-11.0.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Elixir 1.10.3 (compiled with Erlang/OTP 22)
```