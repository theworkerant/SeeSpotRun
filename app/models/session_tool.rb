class SessionTool < ActiveRecord::Base
  belongs_to :session
  belongs_to :tool
end
