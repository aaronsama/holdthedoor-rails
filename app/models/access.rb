class Access
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :openedWith, type: String
  field :user, type: String
end
