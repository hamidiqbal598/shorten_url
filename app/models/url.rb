class Url < ApplicationRecord

  belongs_to :user, optional: true

  scope :fetch_with_original_url, -> (original_url) { where(original_url: original_url) }
  scope :fetch_public_original_url, -> (original_url) { where(is_public: true, original_url: original_url) }
  scope :fetch_non_public_original_url, -> (original_url) { where(is_public: false, original_url: original_url) }
  scope :search_by_id, -> (url_id) { where(id: url_id) }
  scope :search_by_user, -> (user_id) { where(user_id: user_id) }
  scope :search_public_urls, -> (is_public) { where(is_public: is_public) }
  scope :fetch_with_shorten_url, -> (shorten_url) { where(shorten_url: shorten_url) }

  validates :original_url, presence: true, format: URI::regexp(%w[http https])
  validates_length_of :original_url, within: 3..255, on: :create, message: "URL is too big"

  validates_uniqueness_of :shorten_url
  validates_length_of :shorten_url, within: 3..255, on: :create, message: "New URL is too big"

  before_validation :generate_shorten_url

  def generate_shorten_url
    self.shorten_url = SecureRandom.uuid[0..8] if self.shorten_url.nil? || self.shorten_url.empty?
    true
  end

  def self.filter_results(params)
    urls = Url.all.page(params[:page])
    urls = urls.search_by_user(params[:user_id]) unless params[:user_id].blank?
    urls = urls.search_public_urls(params[:is_public]) unless params[:is_public].blank?
    urls = urls.search_by_id(params[:url_id]) unless params[:url_id].blank?
    urls
  end

  def self.making_shorten_url(params, current_user = nil)
    if params[:original_url].present?
      if current_user
        urls = Url.fetch_non_public_original_url(params[:original_url]).search_by_user(current_user.id)
      else
        urls = Url.fetch_public_original_url(params[:original_url])
      end
      if urls.empty?
        url = Url.new(original_url: params[:original_url], last_access_at: DateTime.now())
        if current_user
          url.user_id = current_user.id
          url.is_public = false
        end
        url.save!
        return []
      else
        urls.first.update!(often_shorten: urls.first.often_shorten + 1, last_access_at: DateTime.now())
        return []
      end
    end
    urls = Url.all.page(params[:page])
    if current_user
      urls = urls.search_by_user(current_user.id)
    else
      urls = urls.search_public_urls(true)
    end
    urls
  end

end
