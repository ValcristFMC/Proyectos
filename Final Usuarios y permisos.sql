select	
	UserID
	, Name
	, tbUsuarios.SecCode
	, NoEntryList
	, Description
	, ParentSecCode
	, OptionType
	, OptionSubType
	, MenuID
	, MenuDesc
	, ParentMenuID
from
(
select distinct
	SecCode
	, UserID			=	case
								when Usuarios.UserID = ''--EntryList
								then
									'N/A'
								when Usuarios.UserID = ''
								then
									'Todos'
								else
									Usuarios.UserID
							end
	, Name				=
							case
								when Name = ''
								then
									(
										select distinct Name from	(
																		select distinct
																			UserID
																			, Company = CurComp
																			, Name
																		from
																			Ice.SysUserFile
																		where
																			CurComp = 'MG01'
																	) as Usu where Usu.UserID = Usuarios.UserID and Usu.Name <> ''
									)
								else
									Name
							end
	, NoEntryList		=	case
								when NoEntryList = '*'
								then
									'Todos'
								when NoEntryList = ''
								then
									'Ninguno'
								else
									NoEntryList
							end
	, Description
	, ParentSecCode
from
	Ice.Security
join
	(
		select distinct
			UserID
			, Company = CurComp
			, Name
		from
			Ice.SysUserFile
		where
			CurComp = 'MG01'
	) as Usuarios on EntryList like ('%' + Usuarios.UserID + '%')
) as tbUsuarios
join
	(
		select
			MenuID
			, SecCode
			, MenuDesc
			, ParentMenuID
			, OptionType		=	case
										when OptionType = 'S'
										then
											'Sub Menú'
										when OptionType = 'I'
										then
											'Elemento de menú (Programa)'
										when OptionType = 'B'
										then
											'Generador de informes Informe de Enlace'
										else
											'N/A'
									end
			, OptionSubType		=	case
										when OptionSubType = 'F'
										then
											'Formulario'
										when OptionSubType = 'T'
										then
											'Rastreador'
										when OptionSubType = 'M'
										then
											'Mantenimiento'
										when OptionSubType = 'P'
										then
											'Proceso'
										when OptionSubType = 'R'
										then
											'Informe'
										when OptionSubType = 'E'
										then
											'Entrada'
										else
											'N/A'
									end
		from
			Ice.Menu
		where
			Menu.Company = 'MG01'
	) as Men on Men.SecCode = tbUsuarios.SecCode