defmodule Vuechat.Message do
  use Vuechat.Web, :model

  schema "messages" do
    field :username, :string
    field :body, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :body])
    |> validate_required([:username, :body])
  end
end
