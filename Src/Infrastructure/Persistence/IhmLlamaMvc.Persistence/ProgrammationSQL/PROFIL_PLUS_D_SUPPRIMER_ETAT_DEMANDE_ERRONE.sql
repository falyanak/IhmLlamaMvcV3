IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_D_SUPPRIMER_ETAT_DEMANDE_ERRONE')
DROP PROCEDURE PROFIL_PLUS_D_SUPPRIMER_ETAT_DEMANDE_ERRONE
GO


CREATE PROCEDURE [dbo].PROFIL_PLUS_D_SUPPRIMER_ETAT_DEMANDE_ERRONE
@DemandeIdent varchar(50),
@EtatDemandeIdent tinyint
AS
/*   
Auteur: François Alyanakian
Date de création: 6/10/2023
------------------------------------------------------------------------------------------------------
Description : Supprimer  l'état 'réponse effective agent' dans lequel une demande de modification
              est restée bloquée à la suite d'une erreur dans la modification du compte AD
              l'erreur est probablement due à un compte AD créé sans adresse mail
-------------------------------------------------------------------------------------------------------
Modification :  
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

SET NOCOUNT ON

BEGIN

  DELETE FROM PROFIL_PLUS_SuiviEtatDemande 
    WHERE PFL_PLUS_DemandeIdent = @DemandeIdent 
      AND EtatDemandeIdent = @EtatDemandeIdent
END

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
GRANT EXECUTE ON PROFIL_PLUS_D_SUPPRIMER_ETAT_DEMANDE_ERRONE TO SELECTEXEC
*/
