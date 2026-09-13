module PostsHelper
  def whatsapp_share_url(post)
    "https://api.whatsapp.com/send?text=#{CGI.escape(post.title + ' ' + post_url(post))}"
  end

  def twitter_share_url(post)
    "https://twitter.com/intent/tweet?text=#{CGI.escape(post.title)}&url=#{post_url(post)}"
  end

  def facebook_share_url(post)
    "https://www.facebook.com/sharer/sharer.php?u=#{post_url(post)}"
  end
end
