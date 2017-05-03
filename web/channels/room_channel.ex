defmodule Feedback.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("responded", %{"body" => body}, socket) do
    broadcast! socket, "responded", %{body: body}
    {:noreply, socket}
  end

  intercept ["responded"]

  def handle_out("responded", payload, socket) do
    push socket, "responded", payload
    {:noreply, socket}
  end
end
