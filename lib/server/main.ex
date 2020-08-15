defmodule OauthDemo.Server do
  alias OauthDemo.Server.Resource, as: Resource
  alias OauthDemo.Server.Authorization, as: Authorization
  @default_user_limit 5

  def launch do
    default_users = default_user_list()
    {:ok, auth_pid} = Authorization.launch(default_users)
    {:ok, src_pid} = Resource.launch(auth_pid)
    {:ok, auth_pid, src_pid, default_users}
  end

  def auth(auth_pid, id, password) do
    pid = self()
    send(auth_pid, {"AUTH", pid, %{"id" => id, "password" => password}})
    receive do
      {:status_ok, access_token} -> access_token
      {:status_unauthorized, _} -> raise "401 Unauthorized"
    end
  end

  def request(src_pid, access_token) do
    pid = self()
    send(src_pid, {"REQUEST", pid, access_token})
    receive do
      {:status_ok, resource} -> resource
      {:status_unauthorized, _} -> raise "401 Unauthorized"
    end
  end

  def default_user_list do
    # ゴチャるので5人で固定
    Enum.map(1..@default_user_limit, fn _ ->
      %{
        "id" => Faker.Person.first_name(),
        "password" => Faker.String.base64(),
      }
    end)
  end
end
