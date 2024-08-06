POINTS_OF_INTEREST = [
    {latitude: 53.39059, longitude: -1.50906, name: 'Bole Hill Recreation Ground', location: 'sheffield', 
     description: 'Bolehill Recreation Ground, known locally as The Bole Hills is a public open space in the suburb of Crookes within the city of Sheffield, England.',features: [FEATURES[1], FEATURES[5]], likes: rand(0..1000)},
    {latitude: 53.38247, longitude: -1.48985, name: 'Weston Park', location: 'sheffield', description: 'Tranquil urban park area offering picnic areas, a bandstand, statues & a duck & fish pond.',
        features: [FEATURES[2], FEATURES[5], FEATURES[10], FEATURES[11]],
        likes: rand(0..1000)
    },
    {latitude: 53.38362, longitude: -1.49270, name: 'Crookes Valley Park', location: 'sheffield', description: 'Crookes Valley Park is an area of public parkland in the Crookesmoor area of the City of Sheffield in South Yorkshire, England.',
        features: [FEATURES[5], FEATURES[8], FEATURES[11]],
        likes: rand(0..1000)
    },
    {latitude: 53.38685, longitude: -1.48641, name: 'Ponderosa', location: 'sheffield', description: 'Park in a large bowl-shaped indentation with a lawned area hosting events, woods & a playground.',
        features: [FEATURES[5]],
        likes: rand(0..1000)
    },
    {latitude: 53.37900, longitude: -1.47831, name: 'Devonshire Green', location: 'sheffield', description: 'Energetic recreational retreat featuring an amphitheater, grassy lawn & a concrete skate park.',
        features: [FEATURES[5], FEATURES[9], FEATURES[8]],
        likes: rand(0..1000)
    },
    {latitude: 53.36862, longitude: -1.50895, name: 'Endcliffe Park', location: 'sheffield', description: 'Large park dating from 1887, with statue of Queen Victoria, childrens playground, cafe and lake.',
        features: [FEATURES[9]],
        likes: rand(0..1000)
    },
    {latitude: 53.37215, longitude: -1.49764, name: 'Botanical Gardens', location: 'sheffield', description: 'Plants and flowers from around the world in themed areas, formal gardens and large glasshouses',
        features: [FEATURES[2], FEATURES[5], FEATURES[9], FEATURES[11]],
        likes: rand(0..1000)
    },
    {latitude: 53.37997, longitude: -1.46969, name: 'Peace Gardens', location: 'sheffield', description: 'Open town hall square in the heart of the city with water fountains, cascades and war memorials.',
        features: [FEATURES[3], FEATURES[4], FEATURES[5], FEATURES[6], FEATURES[7], FEATURES[8]],
        likes: rand(0..1000)
    },
    {latitude: 53.39831, longitude: -1.47515, name: 'Parkwood Springs', location: 'sheffield', description: '​Parkwood Springs is an amazing, natural, wild space close to the centre of the city of Sheffield.',
        features: [FEATURES[0], FEATURES[1], FEATURES[5]],
        likes: rand(0..1000)
    }

]

Poi.upsert_all(POINTS_OF_INTEREST, unique_by: [:name], record_timestamps: true)