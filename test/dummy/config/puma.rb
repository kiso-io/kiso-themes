environment 'production'

 workers 7
 threads 16, 32
 preload_app!

 on_worker_boot do
   ActiveSupport.on_load(:active_record) do
     ActiveRecord::Base.establish_connection
   end
 end

