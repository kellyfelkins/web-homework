defmodule Homework.TransactionsTest do
  use Homework.DataCase

  alias Homework.Merchants
  alias Homework.Accounts
  alias Homework.Transactions

  describe "transactions" do
    alias Homework.Transactions.Transaction

    setup do
      {:ok, company1} =
        Accounts.create_company(%{
          available_credit: 10_000_00,
          credit_line: 10_000_00,
          name: "some name"
        })

      {:ok, company2} =
        Accounts.create_company(%{
          available_credit: 10_000_00,
          credit_line: 10_000_00,
          name: "some updated name"
        })

      {:ok, merchant1} =
        Merchants.create_merchant(%{description: "some description", name: "some name"})

      {:ok, merchant2} =
        Merchants.create_merchant(%{
          description: "some updated description",
          name: "some updated name"
        })

      user1 = insert(:user, company: company1)

      user2 = insert(:user, company: company2)

      valid_attrs = %{
        amount: 42,
        company_id: company1.id,
        credit: true,
        debit: true,
        description: "some description",
        merchant_id: merchant1.id,
        user_id: user1.id
      }

      update_attrs = %{
        amount: 43,
        company_id: company2.id,
        credit: false,
        debit: false,
        description: "some updated description",
        merchant_id: merchant2.id,
        user_id: user2.id
      }

      invalid_attrs = %{
        amount: nil,
        company_id: nil,
        credit: nil,
        debit: nil,
        description: nil,
        merchant_id: nil,
        user_id: nil
      }

      {:ok,
       %{
         company1: company1,
         company2: company2,
         invalid_attrs: invalid_attrs,
         merchant1: merchant1,
         merchant2: merchant2,
         update_attrs: update_attrs,
         user1: user1,
         user2: user2,
         valid_attrs: valid_attrs
       }}
    end

    def transaction_fixture(valid_attrs, attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(valid_attrs)
        |> Transactions.create_transaction()

      transaction
    end

    test "list_transactions/1 returns all transactions", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert Transactions.list_transactions([]) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction", %{
      company1: company1,
      merchant1: merchant1,
      user1: user1,
      valid_attrs: valid_attrs
    } do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.amount == 42
      assert transaction.company_id == company1.id
      assert transaction.credit == true
      assert transaction.debit == true
      assert transaction.description == "some description"
      assert transaction.merchant_id == merchant1.id
      assert transaction.user_id == user1.id
    end

    test "create_transaction/1 with invalid data returns error changeset", %{
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction", %{
      company2: company2,
      merchant2: merchant2,
      update_attrs: update_attrs,
      user2: user2,
      valid_attrs: valid_attrs
    } do
      transaction = transaction_fixture(valid_attrs)

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.amount == 43
      assert transaction.company_id == company2.id
      assert transaction.credit == false
      assert transaction.debit == false
      assert transaction.description == "some updated description"
      assert transaction.merchant_id == merchant2.id
      assert transaction.user_id == user2.id
    end

    test "update_transaction/2 with invalid data returns error changeset", %{
      valid_attrs: valid_attrs,
      invalid_attrs: invalid_attrs
    } do
      transaction = transaction_fixture(valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
