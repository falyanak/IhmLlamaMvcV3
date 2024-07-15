IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_DEMANDE_PAR_MAIL_TEST')
DROP PROCEDURE PROFIL_PLUS_S_DEMANDE_PAR_MAIL_TEST
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_DEMANDE_PAR_MAIL_TEST]
(
    @Mail varchar(100)
)AS
/*   
Auteur: François Alyanakian
Date de création: 16/11/2022
-------------------------------------------------------------------------------------------------------
Description : Recherche les demandes à partir d'une adresse mail
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
Test :
        Exec PROFIL_PLUS_S_DEMANDE_PAR_MAIL_TEST 'mail'

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

select 
       Dem.PFL_PLUS_NomFam as 'NomFamille'
	  ,Dem.PFL_PLUS_PreUsu as 'PrenomUsuel'
	  ,Dem.PFL_PLUS_Mail as 'Courriel'
	  ,Dem.PFL_PLUS_DemandeIdent as 'Id'
	  ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
      ,Dem.PFL_PLUS_Commentaire as 'Commentaire'
      ,Dem.PFL_PLUS_CompteADCree as 'CompteADCree'
      ,Dem.PFL_PLUS_CompteApplicatifCree as 'CompteApplicatifCree'
      ,Dem.Ag_Ident_ConcerneParDemande as 'AgentConcerneId'
      ,Dem.PFL_PLUS_Sexe as 'Sexe'
      ,PFL_PLUS_LibelleSexe as 'LibelleSexe'

 FROM PROFIL_PLUS_Demande as Dem
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
GRANT EXECUTE ON PROFIL_PLUS_S_DEMANDE_PAR_MAIL_TEST TO SELECTEXEC
*/