IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_SELECTIONNER_DEMANDES_CREEES_SUR_PERIODE')
DROP PROCEDURE PROFIL_PLUS_S_SELECTIONNER_DEMANDES_CREEES_SUR_PERIODE
GO


CREATE PROCEDURE [dbo].PROFIL_PLUS_S_SELECTIONNER_DEMANDES_CREEES_SUR_PERIODE
  @DateHeureDebut datetime,
  @DateHeureFin datetime,
  @NombreDemandeMax smallint
AS
/*   
Auteur: François Alyanakian
Date de création: 28/08/2023
------------------------------------------------------------------------------------------------------
Description : Contrôler le nombre de demandes créé sur une periode de temps
              définie par la constante DureeEnHeureControleCreation = 24;

Retourner une liste des demandes des demandes crées sur cette période
en cas de déplacement du @NombreDemandeMax
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
*/


BEGIN TRY

SET NOCOUNT ON

BEGIN
declare @NombreDemandes int

SET @NombreDemandes = (
        SELECT  count(Dem.PFL_PLUS_DemandeIdent)
        FROM  PROFIL_PLUS_Demande as Dem
		WHERE Dem.PFL_PLUS_DateCreationDemande 
            BETWEEN @DateHeureDebut AND @DateHeureFin
       )

--select @NombreDemandes as '@NombreDemandes', @NombreDemandeMax as '@NombreDemandeMax'

IF @NombreDemandes >= @NombreDemandeMax
 BEGIN
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
      ,Dem.PFL_PLUS_Sexe as 'Sexe'

  FROM V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
        left join PROFIL_PLUS_Demande as Dem
        on dem.Unfct_Ident = EntitesGroup.UniteFonctionnelleId

        left join REF_X_FONCTION as fonc
        on Dem.FCT_IDENT = Fonc.FCT_IDENT

        inner join PROFIL_PLUS_SuiviEtatDemande as SuiviEtat
        on Dem.PFL_PLUS_DemandeIdent = SuiviEtat.PFL_PLUS_DemandeIdent
        -- ne conserver que le dernier état
        and SuiviEtat.EtatDemandeIdent = 
        (SELECT MAX(EtatDemandeIdent) FROM [PROFIL_PLUS_SuiviEtatDemande]
        where PFL_PLUS_DemandeIdent = SuiviEtat.PFL_PLUS_DemandeIdent)

        inner join PROFIL_PLUS_REF_EtatDemande as EtatDem
        on SuiviEtat.EtatDemandeIdent = EtatDem.EtatDemandeIdent

        inner join PROFIL_PLUS_REF_TypeDemande as TypeDem
        on Dem.TypeDemandeIdent = TypeDem.TypeDemandeIdent

        inner join PROFIL_PLUS_REF_TypeTraitementDemande as TypeTraitDem
        on Dem.TypeTraitementDemandeIdent = TypeTraitDem.TypeTraitementDemandeIdent

       WHERE Dem.PFL_PLUS_DateCreationDemande 
            BETWEEN @DateHeureDebut AND @DateHeureFin

    END
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
