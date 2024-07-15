IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_D_SUPPRIMER_DEMANDES_ANTERIEURES_A_UNE_DATE_RGPD')
DROP PROCEDURE PROFIL_PLUS_D_SUPPRIMER_DEMANDES_ANTERIEURES_A_UNE_DATE_RGPD
GO


CREATE PROCEDURE [dbo].PROFIL_PLUS_D_SUPPRIMER_DEMANDES_ANTERIEURES_A_UNE_DATE_RGPD
(
    @DateConformiteRGPD datetime
)
AS
/*   
Auteur: François Alyanakian
Date de création: 30/08/2023
------------------------------------------------------------------------------------------------------
Description : conformité RGPD : Supprimer les demandes antérieures à 2 ans

Retourner une liste des demandes supprimées placées dans une table temporaire
-------------------------------------------------------------------------------------------------------
Modification :  
-------------------------------------------------------------------------------------------------------
*/


BEGIN TRY

SET NOCOUNT ON

BEGIN

-- supprimer la table temporaire
DROP TABLE IF EXISTS #PROFIL_PLUS_Temporaire_Suppression_Demande_RGPD;

-- sélectionner les demandes à supprimer, les stocker dans une table temporaire
SELECT 
       EntitesGroup.Entite as 'Entite'
      ,Dem.PFL_PLUS_DemandeIdent as 'Id'
  	  ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
	  ,EtatDem.EtatDemandeLibelleCourt as 'EtatDemande'
	  ,TypeDem.TypeDemandeLibelleCourt as 'TypeDemande'
   	  ,TypeTraitDem.TypeTraitementDemandeLibelleCourt as 'TypeTraitementDemande'
      ,Dem.PFL_PLUS_NomFam as 'NomFamille'
	  ,Dem.PFL_PLUS_PreUsu as 'PrenomUsuel'
	  ,Dem.PFL_PLUS_Mail as 'Courriel'
      ,Dem.Unfct_Ident as 'UniteFonctionnelleId'
      ,EntitesGroup.UniteFonctionnelle as 'UniteFonctionnelle'
      ,EntitesGroup.UniteAdministrativeId as 'UniteAdministrativeId'
      ,EntitesGroup.UniteAdministrative as 'UniteAdministrative'
      ,Dem.FCT_IDENT as 'FonctionId'
	  ,Fonc.FCT_LIBELLE as 'Fonction'

  INTO #PROFIL_PLUS_Temporaire_Suppression_Demande_RGPD

  FROM PROFIL_PLUS_Demande as Dem
       inner join V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
       on dem.Unfct_Ident = EntitesGroup.UniteFonctionnelleId

	   inner join PROFIL_PLUS_SuiviEtatDemande as SuiviEtat
       on dem.PFL_PLUS_DemandeIdent = SuiviEtat.PFL_PLUS_DemandeIdent
 
        inner join PROFIL_PLUS_REF_EtatDemande as EtatDem
        on SuiviEtat.EtatDemandeIdent = EtatDem.EtatDemandeIdent

        inner join PROFIL_PLUS_REF_TypeDemande as TypeDem
        on Dem.TypeDemandeIdent = TypeDem.TypeDemandeIdent

        inner join PROFIL_PLUS_REF_TypeTraitementDemande as TypeTraitDem
        on Dem.TypeTraitementDemandeIdent = TypeTraitDem.TypeTraitementDemandeIdent

        left join REF_X_FONCTION as fonc
        on Dem.FCT_IDENT = Fonc.FCT_IDENT

   WHERE DEM.PFL_PLUS_DateCreationDemande < @DateConformiteRGPD 

-- Supprimer les demandes dans la table PROFIL_PLUS_SuiviEtatDemande
 DELETE FROM PROFIL_PLUS_SuiviEtatDemande
 WHERE PFL_PLUS_DemandeIdent IN
   (SELECT Id FROM #PROFIL_PLUS_Temporaire_Suppression_Demande_RGPD)

-- Supprimer les demandes dans la table PROFIL_PLUS_Demande
 DELETE FROM PROFIL_PLUS_Demande
 WHERE PFL_PLUS_DemandeIdent IN
   (SELECT Id FROM #PROFIL_PLUS_Temporaire_Suppression_Demande_RGPD)

-- retourner la liste des demandes supprimées
SELECT 
       Entite
      ,Id
  	  ,DateCreationDemande
	  ,EtatDemande
	  ,TypeDemande
   	  ,TypeTraitementDemande
      ,NomFamille
	  ,PrenomUsuel
	  ,Courriel
      ,UniteFonctionnelleId
      ,UniteFonctionnelle
      ,UniteAdministrativeId
      ,UniteAdministrative
      ,FonctionId
	  ,Fonction
  FROM #PROFIL_PLUS_Temporaire_Suppression_Demande_RGPD 

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
GRANT EXECUTE ON PROFIL_PLUS_D_SUPPRIMER_DEMANDES_ANTERIEURES_A_UNE_DATE_RGPD TO SELECTEXEC
*/
