# frozen_string_literal: true

module Admin
  module Stats
    class PoisController < ApplicationController
      before_action :authorize_admin_controllers

      def all
        app_visits = AppVisit.all
        pois = Poi.all.index_by(&:id)

        email_poi_counts = Hash.new {|h, k| h[k] = Hash.new(0) }
        session_poi_counts = Hash.new {|h, k| h[k] = Hash.new(0) }
        total_poi_counts = Hash.new(0)
        app_visit_poi_counts = Hash.new(0)

        app_visits.each do |visit|
          unique_pois = visit.viewed_pois.uniq
          unique_pois.each do |poi_id|
            email_poi_counts[visit.email][poi_id] = 1
            session_poi_counts[visit.session_id][poi_id] = 1
            app_visit_poi_counts[poi_id] += 1
          end
          visit.viewed_pois.each {|poi_id| total_poi_counts[poi_id] += 1 }
        end

        email_grouped = transform_counts_to_array(email_poi_counts, pois, true)
        session_id_grouped = transform_counts_to_array(session_poi_counts, pois, true)
        pois_grouped_with_duplicates = transform_counts_to_array({"all" => total_poi_counts}, pois, true)
        app_visit_grouped = transform_counts_to_array({"all" => app_visit_poi_counts}, pois, true)

        render json: {
          email_grouped:,
          session_id_grouped:,
          pois_grouped_with_duplicates:,
          app_visit_grouped:
        }
      end

      private

      def transform_counts_to_array(counts_hash, pois, flatten_all=false)
        aggregated_counts = counts_hash.each_with_object(Hash.new(0)) do |(_key, counts), agg|
          counts.each {|poi_id, count| agg[poi_id] += count }
        end

        aggregated_counts.select {|poi_id, _| pois.key?(poi_id) }

        result = aggregated_counts.map do |poi_id, count|
          {count:, poi: pois[poi_id]}
        end.sort_by {|h| -h[:count] }

        flatten_all ? result.flatten(1) : result
      end
    end
  end
end
