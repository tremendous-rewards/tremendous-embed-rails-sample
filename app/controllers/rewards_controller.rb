class RewardsController < ApplicationController

  def new
    @reward = create_new_reward!

    # The public key is passed to the Reward js initializer.
    # It is used in conjunction with the private key to decode the JWT.
    @public_key = TREMENDOUS_EMBED_PUBLIC_KEY

    # The reward data (amount, currency, external_id, etc.) is encrypted
    # with Tremendous API access token and only readable using that same key.
    @reward_token = tokenize_reward_configuration(@reward)
  end

  def show
    @reward = Reward.find_by_id(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @reward.present?

    @public_key = TREMENDOUS_EMBED_PUBLIC_KEY
    @reward_token = tokenize_reward_configuration(@reward)
  end

  def update
    # After the reward is created via the javascript SDK,
    # we hit this endpoint with the ID from our system
    # to eventually retrieve the full reward data from the Tremendous REST API.
    reward = Reward.find_by_id(params[:id])
    byebug

    if reward.blank?
      logger.error("Attempt to re-redeem reward :: #{params[:id]}")
      render status: 401, json: {}
    else
      logger.info("Redeem reward :: #{params[:id]}")
      reward.update_attributes({
        tremendous_id: params[:tremendous_id],
        status: Reward.statuses[:redeemed]
      })

      render status: 200, json: {}
    end
  end

  def error
  end

  def webhook
    # This should be handled in an asynchronous worker if possible
    # so that we can respond to the webhook quickly.
    Webhook.handle(params)
    render status: 200, json: {}
  end

  private
    def create_new_reward!
      # For demo purposes, we create a new reward each time we render the page.
      # This is more convenient than running a rake task to generate new model instances.
      user = User.find_or_create_by({
        name: 'Test User',
        email: "test+1@mydomain.com"
      })

      Reward.create!({
        user: user,
        amount: (params[:amount].presence || 50).to_i
      })
    end

    def require_reward
      reward = Reward.find_by_id(params[:id])
      if reward.blank?
        logger.error("Attempt to re-redeem completed reward #{params[:id]}")
        render status: 404, json: {}
      end
    end

    def tokenize_reward_configuration(reward)
      Tremendous::Embed.tokenize(
        TREMENDOUS_ACCESS_TOKEN,
        {
          payment: {
            funding_source_id: ENV["TREMENDOUS_FUNDING_SOURCE_ID"]
          },
          reward: {
            value: {
              denomination: 30,
              currency_code: "USD"
            },
            # products: ["ET0ZVETV5ILN", "A2J05SWPI2QG", "Q24BD9EZ332JT"],
            campaign_id: ENV["TREMENDOUS_CAMPAIGN_ID"],
            recipient: {
              email: "steve@johnson.com",
              name: "Steve Johnson"
            }
          }
        }
      )

    end
end
