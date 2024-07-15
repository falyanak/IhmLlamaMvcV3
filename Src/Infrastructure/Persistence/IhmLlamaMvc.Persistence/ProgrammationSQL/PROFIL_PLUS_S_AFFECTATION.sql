IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_AFFECTATION')
DROP PROCEDURE PROFIL_PLUS_S_AFFECTATION
GO


CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_AFFECTATION]
AS
/*   
Auteur: François Alyanakian
Date de création: 14/11/2022
-------------------------------------------------------------------------------------------------------
Description : Retourne la liste des affectations : SCL, DGDDI, DGAL
-------------------------------------------------------------------------------------------------------
Modification : 
mise en commentaire pour récupérer la liste des affectations
	--
Test :
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

select 
       EntitesGroup.Entite as 'Entite'
      ,EntitesGroup.UniteFonctionnelleId as 'UniteFonctionnelleId'
      ,EntitesGroup.UniteFonctionnelle as 'UniteFonctionnelle'
      ,EntitesGroup.UniteAdministrativeId as 'UniteAdministrativeId'
      ,EntitesGroup.UniteAdministrative as 'UniteAdministrative'
      ,EntitesGroup.ActiveDirectoryOU as 'ActiveDirectoryOU'
      ,EntitesGroup.ContactOU as 'ContactOU'
      ,EntitesGroup.GroupeOU as 'GroupeOU'
      ,EntitesGroup.GroupeOU2 as 'GroupeOU2'

 From V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL AS EntitesGroup
 --WHERE EntitesGroup.ActiveDirectoryOU IS NOT NULL
 --  AND EntitesGroup.GroupeOU IS NOT NULL 
 --  AND EntitesGroup.ContactOU IS NOT NULL 

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
GRANT EXECUTE ON PROFIL_PLUS_S_AFFECTATION TO SELECTEXEC
*/
