module ApplicationHelper
  def question?(record)
    record.is_a?(Question)
  end

  def answer?(record)
    record.is_a?(Answer)
  end

  def user?(record)
    record.is_a?(User)
  end

  def comment?(record)
    record.is_a?(Comment)
  end
end
