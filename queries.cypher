// Use-case 1: Recommend articles to a reader based on their reading history.
// Step 1: Find the topics of articles the reader has already read.
// Step 2: Find other articles associated with those same topics.
// Step 3: Exclude articles the reader has already read to avoid repetition.
// Step 4: Return a list of recommended article titles per reader.
MATCH (r:Reader)-[:READ]->(readAr:Article)-[:HAS_TOPIC]->(t:Topic)
MATCH (a:Article)-[:HAS_TOPIC]->(t)
WHERE NOT (r)-[:READ]->(a)
RETURN r.name AS Reader, collect(DISTINCT a.title) AS RecommendedArticles

// Use-case 2: Identify readers likely to engage with new articles about a specific topic.
// Step 1: Find the topics of articles each reader has already read.
// Step 2: Find other articles associated with those same topics.
// Step 3: Exclude articles the reader has already read.
// Step 4: Return a list of new article titles per reader that match their topic interests.
MATCH (r:Reader)-[:READ]->(a:Article)-[:HAS_TOPIC]->(t:Topic)
MATCH (allArticle:Article)-[:HAS_TOPIC]->(t)
WHERE NOT (r)-[:READ]->(allArticle)
RETURN
  r.name AS Reader,
  collect(DISTINCT allArticle.title) AS New_Articles_To_Read

// Use-case 3: Identify trending topics among readers with similar interests.
// Step 1: Find all tags associated with the articles a reader has read.
// Step 2: Identify other readers who have read articles with those same tags (i.e., similar interests).
// Step 3: From those similar readers, collect the topics of the articles they have read.
// Step 4: Count how frequently each topic appears — these are the trending topics.
// Step 5: Exclude self-matches to avoid comparing a reader with themselves.
MATCH (r:Reader)-[:READ]->(:Article)-[:HAS_TAG]->(tag:Tag)
MATCH (r1:Reader)-[:READ]->(a:Article)-[:HAS_TAG]->(tag)
MATCH (a)-[:HAS_TOPIC]->(t:Topic)
WHERE r.name <> r1.name
RETURN t.title AS Trending_Topic, count(*) AS Frequency

// Use-case 4: Recommend related articles based on shared tags.
// Step 1: Find all articles a reader has already read.
// Step 2: Get the tags associated with those read articles.
// Step 3: Find other articles that share the same tags.
// Step 4: Exclude articles that the reader has already read or is currently reading.
// Step 5: Return a list of related, unread article titles for each reader.
MATCH (r:Reader)-[:READ]->(a:Article)
MATCH (a)-[:HAS_TAG]->(tag:Tag)
MATCH (newArticles:Article)-[:HAS_TAG]->(tag)
WHERE a.title <> newArticles.title AND NOT (r)-[:READ]->(newArticles)
RETURN r.name AS Reader, collect(DISTINCT newArticles.title) AS Related_Articles

// Use-case 5: Find authors who have written articles on topics a reader is interested in but hasn't read.
// Step 1: Find the topics of articles that the reader has already read.
// Step 2: Find other (unread) articles that are also tagged with those topics.
// Step 3: Get the authors of those unread articles.
// Step 4: Exclude any articles the reader has already read.
// Step 5: Return the list of authors per reader that they haven't discovered yet.
MATCH (r:Reader)-[:READ]->(:Article)-[:HAS_TOPIC]->(t:Topic)
MATCH
  (a:Article)-[:HAS_TOPIC]->
  (t)<-[:HAS_TOPIC]-
  (unread:Article)-[:WRITTEN_BY]->
  (au:Author)
WHERE NOT (r)-[:READ]->(unread)
RETURN DISTINCT r.name AS Reader, collect(DISTINCT au.name) AS Author

// Use-case 6: Classify readers as Light or Power users based on article engagement.
// Step 1: Match each reader to the articles they have read.
// Step 2: Get the topics of the articles they have read.
// Step 3: Count how many articles each reader has read.
// Step 4: Use a CASE statement to classify them as 'Power User' (2 or more reads) or 'Light User' (fewer than 2).
// Step 5: Return the reader’s name, number of articles read, topics of interest, and user classification.
MATCH (r:Reader)-[:READ]->(a:Article)
MATCH (a)-[:HAS_TOPIC]->(t:Topic)
RETURN
  r.name AS Reader,
  count(a) AS ArticlesRead,
  collect(DISTINCT t.title) AS Topics,
  CASE
    WHEN count(a) >= 2 THEN 'Power User'
    ELSE 'Light User'
  END AS UserType