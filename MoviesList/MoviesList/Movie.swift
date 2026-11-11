import Foundation

struct Movie {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int
    let description: String
}

struct MovieStore {
    static let movies: [Movie] = [
        Movie(
            title: "Harry Potter",
            subtitle: "Chris Columbus · 2001",
            imageName: "poster 1",
            rating: 5,
            description: "A young wizard discovers his magical heritage on his eleventh birthday. He receives an invitation to attend Hogwarts School of Witchcraft and Wizardry. Along with new friends, he discovers a dark mystery hidden deep within the castle walls."
        ),
        Movie(
            title: "Avatar",
            subtitle: "James Cameron · 2009",
            imageName: "poster 2",
            rating: 4,
            description: "A paraplegic Marine is sent to the alien moon Pandora on a unique mission. He connects with the indigenous Na'vi people through an avatar body. Soon, he finds himself torn between following his military orders and protecting his new home."
        ),
        Movie(
            title: "Twilight",
            subtitle: "Catherine Hardwicke · 2008",
            imageName: "poster 3",
            rating: 4,
            description: "A teenage girl moves to a small rainy town and falls in love with a mysterious classmate who turns out to be a vampire. Their romance risks attracting the unwanted attention of a rival vampire pack. She must choose between safety and her love."
        ),
        Movie(
            title: "Titanic",
            subtitle: "James Cameron · 1997",
            imageName: "poster 4",
            rating: 5,
            description: "A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated ship. Their love defies social expectations and strict family rules. When disaster strikes in the icy ocean, they struggle together for survival."
        ),
        Movie(
            title: "1+1",
            subtitle: "Olivier Nakache · 2011",
            imageName: "poster 5",
            rating: 5,
            description: "An aristocrat who was injured in a paragliding accident hires a young man from the slums as his live-in caregiver. Despite their completely different backgrounds, an unexpected friendship blooms between them. They transform each other's lives in joyful ways."
        ),
        Movie(
            title: "Avengers",
            subtitle: "Joss Whedon · 2012",
            imageName: "poster 6",
            rating: 5,
            description: "Earth's mightiest heroes must come together to stop Loki and his alien army from conquering the planet. S.H.I.E.L.D. brings Iron Man, Captain America, Thor, and the Hulk into one team. They must learn to overcome their differences to save humanity."
        ),
        Movie(
            title: "Spiderman",
            subtitle: "Sam Raimi · 2002",
            imageName: "poster 7",
            rating: 5,
            description: "A high school student gains spider-like abilities after being bitten by a genetically altered spider. He uses his newfound powers to fight crime after facing a tragic personal loss. He must protect his city from the dangerous Green Goblin."
        ),
        Movie(
            title: "Interstellar",
            subtitle: "Christopher Nolan · 2014",
            imageName: "poster 8",
            rating: 5,
            description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival. They leave Earth behind to discover new habitable worlds. Time dilation and cosmic hazards test their endurance to the absolute limit."
        ),
        Movie(
            title: "La La Land",
            subtitle: "Damien Chazelle · 2016",
            imageName: "poster 9",
            rating: 4,
            description: "A jazz pianist and an aspiring actress fall in love in Los Angeles while pursuing their dreams. Their shared passions pull them closer, but career opportunities threaten their connection. They must choose between their love and artistic ambitions."
        ),
        Movie(
            title: "The Matrix",
            subtitle: "Lana & Lilly Wachowski · 1999",
            imageName: "poster1 0",
            rating: 5,
            description: "A computer hacker learns about the true nature of his reality from a group of mysterious rebels. He wakes up to discover a dystopian world controlled by artificial intelligence. Together with Morpheus and Trinity, he fights for human liberation."
        ),
        Movie(
            title: "Inception",
            subtitle: "Christopher Nolan · 2010",
            imageName: "poster 11",
            rating: 5,
            description: "A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O. He must pull off the ultimate heist with a specialized team of experts. If they fail, they might get lost in dreams forever."
        ),
        Movie(
            title: "The Dark Knight",
            subtitle: "Christopher Nolan · 2008",
            imageName: "poster 12",
            rating: 5,
            description: "When the menace known as the Joker wreaks havoc on Gotham City, Batman must accept one of the greatest psychological tests of his ability. He fights relentlessly to defend justice against pure chaos. Gotham's future hangs in the balance as alliances are tested."
        ),
        Movie(
            title: "Fight Club",
            subtitle: "David Fincher · 1999",
            imageName: "poster 13",
            rating: 5,
            description: "An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into something far bigger. The secret movement spreads rapidly across the country. Dark secrets threaten to unravel the main character's mind."
        ),
        Movie(
            title: "The Truman Show",
            subtitle: "Peter Weir · 1998",
            imageName: "poster 14",
            rating: 5,
            description: "An insurance salesman discovers his entire life is actually a constructed reality television show, broadcast around the clock to billions. Every person in his town is a hired actor, including his wife. He decides to risk everything to escape his artificial world and find the truth."
        ),
        Movie(
            title: "Dune",
            subtitle: "Denis Villeneuve · 2021",
            imageName: "poster 15",
            rating: 4,
            description: "A noble family becomes embroiled in a war for control over the galaxy's most valuable asset. Paul Atreides must navigate a dangerous desert planet filled with giant sandworms and hostile enemies. His epic journey tests his courage and ultimate destiny."
        ),
        Movie(
            title: "Oppenheimer",
            subtitle: "Christopher Nolan · 2023",
            imageName: "poster 16",
            rating: 5,
            description: "The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb. The film follows the race against time during World War II. It deeply explores the moral dilemmas and political fallout that followed."
        ),
        Movie(
            title: "Whiplash",
            subtitle: "Damien Chazelle · 2014",
            imageName: "poster 17",
            rating: 5,
            description: "A promising young drummer enrolls at a cut-throat music conservatory where his dreams of greatness are mentored by a terrifying instructor. The teacher will stop at nothing to realize a student's potential. The relentless pressure pushes the boy to his physical limit."
        ),
        Movie(
            title: "The Karate Kid",
            subtitle: "Harald Zwart · 2010",
            imageName: "poster 18",
            rating: 5,
            description: "A young boy moves to China with his mother and faces severe bullying from his new classmates. He meets a wise maintenance man who secretly happens to be a master of kung fu. Through rigorous discipline and mental strength, he learns self-defense to compete in a major martial arts tournament."
        ),
        Movie(
            title: "Gladiator",
            subtitle: "Ridley Scott · 2000",
            imageName: "poster 19",
            rating: 5,
            description: "A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery. He fights his way through the Colosseum as a gladiator. His bravery inspires the people of Rome to fight for freedom."
        ),
        Movie(
            title: "The Shawshank Redemption",
            subtitle: "Frank Darabont · 1994",
            imageName: "poster 20",
            rating: 5,
            description: "Over the course of several years, two convicts form a deep friendship, seeking consolation and eventual redemption through basic human compassion. Andy Dufresne maintains his hope despite serving a life sentence. His patience leads to an unforgettable escape."
        )
    ]
}
