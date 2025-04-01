module Api
  module V1
    class EventsController < ApplicationController
      before_action :set_event, only: [:show, :update, :destroy]
      before_action :authorize_organizer, only: [:create, :update, :destroy]

      def index
        @events = Event.all
        render json: @events
      end

      def show
        render json: @event
      end

      def create
        @event = @current_user.events.build(event_params)
        if @event.save
          render json: @event, status: :created
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end

      def update
        if @event.update(event_params)
          EventUpdateNotificationJob.perform_later(@event.id)
          render json: @event
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @event.destroy
        head :no_content
      end

      private

      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        params.require(:event).permit(:title, :description, :date, :venue)
      end

      def authorize_organizer
        unless @current_user.is_a?(EventOrganizer)
          render json: { error: 'Forbidden' }, status: :forbidden
        end
      end
    end
  end
end
