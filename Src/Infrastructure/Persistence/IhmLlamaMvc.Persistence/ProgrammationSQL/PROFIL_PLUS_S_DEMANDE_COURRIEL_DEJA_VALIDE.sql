IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_DEMANDE_COURRIEL_DEJA_VALIDE')
DROP PROCEDURE PROFIL_PLUS_S_DEMANDE_COURRIEL_DEJA_VALIDE
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_DEMANDE_COURRIEL_DEJA_VALIDE]
(
   @DemandeIdent VARCHAR(200)

)AS
/*   
Auteur: François Alyanakian
Date de création: 21/02/2023
-------------------------------------------------------------------------------------------------------
Description : Vérifier si l'utilisateur a déjà validé son adresse mail
 s'il y a eu validation l'état 'Réponse agent effective' (EtatDemandeIdent = 2) existe déjà
 
-------------------------------------------------------------------------------------------------------
Modification :  
	--
Test :
        Exec PROFIL_PLUS_S_DEMANDE_COURRIEL_DEJA_VALIDE demandeId

-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

select 
	   Dem.PFL_PLUS_DemandeIdent as 'Id'
      ,Dem.TypeDemandeIdent as 'TypeDemandeId'
      ,Dem.PFL_PLUS_DateCreationDemande as 'DateCreationDemande'
 	  ,Etat.DateEtatDemande as 'DateEtatdemande'
      ,Etat.EtatDemandeIdent as 'EtatDemandeId'
	  ,EtatDem.EtatDemandeLibelleCourt as 'EtatDemande'

From PROFIL_PLUS_Demande as Dem

 inner join PROFIL_PLUS_SuiviEtatDemande as Etat
 on Dem.PFL_PLUS_DemandeIdent = Etat.PFL_PLUS_DemandeIdent
  -- ne conserver que le dernier état
  and Etat.EtatDemandeIdent = (SELECT MAX(EtatDemandeIdent) FROM [PROFIL_PLUS_SuiviEtatDemande]
       where PFL_PLUS_DemandeIdent = Etat.PFL_PLUS_DemandeIdent)

 inner join PROFIL_PLUS_REF_EtatDemande as EtatDem
 on Etat.EtatDemandeIdent = EtatDem.EtatDemandeIdent

 
 WHERE Dem.PFL_PLUS_DemandeIdent = @DemandeIdent 


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
GRANT EXECUTE ON PROFIL_PLUS_S_DEMANDE_COURRIEL_DEJA_VALIDE TO SELECTEXEC
*/