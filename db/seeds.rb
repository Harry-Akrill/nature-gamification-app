case Rails.env
when "test"
    User.find_or_create_by(email: "customer@test.com") do |user|
        user.password = "password"
        user.user_type = 0
        user.nickname = "test_customer"
        user.description = "test_description"

      end
    User.find_or_create_by(email: "admin@test.com") do |user|
        user.password = "password"
        user.user_type = 1
        user.nickname = "test_admin"
        user.description = "test_description"

    end
    User.find_or_create_by(email: "customer1@test.com") do |user|
        user.password = "password"
        user.user_type = 0
        user.nickname = "test_customer1"
        user.description = "test_description"

      end

    Review.create(rating: 4, content:"trial_content_1", author:"author_1", upvotes: 10, downvotes:2)
    Review.create(rating: 4, content:"trial_content_2", author:"author_2", upvotes: 10, downvotes:2)

    Question.create(answer:nil , question:"test_question_1", upvotes:0, downvotes:0)
    Question.create(answer:"test_answer_2" , question:"test_question_2", upvotes:0, downvotes:0)
    
    # Create sample comments associated with the POI
    # PoiComment.create(user_id: 1, poi_id: 31, text: "Sample comment 1 for POI 31", rating: 4)
    # PoiComment.create(user_id: 2, poi_id: 31, text: "Sample comment 2 for POI 31", rating: 5)

when "development"
    User.find_or_create_by(email: "customer@test.com") do |user|
        user.password = "password"
        user.user_type = 0
        user.nickname = "test_customer"
        user.description = "test_description"

      end
      User.find_or_create_by(email: "customer2@test.com") do |user|
        user.password = "password"
        user.user_type = 0
        user.nickname = "test_customer1"
        user.description = "test1_description"

      end
    User.find_or_create_by(email: "admin@test.com") do |user|
        user.password = "password"
        user.user_type = 1
        user.nickname = "test_admin"
        user.description = "test_description"

    end
    User.find_or_create_by(email: "reporter@test.com") do |user|
        user.password = "password"
        user.user_type = 2
        user.nickname = "test_reporter"
        user.description = "test_description"

    end

    # PoiComment.create(user_id: 1, poi_id: 31, text: "Sample comment 1 for POI 31", rating: 4)
    # PoiComment.create(user_id: 2, poi_id: 31, text: "Sample comment 2 for POI 31", rating: 5)
    require_relative 'points_of_interest'

when "production"

when "demo"
    User.find_or_create_by(email: "customer@demo.com") do |user|
        user.password = "password"
        user.user_type = 0
        user.nickname = "customer"
        user.description = "I'm a regular customer who loves exploring new places."
    end
    User.find_or_create_by(email: "customer2@demo.com") do |user|
        user.password = "password"
        user.user_type = 0
        user.nickname = "customer2"
        user.description = "Adventure enthusiast and frequent traveler."
    end
    User.find_or_create_by(email: "admin@demo.com") do |user|
        user.password = "password"
        user.user_type = 1
        user.nickname = "admin"
        user.description = "admin_description"
    end
    User.find_or_create_by(email: "reporter@demo.com") do |user|
        user.password = "password"
        user.user_type = 2
        user.nickname = "reporter"
        user.description = "reporter_description"
    end
    # PoiComment.create(user_id: 1, poi_id: 31, text: "Sample comment 1 for POI 31", rating: 4)
    # PoiComment.create(user_id: 2, poi_id: 31, text: "Sample comment 2 for POI 31", rating: 5)
    require_relative 'points_of_interest'
end