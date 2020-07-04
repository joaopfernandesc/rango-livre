class AddResponsibleIdColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :responsible_id, :integer
  end
end
