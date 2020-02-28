class ChangeColumnYieldToOutput < ActiveRecord::Migration[6.0]
  def change
    rename_column :recipes, :yield, :output
  end
end
