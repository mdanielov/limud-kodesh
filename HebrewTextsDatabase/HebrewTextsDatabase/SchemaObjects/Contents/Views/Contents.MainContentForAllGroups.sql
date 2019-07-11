CREATE VIEW [Contents].[MainContentForAllGroups]
	AS 
	select * from Contents.MainContent
 union 
   select mc.[MainContentID]
      ,sg.GroupID as [GroupID]
      ,[SequenceNumber]
      ,[RootGroupID]
      ,[SequenceNumberByRootGroup]
      ,[Content]
      ,[LargeContent]
      ,sg.[VersionID],
	  NextContentID
 from Contents.MainContent mc
cross join Contents.[ContentToAlternateGroups] sg
where mc.RootGroupID = (select RootGroupID  from Contents.MainContent where [MainContentID]=sg.FromContentID)
and SequenceNumberByRootGroup between (select SequenceNumberByRootGroup from Contents.MainContent where [MainContentID]=sg.FromContentID) and (select SequenceNumberByRootGroup from Contents.MainContent where [MainContentID]=sg.ToContentID)



