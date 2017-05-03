defmodule Feedback.ForumView do
  use Feedback.Web, :view
  import Feedback.FeedbackView, only: [truncate_text: 2, format_date: 1]
end
