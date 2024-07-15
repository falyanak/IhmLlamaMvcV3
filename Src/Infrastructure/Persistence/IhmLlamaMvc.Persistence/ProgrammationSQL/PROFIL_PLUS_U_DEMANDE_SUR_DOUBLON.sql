IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_U_DEMANDE_SUR_DOUBLON')
DROP PROCEDURE PROFIL_PLUS_U_DEMANDE_SUR_DOUBLON
GO


CREATE PROCEDURE [dbo].PROFIL_PLUS_U_DEMANDE_SUR_DOUBLON (
    @DemandeId varchar(50),
    @TypeTraitementId smallint,
    @DateConfirmationMail datetime,
    @EtatDemandeId smallint,
    @CompteADCree bit,
    @CompteApplicatifCree bit
)
AS
/*   
Auteur: François Alyanakian
Date de création: 14/06/2023
------------------------------------------------------------------------------------------------------
Description : Modifier la demande après détection d'un doublon :
    Actions : modifier la date de confirmation de l'adresse mail
              passer le traitement à manuel car, en cas de doublon, traitement réalisé par la CNE
              passer la demande à l'état "en cours" et non à "terminée"
                pour garder une trace temporaire dans l'IHM
              passer le @CompteADCree à vrai
              passer le CompteApplicatifCree à vrai 
-------------------------------------------------------------------------------------------------------
Modification :  
-------------------------------------------------------------------------------------------------------
*/


BEGIN TRY

SET NOCOUNT ON

BEGIN

UPDATE PROFIL_PLUS_Demande 
       set 
           PFL_PLUS_DateConfirmationMail = @DateConfirmationMail,
           TypeTraitementDemandeIdent = @TypeTraitementId,
           PFL_PLUS_CompteADCree = @CompteADCree,
           PFL_PLUS_CompteApplicatifCree = @CompteApplicatifCree
       where PFL_PLUS_DemandeIdent=@DemandeId


INSERT PROFIL_PLUS_SuiviEtatDemande
           (
            EtatDemandeIdent
           ,PFL_PLUS_DemandeIdent
           ,DateEtatDemande)
        VALUES
           ( 
            @EtatDemandeId,
            @DemandeId,
            getdate()
           )
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
GRANT EXECUTE ON PROFIL_PLUS_U_DEMANDE_SUR_DOUBLON TO SELECTEXEC
*/
