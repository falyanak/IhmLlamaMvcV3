IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_AGENTS_DANS_ENTITE')
DROP PROCEDURE PROFIL_PLUS_S_AGENTS_DANS_ENTITE
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_AGENTS_DANS_ENTITE]
(
    @ENTITE varchar(10)
   ,@NOM VARCHAR(42)=NULL
)AS
/*   
Auteur: François Alyanakian
Date de création: 16/11/2022
-------------------------------------------------------------------------------------------------------
Description : Recherche les agents à partir de leur entité d'affectation : DGAL, DGDDI, SCL
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe

                12/03/2024 jointure avec [INTERFACE_SIRHIUS].[dbo].[AGENT_NPC_SIRHIUS]
                pour ne prendre en compte, pour la DGAL, que les agents dont le champ
                Commentaire a pour valeur 'Agriculture'
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_AGENTS_DANS_ENTITE ENTITES = 'DGAL'

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

IF @ENTITE IS NOT NULL AND (RIGHT(@ENTITE,1)='*' OR LEFT(@ENTITE,1)='*')
       SET @ENTITE = REPLACE(@ENTITE,'*','%')  

IF @NOM IS NOT NULL AND (RIGHT(@NOM,1)='*' OR LEFT(@NOM,1)='*')
       SET @NOM = REPLACE(@NOM,'*','%')  

IF @ENTITE = 'DGAL'
BEGIN		
    select 
       Agt.ag_ident as 'Id'
      ,Agt.matrc12 AS 'Matricule'
      ,Agt.nomfam as 'NomFamille'
	  ,Agt.preusu as 'PrenomUsuel'
	  ,Agt.mail as 'Courriel'
      ,Agt.compteAD as 'CompteActiveDirectory'
	  ,fonc.FCT_LIBELLE as 'Fonction'
      ,AgtFonc.FCT_IDENT as 'FonctionId'
      ,EntitesGroup.Entite as 'Entite'
      ,EntitesGroup.UniteFonctionnelle as 'UniteFonctionnelle'
      ,Agt.Unfct_Ident as 'UniteFonctionnelleId'
      ,Agt.cdetcv as 'Sexe'
      ,Agt.libetcv as 'LibelleSexe'

    From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
    inner join AGENT_DGCCRF as Agt
    on agt.unfct_ident = EntitesGroup.UniteFonctionnelleId
    left join REF_X_AG_FCT as AgtFonc  -- left join pour ne pas perdre d'agents
    on Agt.ag_ident = AgtFonc.AG_IDENT
    left join REF_X_FONCTION as fonc -- left join pour ne pas perdre d'agents
    on AgtFonc.FCT_IDENT = Fonc.FCT_IDENT

    -- ajout jointure pour filtrer la DGAL sur la colonne Commentaire = 'Agriculture'
    left join INTERFACE_SIRHIUS..AGENT_NPC_SIRHIUS AS NPC_Sirhius
    on Agt.ag_ident = NPC_Sirhius.AG_IDENT

    WHERE EntitesGroup.Entite LIKE 'DGAL'
    AND Agt.matrc12 like 'A%'
	AND Agt.nomfam LIKE CASE WHEN @NOM IS NOT NULL THEN @NOM ELSE '%' END
    AND Agt.ag_flag_obsolet = 0  -- agent present seulement
    AND NPC_Sirhius.Commentaire = 'Agriculture'
    order by Entite, Agt.nomfam, Agt.preusu
 END
 ELSE
 BEGIN
     select 
       Agt.ag_ident as 'Id'
      ,Agt.matrc12 AS 'Matricule'
      ,Agt.nomfam as 'NomFamille'
	  ,Agt.preusu as 'PrenomUsuel'
	  ,Agt.mail as 'Courriel'
      ,Agt.compteAD as 'CompteActiveDirectory'
	  ,fonc.FCT_LIBELLE as 'Fonction'
      ,AgtFonc.FCT_IDENT as 'FonctionId'
      ,EntitesGroup.Entite as 'Entite'
      ,EntitesGroup.UniteFonctionnelle as 'UniteFonctionnelle'
      ,Agt.Unfct_Ident as 'UniteFonctionnelleId'
      ,Agt.cdetcv as 'Sexe'
      ,Agt.libetcv as 'LibelleSexe'

    From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
    inner join AGENT_DGCCRF as Agt
    on agt.unfct_ident = EntitesGroup.UniteFonctionnelleId
    left join REF_X_AG_FCT as AgtFonc  -- left join pour ne pas perdre d'agents
    on Agt.ag_ident = AgtFonc.AG_IDENT
    left join REF_X_FONCTION as fonc -- left join pour ne pas perdre d'agents
    on AgtFonc.FCT_IDENT = Fonc.FCT_IDENT
    WHERE EntitesGroup.Entite LIKE @ENTITE
    AND Agt.matrc12 like 'A%'
	AND Agt.nomfam LIKE CASE WHEN @NOM IS NOT NULL THEN @NOM ELSE '%' END
    AND Agt.ag_flag_obsolet = 0  -- agent present seulement
     order by Entite, Agt.nomfam, Agt.preusu
 END

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
GRANT EXECUTE ON PROFIL_PLUS_S_AGENTS_DANS_ENTITE TO SELECTEXEC
*/