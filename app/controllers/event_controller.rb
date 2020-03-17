class EventController < ApplicationController
  before_action :authenticate_user!
  skip_forgery_protection
    def get
      events = Event.where(:user_id => current_user.id)

      render :json => events.map {|event| {
          :id => event.id,
          :start_date => event.start_date.to_formatted_s(:db),
          :end_date => event.end_date.to_formatted_s(:db),
          :text => event.text
      }}
    end

    def add
      event = current_user.events.create :text=>params["text"], :start_date=>params["start_date"], :end_date=>params["end_date"]
      render :json=>{:action => "inserted", :tid => event.id}
    end

    def update
      event = Event.find(params["id"])
      event.text = params["text"]
      event.start_date = params["start_date"]
      event.end_date = params["end_date"]
      event.user_id = current_user.id
      event.save
      render :json=>{:action => "updated"}
    end

    def delete
      Event.find(params["id"]).destroy

      render :json=>{:action => "deleted"}
    end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end
  # Only allow a list of trusted parameters through.
  def log_params
    params.require(:event).permit(:start_date, :end_date, :text)
  end
end
