module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :set_subscribable, only: %i[subscribe]
  end

  def subscribe
    @subscribable.subscribe(current_user)
    render template: 'shared/subscribe', resource: @subscribable
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_subscribable
    @subscribable = model_klass.find(params[:id])
  end
end
