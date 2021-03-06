context("Group")

test_that("simple group operation with $group",
{
	MongoPipeline() %>% mgroup(by = .groupingVar) %>%
		pipelineAssert('{"$group":{"_id":"$groupingVar"}}')
})

test_that("grouping by multiple fields with $group and subdocuments",
{
	MongoPipeline() %>% mgroup(by = .list(first = .groupingVar, second = .anotherFactor)) %>%
		pipelineAssert('{"$group":{"_id":{"first":"$groupingVar","second":"$anotherFactor"}}}')
})

test_that("grouping with $sum accumulator",
{
	MongoPipeline() %>% mgroup(by = .groupingVar, count = .sum(1)) %>%
		pipelineAssert('{"$group":{"count":{"$sum":1},"_id":"$groupingVar"}}')
})

test_that("grouping with $min/$max accumulators",
{
	MongoPipeline() %>% mgroup(by = .groupingVar, lowest = .min(.numericField), highest = .max(.numericField)) %>%
		pipelineAssert('{"$group":{"lowest":{"$min":"$numericField"},"highest":{"$max":"$numericField"},"_id":"$groupingVar"}}')
})

test_that("grouping with $first accumulator",
{
	MongoPipeline() %>% mgroup(by = .groupingVar, firstFieldSpotted = .first(.field)) %>%
		pipelineAssert('{"$group":{"firstFieldSpotted":{"$first":"$field"},"_id":"$groupingVar"}}')
})

test_that("grouping with mathematical expressions in accumulators",
{
	MongoPipeline() %>% mgroup(by = .groupingVar,
			addField = .a + .b,
			subField = .a - .b,
			divField = .a / .b,
			mulField = .a * .b
		) %>%
		pipelineAssert('{"$group":{"addField":{"$add":["$a","$b"]},"subField":{"$subtract":["$a","$b"]},"divField":{"$divide":["$a","$b"]},"mulField":{"$multiply":["$a","$b"]},"_id":"$groupingVar"}}')
})

test_that("grouping with $substr function in accumulators",
{
	MongoPipeline() %>% mgroup(by = .groupingVar,
			newStringField = .substr(.numericField, 0, -1)
		) %>%
		pipelineAssert('{"$group":{"newStringField":{"$substr":["$numericField",0,-1]},"_id":"$groupingVar"}}')
})
