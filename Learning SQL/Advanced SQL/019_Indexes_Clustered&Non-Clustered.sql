-- Optimazing Technique - Index
USE MySalesDB


/*
	Index data sctructure provides quick access to data,
	optimizing the speed of your queries.
	There are three type of Indexes: Structure, Storage, Functions.
	In the Structure Index we have two categories: Clustered Index and
	Non-Clastered Index.
	In the Storage Index we have two types: Rowstore Index and Columnstore Index
	In the Functions Index we have two types: Unique Index and Filtered Index.
*/


-- WHEN DATABASE USE INDEXES?
-- Database uses indexes when we have defined index on a column and in our query we work on that column
-- for example
/*
	SELECT * FROM customers WHERE customername='Brown'

	we can create an index on customername column and when we query customername
	the database will use the index.
*/



/*
	Clustered Index.
	The clustered index uses B-TREE structure(Balance tree). data is stored like
	a tree where leaf node only contains actual data, then there are intermediate nodes
	that contain pointers about leaves and another intermediate nodes. At the top there is 
	a root node. PS. the data is ordered.
	Searching in this structure is very fast(like binary search).
	For one table we can create only one clustered index.
*/
-- By default SQL Server creates Clustered Index once we create a new table
-- Let's create a table without any index to create index by our own.
/*SELECT 
* 
INTO DBCustomers
FROM customers*/

-- create an index
CREATE CLUSTERED INDEX idx_DBCustomers_id
ON DBCustomers (id)

-- To delete an index we use DROP command
DROP INDEX idx_DBCustomers_id ON DBCustomers


/*
	Non-Clustered Index.
	The non-clustered index does not touch the actual data. This type of index uses 
	B-TREE as well but here, data is not sotred in leaf nodes, data is stored in base page
	memory, instead of actual data, in here leaf node contains pointers of row's exact location
	in pages, inside the leaf the pointers IDs are ordered so this way an entire dataset is ordered.
	the rest of the nodes in the tree are just the same as in clustered indexes.
	For one table we can create as many indexes as we want.
*/

-- creating non-clustered index
CREATE NONCLUSTERED INDEX idx_DBCustomers_lastName
ON DBCustomers (customersurname)


-- Composite Index is index that is created using more than one columns
CREATE NONCLUSTERED INDEX idx_DBCustomers_lastName_comp
ON DBCustomers (customersurname, customername)



/*
					Clustered Index			VS			Non-Clustered Index
	Definition		physically sorts and stores rows	seperate structure with pointers to the data
	
	Num. of indexes	ONE index per table					Multiple indexes are allowed
	
	Read 
	Performance		Faster								Slower
	
	Write 
	Performance		Slower								Faster
	
	Storage 
	Efficiency		More storage-efficient				Requires additional storage space

*/