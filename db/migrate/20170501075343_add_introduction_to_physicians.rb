class AddIntroductionToPhysicians < ActiveRecord::Migration[5.0]
  def change
    add_column :physicians, :introduction, :text
  end
end
