IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_I_ETAT_DEMANDE')
DROP PROCEDURE PROFIL_PLUS_I_ETAT_DEMANDE
GO

CREATE PROCEDURE dbo.PROFIL_PLUS_I_ETAT_DEMANDE 
    @DemandeGuid varchar(200),
    @EtatDemandeId tinyint,
    @DateCreationDemande datetime
AS

/*   
Auteur: François Alyanakian
Date de création: 28/11/2022
-------------------------------------------------------------------------------------------------------
Description : Insère l'état d'une demande de création d'un compte pour un agent non CCRF
-------------------------------------------------------------------------------------------------------
Modification :  
-------------------------------------------------------------------------------------------------------
*/
BEGIN TRY

        INSERT PROFIL_PLUS_SuiviEtatDemande
           (
            EtatDemandeIdent
           ,PFL_PLUS_DemandeIdent
           ,DateEtatDemande)
        VALUES
           ( 
            @EtatDemandeId,
            @DemandeGuid,
            @DateCreationDemande
           )

  -- Renvoi du nouvel Id de l'état inséré
SELECT SuiviEtatDemandeIdent as 'Id' FROM PROFIL_PLUS_SuiviEtatDemande where SuiviEtatDemandeIdent = @@IDENTITY;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
       ROLLBACK TRANSACTION

       DECLARE @NomProcedure VARCHAR(255),@NomBase VARCHAR(255)
       SELECT @NomProcedure =OBJECT_NAME(@@PROCID), @NomBase=DB_NAME()
       EXEC TraceSQL.dbo.P_SQLAPP_I_TraceErreurs @NomProcedure,@NomBase

       -- Propage l'erreur au niveau supérieur
       DECLARE @ERROR_MESSAGE NVARCHAR(4000),@ERROR_NUMBER INT,@ERROR_SEVERITY INT,@ERROR_STATE INT
       SET @ERROR_MESSAGE=ERROR_MESSAGE()
       SET @ERROR_SEVERITY=ERROR_SEVERITY()
       SET @ERROR_STATE=ERROR_STATE()
       RAISERROR(@ERROR_MESSAGE,@ERROR_SEVERITY,@ERROR_STATE)

END CATCH;

GO
/*
GRANT EXECUTE ON PROFIL_PLUS_I_ETAT_DEMANDE TO SELECTEXEC
*/