class Parentee::IllnessGuidesController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(['parentee'])}

  def index

  end

  def illness
    set_illnesses
  end

  def content
    find_illness_guide

  end

  private

  def set_illnesses
    @illnesses ||= Illness.where(language: I18n.locale.downcase).all
  end

  def set_illness
    @illness = Illness.find params[:illness_id] if (params[:illness_id].present?)
  end

  def find_illness_guide
    set_illness

    @illness_guide = ''
    if @illness && params['target_role'].present?
      if params['target_role'] == 'worker'
        @illness_guide = @illness.worker_guide.url unless @illness.worker_guide.blank?
      else
        @illness_guide = @illness.parent_guide.url unless @illness.parent_guide.blank?
      end
    end
  end
end
