defmodule PhoenixCart.CartChannel do
  use PhoenixCart.Web, :channel

  def join("carts:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket.assigns[:cart_count], socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
   {:reply, {:ok,payload }, socket}
  end

  def handle_in("join_map_and_uppercase", payload, socket) do
   payload_joined=Enum.reduce( Map.to_list(payload) , "",  fn ({x,y},acc) -> x <> " " <>  y <> acc end )
   {:reply, {:ok, %{"result" => String.upcase( payload_joined )} }, socket}
  end





  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (carts:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "cart:count", %{count: socket.cart_count}
    {:noreply, socket}
  end
end
