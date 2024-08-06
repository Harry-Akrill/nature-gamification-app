# frozen_string_literal: true

module Admin
  class StatsController < ApplicationController
    before_action :authorize_admin_controllers

    # rubocop:disable Style/MultilineBlockChain
    def globe
      unique = LandingPageVisit.all.group_by(&:session_id).map {|_, visits|
                 visits.first
               }.map {|visit| [visit.longitude, visit.latitude, 1] }
      all = LandingPageVisit.pluck(:longitude, :latitude).map {|coordinates| coordinates << 1 }
      render json: {all:, unique:}
    end

    # rubocop:enable Style/MultilineBlockChain
    # rubocop:disable Style/MultilineBlockChain
    # rubocop:disable Metrics/AbcSize
    def all_visits
      unique = LandingPageVisit.all.group_by(&:session_id).map {|_, visits|
                 visits.first.email_of_registered_user = visits.any? {|visit| !visit.email_of_registered_user.nil? }
                 visits.first
               }.map {|visit|
        [visit.country, visit.created_at, visit.time_spent_seconds,
         !visit.email_of_registered_user.nil?]
      }
      all = LandingPageVisit.pluck(:country, :created_at, :time_spent_seconds, :email_of_registered_user)
      all.map! {|visit|
        visit[3] = !visit[3].nil?
        visit
      }

      unique.sort_by! {|visit| visit[1] }
      all.sort_by! {|visit| visit[1] }

      # Remove in production, 3D plot has tooltip not showing bug with very small amounts of data
      # unique = unique.flat_map do |element|
      #   10.times.map { [element[0], rand(1..15).days.ago, element[2] * rand(1..15), element[3]] }
      # end

      # all = all.flat_map do |element|
      #   10.times.map { [element[0], rand(1..15).days.ago, element[2] * rand(1..15), element[3]] }
      # end

      # unique.sort_by! {|visit| visit[1] }
      # all.sort_by! {|visit| visit[1] }

      render json: {all:, unique:}
    end

    # rubocop:enable Style/MultilineBlockChain
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize
    def route_visits
      entries = LandingPageVisit.all.group_by(&:session_id)

      counts = Hash.new(0)
      entries.each_value do |visits|
        paths = visits.pluck(:path_to_registration).map {|path| path.split("/") }
        unique_paths = paths.flatten(1).reject(&:empty?).uniq
        unique_paths.each {|path| counts[path] += 1 }
      end
      number_of_registrations = LandingPageVisit.where.not(email_of_registered_user: nil).count
      total_unique_visits = LandingPageVisit.select(:session_id).distinct.count
      render json: {routes_visited: counts, registrations: number_of_registrations,
total_unique_visits:}
    end
    # rubocop:enable Metrics/AbcSize

    def overall_details
      questions_asked = Question.count
      questions_answered = Question.where.not(answer: nil).count
      mailing_list_signups = MailingList.count
      customer_users_in_system = User.where(user_type: 0).count
      total_reviews = Review.count
      average_review_rating = Review.average(:rating)
      average_review_rating = 5 if average_review_rating.nil?
      render json: {
        questions_asked:,
        questions_answered:,
        mailing_list_signups:,
        customer_users_in_system:,
        total_reviews:,
        average_review_rating:
      }
    end
  end
end
