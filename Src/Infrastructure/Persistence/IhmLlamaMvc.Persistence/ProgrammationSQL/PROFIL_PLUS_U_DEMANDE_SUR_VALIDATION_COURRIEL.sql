IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_U_DEMANDE_SUR_VALIDATION_COURRIEL')
DROP PROCEDURE PROFIL_PLUS_U_DEMANDE_SUR_VALIDATION_COURRIEL
GO


CREATE PROCEDURE [dbo].PROFIL_PLUS_U_DEMANDE_SUR_VALIDATION_COURRIEL (
    @DemandeId varchar(50),
    @DateConfirmationMail datetime,
    @CreationCompteADEffective bit,
    @CompteAD varchar(15),
    @EtatDemandeId smallint
)
AS
/*   
Auteur: François Alyanakian
Date de création: 24/01/2023
------------------------------------------------------------------------------------------------------
Description : Ajouter le matricule créé dans la table PROFIL_PLUS_Demande et
              affecter la demande à l'état Terminée
-------------------------------------------------------------------------------------------------------
Modification :  
-------------------------------------------------------------------------------------------------------
*/


BEGIN TRY

SET NOCOUNT ON

BEGIN

UPDATE PROFIL_PLUS_Demande 
       set 
           PFL_PLUS_CompteADCree = @CreationCompteADEffective,
           PFL_PLUS_DateConfirmationMail = @DateConfirmationMail,
           PFL_PLUS_CompteAD = @CompteAD
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
GRANT EXECUTE ON PROFIL_PLUS_U_DEMANDE_SUR_VALIDATION_COURRIEL TO SELECTEXEC
*/
