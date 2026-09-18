// Create Reader Nodes
// These are the users of the digital newspaper
MERGE (r1:Reader {name: 'Reader_A'}) // Interested in sports
MERGE (r2:Reader {name: 'Reader_B'}) // Follows cricket news
MERGE (r3:Reader {name: 'Reader_C'}) // Technology enthusiast
MERGE (r4:Reader {name: 'Reader_D'}) // Follows tech and blockchain
MERGE (r5:Reader {name: 'Reader_E'}) // Interested in cricket

// Create Article Nodes
// Articles published on various topics
MERGE (a1:Article {title: 'IPL'})
MERGE (a2:Article {title: 'World Cup'})
MERGE (a3:Article {title: 'Machine Learning'})
MERGE (a4:Article {title: 'Blockchain'})
MERGE (a5:Article {title: 'Champions League'})
MERGE (a6:Article {title: 'Cryptocurrency'})

// Create Author Nodes
// Authors who write the articles
MERGE (au1:Author {name: 'Author_1'})
MERGE (au2:Author {name: 'Author_2'})
MERGE (au3:Author {name: 'Author_3'})

// Create Topic Nodes
// Broad categories under which articles fall
MERGE (t1:Topic {title: 'Sports'})
MERGE (t2:Topic {title: 'Technology'})

// Create Tag Nodes
// Specific keywords or entities in the articles
MERGE (tag1:Tag {title: 'Cricket'})
MERGE (tag2:Tag {title: 'IPL'})
MERGE (tag3:Tag {title: 'AI'})
MERGE (tag4:Tag {title: 'Blockchain'})

// Create Relationships between Articles and Authors
// Each article is written by one author
MERGE (a1)-[:WRITTEN_BY]->(au1)
MERGE (a2)-[:WRITTEN_BY]->(au1)
MERGE (a3)-[:WRITTEN_BY]->(au2)
MERGE (a4)-[:WRITTEN_BY]->(au2)
MERGE (a5)-[:WRITTEN_BY]->(au3)
MERGE (a6)-[:WRITTEN_BY]->(au3)

// Assign Topics to Articles
// Used to determine reader interest areas and recommendations
MERGE (a1)-[:HAS_TOPIC]->(t1)
MERGE (a2)-[:HAS_TOPIC]->(t1)
MERGE (a3)-[:HAS_TOPIC]->(t2)
MERGE (a4)-[:HAS_TOPIC]->(t2)
MERGE (a5)-[:HAS_TOPIC]->(t1)
MERGE (a6)-[:HAS_TOPIC]->(t2)

// Tag the Articles
// Helps in fine-grained filtering and topic detection
MERGE (a1)-[:HAS_TAG]->(tag1)
MERGE (a2)-[:HAS_TAG]->(tag2)
MERGE (a3)-[:HAS_TAG]->(tag3)
MERGE (a4)-[:HAS_TAG]->(tag4)
MERGE (a5)-[:HAS_TAG]->(tag1)
MERGE (a6)-[:HAS_TAG]->(tag3)

// Connect Readers with Articles They’ve Read
// This supports recommendation systems and user profiling
MERGE (r1)-[:READ]->(a1)
MERGE (r2)-[:READ]->(a2)
MERGE (r3)-[:READ]->(a3)
MERGE (r4)-[:READ]->(a4)
MERGE (r4)-[:READ]->(a3)
MERGE (r5)-[:READ]->(a5)