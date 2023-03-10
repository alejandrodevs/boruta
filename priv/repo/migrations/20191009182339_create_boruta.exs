defmodule Boruta.Repo.Migrations.CreateBoruta do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:secret, :string)
      add(:redirect_uri, :string)
      add(:scope, :string)
      add(:authorize_scope, :boolean, default: false)

      timestamps()
    end

    create table(:tokens, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:type, :string)
      add(:value, :string)
      add(:refresh_token, :string)
      add(:expires_at, :integer)
      add(:redirect_uri, :string)
      add(:state, :string)
      add(:scope, :string)

      add(:client_id, references(:clients, type: :uuid, on_delete: :nilify_all))
      add(:resource_owner_id, :string)

      timestamps()
    end

    create table(:scopes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :public, :boolean, default: false, null: false

      timestamps()
    end

    create table(:clients_scopes) do
      add(:client_id, references(:clients, type: :uuid, on_delete: :delete_all))
      add(:scope_id, references(:scopes, type: :uuid, on_delete: :delete_all))
    end

    create unique_index(:clients, [:id, :secret])
    create unique_index(:clients, [:id, :redirect_uri])
    create index("tokens", [:value])
    create unique_index("tokens", [:client_id, :value])
    create unique_index("tokens", [:client_id, :refresh_token])
    create unique_index("scopes", [:name])
  end
end
