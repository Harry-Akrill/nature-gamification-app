module Constants
    POINTS_PER_POI_CHECK_IN = 20
    POINTS_PER_NEW_POI_PHOTO = 10
    POINTS_PER_NEW_POI_REVIEW = 5
    BADGES = %w[BRONZE SILVER GOLD SAPPHIRE RUBY EMERALD AMETHYST PEARL OBSIDIAN
    DIAMOND].freeze

    BADGE_THRESHOLDS_FOR_TOTAL_NO_POINTS = {
        BRONZE: 5,
        SILVER: 15,
        GOLD: 40,
        SAPPHIRE: 75,
        RUBY: 125,
        EMERALD: 175,
        AMETHYST: 250,
        PEARL: 350,
        OBSIDIAN: 500,
        DIAMOND: 1000
    }.freeze

    BADGE_THRESHOLDS_FOR_TOTAL_COUNTS_IN_CATEGORY = {
        BRONZE: 1,
        SILVER: 5,
        GOLD: 10,
        SAPPHIRE: 15,
        RUBY: 25,
        EMERALD: 40,
        AMETHYST: 75,
        PEARL: 150,
        OBSIDIAN: 300,
        DIAMOND: 500
    }.freeze
end