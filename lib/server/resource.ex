defmodule OauthDemo.Server.Resource do
  require Logger
  def launch(auth_server_pid) do
    pid = spawn(fn -> server(auth_server_pid) end)
    {:ok, pid}
  end

  def server(auth_server_pid) do
    receive do
      {"REQUEST", from, access_token} ->
        send(auth_server_pid, {"CONFIRM", self(), %{"access_token" => access_token}})
        receive do
          {:ok, true} ->
            Logger.info("Received request: passed authorization")
            send(from, {:status_ok, "Nasubi"})
          {:ok, false} ->
            Logger.info("Received request:  unauthorization")
            send(from, {:status_unauthorized, nil})
        end
    end
    server(auth_server_pid)
  end
end
