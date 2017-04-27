defmodule Feedback.ResponseTest do
  use Feedback.ModelCase

  alias Feedback.Response

  @valid_attrs %{
    response: "This is my response",
    edit: false,
    edited: false,
    feedback_id: 1
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Response.changeset(%Response{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Response.changeset(%Response{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "response schema" do
     actual = Response.__schema__(:fields)
     expected = [
       :id,
       :response,
       :edit,
       :edited,
       :feedback_id,
       :inserted_at,
       :updated_at
     ]
     assert actual == expected
   end

end
