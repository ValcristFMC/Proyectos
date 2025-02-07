select
	*,
	[Apartado Principal]		= MN.MenuID
	, ParentMenu = MN.ParentMenuID
	, [Apartado Secundario]		= MN1.MenuID
	, [Menu]					= MN1.ParentMenuID
	, [Descripcion Apartado]	= MN.MenuDesc
	, [Descipcion Secundaria]	= MN1.MenuDesc

	, [Descripcion]				= Usuarios.Description
	, [Usuarios Permitidos]		= Usuarios.EntryList
	, [Usuarios no Permitidos]	= Usuarios.NoEntryList
from
	Ice.Menu MN
join
	Ice.Menu MN1 on MN1.ParentMenuID in (MN.MenuID)
join
	(select
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
	) as Usuarios on Usuarios.MenuID = MN.MenuID
where
	MN1.ParentMenuID in (
	'MGREPORT'
	, 'MNUDIR'
	, 'XAMN1000'
	, 'XAMN2000'
	, 'XAMN3000'
	, 'XAMN4000'
	, 'XAMN5000'
	, 'XAMN5100'
	, 'XAMN6000'
	, 'XAMN9000'
)

	--MN.ParentMenuID = 'MAINMENU'
order by
	MN.MenuID
	--, ParentMenu = MN.ParentMenuID
	, MN1.MenuID
	, MN1.ParentMenuID

