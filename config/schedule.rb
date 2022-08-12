set :output, "report_cron_log.log"
set :environment, 'development'

every 1.day, at: "1:33 pm" do
  runner "ReportRemindJob.perform_async"
end

every 1.day, at: "4:30 am" do
  rake "nampt:backup backup_name=#{Time.now}"
end
