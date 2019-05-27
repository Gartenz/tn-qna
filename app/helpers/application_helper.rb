module ApplicationHelper
  def question?(record)
    record.is_a?(Question)
  end

  def answer?(record)
    record.is_a?(Answer)
  end
end
