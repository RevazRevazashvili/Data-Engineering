-- OPTIMIZATIONS
-- CTE - Common Table Expression
USE MySalesDB

/*
	Common Table Expression is temporary, named result set(virtual table)
	that can be used multiple times within your query to simplify
	and organize complex query.
	CET creates a temporary table that we can use many times in a query.
	it is the most important difference from Subquery that is also generates an
	intermediate table but it is used only once.
	Another difference between these two techniques is executing order.
	In Subquery queries execute from bottom to top(first subquery and next main query)
	On the other hand - CTE executes from top to bottom, but top query is not
	a main query.
	CTE has two major types: None-Recursive CTE, Recursive CTE.
	None-Recursive CTE has two sub-types: Standalone CTE and Nested CTE.

*/


-- Standalone CTE - Defined and used independently
-- Runs independently as it's self-contained and does not rely
-- on other CTEs or queries.