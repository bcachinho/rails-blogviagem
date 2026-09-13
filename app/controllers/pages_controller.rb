class PagesController < ApplicationController
  def home
    @members = ["thanh", "dimitri", "germain", "damien", "julien"]
    if params[:member]
      @members = @members.select { |member| member.start_with?(params[:member]) }
    end
  end

  def about
  end

  def blog
  end
end
