class AddLikeCountToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :likes_count, :integer, :default => 0

    Post.pluck(:id).each do |i|
      Post.reset_counters(i, :likes)
    end
  end
end
