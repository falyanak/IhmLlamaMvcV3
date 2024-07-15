IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_REFERENTIEL_PARAMETRE')
DROP PROCEDURE PROFIL_PLUS_S_REFERENTIEL_PARAMETRE
GO

CREATE PROCEDURE dbo.PROFIL_PLUS_S_REFERENTIEL_PARAMETRE 
 AS

/*   
Auteur: François Alyanakian
Date de création: 13/12/2022
-------------------------------------------------------------------------------------------------------
Description : Récupére les clés-valeurs utilisées dans l'application
-------------------------------------------------------------------------------------------------------
Modification :  
-------------------------------------------------------------------------------------------------------
*/
BEGIN TRY

      SELECT [PARAM_IDENT] as 'Id'
      ,[PARAM_VALEUR] as 'Valeur'
      ,[PARAM_CODE] as 'Code'
      ,[PARAM_LIBELLE] as 'Libelle'
  FROM [dbo].[REFERENTIEL_PARAMETRE]
  WHERE PARAM_CODE like 'ProfilPlus_%'


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

GO
/*
GRANT EXECUTE ON PROFIL_PLUS_S_REFERENTIEL_PARAMETRE TO SELECTEXEC
*/