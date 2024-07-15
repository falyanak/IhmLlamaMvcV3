IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_D_SUPPRIMER_AGENT_PAR_ID_TEST')
DROP PROCEDURE PROFIL_PLUS_D_SUPPRIMER_AGENT_PAR_ID_TEST
GO


CREATE PROCEDURE [dbo].PROFIL_PLUS_D_SUPPRIMER_AGENT_PAR_ID_TEST
@AgentIdent INT
AS
/*   
Auteur: François Alyanakian
Date de création: 12/04/2023
------------------------------------------------------------------------------------------------------
Description : Supprimer un agent si nompat ='Profil+' dans le cadre des tests 
-------------------------------------------------------------------------------------------------------
Modification :  
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

SET NOCOUNT ON

BEGIN

DELETE FROM REF_X_AG_FCT  WHERE ag_ident = @AgentIdent
DELETE FROM AGENT_DGCCRF  WHERE ag_ident = @AgentIdent AND nompat = 'Profil+'

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
GRANT EXECUTE ON PROFIL_PLUS_D_SUPPRIMER_AGENT_PAR_ID_TEST TO SELECTEXEC
*/
