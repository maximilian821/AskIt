class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
