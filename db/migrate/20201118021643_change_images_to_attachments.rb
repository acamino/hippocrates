class ChangeImagesToAttachments < ActiveRecord::Migration[5.2]
  def change
    rename_table :images, :attachments
  end
end
