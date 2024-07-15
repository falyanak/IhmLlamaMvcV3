IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_DEMANDE_POUR_GRAPHIQUE')
DROP PROCEDURE PROFIL_PLUS_S_DEMANDE_POUR_GRAPHIQUE
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_DEMANDE_POUR_GRAPHIQUE]
(
  @DateDebut datetime,
  @DateFin datetime,
  @Entite varchar(10)=NULL

)AS
/*   
Auteur: François Alyanakian
Date de création: 21/09/2023
-------------------------------------------------------------------------------------------------------
Description : Recherche les demandes comprises entre une date de début 
et une date de fin filtrées ou non par entité : DGAL, DGDDI, SCL
-------------------------------------------------------------------------------------------------------
Modification :  
	--
Test :
        Exec PROFIL_PLUS_S_DEMANDE_POUR_GRAPHIQUE @DateDebut @DateFin @Entite

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

IF @Entite IS NOT NULL AND (RIGHT(@Entite,1)='*' OR LEFT(@Entite,1)='*')
       SET @Entite = REPLACE(@Entite,'*','%')  

    SELECT 
       EntitesGroup.Entite as 'Entite'
	  ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
	  ,TypeDem.TypeDemandeLibelleCourt as 'TypeDemande'
   	  ,TypeDem.TypeDemandeIdent as 'TypeDemandeId'
	  ,TypeTraitDem.TypeTraitementDemandeLibelleCourt as 'TypeTraitementDemande'
      ,TypeTraitDem.TypeTraitementDemandeIdent as 'TypeTraitementDemandeId'
 
        From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
        inner join PROFIL_PLUS_Demande as Dem
        on dem.Unfct_Ident = EntitesGroup.UniteFonctionnelleId

        inner join PROFIL_PLUS_REF_TypeDemande as TypeDem
        on Dem.TypeDemandeIdent = TypeDem.TypeDemandeIdent

        inner join PROFIL_PLUS_REF_TypeTraitementDemande as TypeTraitDem
        on Dem.TypeTraitementDemandeIdent = TypeTraitDem.TypeTraitementDemandeIdent

        WHERE  Dem.PFL_PLUS_DateCreationDemande >= @DateDebut 
           AND Dem.PFL_PLUS_DateCreationDemande <= @DateFin
           AND EntitesGroup.Entite LIKE CASE WHEN @Entite IS NOT NULL THEN @Entite ELSE '%' END

        ORDER BY Entite, Dem.PFL_PLUS_DateCreationDemande

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
GRANT EXECUTE ON PROFIL_PLUS_S_DEMANDE_POUR_GRAPHIQUE TO SELECTEXEC
*/