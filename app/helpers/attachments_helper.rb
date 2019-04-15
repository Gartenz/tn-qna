module AttachmentsHelper
  def is_question?(record)
    record.is_a?(Question)
  end

  def is_answer?(record)
    record.is_a?(Answer)
  end
end
