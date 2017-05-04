defmodule Feedback.FeedbackTest do
  use Feedback.ModelCase, async: false

  alias Feedback.Feedback

  @valid_attrs %{
    item: "This is my feedback",
    response: "This is my response to your feedback",
    responded: true,
    submitter_email: "test@email.com",
    permalink_string: "long-and-un-guessable"
  }
  @invalid_attrs %{
    item: "Feedback without permalink"
  }

  test "changeset with valid attributes" do
    changeset = Feedback.changeset(%Feedback{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Feedback.changeset(%Feedback{}, @invalid_attrs)
    refute changeset.valid?
  end
end
