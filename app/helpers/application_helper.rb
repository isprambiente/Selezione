# frozen_string_literal: true

# This module contain the generic helper for Selezione
module ApplicationHelper
  include Pagy::Frontend
  
  def fa(icon, text=nil, **params)
    params[:class] = "fa-solid #{icon}"
    [content_tag(:i, nil, params),text].compact.join(' ').html_safe
  end

  def link_back(url, **params)
    link_to fa('fa-chevron-left fa-fw', t('site.generic.back')), url, params
  end

  def panel_link(icon, text, url, **params)
    params[:class] = 'panel-block ' + params[:class].to_s 
    link_to content_tag(:span, fa(icon), class: 'panel-icon').html_safe + text, url, params
  end

  def panel_link_back(url, **params)
    panel_link 'fa-chevron-left', t('site.generic.back'), url
  end

end
