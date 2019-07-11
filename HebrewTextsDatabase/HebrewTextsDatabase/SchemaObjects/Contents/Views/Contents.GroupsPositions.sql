CREATE VIEW [Contents].[GroupsPositions]
	AS 
 WITH cte (GroupID,GroupType,ParentGroupID,Path,  Total,PositionInTree,SequenceNumber,ParentSequenceNumber,NextGroupIDInLevel,Hierarchy) AS
(
SELECT [GroupID] as GroupID,GroupType,ParentGroupID, cast (GroupName as nvarchar(max)) as Path,cast (ISNULL([SequenceNumber],0) as nvarchar(max)) as Total,1 as PositionInTree,[SequenceNumber],[SequenceNumber] as ParentSequenceNumber,NextGroupIDInLevel,cast (concat('/' , ISNULL([SequenceNumber],'0') , '/') as hierarchyid) as Hierarchy
FROM Contents.ContentGroups WHERE ParentGroupID IS NULL

UNION ALL

SELECT g.[GroupID] as GroupID ,g.GroupType,g.ParentGroupID,
CAST(cte.path + '\' + IsNull(GroupName,concat(gt.Name , ' ' , g.[SequenceNumber])) AS NVARCHAR(MAX)) as Path,cast (CONCAT(Total,'.',ISNULL(g.[SequenceNumber],0)) as nvarchar(max)) as Total,cte.PositionInTree+1 as PositionInTree,g.[SequenceNumber],cte.SequenceNumber as ParentSequenceNumber,g.NextGroupIDInLevel,cast (concat('/' , Total,'.' , ISNULL(g.[SequenceNumber],'0') , '/') as hierarchyid) as Hierarchy
FROM  Contents.ContentGroups g 
INNER JOIN cte ON cte.GroupID  = g.ParentGroupID
INNER JOIN Contents.GroupsAndDividingTypes gt on g.GroupType=gt.ID
)
SELECT * FROM cte