class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :validates_url_format

  private

  def validates_url_format
    unless url.present? && compliant_url?
      self.errors.add(:url, "is not a valid HTTP URL")
    end
  end

  def compliant_url?
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
