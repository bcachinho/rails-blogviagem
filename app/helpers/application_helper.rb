module ApplicationHelper
  def draft_posts_count
    return 0 unless user_signed_in? && current_user

    if current_user.admin?
      Post.draft.count.to_i
    else
      current_user.posts.draft.count.to_i
    end
  end
end
