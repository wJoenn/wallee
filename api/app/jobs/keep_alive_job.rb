class KeepAliveJob < ApplicationJob
  def perform
    logger.info "Keeping server alive while unused."
  end
end
