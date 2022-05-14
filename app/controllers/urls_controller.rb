class UrlsController < ApplicationController

  before_action :authenticate_admin, only: %i[index show edit destroy]
  before_action :set_url, only: %i[ show edit update destroy ]

  def index
    @urls = Url.filter_results(params)
  end

  def show
  end

  def new
    @url = Url.new
  end

  def edit
  end

  def create
    @url = Url.new(url_params)
    respond_to do |format|
      if @url.save
        format.html { redirect_to url_url(@url), notice: "Url was successfully created." }
        format.json { render :show, status: :created, location: @url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to url_url(@url), notice: "Url was successfully updated." }
        format.json { render :show, status: :ok, location: @url }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url, notice: "Url was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def create_shorten
    @urls = Url.making_shorten_url(params, user_signed_in? ? current_user : nil)
    redirect_to create_shorten_urls_path if (@urls == [])
  end

  def send_to_original
    if params[:shorten_url].present?
      @urls = Url.fetch_with_shorten_url(params[:shorten_url])
      unless @urls.empty?
        @urls.first.update!(often_access: @urls.first.often_access + 1, last_access_at: DateTime.now())
        redirect_to @urls.first.original_url
      end
    end
  end

  private
    def set_url
      @url = Url.find(params[:id])
    end

    def url_params
      params.require(:url).permit(:original_url, :shorten_url, :often_shorten, :often_access, :is_public, :status, :user_id, :last_access_at)
    end

    def authenticate_admin
      if user_signed_in?
        redirect_to root_path unless current_user.role == 'admin'
        true
      else
        redirect_to root_path
      end
    end
end
