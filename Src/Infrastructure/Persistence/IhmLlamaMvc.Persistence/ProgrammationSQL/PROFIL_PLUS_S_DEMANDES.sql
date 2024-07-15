IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_DEMANDES')
DROP PROCEDURE PROFIL_PLUS_S_DEMANDES
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_DEMANDES]
(
    @Entite varchar(10)=NULL
   ,@Nom VARCHAR(42)=NULL
   ,@DemandeIdent VARCHAR(200)=NULL

)AS
/*   
Auteur: François Alyanakian
Date de création: 16/11/2022
-------------------------------------------------------------------------------------------------------
Description : Recherche les demandes à partir de leur entité d'affectation : DGAL, DGDDI, SCL
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_DEMANDES ENTITES = 'DGAL'

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

IF @Entite IS NOT NULL AND (RIGHT(@Entite,1)='*' OR LEFT(@Entite,1)='*')
       SET @Entite = REPLACE(@Entite,'*','%')  

IF @Nom IS NOT NULL AND (RIGHT(@Nom,1)='*' OR LEFT(@Nom,1)='*')
       SET @Nom = REPLACE(@Nom,'*','%')  

IF @DemandeIdent IS NOT NULL AND (RIGHT(@DemandeIdent,1)='*' OR LEFT(@DemandeIdent,1)='*')
       SET @DemandeIdent = REPLACE(@DemandeIdent,'*','%')  

select 
       EntitesGroup.Entite as 'Entite'
      ,Dem.PFL_PLUS_NomFam as 'NomFamille'
	  ,Dem.PFL_PLUS_PreUsu as 'PrenomUsuel'
	  ,Dem.PFL_PLUS_Mail as 'Courriel'
      ,EntitesGroup.UniteFonctionnelle as 'UniteFonctionnelle'
	  ,Fonc.FCT_LIBELLE as 'Fonction'
	  ,Dem.PFL_PLUS_DemandeIdent as 'Id'
	  ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
	  ,Etat.DateEtatDemande as 'DateEtatdemande'
	  ,EtatDem.EtatDemandeLibelleCourt as 'EtatDemande'
	  ,TypeDem.TypeDemandeLibelleCourt as 'TypeDemande'
	  ,TypeTraitDem.TypeTraitementDemandeLibelleCourt as 'TypeTraitementDemande'
      ,Dem.PFL_PLUS_Commentaire as 'Commentaire'
      ,Dem.PFL_PLUS_CompteADCree as 'CompteADCree'
      ,Dem.PFL_PLUS_CompteApplicatifCree as 'CompteApplicatifCree'
      ,dem.PFL_PLUS_Sexe as 'Sexe'
      ,PFL_PLUS_LibelleSexe as 'LibelleSexe'

From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
 inner join PROFIL_PLUS_Demande as Dem
 on dem.Unfct_Ident = EntitesGroup.UniteFonctionnelleId
  
 left join REF_X_FONCTION as fonc -- left join pour ne pas perdre d'agents
 on Dem.FCT_IDENT = Fonc.FCT_IDENT
 
 inner join PROFIL_PLUS_SuiviEtatDemande as Etat
 on Dem.PFL_PLUS_DemandeIdent = Etat.PFL_PLUS_DemandeIdent

 inner join PROFIL_PLUS_REF_EtatDemande as EtatDem
 on Etat.EtatDemandeIdent = EtatDem.EtatDemandeIdent

 inner join PROFIL_PLUS_REF_TypeDemande as TypeDem
 on Dem.TypeDemandeIdent = TypeDem.TypeDemandeIdent

 inner join PROFIL_PLUS_REF_TypeTraitementDemande as TypeTraitDem
 on Dem.TypeTraitementDemandeIdent = TypeTraitDem.TypeTraitementDemandeIdent

 WHERE EntitesGroup.Entite LIKE @Entite
       AND Dem.PFL_PLUS_NomFam LIKE CASE WHEN @Nom IS NOT NULL THEN @Nom ELSE '%' END
       AND Dem.PFL_PLUS_DemandeIdent LIKE CASE WHEN @DemandeIdent IS NOT NULL THEN @DemandeIdent ELSE '%' END

 order by Entite, Dem.PFL_PLUS_NomFam, Dem.PFL_PLUS_PreUsu


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
GRANT EXECUTE ON PROFIL_PLUS_S_DEMANDES TO SELECTEXEC
*/