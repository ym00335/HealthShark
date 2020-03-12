class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]

  # GET /discussions
  # GET /discussions.json
  def index
    @discussions = Discussion.all
  end

  # GET /discussions/1
  # GET /discussions/1.json
  def show
    @messages = @discussion.messages.where("discussion_id IS ?", @discussion.id).order(created_at: :asc).last(5)
    @messages_count = @discussion.messages.count
  end

  # GET /discussions/new
  def new
    @discussion = Discussion.new
  end

  # GET /discussions/1/edit
  def edit
    if @discussion.owner.id != current_user.id
      not_found
    end
  end

  # POST /discussions
  # POST /discussions.json
  def create
    @discussion = Discussion.new(discussion_params)

    # Set the current user to be the owner of the new Discussion
    @discussion.owner = current_user

    respond_to do |format|
      if @discussion.save
        format.html { redirect_to @discussion, notice: 'Discussion was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /discussions/1
  # PATCH/PUT /discussions/1.json
  def update
    # Only allow the update if the owner of the discussion is the current user
    if @discussion.owner.id != current_user.id
      not_found
    end

    respond_to do |format|
      if @discussion.update(discussion_params)
        format.html { redirect_to @discussion, notice: 'Discussion was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /discussions/1
  # DELETE /discussions/1.json
  def destroy
    # Only allow the destroy if the owner of the discussion is the current user
    if @discussion.owner.id != current_user.id
      not_found
    end

    @discussion.destroy
    respond_to do |format|
      format.html { redirect_to discussions_url, notice: 'Discussion was successfully destroyed.' }
    end
  end

  def subscribe
    # Necessary for subscribing to the Action Cable (WebSocket) for the real time discussion connection
  end

  def self.get_discussion_image_path(discussion)
    # Get the image path of a discussion or the default discussion image path
    # if the discussion does not have a custom image
    if discussion.image.present?
      discussion.image.url
    else
      ActionController::Base.helpers.asset_url('default-discussion-img.png', type: :image)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def discussion_params
      params.require(:discussion).permit(:topic, :owner, :image)
    end
end
