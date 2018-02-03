class Users::WorkersController < ApplicationController
    layout 'dashboard'

    def select_daycare
        set_query
        set_daycares
        render layout: 'registration'
    end

    def select_type
        render layout: 'registration'
    end

    def select_department
        set_daycare
        set_departments
    end

    def get_daycares
        set_query
        @daycares ||= params[:query].present? ? Daycare.search(@query, params[:page], 100, 300) : Daycare.all
        respond_to do |format|
            format.json {render :json => @daycares}
        end
    end

    def update_daycare
        set_daycare
        current_user.daycare = @daycare
        current_user.save
        respond_to do |format|
            format.json {render :json => @daycare}
        end
    end

    def update_department
        set_daycare
        set_departments        
    end

    def change_department
        set_daycare
        current_user.daycare = @daycare
        current_user.department_id = params[:department_id]
        current_user.save
        respond_to do |format|
            format.json {render :json => @daycare}
        end
    end

    private

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_daycares
        if params[:query].present?
            if params[:option].to_i < 2
                @daycares = Affiliate.search_by_type(@query, params[:option].to_i)
            else
                care_type = params[:option].to_i - 1
                @daycares = Daycare.search_by_type(@query, care_type, params[:page], 100, 300)
            end            
        else
            if params[:option].to_i < 2
                @daycares = Affiliate.where(affiliate_type: params[:option].to_i)
            else
                care_type = params[:option].to_i - 1
                @daycares = Daycare.where(care_type: care_type)
            end            
        end        
    end

    def set_daycare
        @daycare ||= Daycare.find(params[:daycare_id])
    end

    def set_departments
        @departments ||= @daycare.departments
        render layout: 'registration'
    end
end