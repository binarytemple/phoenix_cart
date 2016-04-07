defmodule PhoenixCart.CartChannelTest do
  use PhoenixCart.ChannelCase

  alias PhoenixCart.CartChannel
  alias PhoenixCart.UserSocket

  setup do
    token = Phoenix.Token.sign(@endpoint, "cart", 1) 
    {:ok, socket} =  UserSocket.connect(%{"token" => token}, socket())
    {:ok, _, socket} = subscribe_and_join(socket,CartChannel, "carts:lobby")
    IO.inspect(socket)
    {:ok, %{socket: socket} }
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    IO.inspect(ref)
    assert_reply ref, :ok, %{"hello" => "there"}
    :ok
  end

  test "shout broadcasts to carts:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
