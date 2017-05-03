defmodule Feedback.RoomChannelTest do
  use Feedback.ChannelCase
  alias Feedback.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("responded", %{body: "body"})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  test "responded replies with status ok", %{socket: socket} do
    push socket, "responded", %{body: "body"}
    assert_broadcast "responded", %{body: "body"}
  end
end
