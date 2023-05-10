defmodule JustEatItWeb.RandomEats do
  @moduledoc """
  LiveView responsible for generating, handling, and displaying random eats.

  Allows returning random eats via query parameters such as `seed` and `count` to control the seed and count respectively.
  """

  use JustEatItWeb, :live_view
  alias JustEatIt.Eats
  alias JustEatIt.Eats.FoodFacility
  require Logger

  @random_greetings [
    "Let's Eat Something",
    "Food, You Will Eat",
    "I Divine a Meal Of...",
    "Are we hungry?",
    "You, You Eat This",
    "Today is a good day to eat...",
    "It's Been 7 Hours and 16 Days Since...",
    "Eat This",
    "This is the Deal, Your Meal",
    "Go Forth and Eat...",
    "It Was Made Known To Me To Eat Here:",
    "Have You Eaten This?",
    "Eat, Eat, and Eat",
    "Eats, They Are These..."
  ]

  defp generate_greeting() do
    Enum.random(@random_greetings)
  end

  @doc """
  Handles initial mounting of the live view, conditionally rendering a fragment when loading.
  """
  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, page: "loading")}
    end
  end

  defp connected_mount(params, _session, socket) do
    # TODO: better parsing of these params, using ecto types most likely, but this will do for something simple
    count = Map.get(params, "count", "1") |> String.to_integer() |> max(1)
    seed = Map.get(params, "seed")
    food_facilities = Eats.random_food_facilities(count, seed)

    {:ok,
     assign(socket, %{
       seed: seed,
       count: count,
       food_facilities: food_facilities,
       greeting: Enum.random(@random_greetings)
     })}
  end

  @doc """
  Handles the randomize event responsible for creating new places to eat.
  """
  def handle_event("randomize", vals, socket) do
    # TODO: better parsing of these params, using ecto types most likely, but this will do for something simple
    item_count = Map.get(vals, "count", "1") |> String.to_integer() |> max(1)
    seed = Map.get(vals, "seed")
    food_facilities = Eats.next_random_food_facilities(item_count)

    # Ideally, we can eventually restructure this to us `update` and push events as well to update the URL with a seed, count, etc.
    # Pushing into the browser history would allow us to track the progress of the sequence as well
    # For now we simply assign the data rather than updating it since the food facilities get replaced entirely and it is easier for a simple use-case such as ours.
    {:noreply,
     assign(socket, %{seed: seed, count: item_count, food_facilities: food_facilities, greeting: generate_greeting()})}
  end

  #TODO: Move Render functionality proper template files, leaving here to keep it simple for now
  @doc """
  Renders the page conditionally, either showing a loading message, errors, or 0 or more places to eat.
  """
  def render(%{page: "loading"} = assigns) do
    ~L"""
    <h3>Please be patient, loading...</h3>
    """
  end

  def render(%{page: "error"} = assigns) do
    ~L"""
    <h3 class="text-color-red">An Error Has Occurred :(</h3>
    """
  end

  def render(assigns) do
    ~L"""
    <div>
    <h1 class="text-4xl font-bold text-center"><%= @greeting %></h1>
    <%= if Enum.empty?(@food_facilities) do %>
      <div class="py-4">
      Sad times, there's nowhere to eat, let's just go home.
      </div>
    <% else %>
        <ul>
      <%= for facility <- @food_facilities do %>
      <li class="py-4">
        <div class="flex flex-col py-2">
          <div>
            <span class="font-bold text-slate"><%=facility.name %></span>
          </div>
          <%= if facility.address do %>
            <div class="inline-flex items-center space-x-2">
              <div>
                <svg class="text-pink-500 stroke-pink-500 fill-none h-8 w-8" viewBox="0 0 24 24">
                  <path d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                  <path d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0z"/>
                </svg>
              </div>
              <%= if facility.latitude != nil and facility.longitude != nil do %>
                <a class="hover:underline hover:decoration-pink-500 hover:decoration-2" href="https://www.google.com/maps/search/?api=1&query=<%=facility.latitude%>%2C<%=facility.longitude%>">
                  <%=facility.address %>
                </a>
              <% else %>
                <span><%=facility.address%></span>
              <% end %>
            </div>
          <% end %>
          <%= if facility.menu_description do %>
            <div class="inline-flex items-center space-x-2">
              <div>
                <svg class="text-pink-500 stroke-pink-500 fill-none h-8 w-8" viewBox="0 0 24 24">
                  <path d="m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0zm-9-3.75h.008v.008H12V8.25z"/>
                </svg>
              </div>
              <span>
                <%=facility.menu_description %>
              </span>
            </div>
          <% end %>
          <%= if facility.facility_type do %>
            <div class="inline-flex items-center space-x-2">
              <div>
                <svg class="text-pink-500 stroke-pink-500 fill-none h-8 w-8" viewBox="0 0 24 24">
                  <path d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12"/>
                </svg>
              </div>
              <span><%=  FoodFacility.friendly_facility_type(facility.facility_type) %></span>
            </div>
          <% end %>
        </div>
      </li>
      <% end %>
      </ul>
    <% end%>

    <p class="text-center">
     <button phx-click="randomize" phx-value-count="<%= @count%>" phx-value-seed="<%= @seed %>" class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 hover:bg-pink-500 rounded-none border-b-2 border-r-2 border-pink-500">Let's Eat Something Else</button>
     </p>
     </div>
    """
  end
end
