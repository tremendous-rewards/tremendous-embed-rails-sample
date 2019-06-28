module Webhook
  def self.handle(body)
    Rails.logger.info("Tremendous webhook fired :: #{body}")
    # Each webhook contains a event_id property.
    # Retries due to failed responses by this server will
    # contain the same event_id. We could store this value
    # and discard duplicate webhooks or we can make our code idempotent.
    end
  end

  def self.on_redeemed(reward)
    reward = Reward.find_by_tremendous_id(reward[:id])
  end

  def self.on_payout_canceled(reward)
    # The user or your team initiated a cancellation of the payout
    # typically so that the recipient can select a different option.
    # Cancel the payout and communicate to the user to redeem again.
    RewardPayout.find_by_tremendous_id(
      reward[:payout][:id]
    ).cancel!
  end

  def self.on_payout_failed(reward)
    # The recipient provided bad redemption information or the payout
    # otherwise failed. Fail the payout and communicate to the user to redeem again.
    RewardPayout.find_by_tremendous_id(
      reward[:payout][:id]
    ).fail!
  end
end
