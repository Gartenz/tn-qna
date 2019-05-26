module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :set_subscribable, only: %i[subscribe]
  end

  def subscribe
    @subscribable.subscribe(current_user)
    make_responde
  end
  ## TODO: Make response to json

  private

  def make_responde
    respond_to do |format|
      format.json { render_json(@votable) }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_subscribable
    @subscribable = model_klass.find(params[:id])
  end
end
