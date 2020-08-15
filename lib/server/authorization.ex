defmodule OauthDemo.Server.Authorization do
  require Logger
  @random_int_max 100

  def launch(user_list) do
    pid = spawn(fn -> server(user_list) end)
    {:ok, pid}
  end

  def server(user_list) do
    receive do
      {"AUTH", from, %{"id" => id, "password" => password}} ->
        Logger.info("Received request 'Oauth': id => #{id}, password => #{password}")
        idx = search_user(user_list, id, password)
        if idx != -1 do
          access_token = create_access_token()
          next = replace_index(user_list, idx, "access_token", access_token)
          Logger.info("Created access token: access_token => #{access_token}")
          send(from, {:status_ok, access_token})
          server(next)
        else
          Logger.info("Unauthorized. Not registed user => #{id}")
          send(from, {:status_unauthorized, nil})
          server(user_list)
        end
      {"CONFIRM", from, %{"access_token" => access_token}} ->
        Logger.info("Received request 'Confirm': access_token => #{access_token}")
        send(from, {:ok, valid_access_token?(user_list, access_token)})
        server(user_list)
      message ->
        raise "Unsupported Type Message :: #{message}"
        server(user_list)
    end
  end

  def find_index(user_list, cond_), do: _find_index(user_list, cond_, 0)
  defp _find_index([], _cond_, _count), do: -1
  defp _find_index([h | t], cond_, count) do
    if cond_.(h) do
      count
    else
      _find_index(t, cond_, count)
    end
  end

  def replace_index(user_list, -1, _, _, _), do: user_list
  def replace_index(user_list, idx, key, value) do
    updated = Enum.at(user_list, idx) |> Map.put(key, value)
    List.replace_at(user_list, idx, updated)
  end

  def search_user(user_list, id, password) do
    cond_ = fn user -> Map.get(user, "id") == id and Map.get(user, "password") == password end
    find_index(user_list, cond_)
  end

  def valid_access_token?(user_list, access_token) do
    cond_ = fn user -> Map.get(user, "access_token") == access_token end
    IO.puts(find_index(user_list, cond_))
    find_index(user_list, cond_) >= 0
  end

  def create_access_token do
    Enum.map(1..10, fn _ -> :rand.uniform(@random_int_max) end)
    |> Enum.map(fn n -> OauthDemo.Utils.ASCII.from_int(n) end)
  end
end
