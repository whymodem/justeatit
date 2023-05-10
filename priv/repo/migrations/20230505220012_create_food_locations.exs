defmodule JustEatIt.Repo.Migrations.CreateFoodLocations do
  use Ecto.Migration

  def change do
    create table(:food_facilities) do
      add :name, :string
      add :facility_type, :integer
      add :menu_description, :text
      add :address, :string
      add :latitude, :decimal
      add :longitude, :decimal
      add :external_id, :string

      timestamps()
    end
  end
end
