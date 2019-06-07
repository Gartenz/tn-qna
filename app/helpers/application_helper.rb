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

  def collection_cache_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
