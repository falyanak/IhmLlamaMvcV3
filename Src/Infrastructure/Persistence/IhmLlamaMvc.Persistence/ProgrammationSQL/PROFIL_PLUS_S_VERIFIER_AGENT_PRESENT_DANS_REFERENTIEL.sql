IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_VERIFIER_AGENT_PRESENT_DANS_REFERENTIEL')
DROP PROCEDURE PROFIL_PLUS_S_VERIFIER_AGENT_PRESENT_DANS_REFERENTIEL
GO


CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_VERIFIER_AGENT_PRESENT_DANS_REFERENTIEL]
(
    @AgentIdent int
)AS
/*   
Auteur: François Alyanakian
Date de création: 21/08/2023
-------------------------------------------------------------------------------------------------------
Description : Vérifier si un agent est présent dans le référentiel
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
   Exec PROFIL_PLUS_S_VERIFIER_AGENT_PRESENT_DANS_REFERENTIEL 
   @@AgentIdent=[un Agent Id]

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

select 
       Agt.ag_ident as 'Id'
      ,Agt.nomfam as 'NomFamille'
	  ,Agt.preusu as 'PrenomUsuel'
	  ,Agt.mail as 'Courriel'
      ,Agt.compteAD as 'CompteActiveDirectory'
      ,Agt.ag_flag_obsolet as 'EstParti'
      ,Agt.cdetcv as 'Sexe'

From REFERENTIEL..AGENT_DGCCRF as Agt
 
WHERE Agt.ag_ident = @AgentIdent

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
GRANT EXECUTE ON PROFIL_PLUS_S_VERIFIER_AGENT_PRESENT_DANS_REFERENTIEL TO SELECTEXEC
*/