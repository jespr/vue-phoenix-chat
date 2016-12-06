defmodule Vuechat.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", Vuechat.RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket
  def connect(%{"username" => username}, socket) do
    {:ok, assign(socket, :username, username)}
  end

  def id(_socket), do: nil
end
