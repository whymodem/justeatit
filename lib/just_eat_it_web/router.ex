defmodule JustEatItWeb.Router do
  use JustEatItWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {JustEatItWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", JustEatItWeb do
    pipe_through :api

    # TODO: Let's move this to its own top-level path to prevent order mattering here and collisions, ex: /api/meal_generator
    get "/food_facilities/random", FoodFacilityController, :random
    resources "/food_facilities", FoodFacilityController, except: [:new, :edit]
  end

  scope "/", JustEatItWeb do
    pipe_through :browser

    live("/", RandomEats)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:just_eat_it, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JustEatItWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
