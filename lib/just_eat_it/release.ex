defmodule JustEatIt.Release do
  @moduledoc """
    Provides functionality for supporting releases without the use of `mix`.
  """
  @app :just_eat_it

  require Logger

  # TODO: we can move functionality like running the seed code into its own module, but leaving for now so it's all simple and in a single place because requirements are not large currently.

  def setup() do
    load_app()

    create_db_for(@app)
    migrate_for(@app)
    seed_app_for(@app)
  end

  def migrate() do
    load_app()

    migrate_for(@app)
  end

  defp migrate_for(app) do
    for repo <- repos(app) do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def re_migrate() do
    load_app()

    for repo <- repos(@app) do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, all: true))
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def create_app_db() do
    load_app()

    create_db_for(@app)
  end

  defp create_db_for(app) do
    for repo <- repos(app) do
      :ok = ensure_repo_created(repo)
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos(app) do
    Application.fetch_env!(app, :ecto_repos)
  end

  defp ensure_repo_created(repo) do
    IO.puts("create #{inspect(repo)} database if it doesn't exist")

    case repo.__adapter__.storage_up(repo.config) do
      :ok -> :ok
      {:error, :already_up} -> :ok
      {:error, term} -> {:error, term}
    end
  end

  def seed() do
    load_app()

    seed_app_for(@app)
  end

  defp seed_app_for(app) do
    for repo <- repos(app) do
      :ok = seed_for(repo, "seeds.exs")
    end
  end

  def seed_for(repo, filename) do
    load_app()

    case Ecto.Migrator.with_repo(repo, &eval_seed(&1, filename)) do
      {:ok, {:ok, _fun_return}, _apps} ->
        :ok

      {:ok, {:error, reason}, _apps} ->
        Logger.error(reason)
        {:error, reason}

      {:error, term} ->
        IO.warn(term, [])
        {:error, term}
    end
  end

  @spec eval_seed(Ecto.Repo.t(), String.t()) :: any()
  defp eval_seed(repo, filename) do
    seeds_file = get_path(repo, "seed", filename)
    Logger.info("seeds file: #{inspect(seeds_file)}")

    if File.regular?(seeds_file) do
      {:ok, Code.eval_file(seeds_file)}
    else
      {:error, "Seeds file not found."}
    end
  end

  @spec get_path(Ecto.Repo.t(), String.t(), String.t()) :: String.t()
  defp get_path(repo, directory, filename) do
    priv_dir = "#{:code.priv_dir(@app)}"

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    Path.join([priv_dir, repo_underscore, directory, filename])
  end

  defp load_app do
    Application.load(@app)
  end
end
