select
	Menu.MenuID
	, Menu.ParentMenuID
	, S.SecCode
	, S.EntryList
	, S.NoEntryList
	, S.Description
	, S.ParentSecCode
	, S.ParentSeqNum
	, S.SystemCode
from
	Ice.Security S
join
	Ice.Menu on Menu.SecCode = S.SecCode