class PodcastsController < ApplicationController

  def index
    if params[:tags].present?
      @podcasts = Podcast.joins(:tags).where(tags: {id: params[:tags][:ids]})
    else
      @podcasts = Podcast.where(nil)
    end
    @podcasts = @podcasts.filter_by_active
    @podcasts = @podcasts.filter_by_location(params[:location])if params[:location].present?
    @podcasts = @podcasts.filter_by_adult_content(params[:adult_content])if params[:adult_content].present?
    @podcasts = @podcasts.filter_by_name(params[:name])if params[:name].present?
  end

  def new
    @podcast = Podcast.new
  end

  def show
    podcast = Podcast.find(params[:id])
    @podcast_facade = PodcastFacade.new(podcast)
  end

  def create
    podcast = current_user.podcasts.new(podcast_params)
    if podcast.save
      params[:tags][:ids].each {|tag| PodcastTag.create({podcast_id: podcast.id, tag_id: tag})} if params[:tags]
      flash[:notice] = 'Podcast submitted and waiting approval'
      redirect_to '/dashboard'
    else
      flash[:error] = podcast.errors.full_messages.to_sentence
      redirect_to request.referrer
    end
  end

  private

  def podcast_params
    params.permit(:name, :location, :description, :patreon, :instagram, :facebook, :twitter, :podcast_uri, :photo, :adult_content)
  end
end
