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

  def link_edit(url, **params)
    link_to fa('fa-pen-to-square fa-fw', t('site.generic.edit')), url, params
  end

  def link_destroy(url, **params)
    default = { data: { turbo_method: :delete, turbo_confirm: 'Confermi eliminazione?' } }
    link_to fa('fa-trash fa-fw', t('site.generic.destroy')), url, default.merge(params)
  end

  def panel_link(icon, text, url, **params)
    params[:class] = "panel-block #{params[:class]}"
    safe_join [link_to(content_tag(:span, fa(icon), class: 'panel-icon') + text, url, params)]
  end

  def panel_link_back(url, **_params)
    panel_link 'fa-chevron-left', t('site.generic.back'), url
  end

  def yield_title(icon, text)
    content_tag :h3, fa(icon, text), class: 'title has-text-centered'
  end

  def details_element(obj, method, alt: nil, dl_opt: {}, dt_opt: {}, dd_opt: {})
    content_tag :dl, safe_join( [content_tag( :dt, t(method, scope: ['activerecord.attributes', obj.class.name.downcase ]), dt_opt), content_tag(:dd, alt || obj.send(method), dd_opt)]), dl_opt
  end

  def details_description(obj, method, alt: nil, dl_opt: {class: 'description'}, dt_opt: {}, dd_opt: {})
    details_element(obj, method, alt: alt, dl_opt: dl_opt, dt_opt: dt_opt, dd_opt: dd_opt)
  end
end
