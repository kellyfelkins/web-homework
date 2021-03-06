defmodule Homework.Accounts.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "companies" do
    field(:available_credit, :integer)
    field(:credit_line, :integer)
    field(:name, :string)
    field(:tid, :string)

    timestamps()
  end

  @valid_attributes ~w{available_credit credit_line name tid}a
  @required_attributes ~w{available_credit credit_line name}a

  def changeset(company, attrs) do
    company
    |> cast(attrs, @valid_attributes)
    |> validate_required(@required_attributes)
  end

  def create_changeset(company, attrs) do
    attrs =
      case attrs do
        %{:credit_line => credit_line} -> Map.put(attrs, :available_credit, credit_line)
        _ -> attrs
      end

    changeset(company, attrs)
  end
end
