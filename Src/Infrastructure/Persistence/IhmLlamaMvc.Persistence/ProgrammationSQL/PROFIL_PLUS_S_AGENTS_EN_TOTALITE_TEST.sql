IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_AGENTS_EN_TOTALITE_TEST')
DROP PROCEDURE PROFIL_PLUS_S_AGENTS_EN_TOTALITE_TEST
GO


CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_AGENTS_EN_TOTALITE_TEST]
@count int OUTPUT
AS
/*   
Auteur: François Alyanakian
Date de création: 07/03/2023
-------------------------------------------------------------------------------------------------------
Description : Recherche tous les agents ayant été créés par l'application Profil+
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_AGENTS_EN_TOTALITE_TEST

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

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

From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
 inner join AGENT_DGCCRF as Agt
 on agt.unfct_ident = EntitesGroup.UniteFonctionnelleId
 left join REF_X_AG_FCT as AgtFonc  -- left join pour ne pas perdre d'agents
 on Agt.ag_ident = AgtFonc.AG_IDENT
 left join REF_X_FONCTION as fonc -- left join pour ne pas perdre d'agents
 on AgtFonc.FCT_IDENT = Fonc.FCT_IDENT
 --where EntitesGroup.Entite in ('SCL') AND Agt.ag_flag_obsolet = 0  -- agents presents seulement
 WHERE Agt.nompat ='Profil+'
 order by Entite, Agt.nomfam, Agt.preusu

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
GRANT EXECUTE ON PROFIL_PLUS_S_AGENTS_EN_TOTALITE_TEST TO SELECTEXEC
*/