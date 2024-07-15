IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_D_DEMANDE_ET_AGENT_TEST')
DROP PROCEDURE PROFIL_PLUS_D_DEMANDE_ET_AGENT_TEST
GO


CREATE PROCEDURE [dbo].[PROFIL_PLUS_D_DEMANDE_ET_AGENT_TEST] 
(
  @AgentIdent INT
 ,@DemandeIdent VARCHAR(200)=NULL
)
AS

/*   
Auteur: François Alyanakian
Date de création: 14/02/2023
Date de modification: 
-------------------------------------------------------------------------------------------------------
Description :
Suppression d'une demande de profil et de l'agent non ccrf bénéficiaire
-------------------------------------------------------------------------------------------------------
*/
BEGIN TRY

IF @DemandeIdent is not null
begin
    DELETE FROM PROFIL_PLUS_SuiviEtatDemande  WHERE PFL_PLUS_DemandeIdent = @DemandeIdent
    DELETE FROM PROFIL_PLUS_Demande  WHERE PFL_PLUS_DemandeIdent = @DemandeIdent
end
DELETE FROM REF_X_AG_FCT  WHERE ag_ident = @AgentIdent
DELETE FROM AGENT_DGCCRF  WHERE ag_ident = @AgentIdent


--UPDATE INTERFACE_SIRHIUS..AGENT_NPC_SIRHIUS SET cdrpos='FINAC', dtcdrpos=convert(char(10),getdate(),103) WHERE ag_ident = @IDENT

--DELETE SYNCHRO.dbo.LISTE_ROUGE_ANAIS WHERE uid = (SELECT loginLdap FROM AGENT_DGCCRF WHERE ag_ident = @IDENT)

--UPDATE AGENT_DGCCRF SET cdrpos='FINAC',librpos='cessation définitive d''activité',ag_flag_obsolet=1,dtcdrpos=convert(char(10),getdate(),103), mail = NULL, loginLdap = NULL, compteAD = NULL WHERE ag_ident = @IDENT

--DELETE FROM SYNCHRO..W_AGENT_SAGE_EXCH WHERE SAGE_MATRICULE = (SELECT matrc12 FROM AGENT_DGCCRF WHERE ag_ident = @IDENT)

	
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
GRANT EXECUTE ON PROFIL_PLUS_D_DEMANDE_ET_AGENT_TEST TO SELECTEXEC
*/	