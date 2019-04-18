class RewardsController < ApplicationController
  expose(:user_rewards) { current_user&.rewards }
end
