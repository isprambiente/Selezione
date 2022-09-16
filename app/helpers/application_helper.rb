# frozen_string_literal: true

# This module contain the generic helper for Selezione
module ApplicationHelper
  include Pagy::Frontend

  def fa(icon, text = nil, **params)
    params[:class] = "fa-solid #{icon}"
    safe_join [content_tag(:i, nil, params), text], ' '
  end

  def link_back(url, **params)
    link_to fa('fa-chevron-left fa-fw', t('site.generic.back')), url, params
  end

  def panel_link(icon, text, url, **params)
    params[:class] = "panel-block #{params[:class]}"
    safe_join [link_to(content_tag(:span, fa(icon), class: 'panel-icon') + text, url, params)]
  end

  def panel_link_back(url, **_params)
    panel_link 'fa-chevron-left', t('site.generic.back'), url
  end
end
