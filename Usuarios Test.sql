use Epicor10Prod
go

declare @UserDisabled bit = 0
declare @EmpStatus char = 'A'

--if OBJECT_ID('tempdb.dbo.#tmpTabla', 'U') IS NOT NULL
--begin
--  drop table #tmpTabla;
--end

select distinct
	TablaGruposPermisos.EmpID
	, TablaGruposPermisos.Name
	, TablaGruposPermisos.UserID 
	, TablaGruposPermisos.Company 
	, TablaGruposPermisos.Departamento
	, TablaGruposPermisos.Menu
	, Acceso = Security.Description --TablaTablas.TableName
	--, DescripcionAcceso = TablaTablas.TableDesc
	, Esquema = TablaTablas.SchemaName
	, TablaGruposPermisos.Estatus
	, TablaGruposPermisos.UserDisabled
	, TablaGruposPermisos.Administrador
	, Grupo											=	(select distinct
															SecGroupDesc
														from
															(select distinct
															SG.SecGroupCode
															, SecGroupDesc
														from
															Ice.SecGroup SG
														join
															Ice.SecColumn SC on  SC.ReadAllowList like '%' + SG.SecGroupCode + '%'
														) as tbSecGru
														where SecGroupCode = TablaGruposPermisos.GroupList)
	, TablaGruposPermisos.Idioma
	, TablaGruposPermisos.UseInternalWebBrowser
	, TablaGruposPermisos.AllowMultipleSessions
	
from
	(
		select
			EmpID						= ''
			, TU.Name
			, TU.UserID 
			, TU.Company 
			, Departamento				= ''
			, Estatus					= ''
			, TU.UserDisabled
			, TU.Administrador
			, TU.GroupList
			, TU.Menu
			, TU.Idioma
			, TU.UseInternalWebBrowser
			, TU.AllowMultipleSessions
		from
			(
				select
					tbUsuarios.UserID
					, Name						=	case
														when
															isnull	(tbUsuarios.Name, '') = ''
														then
															'N/A'
														when
															tbUsuarios.Name = ''
														then
															'N/A'
														else
															tbUsuarios.Name
													end
					, Company					=	(select Name from Erp.Company C where C.Company = tbUsuarios.Company)
					, tbUsuarios.UserDisabled
					, Administrador				= tbUsuarios.SecurityMgr
					, GroupList					=	case
														when
															isnull	(tbUsuarios.GroupList, '') = ''
														then
															'N/A'
														when
															tbUsuarios.GroupList = ''
														then
															'N/A'
														else
															tbUsuarios.GroupList
													end
					, Menu						=	isnull	
													((
														select
															Descripcion
														from
															(
																select
																	MenuID
																	, Descripcion = MenuDesc
																from
																	Erp.MESMenu
																where
																	isnull(MenuID, '') <> ''
																and
																	MenuID <> ''
																union all
																select
																	MenuID
																	, Descripcion = MenuDesc
																from
																	Ice.Menu
																where
																	isnull(MenuID, '') <> ''
																and
																	MenuID <> ''
																union all
																select
																	MenuID
																	, Descripcion = MenuDesc
																from
																	IM.IMMenu
																where
																	isnull(MenuID, '') <> ''
																and
																	MenuID <> ''
															) as tbMenus
														where
															tbMenus.MenuID = tbUsuarios.CurMenuID
													), 'N/A')
					, Idioma					= (select Description from Ice.LangName LN where LN.LangNameID = tbUsuarios.LangNameID)
					, tbUsuarios.UseInternalWebBrowser
					, tbUsuarios.AllowMultipleSessions
				from
					(
						select
							UserID = Ucom.DcdUserID
							, Ucom.Company
							, Ucom.Name

							, UFil.UserDisabled
							, UFil.SecurityMgr
							, UFil.CanChangeSaveSettings
							, UFil.SaveSettings
							, UFil.CurComp
							, UFil.GroupList
							, UFil.CompList
							, UFil.CurMenuID
							, UFil.LangNameID
							, UFil.UseInternalWebBrowser
							, UFil.AllowMultipleSessions
							, UFil.ViewStatusPanelUserID
							, UFil.ViewStatusPanelLanguage
							, UFil.ViewStatusPanelCompany
							, UFil.ViewStatusPanelPlant
							, UFil.ViewStatusPanelServer
							, UFil.ViewStatusPanelWorkstationID
						from
							Erp.UserComp	UCom
						join
							Erp.UserFile	UFil	on UFil.DcdUserID = Ucom.DcdUserID
						where
							UserDisabled = @UserDisabled
						union all
						select
							UserID = Ucom.UserID
							, Ucom.Company
							, Ucom.Name

							, UFil.UserDisabled
							, UFil.SecurityMgr
							, UFil.CanChangeSaveSettings
							, UFil.SaveSettings
							, UFil.CurComp
							, UFil.GroupList
							, UFil.CompList
							, UFil.CurMenuID
							, UFil.LangNameID
							, UFil.UseInternalWebBrowser
							, UFil.AllowMultipleSessions
							, UFil.ViewStatusPanelUserID
							, UFil.ViewStatusPanelLanguage
							, UFil.ViewStatusPanelCompany
							, UFil.ViewStatusPanelPlant
							, UFil.ViewStatusPanelServer
							, UFil.ViewStatusPanelWorkstationID
						from
							Ice.SysUserComp	UCom
						join
							Ice.SysUserFile	UFil	on UFil.UserID = Ucom.UserID
						where
							UserDisabled = @UserDisabled
						union all
						select
							UserID = ''
							, Ucom.Company
							, Ucom.Name

							, UFil.UserDisabled
							, UFil.SecurityMgr
							, UFil.CanChangeSaveSettings
							, UFil.SaveSettings
							, UFil.CurComp
							, UFil.GroupList
							, UFil.CompList
							, UFil.CurMenuID
							, UFil.LangNameID
							, UFil.UseInternalWebBrowser
							, UFil.AllowMultipleSessions
							, UFil.ViewStatusPanelUserID
							, UFil.ViewStatusPanelLanguage
							, UFil.ViewStatusPanelCompany
							, UFil.ViewStatusPanelPlant
							, UFil.ViewStatusPanelServer
							, UFil.ViewStatusPanelWorkstationID
						from
							IM.IMUserComp	UCom
						join
							IM.IMUserFile	UFil	on UFil.IntQueID = Ucom.IntQueID
						where
							UserDisabled = @UserDisabled
					) as tbUsuarios
			) TU
		union all
		select
			EmpID
			, Name
			, Usuario
			, Company
			, Departamento
			, Estatus
			, UserDisabled			= 0
			, Administrador			= 0
			, GroupList				= ''
			, Menu					= ''
			, Idioma				= ''
			, UseInternalWebBrowser = 0
			, AllowMultipleSessions = 0
		from
			(
				select
					EBas.EmpID
					, EBas.Name
					, Usuario					=	case
														when
															isnull	(EBas.DcdUserID, '') = ''
														then
															'N/A'
														when
															EBas.DcdUserID = ''
														then
															'N/A'
														else
															EBas.DcdUserID
													end
					, Company					= (select Name from Erp.Company C where C.Company = EBas.Company)
					, Departamento				= case
														when
															isnull	((select Description from Erp.JCDept JD where JD.JCDept = EBas.JCDept), '') = ''
														then
															'N/A'
														when
															(select Description from Erp.JCDept JD where JD.JCDept = EBas.JCDept) = ''
														then
															'N/A'
														else
															(select Description from Erp.JCDept JD where JD.JCDept = EBas.JCDept)
													end
					, Estatus					= EBas.EmpStatus
				from
					Erp.EmpBasic EBas
				where
					EmpStatus = 'A'
				union all
				select
					EBas.EmpID
					, EBas.Name
					, Usuario					=	case
														when
															isnull	(EBas.DcdUserID, '') = ''
														then
															'N/A'
														when
															EBas.DcdUserID = ''
														then
															'N/A'
														else
															EBas.DcdUserID
													end
					, Company					= (select Name from Erp.Company C where C.Company = EBas.Company)
					, Departamento				= (select Description from Erp.JCDept JD where JD.JCDept = EBas.JCDept)
					, Estatus					= EBas.EmpStatus
				from
					IM.IMEmpBasic EBas
				where
					EmpStatus = 'A'
			) as TE
	) as TablaGruposPermisos
--join
--	Ice.SecGroup SG
join
	Ice.SecColumn on  SecColumn.ReadAllowList like '%' + TablaGruposPermisos.UserID + '%'
join
	(
		select
			TableAttribute.SchemaName
			, TableAttribute.TableName
			, TableAttribute.TableDesc
		from
			Ice.TableAttribute
		join
			Ice.SecColumn on  SecColumn.TableName = TableAttribute.TableName
	) TablaTablas on TablaTablas.TableName = SecColumn.TableName
join
	Ice.Security on Security.EntryList like '%' + TablaGruposPermisos.UserID + '%'
order by Security.Description