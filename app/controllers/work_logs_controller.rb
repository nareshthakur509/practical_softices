class WorkLogsController < ApplicationController


    def index
       @work_logs = WorkLog.includes(:user).all
       render json: @work_logs.as_json(include: :user)
    end

    def create
        @work_log = WorkLog.new(work_log_params)
        if @work_log.save!
            render json: @work_log, status: :created
        else
            render json: @work_log.errors, status: :unprocessable_entity
        end
    end

    def update
        @work_log = WorkLog.find(params[:id])
        if @work_log.update!(work_log_params)
            render json: @work_log
        else
            render json: @work_log.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @work_log = WorkLog.find(params[:id])
        if @work_log.present?
            @work_log.destroy!
            render json: "WorkLoad Deleted !"
        else
            render json: "No Workload Present !"
        end
    end


    def daily_summary
        from = params[:from]
        to = params[:to]
        summary = WorkLog.joins(:user).where(date: from..to)
                .select('users.id AS user_id',
                  'users.name AS user_name',
                  'work_logs.date AS date',
                  'SUM(work_logs.hours) AS total_hours',
                  "GROUP_CONCAT(work_logs.notes ORDER BY work_logs.id SEPARATOR ' | ') AS notes",
                  'MAX(users.preferred_working_hour_per_day) AS preferred_hours' 
                  )
                .group('users.id, work_logs.date')
                .order('work_logs.date ASC, users.name ASC')
                
        results = summary.map do |record|
            total_hours = record.read_attribute(:total_hours).to_f
            preferred_hours = record.read_attribute(:preferred_hours).to_f
            {
                user_id: record.user_id,
                user_name: record.user_name,
                date: record.date,
                total_hours: record.total_hours,
                preferred_hours: record.preferred_hours,
                notes: record.read_attribute(:notes),
                status: total_hours < preferred_hours ? 'red' : 'green'
            }
        end

        render json: {
            from: from,
            to: to,
            total_records: results.size,
            data: results
        }
    end

    private

    def work_log_params
        params.require(:work_log).permit(:user_id, :date, :hours, :notes)
    end
    
end
