module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down vote_cancel]
  end

  def vote_up
    if !@votable.voted?(current_user) && !current_user.author_of?(@votable)
      @votable.vote(current_user, true)
    end
    make_responde
  end

  def vote_down
    if !@votable.voted?(current_user) && !current_user.author_of?(@votable)
      @votable.vote(current_user, false)
    end
    make_responde
  end

  def vote_cancel
    if @votable.voted?(current_user)
      @votable.cancel_vote(current_user)
    end
    make_responde
  end

  private

  def make_responde
    respond_to do |format|
      format.json { render_json(@votable) }
    end
  end

  def render_json(item)
    body = { "id": item.id, "score": item.score }
    render json: Hash[param_name(item), body]
  end

  def param_name(item)
    item.class.name.underscore
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
