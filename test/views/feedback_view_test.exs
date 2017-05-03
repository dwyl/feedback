defmodule Feedback.FeedbackViewTest do
  use Feedback.ConnCase, async: true


  test "truncate_text" do
    truncated_text = Feedback.FeedbackView.truncate_text("Test", 2)
    assert truncated_text == "Te..."
  end

  test "truncate_text doesn't apply to text shorter than given length" do
    truncated_text = Feedback.FeedbackView.truncate_text("Test", 5)
    assert truncated_text == "Test"
  end

  test "truncate_text removes white space" do
    truncated_text = Feedback.FeedbackView.truncate_text("Test whitespace   ", 16)
    assert truncated_text == "Test whitespace..."
  end

  test "format_date today" do
    format_date = Feedback.FeedbackView.format_date(DateTime.utc_now())
    assert format_date == "Today"
  end

  test "format_date not today" do
    date = ~D[2017-01-01]
    format_date = Feedback.FeedbackView.format_date(date)
    assert format_date == "1/1/2017"
  end
end
