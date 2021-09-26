class ArticlesController < ApplicationController
  include Paginable

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end

  def serializer
    ArticleSerializer
  end

  def show
    @article = Article.find(params[:id])
    render json: serializer.new(@article)
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message, detail: "Here will be nicely formatted responce" }
  end
end