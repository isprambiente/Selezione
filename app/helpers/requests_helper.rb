# frozen_string_literal: true

# This module contain all helper afferent to {Request} module
module RequestsHelper
  def requestable(**params)
    render partial: 'requestable', locals: params
  end
end
