IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_D_COMPTES_INACTIFS')
DROP PROCEDURE PROFIL_PLUS_D_COMPTES_INACTIFS
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_D_COMPTES_INACTIFS]
  @GestionGuid VARCHAR(50)
AS
/*   
Auteur: François Alyanakian
Date de création: 3/11/2023
-------------------------------------------------------------------------------------------------------
Description : Suppression d'un enregistrement de gestion de la désactivation 
              d'un compte inactif
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

  DELETE FROM [PROFIL_PLUS_Gestion_Compte_Inactif]
        WHERE PFL_PLUS_Gestion_Ident = @GestionGuid

END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
	ROLLBACK TRANSACTION;
        
    DECLARE @NomProcedure VARCHAR(255),@NomBase  VARCHAR(255);
    SELECT @NomProcedure =OBJECT_NAME(@@PROCID), @NomBase=DB_NAME();
    EXEC TraceSQL.dbo.P_SQLAPP_I_TraceErreurs @NomProcedure,@NomBase;

            -- Propage l'erreur au niveau supérieur
    DECLARE @ERROR_MESSAGE NVARCHAR(4000),@ERROR_NUMBER INT,@ERROR_SEVERITY INT,@ERROR_STATE INT;
    SET  @ERROR_MESSAGE=ERROR_MESSAGE();
    SET  @ERROR_SEVERITY=ERROR_SEVERITY();
    SET  @ERROR_STATE=ERROR_STATE();
    RAISERROR(@ERROR_MESSAGE,@ERROR_SEVERITY,@ERROR_STATE);

END CATCH;

GO
/*
GRANT EXECUTE ON PROFIL_PLUS_D_COMPTES_INACTIFS TO SELECTEXEC
*/
