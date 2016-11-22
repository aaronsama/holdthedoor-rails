class Access
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :openedWith, type: String

  belongs_to :user
end
