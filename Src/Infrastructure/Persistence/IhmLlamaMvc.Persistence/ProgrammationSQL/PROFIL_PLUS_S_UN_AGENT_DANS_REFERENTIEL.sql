IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_UN_AGENT_DANS_REFERENTIEL')
DROP PROCEDURE PROFIL_PLUS_S_UN_AGENT_DANS_REFERENTIEL
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_UN_AGENT_DANS_REFERENTIEL]
(
   @IDENT INT

)AS
/*   
Auteur: François Alyanakian
Date de création: 1/12/2022
-------------------------------------------------------------------------------------------------------
Description : Recherche un agent dans la table Agents à partir d'un identifiant
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_UN_AGENT_DANS_REFERENTIEL  @IDENT = 'agent_id'

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

select 
     Agt.ag_ident as 'Id'
      ,Agt.nomfam as 'NomFamille'
	  ,Agt.preusu as 'PrenomUsuel'
	  ,Agt.mail as 'Courriel'
      ,Agt.compteAD as 'CompteActiveDirectory'
	  ,fonc.FCT_LIBELLE as 'Fonction'
      ,AgtFonc.FCT_IDENT as 'FonctionId'
      ,Agt.Unfct_Ident as 'UniteFonctionnelleId'
      ,Agt.cdetcv as 'Sexe'
      ,Agt.libetcv as 'LibelleSexe'

From REFERENTIEL..AGENT_DGCCRF as Agt
 left join REF_X_AG_FCT as AgtFonc  -- left join pour ne pas perdre d'agents
 on Agt.ag_ident = AgtFonc.AG_IDENT
 left join REF_X_FONCTION as fonc -- left join pour ne pas perdre d'agents
 on AgtFonc.FCT_IDENT = Fonc.FCT_IDENT
 WHERE  Agt.ag_ident = @IDENT

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
GRANT EXECUTE ON PROFIL_PLUS_S_UN_AGENT_DANS_REFERENTIEL TO SELECTEXEC
*/