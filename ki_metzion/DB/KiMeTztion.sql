USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KiMeTztion'
)
DROP DATABASE KiMeTztion
GO

CREATE DATABASE KiMeTztion
GO