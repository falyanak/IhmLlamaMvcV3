IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_DEMANDE_EN_COURS_PAR_MAIL')
DROP PROCEDURE PROFIL_PLUS_S_DEMANDE_EN_COURS_PAR_MAIL
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_DEMANDE_EN_COURS_PAR_MAIL]
(
   @Mail varchar(100)
)AS
/*   
Auteur: François Alyanakian
Date de création: 16/02/2023
-------------------------------------------------------------------------------------------------------
Description : Recherche une demande avec un état diférent de 'terminée' 
              à partir du mail de l'agent afin d'éviter de créer une demande en double
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_DEMANDE_EN_COURS_PAR_MAIL @Mail

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

select 
       EntitesGroup.Entite as 'Entite'
      ,Dem.PFL_PLUS_NomFam as 'NomFamille'
	  ,Dem.PFL_PLUS_PreUsu as 'PrenomUsuel'
	  ,Dem.PFL_PLUS_Mail as 'Courriel'
      ,Dem.Unfct_Ident as 'UniteFonctionnelleId'
  	  ,Dem.PFL_PLUS_DemandeIdent as 'Id'
	  ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
      ,Dem.Ag_Ident_Createur as 'AgentCreateurId'
      ,Dem.PFL_PLUS_CompteApplicatifCree as 'CompteApplicatifCree'
	  ,Etat.DateEtatDemande as 'DateEtatdemande'
      ,Etat.EtatDemandeIdent as 'EtatDemandeId'
	  ,EtatDem.EtatDemandeLibelleCourt as 'EtatDemande'
	  ,TypeDem.TypeDemandeLibelleCourt as 'TypeDemande'
	  ,TypeTraitDem.TypeTraitementDemandeLibelleCourt as 'TypeTraitementDemande'
      ,PFL_PLUS_Sexe as 'Sexe'
      ,PFL_PLUS_LibelleSexe as 'LibelleSexe'

From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
 inner join PROFIL_PLUS_Demande as Dem
 on dem.Unfct_Ident = EntitesGroup.UniteFonctionnelleId

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
 --
 
  WHERE Dem.PFL_PLUS_Mail = @Mail 
 
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
GRANT EXECUTE ON PROFIL_PLUS_S_DEMANDE_EN_COURS_PAR_MAIL TO SELECTEXEC
*/