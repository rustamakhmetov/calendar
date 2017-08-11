class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_event, only: [:update, :destroy, :share]

  authorize_resource

  respond_to :js

  def create
    @event = current_user.create_event(event_params[:date], event_params[:body])
    errors_to_flash @event
    respond_with @event
  end

  def update
    @event.update(event_params)
    respond_with @event
  end

  def destroy
    respond_with(current_user.delete_event(@event))
  end

  def share
    respond_with(@event.share_by_email(event_params[:email]))
  end

  private

  def load_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:date, :body, :email)
  end
end
