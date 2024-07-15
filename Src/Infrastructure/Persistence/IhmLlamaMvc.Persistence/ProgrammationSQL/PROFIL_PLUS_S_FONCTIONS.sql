IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_FONCTIONS')
DROP PROCEDURE PROFIL_PLUS_S_FONCTIONS
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_FONCTIONS]
AS
/*   
Auteur: François Alyanakian
Date de création: 22/05/2023
-------------------------------------------------------------------------------------------------------
Description : Retourne la liste des fonctions pour les entités : SCL, DGDDI, DGAL
-------------------------------------------------------------------------------------------------------
Modification : 
mise en commentaire pour récupérer la liste complète des fonctions
	--
Test :
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY
SELECT FCT_IDENT as 'Id'
      ,FCT_LIBELLE as 'Libelle'
      ,FCT_SCL as 'DiscriminantScl'
      ,FCT_DGAL as 'DiscriminantDgal'
      ,FCT_DGDDI as 'DiscriminantDgddi'

  FROM [REFERENTIEL].[dbo].[REF_X_FONCTION]

  where FCT_DGDDI = 1 or FCT_DGAL = 1 or FCT_SCL = 1

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
GRANT EXECUTE ON PROFIL_PLUS_S_FONCTIONS TO SELECTEXEC
*/
