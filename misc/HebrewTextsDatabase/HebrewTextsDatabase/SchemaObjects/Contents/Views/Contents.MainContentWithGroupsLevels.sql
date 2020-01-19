CREATE VIEW [Contents].[MainContentWithGroupsLevels]
	AS 	
SELECT mainContent.*,
GroupsLevel1.GroupType as GroupTypeLevel1,
GroupTypesLevel1.Name as GroupTypeNameLevel1,
GroupsLevel1.SequenceNumber as GroupSequenceLevel1,
GroupsLevel1.KeyWordIndex as GroupKeyWordIndexLevel1,
GroupsLevel1.GroupName as GroupNameLevel1,

GroupsLevel2.GroupID as GroupIDLevel2,
GroupsLevel2.GroupType as GroupTypeLevel2,
GroupTypesLevel2.Name as GroupTypeNameLevel2,
GroupsLevel2.SequenceNumber as GroupSequenceLevel2,
GroupsLevel2.KeyWordIndex as GroupKeyWordIndexLevel2,
GroupsLevel2.GroupName as GroupNameLevel2,

GroupsLevel3.GroupID as GroupIDLevel3,
GroupsLevel3.GroupType as GroupTypeLevel3,
GroupTypesLevel3.Name as GroupTypeNameLevel3,
GroupsLevel3.SequenceNumber as GroupSequenceLevel3,
GroupsLevel3.KeyWordIndex as GroupKeyWordIndexLevel3,
GroupsLevel3.GroupName as GroupNameLevel3,

GroupsLevel4.GroupID as GroupIDLevel4,
GroupsLevel4.GroupType as GroupTypeLevel4,
GroupTypesLevel4.Name as GroupTypeNameLevel4,
GroupsLevel4.SequenceNumber as GroupSequenceLevel4,
GroupsLevel4.KeyWordIndex as GroupKeyWordIndexLevel4,
GroupsLevel4.GroupName as GroupNameLevel4,

GroupsLevel5.GroupID as GroupIDLevel5,
GroupsLevel5.GroupType as GroupTypeLevel5,
GroupTypesLevel5.Name as GroupTypeNameLevel5,
GroupsLevel5.SequenceNumber as GroupSequenceLevel5,
GroupsLevel5.KeyWordIndex as GroupKeyWordIndexLevel5,
GroupsLevel5.GroupName as GroupNameLevel5,

GroupsLevel6.GroupID as GroupIDLevel6,
GroupsLevel6.GroupType as GroupTypeLevel6,
GroupTypesLevel6.Name as GroupTypeNameLevel6,
GroupsLevel6.SequenceNumber as GroupSequenceLevel6,
GroupsLevel6.KeyWordIndex as GroupKeyWordIndexLevel6,
GroupsLevel6.GroupName as GroupNameLevel6

FROM Contents.MainContent AS mainContent 
LEFT JOIN Contents.ContentGroups AS GroupsLevel1 ON GroupsLevel1.GroupID=mainContent.GroupID
LEFT JOIN Contents.GroupsAndDividingTypes AS  GroupTypesLevel1 ON GroupsLevel1.GroupType=GroupTypesLevel1.ID

LEFT JOIN Contents.ContentGroups AS GroupsLevel2 ON GroupsLevel1.ParentGroupID=GroupsLevel2.GroupID
LEFT JOIN Contents.GroupsAndDividingTypes AS  GroupTypesLevel2 ON GroupsLevel2.GroupType=GroupTypesLevel2.ID

LEFT JOIN Contents.ContentGroups AS GroupsLevel3 ON GroupsLevel2.ParentGroupID=GroupsLevel3.GroupID
LEFT JOIN Contents.GroupsAndDividingTypes AS  GroupTypesLevel3 ON GroupsLevel3.GroupType=GroupTypesLevel3.ID

LEFT JOIN Contents.ContentGroups AS GroupsLevel4 ON GroupsLevel3.ParentGroupID=GroupsLevel4.GroupID
LEFT JOIN Contents.GroupsAndDividingTypes AS  GroupTypesLevel4 ON GroupsLevel4.GroupType=GroupTypesLevel4.ID

LEFT JOIN Contents.ContentGroups AS GroupsLevel5 ON GroupsLevel4.ParentGroupID=GroupsLevel5.GroupID
LEFT JOIN Contents.GroupsAndDividingTypes AS  GroupTypesLevel5 ON GroupsLevel5.GroupType=GroupTypesLevel5.ID

LEFT JOIN Contents.ContentGroups AS GroupsLevel6 ON GroupsLevel5.ParentGroupID=GroupsLevel6.GroupID
LEFT JOIN Contents.GroupsAndDividingTypes AS  GroupTypesLevel6 ON GroupsLevel6.GroupType=GroupTypesLevel6.ID
;