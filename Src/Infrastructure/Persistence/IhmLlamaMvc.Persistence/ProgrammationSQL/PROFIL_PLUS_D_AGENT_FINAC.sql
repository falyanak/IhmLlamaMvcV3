IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_D_AGENT_FINAC')
DROP PROCEDURE PROFIL_PLUS_D_AGENT_FINAC
GO

IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_D_AGENT_FINAC_TEST')
DROP PROCEDURE PROFIL_PLUS_D_AGENT_FINAC_TEST
GO


CREATE PROCEDURE [dbo].[PROFIL_PLUS_D_AGENT_FINAC] 
(
    @IDENT INT,
    @COMPTEAD varchar(15)
 )
AS

/*   
Auteur: François Alyanakian
Date de création: 16/03/2023
Date de modification: 
-------------------------------------------------------------------------------------------------------
Description : Suppression logique d'une agent en base
-------------------------------------------------------------------------------------------------------
*/
BEGIN TRY


UPDATE INTERFACE_SIRHIUS..AGENT_NPC_SIRHIUS 
    SET cdrpos='FINAC', 
         dtcdrpos=convert(char(10),getdate(),103)
    WHERE ag_ident = @IDENT

UPDATE referentiel..AGENT_DGCCRF 
    SET cdrpos='FINAC',
        librpos='cessation définitive d''activité',
        ag_flag_obsolet=1,
        dtcdrpos=convert(char(10),
        getdate(),103), 
        mail = NULL, 
        loginLdap = NULL, 
        compteAD = NULL 
    WHERE ag_ident = @IDENT

DELETE SYNCHRO.dbo.LISTE_ROUGE_ANAIS where uid=@COMPTEAD
	
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
GRANT EXECUTE ON PROFIL_PLUS_D_AGENT_FINAC TO SELECTEXEC
*/	