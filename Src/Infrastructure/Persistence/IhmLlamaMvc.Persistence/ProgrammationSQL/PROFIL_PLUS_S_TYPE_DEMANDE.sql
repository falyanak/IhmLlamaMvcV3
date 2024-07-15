IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_TYPE_DEMANDE')
DROP PROCEDURE PROFIL_PLUS_S_TYPE_DEMANDE
GO


CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_TYPE_DEMANDE]
AS
/*   
Auteur: François Alyanakian
Date de création: 28/11/2022
-------------------------------------------------------------------------------------------------------
Description : Retourne la liste des types de demande
-------------------------------------------------------------------------------------------------------
Modification : 
mise en commentaire pour récupérer la liste des types de demande
	--
Test :
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

SELECT [TypeDemandeIdent] as 'Id'
      ,[TypeDemandeLibelleCourt] as 'Libelle'
  FROM [REFERENTIEL].[dbo].[PROFIL_PLUS_REF_TypeDemande]
  WHERE TypeDemandeObsolet = 0
  ORDER BY TypeDemandeOrdre

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
GRANT EXECUTE ON PROFIL_PLUS_S_TYPE_DEMANDE TO SELECTEXEC
*/
