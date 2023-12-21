defmodule LiveViewEventPassingDemoWeb.Live.Widgets.WidgetC do
  use LiveViewEventPassingDemoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    sess = session["live_view_broadcaster_session"]
    {:ok, broadcast_group} = LiveViewEventPassingDemo.OTP.LiveViewDispatcher.subscribe(sess)
    LiveViewEventPassingDemo.OTP.LiveViewDispatcher.subscribe({broadcast_group, :widget_c})
    {:ok,
      socket
      |> assign(broadcast_group: broadcast_group)
      |> assign(last_event: nil)
    }
  end

  def handle_info(event, socket) do
    socket = socket
             |> assign(last_event: event)
    {:noreply, socket}
  end


  @impl true
  def handle_event("broadcast", _, socket) do
    g = socket.assigns[:broadcast_group]
    LiveViewEventPassingDemo.OTP.LiveViewDispatcher.publish({g, :widget_a}, :hey_a)

    {:noreply, socket}
  end

end
