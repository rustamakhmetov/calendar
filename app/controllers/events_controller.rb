class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_event, only: [:update, :destroy]

  respond_to :js

  def create
    @event = current_user.create_event(event_params[:date], event_params[:body])
    errors_to_flash @event
    respond_with @event
  end

  # def update
  #   @answer.update(answer_params)
  #   respond_with @answer
  # end
  #
  # def destroy
  #   respond_with(@answer.destroy!)
  # end
  #
  # def accept
  #   respond_with(@answer.accept!)
  # end

  private

  def load_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:date, :body)
  end
end
