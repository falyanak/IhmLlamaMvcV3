IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_DEMANDES_HISTORIQUE_UN_AGENT')
DROP PROCEDURE PROFIL_PLUS_S_DEMANDES_HISTORIQUE_UN_AGENT
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_DEMANDES_HISTORIQUE_UN_AGENT]
  @AgentIdent smallint
AS
/*   
Auteur: François Alyanakian
Date de création: 16/11/2022
-------------------------------------------------------------------------------------------------------
Description : Recherche l'historique des demandes pour un agent
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_DEMANDES_HISTORIQUE_UN_AGENT agentIdent

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY
	DECLARE @resultjson NVARCHAR(max);
	SET @resultjson = (

select 
       Dem.PFL_PLUS_NomFam as 'NomFamille'
	  ,Dem.PFL_PLUS_PreUsu as 'PrenomUsuel'
	  ,Dem.PFL_PLUS_Mail as 'Courriel'
      ,fonc.FCT_LIBELLE as 'Fonction'
      ,EntitesGroup.UniteFonctionnelle as 'UniteFonctionnelle'
	  ,Dem.PFL_PLUS_DemandeIdent as 'Id'
	  ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
	  ,TypeDem.TypeDemandeLibelleCourt as 'TypeDemande'
	  ,TypeTraitDem.TypeTraitementDemandeLibelleCourt as 'TypeTraitementDemande'
      ,Agent.nomfam as 'NomFamilleAgentCreateur'
      ,Agent.preusu as 'PrenomAgentCreateur'
      ,Dem.PFL_PLUS_Sexe as 'Sexe'
      ,PFL_PLUS_LibelleSexe as 'LibelleSexe'

      ,(SELECT SuiviEtat.DateEtatDemande as 'DateEtatDemande'
	          ,Etat.EtatDemandeLibelleCourt as 'EtatDemande'
       FROM PROFIL_PLUS_SuiviEtatDemande as SuiviEtat
            inner join PROFIL_PLUS_REF_EtatDemande as Etat
            on Etat.EtatDemandeIdent = SuiviEtat.EtatDemandeIdent
       WHERE Dem.PFL_PLUS_DemandeIdent = SuiviEtat.PFL_PLUS_DemandeIdent
       ORDER BY SuiviEtat.EtatDemandeIdent desc
       FOR JSON PATH, INCLUDE_NULL_VALUES) AS ListeEtats

  
 From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
 inner join PROFIL_PLUS_Demande as Dem
 on dem.Unfct_Ident = EntitesGroup.UniteFonctionnelleId

 inner join PROFIL_PLUS_REF_TypeDemande as TypeDem
 on Dem.TypeDemandeIdent = TypeDem.TypeDemandeIdent

 inner join PROFIL_PLUS_REF_TypeTraitementDemande as TypeTraitDem
 on Dem.TypeTraitementDemandeIdent = TypeTraitDem.TypeTraitementDemandeIdent
   
 left join REF_X_FONCTION as fonc -- left join pour ne pas perdre d'agents
 on Dem.FCT_IDENT = Fonc.FCT_IDENT

 inner join AGENT_DGCCRF as Agent
 on Agent.ag_ident = Dem.Ag_Ident_Createur

 WHERE Dem.Ag_Ident_ConcerneParDemande = @AgentIdent
  
 order by Dem.PFL_PLUS_DateCreationDemande desc
 	FOR JSON PATH

	);
	SELECT @resultjson; -- on retourne le JSON


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
GRANT EXECUTE ON PROFIL_PLUS_S_DEMANDES_HISTORIQUE_UN_AGENT TO SELECTEXEC
*/