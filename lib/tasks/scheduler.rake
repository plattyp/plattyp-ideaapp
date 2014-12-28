desc "This task is called by the Heroku scheduler add-on"
task :purge_sessions => :environment do
    sql = "DELETE FROM sessions WHERE updated_at < (CURRENT_TIMESTAMP - INTERVAL '1 days');"
    ActiveRecord::Base.connection.execute(sql)
end