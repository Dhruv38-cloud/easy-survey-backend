class Survey < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  # Initialize empty components array
  after_initialize :set_default_components, if: :new_record?

  private

  def set_default_components
    self.components ||= []
  end
end
