IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_DEMANDE_AVEC_DERNIER_ETAT')
DROP PROCEDURE PROFIL_PLUS_S_DEMANDE_AVEC_DERNIER_ETAT
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_DEMANDE_AVEC_DERNIER_ETAT]
(
   @DemandeIdent VARCHAR(200)

)AS
/*   
Auteur: François Alyanakian
Date de création: 16/11/2022
-------------------------------------------------------------------------------------------------------
Description : Recherche une demande avec son dernier état à partir de leur entité d'affectation : DGAL, DGDDI, SCL
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_DEMANDE_AVEC_DERNIER_ETAT identifiant Guid en chaine de caractères

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

    SELECT 
       EntitesGroup.Entite as 'Entite'
      ,Dem.Ag_Ident_ConcerneParDemande as 'AgentConcerneId'
      ,Dem.PFL_PLUS_NomFam as 'NomFamille'
	  ,Dem.PFL_PLUS_PreUsu as 'PrenomUsuel'
	  ,Dem.PFL_PLUS_Mail as 'Courriel'
      ,Dem.PFL_PLUS_CompteAD as 'CompteActiveDirectory'
      ,Dem.Unfct_Ident as 'UniteFonctionnelleId'
      ,Dem.PFL_PLUS_DateDernierClicBoutonCourrielTest as 'DateDernierClicBoutonCourrielTest'
      ,EntitesGroup.UniteFonctionnelle as 'UniteFonctionnelle'
      ,EntitesGroup.UniteAdministrativeId as 'UniteAdministrativeId'
      ,EntitesGroup.UniteAdministrative as 'UniteAdministrative'
      ,Dem.FCT_IDENT as 'FonctionId'
	  ,Fonc.FCT_LIBELLE as 'Fonction'
	  ,Dem.PFL_PLUS_DemandeIdent as 'Id'
	  ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
      ,Dem.Ag_Ident_Createur as 'AgentCreateurId'
	  ,Etat.DateEtatDemande as 'DateEtatdemande'
      ,EtatDem.EtatDemandeIdent as 'EtatDemandeId'
	  ,EtatDem.EtatDemandeLibelleCourt as 'EtatDemande'
	  ,TypeDem.TypeDemandeLibelleCourt as 'TypeDemande'
   	  ,TypeDem.TypeDemandeIdent as 'TypeDemandeId'
	  ,TypeTraitDem.TypeTraitementDemandeLibelleCourt as 'TypeTraitementDemande'
      ,TypeTraitDem.TypeTraitementDemandeIdent as 'TypeTraitementDemandeId'
      ,Dem.ORIAG_IDENT as 'OrigineAgentId'
      ,origAgt.ORIAG_LIBELLE as 'OrigineAgent'
      ,Dem.AdmOrigineIdent as 'AdministrationOrigineId'
      ,adminOri.AdmOrigineLibelle as 'AdministrationOrigine'
      ,Dem.PFL_PLUS_Commentaire as 'Commentaire'
      ,PFL_PLUS_DemandeObsolet as 'DemandeObsolete'
      ,PFL_PLUS_CompteADCree as 'CompteADCree'
      ,PFL_PLUS_CompteApplicatifCree as 'CompteApplicatifCree'
      ,PFL_PLUS_DateEnvoiMail as 'DateEnvoiCourriel'
      ,PFL_PLUS_DateConfirmationMail as 'DateConfirmationMail'
      ,PFL_PLUS_Sexe as 'Sexe'
      ,PFL_PLUS_LibelleSexe as 'LibelleSexe'
 
        From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
        inner join PROFIL_PLUS_Demande as Dem
        on dem.Unfct_Ident = EntitesGroup.UniteFonctionnelleId
  
        left join REF_X_FONCTION as fonc -- left join pour ne pas perdre d'agents
        on Dem.FCT_IDENT = Fonc.FCT_IDENT

        left join REF_X_ORIGINE_AGENT as origAgt -- left join pour ne pas perdre d'agents
        on Dem.ORIAG_IDENT = origAgt.ORIAG_IDENT
 
        left join REF_X_AdminOrigine as adminOri -- left join pour ne pas perdre d'agents
        on Dem.AdmOrigineIdent = adminOri.AdmOrigineIdent
 
        inner join PROFIL_PLUS_SuiviEtatDemande as Etat
        on Dem.PFL_PLUS_DemandeIdent = Etat.PFL_PLUS_DemandeIdent
        -- ne conserver que le dernier état
        and Etat.EtatDemandeIdent = (SELECT MAX(EtatDemandeIdent) FROM [PROFIL_PLUS_SuiviEtatDemande]
        where PFL_PLUS_DemandeIdent = Etat.PFL_PLUS_DemandeIdent)

        inner join PROFIL_PLUS_REF_EtatDemande as EtatDem
        on Etat.EtatDemandeIdent = EtatDem.EtatDemandeIdent

        inner join PROFIL_PLUS_REF_TypeDemande as TypeDem
        on Dem.TypeDemandeIdent = TypeDem.TypeDemandeIdent

        inner join PROFIL_PLUS_REF_TypeTraitementDemande as TypeTraitDem
        on Dem.TypeTraitementDemandeIdent = TypeTraitDem.TypeTraitementDemandeIdent

        WHERE  Dem.PFL_PLUS_DemandeIdent = @DemandeIdent

        ORDER BY Entite, Dem.PFL_PLUS_NomFam, Dem.PFL_PLUS_PreUsu

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
GRANT EXECUTE ON PROFIL_PLUS_S_DEMANDE_AVEC_DERNIER_ETAT TO SELECTEXEC
*/