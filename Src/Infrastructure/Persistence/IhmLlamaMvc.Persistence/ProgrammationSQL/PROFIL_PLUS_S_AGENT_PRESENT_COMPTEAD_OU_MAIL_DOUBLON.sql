IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_AGENT_PRESENT_COMPTEAD_OU_MAIL_DOUBLON')
DROP PROCEDURE PROFIL_PLUS_S_AGENT_PRESENT_COMPTEAD_OU_MAIL_DOUBLON
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_AGENT_PRESENT_COMPTEAD_OU_MAIL_DOUBLON]
(
    @COMPTEAD varchar(30),
    @MAIL varchar(100)
)AS
/*   
Auteur: François Alyanakian
Date de création: 01/02/2023
-------------------------------------------------------------------------------------------------------
Description : Recherche un compte active Directory ou une adresse mail qui existent déjà dans la table agent
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_AGENT_PRESENT_COMPTEAD_OU_MAIL_DOUBLON 
        COMPTEAD = 'login' 'mail'

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY
 
  SELECT 
       Agt.ag_ident as 'Id'
      ,Agt.nomfam as 'NomFamille'
	  ,Agt.preusu as 'PrenomUsuel'
	  ,Agt.comptead as 'CompteActiveDirectory'
      ,Agt.mail as 'Courriel'
      ,Agt.unfct_ident as 'UniteFonctionnelleId'
      ,Agt.cdetcv as 'Sexe'

  FROM REFERENTIEL..AGENT_DGCCRF as Agt
  WHERE ag_flag_obsolet = 0 
    and (compteAD = @COMPTEAD or mail = @MAIL)

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
GRANT EXECUTE ON PROFIL_PLUS_S_AGENT_PRESENT_COMPTEAD_OU_MAIL_DOUBLON TO SELECTEXEC
*/