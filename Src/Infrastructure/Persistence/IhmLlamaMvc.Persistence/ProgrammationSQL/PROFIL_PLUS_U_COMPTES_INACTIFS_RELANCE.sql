IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_U_COMPTES_INACTIFS_RELANCE')
DROP PROCEDURE PROFIL_PLUS_U_COMPTES_INACTIFS_RELANCE
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_U_COMPTES_INACTIFS_RELANCE]
@GestionGuid varchar(50),
@DateEnvoiCourrielRelance datetime,
@EtatGestionIdent tinyint
AS
/*   
Auteur: François Alyanakian
Date de création: 21/11/2023
-------------------------------------------------------------------------------------------------------
Description : Mettre à jour les champs
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

    UPDATE PROFIL_PLUS_Gestion_Compte_Inactif 
      SET PFL_PLUS_DateEnvoiCourrielRelance = @DateEnvoiCourrielRelance, 
          PFL_PLUS_EtatGestionIdent = @EtatGestionIdent
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
GRANT EXECUTE ON PROFIL_PLUS_U_COMPTES_INACTIFS_RELANCE TO SELECTEXEC
*/
