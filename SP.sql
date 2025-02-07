USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_VerificaSesion]    Script Date: 09/07/2024 10:54:31 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Verifica la sesion del usuario para dar acceso al sistema>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_VerificaSesion]

/* Parametros */

@Contraseña varchar(8)
, @Usuario varchar(12)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idUsuario
				, idPuesto
				, idEmpleado
				, Usuario
				, Estatus
				, Contraseña
			from
				Jiricuicho.dbo.tbl_Usuarios
			where
				Usuario = @Usuario
			and
				Contraseña = @Contraseña
			and
				Estatus = 1

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_VerificaSesion'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_VerificaSesion'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ModificarMateriaPrima]    Script Date: 09/07/2024 10:54:29 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Modifica la Materia Prima Seleccionada>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ModificarMateriaPrima]

/* Parametros */
	@idMateriaPrima		int
	, @Estatus			bit
	, @Nombre			varchar(150)
	, @Descripcion		varchar(150)
	, @Clave			varchar(8)
	, @Usuario			varchar(12)
	, @idTipo			int
	, @Cantidad			float
	, @Caducidad		bit
	, @Precio			float
	, @FechaCaducidad	datetime		= null
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

			if @Estatus = 1
			begin
				update dbo.tbl_MateriaPrima
				set
					Estatus				= @Estatus
					, Nombre			= @Nombre
					, Descripcion		= @Descripcion
					, Clave				= @Clave
					, FechaModificacion	= getdate()
					, Usuario			= @Usuario
					, idTipo			= @idTipo
					, Cantidad			= @Cantidad
					, Precio			= @Precio
					, Caducidad			= @Caducidad
					, FechaCaducidad	= @FechaCaducidad
				where
					idMateriaPrima = @idMateriaPrima

				select
					idMateriaPrima
					, Estatus
					, Nombre
					, Clave
					, FechaAlta
					, FechaBaja
					, FechaModificacion
					, Usuario
					, idTipo
					, Cantidad
					, Caducidad
					, Precio
					, FechaCaducidad
					, Descripcion
				from
					dbo.tbl_MateriaPrima
				order by
					idMateriaPrima desc
			end

			if @Estatus = 0
			begin
				update dbo.tbl_MateriaPrima
				set
					Estatus				= @Estatus
					, Nombre			= @Nombre
					, Descripcion		= @Descripcion
					, Clave				= @Clave
					, FechaBaja			= getdate()
					, FechaModificacion	= getdate()
					, Usuario			= @Usuario
					, idTipo			= @idTipo
					, Cantidad			= @Cantidad
					, Precio			= @Precio
					, Caducidad			= @Caducidad
					, FechaCaducidad	= @FechaCaducidad
				where
					idMateriaPrima = @idMateriaPrima

				select
					idMateriaPrima
					, Estatus
					, Nombre
					, Clave
					, FechaAlta
					, FechaBaja
					, FechaModificacion
					, Usuario
					, idTipo
					, Cantidad
					, Caducidad
					, Precio
					, FechaCaducidad
					, Descripcion
				from
					dbo.tbl_MateriaPrima
				order by
					idMateriaPrima desc
			end

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_ModificarMateriaPrima'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_ModificarMateriaPrima'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ModificarInmueble]    Script Date: 09/07/2024 10:54:28 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Modifica el Inmueble Seleccionado>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ModificarInmueble]

/* Parametros */
	@idInmueble				int
	, @Estatus				bit
	, @Descripcion			varchar(150)
	, @Clave				varchar(8)
	, @FechaAlta			datetime		= null
	, @FechaBaja			datetime		= null
	, @FechaModificacion	datetime		= null
	, @Usuario				varchar(12)
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

			if @Estatus = 1
			begin
				update dbo.tbl_Inmuebles
				set
					Estatus				= @Estatus
					, Descripcion		= @Descripcion
					, Clave				= @Clave
					, FechaAlta			= @FechaAlta
					, FechaBaja			= @FechaBaja
					, FechaModificacion	= @FechaModificacion
					, Usuario			= @Usuario
				where
					idInmueble = @idInmueble

				select
					idInmueble
					, Estatus
					, Descripcion
					, Clave
					, FechaAlta
					, FechaBaja
					, FechaModificacion
					, Usuario
				from
					dbo.tbl_Inmuebles
				order by
					idInmueble desc
			end

			if @Estatus = 0
			begin
				update dbo.tbl_Inmuebles
				set
					Estatus				= @Estatus
					, Descripcion		= @Descripcion
					, Clave				= @Clave
					, FechaAlta			= @FechaAlta
					, FechaBaja			= @FechaBaja
					, FechaModificacion	= @FechaModificacion
					, Usuario			= @Usuario
				where
					idInmueble = @idInmueble

				select
					idInmueble
					, Estatus
					, Descripcion
					, Clave
					, FechaAlta
					, FechaBaja
					, FechaModificacion
					, Usuario
				from
					dbo.tbl_Inmuebles
				order by
					idInmueble desc
			end

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_ModificarInmueble'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_ModificarInmueble'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ModificarConsumible]    Script Date: 09/07/2024 10:54:25 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Modifica el Consumible Seleccionado>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ModificarConsumible]

/* Parametros */
	@idConsumible			int
	, @Estatus				bit
	, @Descripcion			varchar(150)
	, @Clave				varchar(8)
	, @FechaAlta			datetime		= null
	, @FechaBaja			datetime		= null
	, @FechaModificacion	datetime		= null
	, @Usuario				varchar(12)
	, @idTipo				int
	, @Cantidad				int
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

			if @Estatus = 1
			begin
				update dbo.tbl_Consumibles
				set
					Estatus				= @Estatus
					, Descripcion		= @Descripcion
					, Clave				= @Clave
					, FechaAlta			= @FechaAlta
					, FechaBaja			= @FechaBaja
					, FechaModificacion	= @FechaModificacion
					, Usuario			= @Usuario
					, idTipo			= @idTipo
					, Cantidad			= @Cantidad
				where
					idConsumibles = @idConsumible

				select
					idConsumibles
					, Estatus
					, Descripcion
					, Clave
					, FechaAlta
					, FechaBaja
					, FechaModificacion
					, Usuario
					, idTipo
					, Cantidad
				from
					dbo.tbl_Consumibles
				order by
					idConsumibles desc
			end

			if @Estatus = 0
			begin
				update dbo.tbl_Consumibles
				set
					Estatus				= @Estatus
					, Descripcion		= @Descripcion
					, Clave				= @Clave
					, FechaAlta			= @FechaAlta
					, FechaBaja			= @FechaBaja
					, FechaModificacion	= @FechaModificacion
					, Usuario			= @Usuario
					, idTipo			= @idTipo
					, Cantidad			= @Cantidad
				where
					idConsumibles = @idConsumible

				select
					idConsumibles
					, Estatus
					, Descripcion
					, Clave
					, FechaAlta
					, FechaBaja
					, FechaModificacion
					, Usuario
					, idTipo
					, Cantidad
				from
					dbo.tbl_Consumibles
				order by
					idConsumibles desc
			end

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_ModificarConsumible'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_ModificarConsumible'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_GuardarPermisoUsuario]    Script Date: 09/07/2024 10:54:23 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Guarda los permisos de Usuario nuevo>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_GuardarPermisoUsuario]

/* Parametros */

--Empleado
	@idUsuario		int
	, @idPermiso	int
	, @Usuario		varchar(12)
	
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction
			
			insert into dbo.tbl_PermisoUsuario
			(
				idUsuario
				, Clave
			) values
			(
				@idUsuario
				, @idPermiso
			)

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarPermisoUsuario'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarPermisoUsuario'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_GuardarMateriaPrima]    Script Date: 09/07/2024 10:54:21 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Guarda una nueva Materia Prima>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_GuardarMateriaPrima]

/* Parametros */
	@Estatus			bit
	, @Nombre			varchar(150)
	, @Descripcion		varchar(150)
	, @Clave			varchar(8)
	, @FechaAlta		datetime
	, @Usuario			varchar(12)
	, @idTipo			int
	, @Cantidad			int
	, @Caducidad		bit
	, @Precio			float
	, @FechaCaducidad	datetime		= null
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            insert into dbo.tbl_MateriaPrima
			(
				Estatus
				, Nombre
				, Descripcion
				, Clave
				, FechaAlta
				, Usuario
				, idTipo
				, Cantidad
				, Precio
				, Caducidad
				, FechaCaducidad
			) values
			(
				1
				, @Nombre
				, @Descripcion
				, @Clave
				, getdate()
				, @Usuario
				, @idTipo
				, @Cantidad
				, @Precio
				, @Caducidad
				, @FechaCaducidad
			)

			select
				idMateriaPrima
				, Estatus
				, Nombre
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
				, idTipo
				, Cantidad
				, Caducidad
				, Precio
				, FechaCaducidad
				, Descripcion
			from
				dbo.tbl_MateriaPrima
			where
				Estatus = 1
			order by
				idMateriaPrima desc

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarMateriaPrima'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarMateriaPrima'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_GuardarInmueble]    Script Date: 09/07/2024 10:54:19 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Guarda un nuevo Inmueble>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_GuardarInmueble]

/* Parametros */
	@Estatus				bit
	, @Descripcion			varchar(150)
	, @Clave				varchar(8)
	, @FechaAlta			datetime
	, @FechaBaja			datetime		= null
	, @FechaModificacion	datetime		= null
	, @Usuario				varchar(12)
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            insert into dbo.tbl_Inmuebles
			(
				Estatus
				, Descripcion
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
			) values
			(
				1
				, @Descripcion
				, @Clave
				, @FechaAlta
				, @FechaBaja
				, @FechaModificacion
				, @Usuario
			)

			select
				idInmueble
				, Estatus
				, Descripcion
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
			from
				dbo.tbl_Inmuebles
			where
				Estatus = 1
			order by
				idInmueble desc

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarInmueble'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarInmueble'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_GuardarEmpleado]    Script Date: 09/07/2024 10:54:18 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Guarda un Empleado nuevo>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_GuardarEmpleado]

/* Parametros */

--Empleado
	@Clave					varchar(10)
	, @idPuesto				int
	, @Estatus				bit
	, @Nombre				varchar(20)
	, @ApellidoPaterno		varchar(20)
	, @ApellidoMaterno		varchar(20)
	, @Telefono				varchar(10)
	, @CorreoElectronico	varchar(150)
	, @FechaIngreso			datetime
	, @NSS					varchar(11)
	, @RFC					varchar(13)
	, @Nomina				float
	, @ClaveBancaria		varchar(16)
	, @Banco				varchar(150)
	, @Usuario				varchar(12)

--Direccion
	, @Fiscal				bit
	, @CP					varchar(5)
	, @Estado				varchar(3)
	, @Municipio			varchar(3)
	, @Calle				varchar(150)
	, @NumeroInt			varchar(8)
	, @NumeroExt			varchar(8)
	, @Colonia				varchar(3)
	, @Ciudad				varchar(3)
	, @Pais					varchar(3)

--Usuario
	, @NombreUsuario		varchar(12)
	, @EstatusUsuario		bit
	, @Contraseña			varchar(8)

	
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction
			
			declare @idDireccion	int
			declare @idUsuario		int
			declare @idEmpleado		int

			insert into dbo.tbl_Direcciones
			(
				Fiscal
				, CP
				, Estado
				, Municipio
				, Calle
				, NumeroInt
				, NumeroExt
				, Colonia
				, Ciudad
				, Pais
			) values
			(
				@Fiscal
				, @CP
				, @Estado
				, @Municipio
				, @Calle
				, @NumeroInt
				, @NumeroExt
				, @Colonia
				, @Ciudad
				, @Pais
			)

			set @idDireccion = (select SCOPE_IDENTITY())

            insert into dbo.tbl_Empleados
			(
				Clave
				, idPuesto
				, Estatus
				, Nombre
				, ApellidoPaterno
				, ApellidoMaterno
				, idDireccion
				, Telefono
				, CorreoElectronico
				, FechaIngreso
				, NSS
				, RFC
				, Nomina
				, ClaveBancaria
				, Banco
				, Usuario
			) values
			(
				@Clave
				, @idPuesto
				, @Estatus
				, @Nombre
				, @ApellidoPaterno
				, @ApellidoMaterno
				, @idDireccion
				, @Telefono
				, @CorreoElectronico
				, @FechaIngreso
				, @NSS
				, @RFC
				, @Nomina
				, @ClaveBancaria
				, @Banco
				, @Usuario
			)

			set @idEmpleado = (select SCOPE_IDENTITY())

			insert into dbo.tbl_Usuarios
			(
				idPuesto
				, idEmpleado
				, Usuario
				, Estatus
				, Contraseña
			) values
			(
				@idPuesto
				, @idEmpleado
				, @NombreUsuario
				, @EstatusUsuario
				, @Contraseña
			)

			set @idUsuario = (select SCOPE_IDENTITY())

			select
				idDireccion		= @idDireccion
				, idUsuario		= @idUsuario
				, idEmpleado	= @idEmpleado

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarEmpleado'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarEmpleado'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_GuardarConsumible]    Script Date: 09/07/2024 10:54:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Guarda un nuevo Consumible>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_GuardarConsumible]

/* Parametros */
	@Estatus				bit
	, @Descripcion			varchar(150)
	, @Clave				varchar(8)
	, @FechaAlta			datetime
	, @FechaBaja			datetime		= null
	, @FechaModificacion	datetime		= null
	, @Usuario				varchar(12)
	, @idTipo				int
	, @Cantidad				int
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            insert into dbo.tbl_Consumibles
			(
				Estatus
				, Descripcion
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
				, idTipo
				, Cantidad
			) values
			(
				1
				, @Descripcion
				, @Clave
				, @FechaAlta
				, @FechaBaja
				, @FechaModificacion
				, @Usuario
				, @idTipo
				, @Cantidad
			)

			select
				idConsumibles
				, Estatus
				, Descripcion
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
				, idTipo
				, Cantidad
			from
				dbo.tbl_Consumibles
			where
				Estatus = 1
			order by
				idConsumibles desc

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarConsumible'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarConsumible'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_GuardarCliente]    Script Date: 09/07/2024 10:54:13 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Guarda un cliente nuevo>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_GuardarCliente]

/* Parametros */
	@Nombre varchar(50)
	, @ApellidoPaterno varchar(50)
	, @ApellidoMaterno varchar(50)
	, @RazonSocial varchar(150)
	, @RFC varchar(13)
	, @Telefono varchar(10)
	, @CorreoElectronico varchar(150)
	, @Usuario varchar(50)
	, @idDireccion int
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            insert into dbo.tbl_Clientes
			(
				Estatus
				, Nombre
				, ApellidoPaterno
				, ApellidoMaterno
				, RazonSocial
				, RFC
				, Telefono
				, CorreoElectronico
				, FechaAlta
				, idDireccion
				, Usuario
			) values
			(
				1
				, @Nombre
				, @ApellidoPaterno
				, @ApellidoMaterno
				, @RazonSocial
				, @RFC
				, @Telefono
				, @CorreoElectronico
				, getdate()
				, @idDireccion
				, @Usuario
			)

			select
				idCliente
				, Estatus
				, Nombre
				, ApellidoPaterno
				, ApellidoMaterno
				, RazonSocial
				, RFC
				, Telefono
				, CorreoElectronico
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
			from
				dbo.tbl_Clientes
			where
				Estatus = 'A'

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarCliente'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_GuardarCliente'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultaTipos]    Script Date: 09/07/2024 10:54:11 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta los tipos>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ConsultaTipos]

/* Parametros */
@Usuario varchar(8)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idTipo
				, Estatus
				, Descripcion
				, Nombre
				, Simbolo
				, Equivalencia
				, Usuario
			from
				dbo.tbl_Tipos

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario				= @Usuario
			, Proceso			= 'Jiricuicho.dbo.usp_ConsultaTipos'
			, Fecha				= getdate()
			, ErrorNumber		= ERROR_NUMBER()  
			, ErrorSeverity		= ERROR_SEVERITY()
			, ErrorState		= ERROR_STATE()
			, ErrorProcedure	= ERROR_PROCEDURE()
			, ErrorLine			= ERROR_LINE()
			, ErrorMessage		= ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber			= ERROR_NUMBER()
			, Usuario			= @Usuario
			, Proceso			= 'Jiricuicho.dbo.usp_ConsultaTipos'
			, Fecha				= getdate()
			, ErrorSeverity		= ERROR_SEVERITY()
			, ErrorState		= ERROR_STATE()
			, ErrorProcedure	= ERROR_PROCEDURE()
			, ErrorLine			= ERROR_LINE()
			, ErrorMessage		= ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultarUsuario]    Script Date: 09/07/2024 10:54:09 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta los datos del usuario>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ConsultarUsuario]

/* Parametros */

@Estatus	bit
, @Usuario	varchar(12)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idUsuario
				, idPuesto
				, idEmpleado
				, Usuario
				, Estatus
				, Contraseña
			from
				Jiricuicho.dbo.tbl_Usuarios
			where
				Usuario = @Usuario
			and
				Estatus = @Estatus

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_ConsultarUsuario'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_ConsultarUsuario'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultarPuestos]    Script Date: 09/07/2024 10:54:07 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta los tipos>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ConsultarPuestos]

/* Parametros */
@Usuario varchar(8)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idPuesto
				, Clave
				, Descripcion
			from
				Jiricuicho.dbo.tbl_Puestos

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario				= @Usuario
			, Proceso			= 'Jiricuicho.dbo.usp_ConsultarPuestos'
			, Fecha				= getdate()
			, ErrorNumber		= ERROR_NUMBER()  
			, ErrorSeverity		= ERROR_SEVERITY()
			, ErrorState		= ERROR_STATE()
			, ErrorProcedure	= ERROR_PROCEDURE()
			, ErrorLine			= ERROR_LINE()
			, ErrorMessage		= ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber			= ERROR_NUMBER()
			, Usuario			= @Usuario
			, Proceso			= 'Jiricuicho.dbo.usp_ConsultarPuestos'
			, Fecha				= getdate()
			, ErrorSeverity		= ERROR_SEVERITY()
			, ErrorState		= ERROR_STATE()
			, ErrorProcedure	= ERROR_PROCEDURE()
			, ErrorLine			= ERROR_LINE()
			, ErrorMessage		= ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultarPermisos]    Script Date: 09/07/2024 10:54:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta los tipos>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ConsultarPermisos]

/* Parametros */
@Usuario varchar(8)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idPermiso
				, Clave
				, Descripcion
				, Estatus
			from
				dbo.tbl_Permisos

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario				= @Usuario
			, Proceso			= 'Jiricuicho.dbo.usp_ConsultarPermisos'
			, Fecha				= getdate()
			, ErrorNumber		= ERROR_NUMBER()  
			, ErrorSeverity		= ERROR_SEVERITY()
			, ErrorState		= ERROR_STATE()
			, ErrorProcedure	= ERROR_PROCEDURE()
			, ErrorLine			= ERROR_LINE()
			, ErrorMessage		= ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber			= ERROR_NUMBER()
			, Usuario			= @Usuario
			, Proceso			= 'Jiricuicho.dbo.usp_ConsultarPermisos'
			, Fecha				= getdate()
			, ErrorSeverity		= ERROR_SEVERITY()
			, ErrorState		= ERROR_STATE()
			, ErrorProcedure	= ERROR_PROCEDURE()
			, ErrorLine			= ERROR_LINE()
			, ErrorMessage		= ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultarMateriaPrima]    Script Date: 09/07/2024 10:54:04 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta una o todas las Materias Primas>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación

Prueba de ejecución:
exec usp_ConsultarMateriaPrima
@Estatus			= 1
, @Nombre			= 'Garrafón'
, @Usuario			= 'Fernando'


*/
ALTER procedure [dbo].[usp_ConsultarMateriaPrima]

/* Parametros */
	@Estatus			bit
	, @Nombre			varchar(150)
	, @Usuario			varchar(12)
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

		if @Estatus = 0 and @Nombre = ''
		begin
			select
				idMateriaPrima
				, Estatus
				, Nombre
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
				, idTipo
				, Cantidad
				, Caducidad
				, Precio
				, FechaCaducidad
				, Descripcion
			from
				dbo.tbl_MateriaPrima
			order by
				idMateriaPrima desc
		end
		else
		begin
			select
				idMateriaPrima
				, Estatus
				, Nombre
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
				, idTipo
				, Cantidad
				, Caducidad
				, Precio
				, FechaCaducidad
				, Descripcion
			from
				dbo.tbl_MateriaPrima
			where
				Estatus = @Estatus
			and
				Nombre like '%' + @Nombre + '%'
			order by
				idMateriaPrima desc
		end

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_ConsultarMateriaPrima'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_ConsultarMateriaPrima'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultarInmueble]    Script Date: 09/07/2024 10:54:02 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta uno o todos los Inmuebles>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación

Prueba de ejecución:
exec usp_ConsultarConsumible
@Estatus			= 1
, @Descripcion		= 'Garrafón'
, @Usuario			= 'Fernando'


*/
ALTER procedure [dbo].[usp_ConsultarInmueble]

/* Parametros */
	@Estatus			bit
	, @Descripcion		varchar(150)
	, @Usuario			varchar(12)
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

		if @Estatus = 0 and @Descripcion = ''
		begin
			select
				idInmueble
				, Estatus
				, Descripcion
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
			from
				dbo.tbl_Inmuebles
			order by
				idInmueble desc
		end
		else
		begin
			select
				idInmueble
				, Estatus
				, Descripcion
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
			from
				dbo.tbl_Inmuebles
			where
				Estatus = @Estatus
			and
				Descripcion like '%' + @Descripcion + '%'
			order by
				idInmueble desc
		end

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_ConsultarInmueble'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_ConsultarInmueble'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultarConsumible]    Script Date: 09/07/2024 10:54:00 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta uno o todos los Consumibles>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación

Prueba de ejecución:
exec usp_ConsultarConsumible
@Estatus			= 1
, @Descripcion		= 'Garrafón'
, @Usuario			= 'Fernando'


*/
ALTER procedure [dbo].[usp_ConsultarConsumible]

/* Parametros */
	@Estatus			bit
	, @Descripcion		varchar(150)
	, @Usuario			varchar(12)
as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

		if @Estatus = 0 and @Descripcion = ''
		begin
			select
				idConsumibles
				, Estatus
				, Descripcion
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
				, idTipo
				, Cantidad
			from
				dbo.tbl_Consumibles
			order by
				idConsumibles desc
		end
		else
		begin
			select
				idConsumibles
				, Estatus
				, Descripcion
				, Clave
				, FechaAlta
				, FechaBaja
				, FechaModificacion
				, Usuario
				, idTipo
				, Cantidad
			from
				dbo.tbl_Consumibles
			where
				Estatus = @Estatus
			and
				Descripcion like '%' + @Descripcion + '%'
			order by
				idConsumibles desc
		end

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'dbo.usp_ConsultarConsumible'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'dbo.usp_ConsultarConsumible'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultaMunicipios]    Script Date: 09/07/2024 10:53:59 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta los municipios>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ConsultaMunicipios]

/* Parametros */

@Estado varchar(3)
, @Descripcion varchar(150)
, @Usuario varchar(50)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idMunicipio
				, Municipio
				, Estado
				, Descripcion
			from
				Jiricuicho.dbo.tbl_Municipio
			where
				Estado = @Estado
			and
				Descripcion like @Descripcion

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_GuardarCliente'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_GuardarCliente'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultaLocalidades]    Script Date: 09/07/2024 10:53:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta las localidades>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ConsultaLocalidades]

/* Parametros */

@Estado varchar(3)
, @Localidad varchar(2)
, @Usuario varchar(50)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idLocalidad
				, Localidad
				, Estado
				, Descripcion
			from
				Jiricuicho.dbo.tbl_Localidad
			where
				Estado = @Estado
			and
				Localidad = @Localidad

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_GuardarCliente'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_GuardarCliente'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultaEstados]    Script Date: 09/07/2024 10:53:56 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta los estados>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ConsultaEstados]

/* Parametros */

@Estado varchar(3)
, @Usuario varchar(50)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idEstado
				, Estado
				, Pais
				, Nombre
			from
				Jiricuicho.dbo.tbl_Estado
			where
				Estado = @Estado

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_GuardarCliente'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_GuardarCliente'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConsultaColonias]    Script Date: 09/07/2024 10:53:54 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta las colonias por codigo postal>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_ConsultaColonias]

/* Parametros */

@CodigoPostal varchar(5)
, @Usuario varchar(50)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idColonia
				, Colonia
				, CodigoPostal
				, Asentamiento
			from
				Jiricuicho.dbo.tbl_Colonia
			where
				CodigoPostal = @CodigoPostal

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_ConsultaColonias'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.usp_ConsultaColonias'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[usp_Consulta_Codigo_Postal]    Script Date: 09/07/2024 10:53:52 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta el codigo postal>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[usp_Consulta_Codigo_Postal]

/* Parametros */

@CodigoPostal	varchar(5)
, @Usuario		varchar(50)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction

            select
				idCodigoPostal
				, CodigoPostal
				, Estado
				, Municipio
				, Localidad
			from
				Jiricuicho.dbo.tbl_CodigoPostal
			where
				CodigoPostal = @CodigoPostal

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario				= @Usuario
			, Proceso			= 'Jiricuicho.dbo.usp_Consulta_Codigo_Postal'
			, Fecha				= getdate()
			, ErrorNumber		= ERROR_NUMBER()  
			, ErrorSeverity		= ERROR_SEVERITY()
			, ErrorState		= ERROR_STATE()
			, ErrorProcedure	= ERROR_PROCEDURE()
			, ErrorLine			= ERROR_LINE()
			, ErrorMessage		= ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber			= ERROR_NUMBER()
			, Usuario			= @Usuario
			, Proceso			= 'Jiricuicho.dbo.usp_Consulta_Codigo_Postal'
			, Fecha				= getdate()
			, ErrorSeverity		= ERROR_SEVERITY()
			, ErrorState		= ERROR_STATE()
			, ErrorProcedure	= ERROR_PROCEDURE()
			, ErrorLine			= ERROR_LINE()
			, ErrorMessage		= ERROR_MESSAGE()

    end catch
end

USE [Jiricuicho]
GO
/****** Object:  StoredProcedure [dbo].[sp_ConsultaEstados]    Script Date: 09/07/2024 10:53:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================
-- Descripción:         <Consulta los estados>
-- ====================

/*
Modificaciones:
No.    Fecha          Autor                             Descripción
---    -----          -----                             -----------
> 1    08/07/2024     Fernando Morales Castillo         Creación
*/
ALTER procedure [dbo].[sp_ConsultaEstados]

/* Parametros */

@Nombre varchar(50)

as
begin
    SET NOCOUNT ON;

    begin try
        begin transaction
			
			declare @Usuario varchar(3)
			set @Usuario = 'Fer'

            select
				idEstado
				, Clave = Estado
				, Nombre
			from
				Jiricuicho.dbo.tbl_Estado
			where
				Nombre like '%' + @Nombre + '%'

		commit transaction
    end try
    begin catch
        
		if XACT_STATE() <> 0
		begin
			rollback
		end

        insert into Jiricuicho.dbo.tbl_LogError
		select
			Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.sp_ConsultaEstados'
			, Fecha = getdate()
			, ErrorNumber = ERROR_NUMBER()  
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()
		
		where
			@Usuario <> ''

		select
			ErrorNumber = ERROR_NUMBER()
			, Usuario = @Usuario
			, Proceso = 'Jiricuicho.dbo.sp_ConsultaEstados'
			, Fecha = getdate()
			, ErrorSeverity = ERROR_SEVERITY()
			, ErrorState = ERROR_STATE()
			, ErrorProcedure = ERROR_PROCEDURE()
			, ErrorLine = ERROR_LINE()
			, ErrorMessage = ERROR_MESSAGE()

    end catch
end