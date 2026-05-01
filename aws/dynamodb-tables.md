# DynamoDB Tables
Top Level Entities
- Tables - similar to SQL tables
- Items - similar to SQL rows
- Attributes - similar to SQL columns
- Primary Keys - mandatory, minimum 1, maximum 2
- Secondary Indexes - local and global
- Streams - capture changes to the table
- TTL - time-to-live for items
- Capacity Units - read and write capacity
- Transactions - atomic, consistent, isolated, durable
- On-Demand - pay-per-request billing
- Accelerator - DAX (DynamoDB Accelerator)
- Backup - on-demand and continuous

Independent Entities
- Streams - capture changes to the table
- TTL - time-to-live for items
- Capacity Units - read and write capacity
- Transactions - atomic, consistent, isolated, durable
- On-Demand - pay-per-request billing

Flexible Schema
- Attributes - no fixed schema
- Sparse Indexes - only index non-empty attributes
- Composite Attributes - nested attributes
- Sets - unordered collection of unique elements