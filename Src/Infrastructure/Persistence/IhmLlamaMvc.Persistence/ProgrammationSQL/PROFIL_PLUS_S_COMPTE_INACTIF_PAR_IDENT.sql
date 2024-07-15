IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_COMPTE_INACTIF_PAR_IDENT')
DROP PROCEDURE PROFIL_PLUS_S_COMPTE_INACTIF_PAR_IDENT
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_COMPTE_INACTIF_PAR_IDENT]
  @GestionGuid VARCHAR(50)
AS
/*   
Auteur: François Alyanakian
Date de création: 27/11/2023
-------------------------------------------------------------------------------------------------------
Description : Retourne un enregistrement de suivi de gestion des comptes Windows inactifs 
              à désactiver automatiquement si l'agent n'en a pas demandé le maintien 
              en cliquant sur un lien présent dans un courriel
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY
SELECT PFL_PLUS_Gestion_Ident as 'Id'
      ,PFL_PLUS_CompteADInactif as 'CompteAd'
      ,PFL_PLUS_DistinguishedName as 'DistinguishedName'
      ,PFL_PLUS_DateDerniereConnexionAD as 'DateDerniereConnexionAD'
      ,PFL_PLUS_Mail as 'Mail'
      ,PFL_PLUS_DateEnvoiCourrielInitial as 'DateEnvoiCourrielInitial'
      ,PFL_PLUS_DateEnvoiCourrielRelance as 'DateEnvoiCourrielRelance'
      ,PFL_PLUS_DateMaintienActivite as 'DateMaintienActivite'
      ,PFL_PLUS_DateEnvoiCourrielSuppression as 'DateEnvoiCourrielSuppression'
      ,PFL_PLUS_DateSuppressionAD as 'DateSuppressionAD'
  FROM PROFIL_PLUS_Gestion_Compte_Inactif
  WHERE PFL_PLUS_Gestion_Ident = @GestionGuid

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
GRANT EXECUTE ON PROFIL_PLUS_S_COMPTE_INACTIF_PAR_IDENT TO SELECTEXEC
*/
