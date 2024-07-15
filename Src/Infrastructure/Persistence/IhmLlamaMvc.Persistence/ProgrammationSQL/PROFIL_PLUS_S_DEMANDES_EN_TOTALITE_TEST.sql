IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_DEMANDES_EN_TOTALITE_TEST')
DROP PROCEDURE PROFIL_PLUS_S_DEMANDES_EN_TOTALITE_TEST
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_DEMANDES_EN_TOTALITE_TEST]
@count int OUTPUT
AS
/*   
Auteur: François Alyanakian
Date de création: 07/03/2023
-------------------------------------------------------------------------------------------------------
Description : Recherche toutes les demandes 
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_DEMANDES_EN_TOTALITE_TEST

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

select 
       EntitesGroup.Entite as 'Entite'
      ,Dem.PFL_PLUS_NomFam as 'NomFamille'
	  ,Dem.PFL_PLUS_PreUsu as 'PrenomUsuel'
	  ,Dem.PFL_PLUS_Mail as 'Courriel'
      ,EntitesGroup.UniteFonctionnelle as 'UniteFonctionnelle'
	  ,Fonc.FCT_LIBELLE as 'Fonction'
	  ,Dem.PFL_PLUS_DemandeIdent as 'Id'
	  ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
      ,SuiviEtatDem.DateEtatDemande as 'DateEtatdemande'
	  ,EtatDem.EtatDemandeLibelleCourt as 'EtatDemande'
	  ,TypeDem.TypeDemandeLibelleCourt as 'TypeDemande'
	  ,TypeTraitDem.TypeTraitementDemandeLibelleCourt as 'TypeTraitementDemande'
      ,Dem.PFL_PLUS_Commentaire as 'Commentaire'
      ,Dem.PFL_PLUS_CompteADCree as 'CompteADCree'
      ,Dem.PFL_PLUS_CompteApplicatifCree as 'CompteApplicatifCree'
      ,Dem.PFL_PLUS_Sexe as 'Sexe'
      ,PFL_PLUS_LibelleSexe as 'LibelleSexe'

From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
 inner join PROFIL_PLUS_Demande as Dem
 on dem.Unfct_Ident = EntitesGroup.UniteFonctionnelleId
  
 left join REF_X_FONCTION as fonc -- left join pour ne pas perdre d'agents
 on Dem.FCT_IDENT = Fonc.FCT_IDENT
 
 inner join PROFIL_PLUS_SuiviEtatDemande as SuiviEtatDem
 on Dem.PFL_PLUS_DemandeIdent = SuiviEtatDem.PFL_PLUS_DemandeIdent
 -- ne conserver que le dernier état
  and SuiviEtatDem.EtatDemandeIdent = (SELECT MAX(EtatDemandeIdent) FROM [PROFIL_PLUS_SuiviEtatDemande]
       where PFL_PLUS_DemandeIdent = SuiviEtatDem.PFL_PLUS_DemandeIdent)

 inner join PROFIL_PLUS_REF_EtatDemande as EtatDem
 on SuiviEtatDem.EtatDemandeIdent = EtatDem.EtatDemandeIdent

 inner join PROFIL_PLUS_REF_TypeDemande as TypeDem
 on Dem.TypeDemandeIdent = TypeDem.TypeDemandeIdent

 inner join PROFIL_PLUS_REF_TypeTraitementDemande as TypeTraitDem
 on Dem.TypeTraitementDemandeIdent = TypeTraitDem.TypeTraitementDemandeIdent

 order by Entite, Dem.PFL_PLUS_NomFam, Dem.PFL_PLUS_PreUsu

 SELECT @count = @@ROWCOUNT

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
GRANT EXECUTE ON PROFIL_PLUS_S_DEMANDES_EN_TOTALITE_TEST TO SELECTEXEC
*/