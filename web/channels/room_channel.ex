defmodule Vuechat.RoomChannel do
  use Vuechat.Web, :channel
  alias Vuechat.Presence

  def join("room:lobby", payload, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "Unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    message = %{
      body: body,
      username: socket.assigns.username
    }

    broadcast! socket, "new_msg", message
    %Vuechat.Message{body: message.body, username: message.username}
      |> Vuechat.Repo.insert

    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.username, %{
      online_at: inspect(System.system_time(:milliseconds))
    })
    push socket, "presence_state", Presence.list(socket)

    messages = Repo.all(from m in Vuechat.Message, limit: 10)
    Enum.each(messages, fn message ->
      push socket, "new_msg", %{"body" => message.body, "username" => message.username }
    end)

    {:noreply, socket}
  end
end
