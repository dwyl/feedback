defmodule Feedback.FeedbackTest do
  use Feedback.ModelCase

  alias Feedback.Feedback

  @valid_attrs %{
    item: "This is my feedback",
    submitter_email: "test@email.com",
    permalink_string: "long-and-un-guessable",
    mood: "happy",
    public: false,
    edit: false,
    edited: false
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Feedback.changeset(%Feedback{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Feedback.changeset(%Feedback{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "feedback schema" do
     actual = Feedback.__schema__(:fields)
     expected = [
       :id,
       :item,
       :submitter_email,
       :permalink_string,
       :mood,
       :public,
       :edit,
       :edited,
       :inserted_at,
       :updated_at
     ]
     assert actual == expected
   end
end
