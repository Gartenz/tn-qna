module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :set_subscribable, only: %i[subscribe]
    after_action :self_subscribe, only: %i[create]
  end

  def subscribe
    @subscribable.subscribe(current_user)
    render template: 'shared/subscribe', resource: @subscribable
  end

  private

  def self_subscribe
    if Gem.loaded_specs.has_key?('decent_exposure')
      self.instance_variable_get("@exposed_#{controller_name.classify.downcase}").subscribe(current_user)
    else
      self.instance_variable_get("@#{controller_name.classify.downcase}").subscribe(current_user)
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_subscribable
    @subscribable = model_klass.find(params[:id])
  end
end
