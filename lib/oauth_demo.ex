defmodule OauthDemo do
  def main(mode) do
    {:ok, auth_pid, src_pid, default_users} = OauthDemo.Server.launch()
    flow(mode, auth_pid, src_pid, default_users)
  end

  def flow("PASS", auth_pid, src_pid, default_users) do
    user_info = Enum.at(default_users, 0)
    access_token = create_access_token(auth_pid, user_info)
    res = OauthDemo.Server.request(src_pid, access_token)
    IO.puts("[Success] Response: #{res}")
  end

  def flow("UNAUTHORIZED", auth_pid, _src_pid, _default_users) do
    try do
      create_access_token(
        auth_pid,
        %{"id" => "okabe", "password" => "1234"}
      )
    rescue _ ->
      IO.puts("[Success] Response: Unauthorized")
    end
  end

  def flow("UNVALID_TOKEN", auth_pid, src_pid, default_users) do
    user_info = Enum.at(default_users, 0)
    create_access_token(auth_pid, user_info)
    try do
      OauthDemo.Server.request(src_pid, "xxxxxxxx")
    rescue _ ->
      IO.puts("[Success] Response: Unvalid token")
    end
  end

  def create_access_token(auth_pid, user_info) do
    OauthDemo.Server.auth(
      auth_pid,
      Map.get(user_info, "id"),
      Map.get(user_info, "password")
    )
  end
end
