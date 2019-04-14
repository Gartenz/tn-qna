module AttachmentsHelper
  def is_record_question?(record)
    record.is_a?(Question)
  end

  def is_record_answer?(record)
    record.is_a?(Answer)
  end
end
