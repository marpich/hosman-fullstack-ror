class Expert < ApplicationRecord
  has_many :properties
  CITIES = ["paris", "bordeaux", "toulouse", "lille"]
end
