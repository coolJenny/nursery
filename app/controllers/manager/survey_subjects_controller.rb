class Manager::SurveySubjectsController < ApplicationController
    layout 'dashboard_v2'
    before_action -> { authenticate_role!(["manager"]) }
    before_action :authenticate_subscribed!

    def results
        set_subject
        set_workers
        set_parents
        params[:role] = ['parentee', 'worker']
#        @trend = SurveyTrendsGenerator.new(@subject, population)

        if request.xhr?
          render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}
        end
    end

    def result
        set_workers
        set_parents
        @subject ||= SurveySubject.find(params[:id])
        population = @workers.map(&:id) + @parents.map(&:id)
        @trend = SurveyTrendsGenerator.new(@subject, population)
        if request.xhr?
          render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}
        end
    end

    def user_result
        set_subject
        population = [params[:user_id]]
        @trend = SurveyTrendsGenerator.new(@subject, population)
        render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}
    end

    def group_result
        set_subject
        if (params[:role] == 'parentee')
          set_parents
          population = @parents.map(&:id)
        else
          set_workers
          population = @workers.map(&:id)
        end
        @trend = SurveyTrendsGenerator.new(@subject, population)

        render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}
    end

    private

    def set_subject
        @subject ||= SurveySubject.where(language: I18n.locale.upcase).first
    end

    def set_workers
        @workers = current_daycare.workers
    end

    def set_parents
        @parents = current_daycare.parents
    end
end
