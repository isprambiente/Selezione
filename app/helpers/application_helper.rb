# frozen_string_literal: true

# This module contain the generic helper for Selezione
module ApplicationHelper
  include Pagy::Frontend
  
  def fa(icon)
    content_tag(:i, nil, class: "fa-solid #{icon}").html_safe
  end
end
